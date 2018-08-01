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
short_description: Copies files to remote IDGs
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
    - File has been created.

file:
  description:
    - Content of the file or files of the requested directory
  returned: success
  type: complex
  sample: [{"name": "ErrorCodes.xml", "file": "PD94bWw...YW1lPgo"},
           {"name": "Properties.xml", "file": "RlIGluZ...ZCAgY29u"}]
'''

# Version control
__MODULE_NAME = "idg_domain_fetch"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION

import json
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
        domain=dict(type='str', required=True),  # Domain name
        path=dict(type='str', required=True),  # Remote absolute path for file or directory
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

        #
        # Here the action begins
        #

        pdb.set_trace()

        if _pldir + ':' in IDGUtils.IDG_DIRS:  # Base IDG directory is OK

            api_uri = '/'.join([IDGApi.URI_FILESTORE.format(domain_name), _pldir] + _ppath_list)  # Path prefix
            ck_code, ck_msg, ck_data = idg_mgmt.api_call(api_uri, method='GET')

            if ck_code == 200 and ck_msg == 'OK':

                if 'filestore' in ck_data.keys():  # Is directory

                    if 'file' in ck_data['filestore']['location'].keys():

                        files_names = [i for i in AbstractListDict(ck_data['filestore']['location']['file']).values(key='name')]
                        files = []
                        for f in files_names:

                            dw_code, dw_msg, dw_data = idg_mgmt.api_call(api_uri + '/' + f, method='GET')
                            if dw_code == 200 and dw_msg == 'OK':
                                files.append({"name": f, "file": dw_data['file']})
                            else:
                                module.fail_json(msg=IDGApi.GENERAL_STATELESS_ERROR.format(__MODULE_FULLNAME, domain_name) + str(ErrorHandler(dw_data['error'])))

                        result['files'] = files

                    else:
                        result['files'] = []

                else:  # Is file
                    result['files'] = [{"name": _ppath_list[-1], "file": ck_data['file']}]

            elif ck_code == 404 and ck_msg == 'Not Found':
                # Source not found
                module.fail_json(msg="Target {0} does not exist.".format(path))

            else:
                # Other Errors
                module.fail_json(msg=IDGApi.GENERAL_STATELESS_ERROR.format(__MODULE_FULLNAME, domain_name) + str(ErrorHandler(ck_data['error'])))

        # Finish
        result['msg'] = IDGApi.COMPLETED

    except Exception as e:
        # Uncontrolled exception
        module.fail_json(msg=(IDGUtils.UNCONTROLLED_EXCEPTION + '. {0}').format(to_native(e)))
    else:
        # That's all folks!
        module.exit_json(**result)


if __name__ == '__main__':
    main()
