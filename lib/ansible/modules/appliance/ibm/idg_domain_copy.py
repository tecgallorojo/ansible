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

module: idg_domain_copy
short_description: Copies files to remote IDGs
description:
  - The idg_domain_copy module upload a file from the local or remote IDG to a location on the remote IDG.
  - Use the idg_domain_fetch module to download files from remote IDGs to the local box.
version_added: "2.7"
options:

  domain:
    description:
      - Domain identifier.
    required: True

  backup:
    description:
      - Create a backup file including the timestamp information so you can get the original file back if something went wrong
    default: False
    type: bool

  checksum:
    description:
      - SHA1 checksum of the file being transferred. Used to validate that the copy of the file was successful.
    default: False

  src:
    description:
      - Local path to a file to copy to the remote server; can be absolute or relative. If path is a directory, it is copied recursively.
    required: True

  dest:
    description:
      - Remote absolute path where the file should be copied to. If src is a directory, this must be a directory too.
    required: True

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
    idg_domain_copy:
        idg_connection: "{{ remote_idg }}"
        domain: dev
        src: /home/developer/xsls/transform.xsl
        dest: local:///xsls/transform.xsl

'''

RETURN = '''
msg:
  description:
    - Message returned by the device API.
  returned: always
  type: string
  sample:
    - File has been created.

size:
  description:
    - Size of the target, after execution
  returned: success
  type: int
  sample:
    - 1220

checksum:
  description:
    - SHA1 checksum of the file after running copy
  returned: success
  type: string
  sample:
    - 6e642bb8dd5c2e027bf21dd923337cbb4214f827

backup_file:
  description:
    - Name of backup file created
  returned: success
  type: string
  sample:
    - local:///xsls/transform.xsl_20180715T1425

'''

# Version control
__MODULE_NAME = "idg_domain_copy"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION

import json
import os
import os.path
import shutil
import tempfile
import base64
from zipfile import ZipFile, BadZipfile
import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native
from ansible.module_utils.six.moves.urllib.parse import urlparse

# Common package of our implementation for IDG
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils, IDGException
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi, AbstractListDict, ErrorHandler
    HAS_IDG_DEPS = True
except ImportError:
    HAS_IDG_DEPS = False


def main():

    module_args = dict(
        backup=dict(type='bool', required=False, default=False),  # Create a backup file
        checksum=dict(type='str', required=False),  # SHA1 checksum of the source
        domain=dict(type='str', required=True),  # Domain name
        src=dict(type='str', required=True),  # Local path to a file or directory
        dest=dict(type='str', required=True),  # Remote absolute path
        idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True)  # IDG connection
    )

    # AnsibleModule instantiation
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # Validates the dependence of the utility module
    if not HAS_IDG_DEPS:
        module.fail_json(msg=IDGUtils.ERROR_IMPORT_MODULE)

    try:

        # Parse arguments to dict
        idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)
        domain_name = module.params['domain']
        backup = module.params['backup']
        changed = False

        tmp_dir=''  # Directory for processing on the control host

        src = module.params['src']
        _src_parse = urlparse(src)
        _src_ldir = _src_parse.scheme  # Local directory
        _src_rpath = _src_parse.path  # Relative path
        _src_path_list = [d for d in _src_rpath.split('/') if d.strip() != '']

        dest = module.params['dest']
        _dest_parse = urlparse(dest)
        _dest_ldir = _dest_parse.scheme  # Local directory
        if _dest_ldir + ':' not in IDGUtils.IDG_DIRS:
            module.fail_json(msg="Base directory of the destination file {0} does not correspond to what is specified for datapower.".format(dest))
        _dest_rpath = _dest_parse.path  # Relative path
        _dest_path_list = [d for d in _dest_rpath.split('/') if d.strip() != '']

        # Customize the result
        del result['name']

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

        create_file_msg = {"file": {"name": "", "content": ""}}
        export_action_msg = {"Export": {"Format":"ZIP", "AllFiles":"on", "Persisted":"off", "IncludeInternalFiles":"off", "Object": []}}

        #
        # Here the action begins
        #

        pdb.set_trace()

        if _src_ldir + ':' in IDGUtils.IDG_DIRS:  # The copy is between remote targets

            t_src = '/'.join([IDGApi.URI_FILESTORE.format(domain_name), _src_ldir] + _src_path_list)  # Path prefix
            ck_code, ck_msg, ck_data = idg_mgmt.api_call(t_src, method='GET')

            if ck_code == 200 and ck_msg == 'OK':

                if 'filestore' in ck_data.keys():  # Is directory

                    tmp_dir = tempfile.mkdtemp()  # create temp directory

                    try:

                        exp_code, exp_msg, exp_data = idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST',
                                                                        data=json.dumps(export_action_msg))

                        if exp_code == 202 and exp_msg == 'Accepted':
                            # Asynchronous actions export accepted. Wait for complete
                            state = "download"
                            action_result = idg_mgmt.wait_for_action_end(IDGApi.URI_ACTION.format(domain_name), href=exp_data['_links']['location']['href'],
                                                                         state=state)

                            # Export completed. Get result
                            doex_code, doex_msg, doex_data = idg_mgmt.api_call(exp_data['_links']['location']['href'], method='GET')

                            if doex_code == 200 and doex_msg == 'OK':
                                # Export ok
                                try:
                                    backup_file = os.sep.join([tmp_dir, domain_name + ".zip"])
                                    with open(backup_file, 'wb') as f:
                                        f.write(base64.b64decode(doex_data['result']['file']))

                                    ziparch = ZipFile(backup_file)
                                    ziparch.extractall(tmp_dir)

                                except Exception as e:
                                    module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))

                            else:
                                # Can't retrieve the export
                                module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))

                        elif exp_code == 200 and exp_msg == 'OK':
                            # Successfully processed synchronized action
                            result['msg'] = idg_mgmt.status_text(exp_data['Export'])
                            result['changed'] = True

                        else:
                            # Export not accepted
                            module.fail_json(msg=IDGApi.ERROR_ACCEPTING_ACTION.format(state, domain_name))

                    finally:
                        pass
                        # Clean
                        shutil.rmtree(tmp_dir)

                else:  # Is file

            elif ck_code == 404 and ck_msg == 'Not Found':
                # Source not found
                module.fail_json(msg="Source {0} does not exist.".format(src))
            else:
                # Other Errors
                pass
        elif isdir(src):  # The source is a local directory
            pass
            # Loop over directory
            # check backup
            # upload files and directories recursively
        elif isfile(src):  # The source is a local file
            pass
            # Get the file
            # check backup
            # copy the file
        else:
            module.fail_json(msg="Source {0} is not supported.".format(src))

        # Finish
        result['msg'] = result_msg
        result['changed'] = changed

    except Exception as e:
        # Uncontrolled exception
        # shutil.rmtree(tmp_dir)
        module.fail_json(msg=(IDGUtils.UNCONTROLLED_EXCEPTION + '. {0}').format(to_native(e)))
    else:
        # That's all folks!
        # shutil.rmtree(tmp_dir)
        module.exit_json(**result)


if __name__ == '__main__':
    main()
