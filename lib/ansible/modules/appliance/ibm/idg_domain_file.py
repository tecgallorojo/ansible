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

module: idg_domain_file
short_description: Module for managing directories and files
description:
  - Module for managing directories and files
version_added: "2.7"
options:

  domain:
    description:
      - Domain identifier.
    required: True

  path:
    description:
      - Path to the file or directory being managed
    required: True

  state:
    description:
      - If C(directory), all intermediate subdirectories will be created if they do not exist. If file, the file will B(not) be created if it does not exist.
      - If C(absent), directories will be recursively delete.
      - If C(show), shows information about the destination if it is a directory list its content.
      - If C(move), When you want to move an entire directory do not add the / character at the end.
        This state requires the I(source) and I(overwrite) parameters.
      - The C(overwrite) parameter does not apply when working with directories.
    required: False
    default: directory
    choices:
      - absent
      - directory
      - move
      - show

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

  - name: Create directory
    idg_domain_file:
        idg_connection: "{{ remote_idg }}"
        domain: dev
        path: local:/backup
        state: directory

  - name: Move file
    idg_domain_file:
        idg_connection: "{{ remote_idg }}"
        domain: dev
        path: local:/backup/ErrorCodes-2016.xsl
        source: local:/ErrorCodes.xml
        overwrite: False
        state: absent

  - name: Delefe file
    idg_domain_file:
        idg_connection: "{{ remote_idg }}"
        domain: dev
        path: local:/backup/july-2016.xsl
        state: absent

'''

RETURN = '''
msg:
  description:
    - Message returned by the device API.
  returned: always
  type: string
  sample:
    - Directory was created.

path:
  description:
    - Path to the file or directory managed
  returned: success
  type: string
  sample:
    - local:/backup
    - local:/backup/july-2016.xsl

output:
  description:
    - List of content of directories or detail of file target
  returned: success when I(state=show)
  type: dict
  sample:
    - {
        "directory": [{"name": "local:/XSLs"}, {"name": "local:/XSDs"}, {"name": "local:/XMLs"}],
        "file": [{"name": "ErrorCodes.xml", "size": 82226, "modified": "2018-08-01 11:09:51"}]
      }
'''

# Version control
__MODULE_NAME = "idg_domain_file"
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

    try:
        module_args = dict(
            state=dict(type='str', required=False, default='directory', choices=['absent', 'directory', 'move', 'show']),  # State alternatives
            path=dict(type='str', required=True),  # Path to resource
            source=dict(type='str', required=False),  # Source. Only valid when state = move
            overwrite=dict(type='bool', required=False, default=False),  # overwrite target. Valid when state = move
            domain=dict(type='str', required=True),  # Domain name
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True)  # IDG connection
        )

        # AnsibleModule instantiation
        module = AnsibleModule(
            argument_spec=module_args,
            supports_check_mode=True,
            required_if=[["state", "move", ["source", "overwrite"]]]
        )

        # Validates the dependence of the utility module
        if not HAS_IDG_DEPS:
            module.fail_json(msg="The IDG utils modules is required")

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
        move_file_msg = {"MoveFile": {"sURL": "", "dURL": "", "Overwrite": ""}}

        #
        # Here the action begins
        #

        pdb.set_trace()

        # Do request
        parse = urlparse(path)
        ldir = parse.scheme  # Local directory
        rpath = parse.path  # Relative path
        path_as_list = [d for d in rpath.split('/') if d.strip() != '']
        td = '/'.join([IDGApi.URI_FILESTORE.format(domain_name), ldir])  # Path prefix

        result_msg = ''

        if state == 'directory':
            # Create directory recursively
            for d in path_as_list:

                ck_code, ck_msg, ck_data = idg_mgmt.api_call(td, method='GET')

                if ck_code == 200 and ck_msg == 'OK':

                    td = '/'.join([td, d])

                    if 'directory' in ck_data['filestore']['location'].keys():
                        filestore_abst = AbstractListDict(ck_data['filestore']['location']['directory'])  # Search between directories
                    else:
                        filestore_abst = AbstractListDict({})  # Not contain directories

                    if td in filestore_abst.values(key='href'):  # if directory exist
                        result_msg = IDGUtils.IMMUTABLE_MESSAGE
                    else:  # Not exist, create it

                        # If the user is working in only check mode we do not want to make any changes
                        IDGUtils.implement_check_mode(module, result)

                        create_dir_msg['directory']['name'] = d
                        cr_code, cr_msg, cr_data = idg_mgmt.api_call(td, method='PUT', data=json.dumps(create_dir_msg))

                        if cr_code == 201 and cr_msg == 'Created':
                            result_msg = cr_data['result']
                            changed = True
                        else:
                            module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(cr_data['error'])))

                else:
                    module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(ck_data['error'])))

        elif state == 'move':  # Move remote files
            move_file_msg['MoveFile']['sURL'] = module.params['source']
            move_file_msg['MoveFile']['Overwrite'] = IDGUtils.str_on_off(module.params['overwrite'])
            move_file_msg['MoveFile']['dURL'] = path

            mv_code, mv_msg, mv_data = idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(move_file_msg))

            if mv_code == 200 and mv_msg == 'OK':
                result_msg = mv_data['MoveFile']
                changed = True
            else:
                module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(mv_data['error'])))

        elif state == 'show':  # Show details of file or content of directories

            sh_code, sh_msg, sh_data = idg_mgmt.api_call('/'.join([td] + path_as_list), method='GET')

            if sh_code == 200 and sh_msg == 'OK':
                output = {}
                if 'filestore' in sh_data.keys():  # is directory

                    if 'directory' in sh_data['filestore']['location'].keys():
                        output['directory'] = [{"name": i["name"]} for i in AbstractListDict(sh_data['filestore']['location']['directory']).raw_data()]

                    if 'file' in sh_data['filestore']['location'].keys():
                        output['file'] = [{"name": i["name"], "size": i["size"], "modified": i["modified"]} for i in AbstractListDict(sh_data['filestore']['location']['file']).raw_data()]
                else:
                    fi_code, fi_msg, fi_data = idg_mgmt.api_call('/'.join([td] + path_as_list[:-1]), method='GET')

                    if fi_code == 200 and fi_msg == 'OK':
                        output = [{"name": i["name"], "size": i["size"], "modified": i["modified"]} for i in fi_data['filestore']['location']['file'] if i['name'] == path_as_list[-1]]
                    else:
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(fi_data['error'])))

                result['output'] = output

            else:
                module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(sh_data['error'])))

        else:  # state = 'absent'
            # Remove directory recursively

            # If the user is working in only check mode we do not want to make any changes
            IDGUtils.implement_check_mode(module, result)

            td = '/'.join([td] + path_as_list)
            rm_code, rm_msg, rm_data = idg_mgmt.api_call(td, method='DELETE')

            if rm_code == 200 and rm_msg == 'OK':
                result_msg = rm_data['result']
                changed = True
            elif rm_code == 404 and rm_msg == 'Not Found':
                result_msg = IDGUtils.IMMUTABLE_MESSAGE
            else:
                module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(rm_data['error'])))

        # Finish
        result['msg'] = result_msg
        result['changed'] = changed

    except (NameError, UnboundLocalError) as e:
        # Very early error
        module_except = AnsibleModule(argument_spec={})
        module_except.fail_json(msg=to_native(e))

    except Exception as e:
        # Uncontrolled exception
        module.fail_json(msg=(IDGUtils.UNCONTROLLED_EXCEPTION + '. {0}').format(to_native(e)))
    else:
        # That's all folks!
        module.exit_json(**result)


if __name__ == '__main__':
    main()
