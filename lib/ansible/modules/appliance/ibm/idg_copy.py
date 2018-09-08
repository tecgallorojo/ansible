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

module: idg_copy
short_description: Copies files to remote IDGs
description:
  - The idg_domain_copy module upload a file from the local or remote IDG to a location on the remote IDG.
  - Use the idg_domain_fetch module to download files from remote IDGs to the local box.
version_added: "2.8"
options:

  domain:
    description:
      - Domain identifier.
    required: True

  backup:
    description:
      - Create a backup file adding a timestamp so you can get the original file back if something went wrong
    default: False
    type: bool

  src:
    description:
      - Local path to a file to copy to the remote server; can be absolute or relative.
      - If path is a directory, the contained files are copied.
    required: True

  dest:
    description:
      - Remote absolute path where the file should be copied to.
      - Always will be treated I(dest) as a directory.
    required: True

  recursive:
    description:
      - Indicates that you want to recursively(include subdirectories) upload the contents of a directory.
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
    idg_copy:
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

domain:
  description:
    - The name of the domain.
  returned: always
  type: string
  sample:
    - core-security-wrap
    - DevWSOrchestration

backup_file:
  description:
    - Name of backup file created
    - It is only returned when a single file is copied
  returned: when success and I(backup=True)
  type: string
  sample:
    - local:///xsls/transform.xsl-20180715T1425

