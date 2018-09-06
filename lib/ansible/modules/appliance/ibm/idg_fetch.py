#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2018, [David Grau Merconchini <david@gallorojo.com.mx>]
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import absolute_import, division, print_function
__metaclass__ = type

ANSIBLE_METADATA = {'metadata_version': '1.1',
                    'status': ['preview'],
                    'supported_by': 'community'}

DOCUMENTATION = '''
---

module: idg_domain_fetch
short_description: Copies files from remote IDGs
description:
  - The M(idg_domain_fetch) module download files from remote IDGs to the local box.
  - Use M(idg_domain_copy) to upload a file from local to a location on the remote IDG.
version_added: "2.7"
options:

  domain:
    description:
      - Domain identifier.
    required: True

  path:
    description:
      - Remote absolute path where the file should be copied to. If src is a directory, this must be a directory too.
    required: True

  recursive:
    description:
      - Indicates that you want to recursively download the contents of a directory.
      - Only applies to the local:/ directory.
    default: False
    type: bool

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower file module
  connection: local
  hosts: localhost
  vars:
    remote_idg:
        server: idghosts
        server_port: 5554
        user: admin
        password: admin
        validate_certs: false
        timeout: 15

  tasks:

  - name: Upload transform
    idg_domain_fetch:
        idg_connection: "{{ remote_idg }}"
        domain: dev
        path: "local:/XMLs/ErrorCodes.xml"
'''

RETURN = '''
msg:
  description:
    - Message returned by the device API.
  returned: always
  type: string
  sample:
    - Completed.

domain:
  description:
    - The name of the domain.
  returned: always
  type: string
  sample:
    - core-security-wrap
    - DevWSOrchestration

file:
  description:
    - Content of the file or files of the requested directory.
    - When I(recursive=false)
  returned: when success and not recursive
  type: list
  sample:
    - {"name": "ErrorCodes.xml", "file": "PD94bWw...YW1lPgo"}
    - {"name": "Properties.xml", "file": "RlIGluZ...ZCAgY29u"}

directory:
  description:
    - Compressed and base64 content of the requested directory
    - When I(recursive=true)
  returned: when success and recursive
  type: string
  sample: "PD94bWw...YW1lPgo"

'''

import json
import tempfile
import os
import shutil
import base64
from zipfile import ZipFile, ZIP_DEFLATED
# import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native
from ansible.module_utils.six.moves.urllib.parse import urlparse

# Common package of our implementation for IDG
HAS_IDG_DEPS = False
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi, ErrorHandler, AbstractListDict
    HAS_IDG_DEPS = True
except ImportError:
    try:
        from library.module_utils.idg_common import result, idg_endpoint_spec, IDGUtils
        from library.module_utils.idg_rest_mgmt import IDGApi, ErrorHandler, AbstractListDict
        HAS_IDG_DEPS = True
    except ImportError:
        pass

