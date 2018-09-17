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
version_added: "2.8"
options:

  domain:
    description:
      - Domain identifier.
    required: True

  path:
    description:
      - Path to file or directory.
      - When the I(state=move) refers to the target
    required: True

  source:
    description:
      - When the I(state=move) indicates the source file or directory
    required: True

  overwrite:
    description:
      - When the I(state=move) indicates that you want to overwrite the destination
    required: False
    type: bool
    default: False

  state:
    description:
      - C(directory) all intermediate subdirectories will be created if they do not exist. If file, the file will B(not) be created if it does not exist.
      - C(absent) remove files or directories. Directories will be recursively delete.
      - C(show) shows information about the destination if it is a directory list its content.
      - C(move) move (rename) files or directories. This state requires the I(source) and I(overwrite) parameters.
      - C(overwrite) indicates that you want to overwrite the destination. Not apply when working with directories.
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

domain:
  description:
    - The name of the domain.
  returned: always
  type: string
  sample:
    - core-security-wrap
    - DevWSOrchestration

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

import json
import pdb

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
__MODULE_NAME = "idg_file"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
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
    else:
        # Failure AnsibleModule instance
        module = AnsibleModule(
            argument_spec={},
            check_invalid_arguments=False
        )
        module.fail_json(msg="The IDG utils modules is required")

    # Parse arguments to dict
    idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)
    path = module.params['path']
    state = module.params['state']
    domain_name = module.params['domain']

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

    # Intermediate values ​​for result
    tmp_result = {"domain": domain_name, "msg": None, "path": None, "changed": None, "output": None}

    #
    # Here the action begins
    #
    pdb.set_trace()

    try:
        # Do request
        parse = urlparse(path)
        ldir = parse.scheme  # Local directory
        rpath = parse.path  # Relative path
        path_as_list = [d for d in rpath.split('/') if d.strip() != '']
        td = '/'.join([IDGApi.URI_FILESTORE.format(domain_name), ldir])  # Path prefix

        if state == 'directory':
            # Create directory recursively
            for d in path_as_list:

                idg_mgmt.api_call(td, method='GET', id="get_remote_directory")

                if idg_mgmt.is_ok(idg_mgmt.last_call()):

                    td = '/'.join([td, d])
                    tmp_result['path'] = idg_mgmt.apifilestore_uri2path(td)

                    if 'directory' in idg_mgmt.last_call()["data"]['filestore']['location'].keys():
                        filestore_abst = AbstractListDict(idg_mgmt.last_call()["data"]['filestore']['location']['directory'])  # Get directories
                    else:
                        filestore_abst = AbstractListDict({})  # Not contain directories

                    if ('href' in filestore_abst.keys()) and (td in filestore_abst.values(key='href')):  # if directory exist
                        tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

                    else:  # Not exist, create it
                        # If the user is working in only check mode we do not want to make any changes
                        IDGUtils.implement_check_mode(module)

                        create_dir_msg = {"directory": {"name": d}}
                        idg_mgmt.api_call(td, method='PUT', data=json.dumps(create_dir_msg), id="create_directory")

                        if idg_mgmt.is_created(idg_mgmt.last_call()):
                            tmp_result['msg'] = idg_mgmt.last_call()["data"]['result']
                            tmp_result['changed'] = True
                        else:
                            module.fail_json(msg=IDGApi.ERROR_REACH_STATE.format(state, domain_name) +
                                             str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

                else:
                    module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) +
                                     str(ErrorHandler(idg_mgmt.call_by_id("get_remote_directory")["data"]['error'])))

        elif state == 'move':  # Move remote files

            # If the user is working in only check mode we do not want to make any changes
            IDGUtils.implement_check_mode(module)

            move_file_msg = {"MoveFile": {"sURL": module.params['source'].strip('/'), "dURL": path.strip('/'),
                             "Overwrite": IDGUtils.str_on_off(module.params['overwrite'])}}
            tmp_result['path'] = move_file_msg['MoveFile']['dURL']

            idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(move_file_msg), id="move_file")

            if idg_mgmt.is_ok(idg_mgmt.last_call()):
                tmp_result['msg'] = idg_mgmt.last_call()["data"]['MoveFile']
                tmp_result['changed'] = True
            else:
                module.fail_json(msg=IDGApi.ERROR_REACH_STATE.format(state, domain_name) +
                                 str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

        elif state == 'show':  # Show details of file or content of directories

            # If the user is working in only check mode we do not want to make any changes
            IDGUtils.implement_check_mode(module)

            list_target = '/'.join([td] + path_as_list)
            idg_mgmt.api_call(list_target, method='GET', id="get_remote_target")

            if idg_mgmt.is_ok(idg_mgmt.last_call()):
                output = {}
                if 'filestore' in idg_mgmt.last_call()["data"].keys():  # is directory

                    if 'directory' in idg_mgmt.last_call()["data"]['filestore']['location'].keys():
                        output['directory'] = [{"name": i["name"]} for i in AbstractListDict(idg_mgmt.last_call()["data"]['filestore']['location']['directory']).raw_data()]

                    if 'file' in idg_mgmt.last_call()["data"]['filestore']['location'].keys():
                        output['file'] = [{"name": i["name"], "size": i["size"], "modified": i["modified"]}
                                          for i in AbstractListDict(idg_mgmt.last_call()["data"]['filestore']['location']['file']).raw_data()]
                else:
                    idg_mgmt.api_call('/'.join([td] + path_as_list[:-1]), method='GET', id="get_file_detail")

                    if idg_mgmt.is_ok(idg_mgmt.last_call()):
                        output = [{"name": i["name"], "size": i["size"], "modified": i["modified"]}
                                  for i in idg_mgmt.last_call()["data"]['filestore']['location']['file'] if i['name'] == path_as_list[-1]]
                    else:
                        module.fail_json(msg=IDGApi.ERROR_REACH_STATE.format(state, domain_name) +
                                         str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

                tmp_result['msg'] = IDGUtils.COMPLETED_MESSAGE
                tmp_result['path'] = idg_mgmt.apifilestore_uri2path(list_target)
                tmp_result['output'] = output

            else:
                module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) +
                                 str(ErrorHandler(idg_mgmt.call_by_id("get_remote_target")["data"]['error'])))

        else:  # Remove
            # Remove directory recursively

            # If the user is working in only check mode we do not want to make any changes
            IDGUtils.implement_check_mode(module)

            td = '/'.join([td] + path_as_list)
            idg_mgmt.api_call(td, method='DELETE', id="remove_remote_target")
            tmp_result['path'] = idg_mgmt.apifilestore_uri2path(td)

            if idg_mgmt.is_ok(idg_mgmt.last_call()):
                tmp_result['msg'] = idg_mgmt.last_call()["data"]['result']
                tmp_result['changed'] = True

            elif idg_mgmt.is_notfound(idg_mgmt.last_call()):
                tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

            else:
                module.fail_json(msg=IDGApi.ERROR_REACH_STATE.format(state, domain_name) +
                                 str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

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
