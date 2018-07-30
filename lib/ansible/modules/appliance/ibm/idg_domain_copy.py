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

  remote_src:
    description:
      - If True it will go to the remote/target IDG for the src.
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
import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native
from ansible.module_utils.six.moves.urllib.parse import urlparse

# Common package of our implementation for IDG
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi, AbstractListDict, ErrorHandler
    HAS_IDG_DEPS = True
except ImportError:
    HAS_IDG_DEPS = False


def main():

    module_args = dict(
        state=dict(type='str', required=False, default='directory', choices=['absent', 'directory']),  # State alternatives
        path=dict(type='str', required=True),  # Path to resource
        domain=dict(type='str', required=True),  # Domain name
        idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True)  # IDG connection
    )

    # AnsibleModule instantiation
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # Validates the dependence of the utility module
    if not HAS_IDG_DEPS:
        module.fail_json(msg="The IDG utils module is required")

    try:

        # Parse arguments to dict
        idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)
        path = module.params['path']
        state = module.params['state']
        domain_name = module.params['domain']
        changed = False

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

        create_dir_msg = {"directory": {"name": ""}}

        #
        # Here the action begins
        #

        pdb.set_trace()

        # Do request
        parse = urlparse(path)
        ldir = parse.scheme  # Local directory
        rpath = parse.path  # Relative path
        path_as_list = [d for d in rpath.split('/') if d.strip() != '']
        td='/'.join([IDGApi.URI_FILESTORE.format(domain_name),ldir])  # Path prefix

        result_msg = ''

        if state == 'directory':
            # Create directory recursively
            for d in path_as_list:

                ck_code, ck_msg, ck_data = idg_mgmt.api_call(td, method='GET')

                if ck_code == 200 and ck_msg == 'OK':

                    td='/'.join([td, d])

                    if 'directory' in ck_data['filestore']['location'].keys():
                        filestore_abst = AbstractListDict(ck_data['filestore']['location']['directory'])  # Search between directories
                    else:
                        filestore_abst = AbstractListDict({})  # Not contain directories

                    if td in filestore_abst.values(key='href'):  # if directory exist
                        result_msg=IDGUtils.IMMUTABLE_MESSAGE
                    else:  # Not exist, create it

                        # If the user is working in only check mode we do not want to make any changes
                        IDGUtils.implement_check_mode(module, result)

                        create_dir_msg['directory']['name']=d
                        cr_code, cr_msg, cr_data = idg_mgmt.api_call(td, method='PUT', data=json.dumps(create_dir_msg))

                        if cr_code == 201 and cr_msg == 'Created':
                            result_msg=cr_data['result']
                            changed = True
                        else:
                            module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(cr_data['error'])))

                else:
                    module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(ck_data['error'])))

        else:  # state = 'absent'
            # Remove directory recursively

            # If the user is working in only check mode we do not want to make any changes
            IDGUtils.implement_check_mode(module, result)

            td='/'.join([td] + path_as_list)
            rm_code, rm_msg, rm_data = idg_mgmt.api_call(td, method='DELETE')

            if rm_code == 200 and rm_msg == 'OK':
                result_msg=rm_data['result']
                changed = True
            elif rm_code == 404 and rm_msg == 'Not Found':
                result_msg=IDGUtils.IMMUTABLE_MESSAGE
            else:
                module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(rm_data['error'])))

        # Finish
        result['msg'] = result_msg
        result['changed'] = changed

    except Exception as e:
        # Uncontrolled exception
        module.fail_json(msg=(IDGUtils.UNCONTROLLED_EXCEPTION + '. {0}').format(to_native(e)))
    else:
        # That's all folks!
        module.exit_json(**result)


if __name__ == '__main__':
    main()