# Version control
__MODULE_NAME = "idg_domain_fetch"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        module_args = dict(
            domain=dict(type='str', required=True),  # Domain name
            path=dict(type='str', required=True),  # Remote absolute path for file or directory
            recursive=dict(type='bool', required=False, default=False),  # Download recursively
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True)  # IDG connection
        )

        # AnsibleModule instantiation
        module = AnsibleModule(
            argument_spec=module_args,
            supports_check_mode=True
        )
    else:
        # Failure AnsibleModule instance
        module = AnsibleModule(
            argument_spec={},
            check_invalid_arguments=False
        )
        module.fail_json(msg="The IDG utils modules is required")

    # Parse arguments to dict
    idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)
    domain_name = module.params['domain']
    recursive = module.params['recursive']

    path = module.params['path']
    _pparse = urlparse(path)
    _pldir = _pparse.scheme  # IDG base directory
    _prpath = _pparse.path  # Relative path
    _ppath_list = [d for d in _prpath.split('/') if d.strip() != '']

    # Init IDG API connect
    idg_mgmt = IDGApi(ansible_module=module,
                      idg_host="https://{0}:{1}".format(idg_data_spec['server'], idg_data_spec['server_port']),
                      headers=IDGUtils.BASIC_HEADERS,
                      http_agent=IDGUtils.HTTP_AGENT_SPEC,
                      use_proxy=idg_data_spec['use_proxy'],
                      timeout=idg_data_spec['timeout'],
                      validate_certs=idg_data_spec['validate_certs'],
                      user=idg_data_spec['user'],
                      password=idg_data_spec['password'],
                      force_basic_auth=IDGUtils.BASIC_AUTH_SPEC)

    export_action_msg = {"Export": {"Format": "ZIP", "AllFiles": "on", "Persisted": "off", "IncludeInternalFiles": "off", "Object": []}}

    # Intermediate values ​​for result
    tmp_result = {"msg": IDGUtils.COMPLETED_MESSAGE, "domain": domain_name, "directory": None, "files": None}

    #
    # Here the action begins
    #

    try:
        if _pldir + ':' in IDGUtils.IDG_DIRS:  # Base IDG directory is OK

            api_uri = '/'.join([IDGApi.URI_FILESTORE.format(domain_name), _pldir] + _ppath_list)  # Path prefix
            idg_mgmt.api_call(api_uri, method='GET', id="get_remote_target")

            if idg_mgmt.is_ok(idg_mgmt.last_call()):

                if 'filestore' in idg_mgmt.last_call()["data"].keys():  # Is directory

                    if recursive:  # recursively download the entire directory

                        # If the user is working in only check mode we do not want to make any changes
                        IDGUtils.implement_check_mode(module)

                        tmp_dir = tempfile.mkdtemp()  # create temp directory

                        try:
                            state = "Download remote directory"
                            idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(export_action_msg), id="export_domain")

                            if idg_mgmt.is_accepted(idg_mgmt.last_call()):
                                # Asynchronous actions export accepted. Wait for complete
                                idg_mgmt.api_event_sink(IDGApi.URI_ACTION.format(domain_name), href=idg_mgmt.last_call()["data"]['_links']['location']['href'],
                                                        state=state)

                                if idg_mgmt.is_ok(idg_mgmt.last_call()):
                                    # Export ok
                                    try:
                                        # Unzip backup in temporary directory
                                        backup_file = os.sep.join([tmp_dir, domain_name + ".zip"])
                                        with open(backup_file, 'wb') as f:
                                            f.write(base64.b64decode(idg_mgmt.last_call()["data"]['result']['file']))

                                        ziparch = ZipFile(backup_file)
                                        ziparch.extractall(tmp_dir)

                                        # Compress directory
                                        local_target = os.sep.join([tmp_dir, _pldir] + _ppath_list)
                                        local_target_zip = _ppath_list[-1] + '.zip'
                                        local_target_home = os.path.dirname(local_target)

                                        os.chdir(local_target_home)
                                        with ZipFile(local_target_zip, "w", ZIP_DEFLATED, allowZip64=True) as zf:
                                            for root, dummy, filenames in os.walk(os.path.basename(local_target)):
                                                for name in filenames:
                                                    name = os.path.join(root, name)
                                                    name = os.path.normpath(name)
                                                    zf.write(name, name)

                                        with open(os.sep.join([local_target_home, local_target_zip]), "rb") as zf:
                                            encoded_file = base64.b64encode(zf.read())

                                        tmp_result['directory'] = encoded_file

                                    except Exception as e:
                                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(e))

                                else:
                                    # Can't retrieve the export
                                    module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))

                            else:
                                # Export not accepted
                                module.fail_json(msg=IDGApi.ERROR_ACCEPTING_ACTION.format(state, domain_name))

                        finally:
                            # Clean
                            shutil.rmtree(tmp_dir)

                    else:  # Only files in the designated directory

                        # If the user is working in only check mode we do not want to make any changes
                        IDGUtils.implement_check_mode(module)

                        if 'file' in idg_mgmt.call_by_id("get_remote_target")["data"]['filestore']['location'].keys():

                            files_names = [i for i in AbstractListDict(idg_mgmt.call_by_id("get_remote_target")["data"]['filestore']['location']['file']).values(key='name')]
                            files = []
                            for f in files_names:

                                idg_mgmt.api_call(api_uri + '/' + f, method='GET', id="download_files")
                                if idg_mgmt.is_ok(idg_mgmt.last_call()):
                                    files.append({"name": f, "file": idg_mgmt.last_call()["data"]['file']})
                                else:
                                    module.fail_json(msg=IDGApi.GENERAL_STATELESS_ERROR.format(__MODULE_FULLNAME, domain_name)
                                                     + str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

                            tmp_result['files'] = files

                        else:
                            tmp_result['files'] = []

                else:  # Is file

                    # If the user is working in only check mode we do not want to make any changes
                    IDGUtils.implement_check_mode(module)

                    tmp_result['files'] = [{"name": _ppath_list[-1], "file": idg_mgmt.call_by_id("get_remote_target")["data"]['file']}]

            elif ck_code == 404 and ck_msg == 'Not Found':
                # Source not found
                module.fail_json(msg="Target {0} does not exist.".format(path))

            else:
                # Other Errors
                module.fail_json(msg=IDGApi.GENERAL_STATELESS_ERROR.format(__MODULE_FULLNAME, domain_name) +
                                 str(ErrorHandler(idg_mgmt.call_by_id("get_remote_target")["data"]['error'])))

        #
        # Finish
        #
        # Customize
        del result['name']
        # Update
        for k, v in tmp_result.items():
            if v is not None:
                result[k] = v

    except Exception as e:
        # Uncontrolled exception
        module.fail_json(msg=(IDGUtils.UNCONTROLLED_EXCEPTION + '. {0}').format(to_native(e)))
    else:
        # That's all folks!
        module.exit_json(**result)


if __name__ == '__main__':
    main()