'''

import json
import os
import base64
from zipfile import ZipFile
import datetime
import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native
from ansible.module_utils.six.moves.urllib.parse import urlparse

# Common package of our implementation for IDG
HAS_IDG_DEPS = False
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi, ErrorHandler
    HAS_IDG_DEPS = True
except ImportError:
    try:
        from library.module_utils.idg_common import result, idg_endpoint_spec, IDGUtils
        from library.module_utils.idg_rest_mgmt import IDGApi, ErrorHandler
        HAS_IDG_DEPS = True
    except ImportError:
        pass

# Version control
__MODULE_NAME = "idg_copy"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def create_directory(module, idg_mgmt, home_path, domain_name):
    create_dir_msg = {"directory": {"name": home_path.split('/')[-1]}}
    idg_mgmt.api_call(home_path, method='PUT', data=json.dumps(create_dir_msg), id="create_directory")

    if not idg_mgmt.is_created(idg_mgmt.last_call()) and not idg_mgmt.is_conflict(idg_mgmt.last_call()):
        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, "Upload directory", domain_name) + str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))
    else:
        return True


def do_backup(module, idg_mgmt, uri_file, remote_file, domain_name):
    idg_mgmt.api_call(uri_file, method='GET', id="make_backup")
    if idg_mgmt.is_ok(idg_mgmt.last_call()):  # File exists

        now = datetime.datetime.now()
        bak_file = remote_file + "-" + now.strftime("%Y%m%dT%H%M%S")
        move_file_msg = {"MoveFile": {"sURL": remote_file, "dURL": bak_file, "Overwrite": "on"}}

        idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(move_file_msg), id="move_file")

        if idg_mgmt.is_ok(idg_mgmt.last_call()):
            return bak_file
        else:
            module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, "Creating backup", domain_name) + str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))


def upload_file(module, idg_mgmt, local_file_path, uri_file, domain_name):

    with open(local_file_path, "rb") as f:
        encoded_file = base64.b64encode(f.read())

    create_file_msg = {"file": {"name": uri_file.split('/')[-1], "content": encoded_file.decode("utf-8")}}
    idg_mgmt.api_call(uri_file, method='PUT', data=json.dumps(create_file_msg), id="upload_file")

    if not idg_mgmt.is_created(idg_mgmt.last_call()) and not idg_mgmt.is_ok(idg_mgmt.last_call()):
        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, "Upload file", domain_name) + str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))
    else:
        return True


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        module_args = dict(
            backup=dict(type='bool', required=False, default=False),  # Create a backup file
            domain=dict(type='str', required=True),  # Domain name
            src=dict(type='str', required=True),  # Local path to a file or directory
            dest=dict(type='str', required=True),  # Remote absolute path
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
    backup = module.params['backup']
    recursive = module.params['recursive']

    tmp_dir = ''  # Directory for processing on the control host

    src = module.params['src']

    dest = module.params['dest']
    _dest_parse = urlparse(dest)
    _dest_ldir = _dest_parse.scheme  # Local directory
    if _dest_ldir + ':' not in IDGUtils.IDG_DIRS:
        module.fail_json(msg="Base directory of the destination file {0} does not correspond to what is specified for datapower.".format(dest))
    _dest_path_list = [d for d in _dest_parse.path.split('/') if d.strip() != '']

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
    tmp_result = {"msg": IDGUtils.COMPLETED_MESSAGE, "domain": domain_name, "backup_file": None, "changed": True}

    #
    # Here the action begins
    #
    pdb.set_trace()

    try:
        remote_home_path = '/'.join([IDGApi.URI_FILESTORE.format(domain_name), _dest_ldir] + _dest_path_list)
        idg_path = '/'.join([_dest_ldir + ':'] + _dest_path_list)

        if os.path.isdir(src):  # The source is a directory

            # If the user is working in only check mode we do not want to make any changes
            IDGUtils.implement_check_mode(module)

            if recursive:
                for home, subdirs, files in os.walk(src):  # Loop over directory

                    home_dir = home.strip('/').split(os.sep)[-1 * ((len(home.strip('/').split(os.sep)) - len(src.strip('/').split(os.sep))) + 1):]
                    remote_home_path_uri = '/'.join([remote_home_path] + home_dir)  # Update root path
                    idg_path_upd = '/'.join([idg_path] + home_dir)  # Update path inside IDG

                    create_directory(module, idg_mgmt, remote_home_path_uri, domain_name)

                    for file_name in files:  # files in home

                        uri_file = '/'.join([remote_home_path_uri, file_name])  # Update URI for file
                        remote_file = '/'.join([idg_path_upd, file_name])  # Update path inside IDG

                        if backup:  # Backup required
                            dummy = do_backup(module, idg_mgmt, uri_file, remote_file, domain_name)

                        local_file_path = os.path.join(home, file_name)
                        upload_file(module, idg_mgmt, local_file_path, uri_file, domain_name)

            else:  # Not recursive
                for home, dummy, files in os.walk(src):  # Loop over directory

                    home_dir = home.split(os.sep)[-1]
                    remote_home_path = '/'.join([remote_home_path, home_dir])  # Update root path
                    idg_path = '/'.join([idg_path, home_dir])  # Update path inside IDG

                    create_directory(module, idg_mgmt, remote_home_path, domain_name)

                    for file_name in files:  # files in home

                        uri_file = '/'.join([remote_home_path, file_name])  # Update URI for file
                        remote_file = '/'.join([idg_path, file_name])  # Path inside IDG

                        if backup:  # check backup
                            dummy = do_backup(module, idg_mgmt, uri_file, remote_file, domain_name)

                        local_file_path = os.path.join(home, file_name)
                        upload_file(module, idg_mgmt, local_file_path, uri_file, domain_name)

                    break  # Prevent continue touring directories

        elif os.path.isfile(src):  # The source is a local file

            file_name = src.split(os.sep)[-1]
            uri_file = '/'.join([remote_home_path, file_name])  # Update URI for file
            remote_file = '/'.join([idg_path, file_name])  # Path inside IDG

            idg_mgmt.api_call(remote_home_path, method='GET', id="get_remote_path")

            if idg_mgmt.is_ok(idg_mgmt.last_call()) or idg_mgmt.is_notfound(idg_mgmt.last_call()):

                # If the user is working in only check mode we do not want to make any changes
                IDGUtils.implement_check_mode(module)

                if 'filestore' not in idg_mgmt.last_call()["data"].keys() or idg_mgmt.is_notfound(idg_mgmt.last_call()):  # Is not a directory or not found
                    create_directory(module, idg_mgmt, remote_home_path, domain_name)

                if backup:  # check backup
                    tmp_result["backup_file"] = do_backup(module, idg_mgmt, uri_file, remote_file, domain_name)

                upload_file(module, idg_mgmt, src, uri_file, domain_name)  # Upload file

            else:
                # Other Errors
                module.fail_json(msg=IDGApi.GENERAL_STATELESS_ERROR.format(__MODULE_FULLNAME, domain_name) +
                                 str(ErrorHandler(idg_mgmt.call_by_id("get_remote_path")["data"]['error'])))

        else:
            module.fail_json(msg='Source "{0}" is not supported.'.format(src))

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
