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
module: idg_domain_password_alias
short_description: Manage the mapping of aliases to passwords.
description:
  - Manage the mapping of aliases to passwords.
version_added: "2.7"
options:

  name:
    description:
      - Password alias identifier.
    required: True

  domain:
    description:
      - Domain identifier.
    required: True

  state:
    description:
      - Specifies the current state of the password alias object inside the domain.
      - C(present), C(absent). Create or remove a passwords.
    default: present
    choices:
      - present
      - absent

  admin_state:
    description:
      - Administrative state of this configuration.
    default: enabled
    choices:
      - enabled
      - disabled

  summary:
    description:
      - Comments for the object.

  password:
    description:
      - Plaintext password to alias.
    required: True

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: DataPower passwordalias module
  connection: local
  hosts: localhost
  vars:
    domain_name: test
    passw_alias_name: passw
    remote_idg:
        server: idghost
        server_port: 5554
        user: admin
        password: admin
        validate_certs: false
        timeout: 15

  tasks:

  - name: Create or update password alias map
    idg_domain_password_alias:
        name: "{{ passw_alias_name }}"
        password: Passw0rd
        summary: PAssword for Portal
        domain: "{{ domain_name }}"
        idg_connection: "{{ remote_idg }}"
        state: present

  # Remove

  - name: Remove password alias map
    idg_domain_password_alias:
        name: "{{ chkpoint_name }}"
        domain: "{{ domain_name }}"
        idg_connection: "{{ remote_idg }}"
        state: absent
'''

RETURN = '''
domain:
  description:
    - The name of the domain.
  returned: changed and success
  type: string
  sample:
    - core-security-wrap
    - DevWSOrchestration

name:
  description:
    - The name of the password map alias.
  returned: changed and success
  type: string
  sample:
    - password-ssl-portal

msg:
  description:
    - Message returned by the device API.
  returned: always
  type: string
  sample:
    - Configuration was created.
'''

import json
# import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native
from http import HTTPStatus

# Common package of our implementation for IDG
HAS_IDG_DEPS = False
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi, AbstractListDict, ErrorHandler
    HAS_IDG_DEPS = True
except ImportError:
    try:
        from library.module_utils.idg_common import result, idg_endpoint_spec, IDGUtils
        from library.module_utils.idg_rest_mgmt import IDGApi, AbstractListDict, ErrorHandler
        HAS_IDG_DEPS = True
    except ImportError:
        pass

# Version control
__MODULE_NAME = "idg_domain_password_alias"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            state=dict(type='str', choices=['present', 'absent'], default='present'),  # Password map alias state
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True),  # IDG connection
            domain=dict(type='str', required=True),  # Domain
            name=dict(type='str', required=True),  # Password map alias
            password=dict(type='str', no_log=True),  # Plaintext password to alias
            admin_state=dict(type='str', choices=['enabled', 'disabled'], default='enabled'),  # Administrative state
            summary=dict(type='str', required=False)  # Description
        )

        # AnsibleModule instantiation
        module = AnsibleModule(
            argument_spec=module_args,
            supports_check_mode=True,
            required_if=[["state", "present", ["password"]]]
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

    state = module.params['state']
    domain_name = module.params['domain']
    # Password Alias Map (pam)
    pam_name = module.params['name']
    pam_admin_state = module.params['admin_state']
    pam_summary = module.params['summary']
    pam_passw = module.params['password']

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

    # Create or update
    create_msg = {"PasswordAlias": {"name": pam_name, "mAdminState": pam_admin_state, "Password": pam_passw, "UserSummary": pam_summary}}

    URI_PAM_CONFIG = IDGApi.URI_CONFIG.format(domain_name) + "/PasswordAlias"
    # Variable to store the status of the action
    action_result = ''

    # Intermediate values ​​for result
    tmp_result = {"name": pam_name, "domain": domain_name, "msg": None, "changed": None}

    #
    # Here the action begins
    #

    # pdb.set_trace()
    try:

        # List of configured password alias in domain
        chk_code, chk_msg, chk_data = idg_mgmt.api_call(URI_PAM_CONFIG, method='GET')

        if chk_code == 200 and chk_msg == 'OK':  # If the answer is correct

            if 'PasswordAlias' in chk_data.keys():
                pams = AbstractListDict(chk_data['PasswordAlias'])
            else:
                pams = AbstractListDict({})

            if state == 'present':

                # If the user is working in only check mode we do not want to make any changes
                IDGUtils.implement_check_mode(module)

                if pam_name not in pams.values(key='name'):  # Create

                    create_code, create_msg, create_data = idg_mgmt.api_call(URI_PAM_CONFIG, method='POST', data=json.dumps(create_msg))

                    if create_code == 201 and create_msg == 'Created':
                        # Create successfully
                        tmp_result['msg'] = create_data[pam_name]
                        tmp_result['changed'] = True

                    else:
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(create_data['error'])))

                else:  # Update
                    upd_code, upd_msg, upd_data = idg_mgmt.api_call(URI_PAM_CONFIG + '/' + pam_name, method='PUT', data=json.dumps(create_msg))

                    if upd_code == 200 and upd_msg == 'OK':
                        # Update successfully
                        tmp_result['msg'] = upd_data[pam_name]
                        tmp_result['changed'] = True

                    else:
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(upd_data['error'])))

            elif state == 'absent':

                # If the user is working in only check mode we do not want to make any changes
                IDGUtils.implement_check_mode(module)

                if pam_name in pams.values(key='name'):

                    rem_code, rem_msg, rem_data = idg_mgmt.api_call(URI_PAM_CONFIG + '/' + pam_name, method='DELETE')

                    if rem_code == 200 and rem_msg == 'OK':
                        # Update successfully
                        tmp_result['msg'] = rem_data[pam_name]
                        tmp_result['changed'] = True

                    else:
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(rem_data['error'])))

                else:
                    tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

        else:  # Can't read password alias status
            module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(chk_data['error'])))

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
