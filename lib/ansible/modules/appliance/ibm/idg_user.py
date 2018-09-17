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
module: idg_user
short_description: Manage a local user account.
description:
  - Manage a local user account.
version_added: "2.8"
options:

  state:
    description:
      - Specifies the current state of the credentials.
      - C(present), C(absent). Create or remove.
      - C(password_resets). Changes the password of an existing user to a new password. The user will have to change the password on initial login.
      - C(force_password_change). User must change their password.
      - C(failed_login_resets). Reset failed login count for user.
    default: present
    choices:
      - present
      - absent
      - password_resets
      - force_password_change
      - failed_login_resets

  name:
    description:
      - Identifier for the Credential.
    required: True

  user_summary:
    description:
      - Descriptive summary for the configuration.

  admin_state:
    description:
      - Define the administrative state of the user.
      - C(enabled), To make active.
      - C(disabled), To make inactive.
    default: enabled
    choices:
      - enabled
      - disabled

  password:
    description:
      - Enter the password for the account.
    required: True

  suppress_password_change:
    description:
      - Indicate whether to force a change to the account password after the first ever successful login.
      - When disabled, the account owner must change the account password.
    default: False
    type: bool

  access_level:
    description:
      - Set the access level for the user account.
      - c(privileged). Grant access to all system functions.
      - C(group-defined). Assign the user account to a user group.
    default: enabled
    choices:
      - privileged
      - group-defined

  group:
    description:
      - Set the user group for the user account. A user account inherits access rights from its user group.

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower idg_user module
  connection: local
  hosts: localhost
  vars:
    remote_idg:
        server: idghost
        server_port: 5554
        user: admin
        password: admin
        validate_certs: false
        timeout: 15

  tasks:
      - name: Manage user group
        idg_user:
            idg_connection: "{{ remote_idg }}"
            name: tester
            state: present
            user_summary: Responsible for the validation of quality and operation
            access_level: group-defined
            group: testers

'''

RETURN = '''
name:
  description:
    - The name of the user account.
  returned: always
  type: string
  sample:
    - validators

msg:
  description:
    - Message returned by the device API.
  returned: always
  type: string
  sample:
    - Configuration was created.
    - Unknown error for (https://idg-host1:5554/mgmt/domains/config/). <open_url error timed out>
'''

import json
import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native

# Common package of our implementation for IDG
HAS_IDG_DEPS = False
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi, ErrorHandler, AbstractListStr
    HAS_IDG_DEPS = True
except ImportError:
    try:
        from library.module_utils.idg_common import result, idg_endpoint_spec, IDGUtils
        from library.module_utils.idg_rest_mgmt import IDGApi, ErrorHandler, AbstractListStr
        HAS_IDG_DEPS = True
    except ImportError:
        pass

# Version control
__MODULE_NAME = "idg_user"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            name=dict(type='str', required=True),  # User name
            user_summary=dict(type='str', required=False),  # Description
            state=dict(type='str', choices=["present", "absent", "password_resets", "force_password_change", "failed_login_resets"], default='present'),
            admin_state=dict(type='str', choices=['enabled', 'disabled'], default='enabled'),  # Administrative state
            password=dict(type='str'),  # User password
            suppress_password_change=dict(type='bool', default=False),
            access_level=dict(type='str', choices=['privileged', 'group-defined']),
            group=dict(type='str'),  # User group
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True)  # IDG connection
        )

        # AnsibleModule instantiation
        module = AnsibleModule(
            argument_spec=module_args,
            supports_check_mode=True,
            required_if=[["access_level", "group-defined", ["group"]],
                         ["state", "present", ["password"]],
                         ["state", "password_resets", ["password"]]]
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

    # Domain to work
    domain_name = "default"

    # Status
    state = module.params['state']
    admin_state = module.params['admin_state']
    user_name = module.params['name']
    user_password = module.params['password']

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
    tmp_result = {"name": user_name, "msg": None, "changed": False, "failed": None}

    # Configuration template for the object
    user_msg = {"User": {
        "name": user_name,
        "mAdminState": admin_state,
        "SuppressPasswordChange": module.params['suppress_password_change'],
        "Password": user_password,
        "AccessLevel": module.params['access_level']
    }}

    # Optional parameters
    # Comments
    if module.params['user_summary'] is not None:
        user_msg["User"].update({"UserSummary": module.params['user_summary']})
    # Group
    if module.params['access_level'] == "group-defined":
        user_msg["User"].update({"GroupName": {"value": module.params['group']}})

    #
    # Here the action begins
    #
    pdb.set_trace()

    try:

        rest_operation = user_name
        # Get host alias configuration
        idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/User", method='GET', id="get_users")

        if idg_mgmt.is_ok(idg_mgmt.last_call()):  # If the answer is correct

            exist_user, exist_user_name = False, False
            for u in idg_mgmt.last_call()["data"]["User"]:
                # Clean
                del u["_links"]

                if "GroupName" in u.keys():
                    del u["GroupName"]["href"]

                if not u["UserSummary"]:
                    del u["UserSummary"]

                if user_msg["User"] == u:
                    exist_user, exist_user_name = True, True
                    break
                elif user_msg["User"]["name"] == u["name"]:
                    exist_user_name = True
                    break

            pdb.set_trace()
            if (state not in ["present", "absent"]) and not (exist_user or exist_user_name):
                module.fail_json(msg=IDGApi.ERROR_REACH_STATE.format(state, domain_name) + " User don't exist")

            if state == "present":  # Requires the creation or modification of the user
                if not exist_user:
                    # If the user is working in only check mode we do not want to make any changes
                    IDGUtils.implement_check_mode(module)

                    idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/User/" + user_name , method='PUT', data=json.dumps(user_msg), id="do_user")

                else:
                    tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

            elif state == "password_resets":
                rest_operation = "UserResetPassword"
                action_msg = {rest_operation: {"User": user_name, "Password": user_password}}

                idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(action_msg), id="reset_user_password")

            elif state == "force_password_change":
                rest_operation = "UserForcePasswordChange"
                action_msg = {rest_operation: {"User": user_name}}

                idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(action_msg), id="force_password_change")

            elif state == "failed_login_resets":
                rest_operation = "UserResetFailedLogin"
                action_msg = {rest_operation: {"User": user_name}}

                idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(action_msg), id="failed_login_resets")

            else:  # state == "absent"
                if exist_user or exist_user_name:
                    # If the user is working in only check mode we do not want to make any changes
                    IDGUtils.implement_check_mode(module)

                    idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/User/" + user_name , method='DELETE', id="delete_user")

                else:
                    tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

            if idg_mgmt.last_call()["id"] != "get_users":  # Some modification to the configuration was required
                if idg_mgmt.is_created(idg_mgmt.last_call()) or idg_mgmt.is_ok(idg_mgmt.last_call()):
                    tmp_result['msg'] = idg_mgmt.last_call()["data"][rest_operation]
                    tmp_result['changed'] = True

                else:
                    module.fail_json(msg=IDGApi.ERROR_REACH_STATE.format(state, domain_name) +
                                     str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))


        else:  # Can't read the settings
            module.fail_json(msg="Could not be read the current user settings")

        #
        # Finish
        #
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
