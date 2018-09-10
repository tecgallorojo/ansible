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
module: idg_ntp_service
short_description: Current local time settings.
description:
  - This module configure NTP (Network Time Protocol) server in the IDG.
  - This allows the automatic synchronization of the system clock.
version_added: "2.8"
options:

  user_summary:
    description:
      - Description for the domain.

  admin_state:
    description:
      - Define the administrative state of the domain.
      - C(enabled), To make active.
      - C(disabled), To make inactive.
    default: enabled
    choices:
      - enabled
      - disabled

  remote_server:
    description:
      - The host name or IP address of an NTP server.
      - If you define multiple servers, ensure that the sequence to contact the servers is your preferred order.

  refresh_interval:
    description:
      - The interval between clock synchronizations. Enter a value in the range 60 - 86400.
    default: 900

  state:
    description:
      - Specifies the current state of the service.
      - C(present) configure and enable or disabled the NTP service.
      - C(absent) this state not remove de object only disable it.
    default: present
    required: True
    choices:
      - present
      - absent

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower idg_ntp_service module
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
      - name: Configure NTP Servers
        idg_ntp_service:
            idg_connection: "{{ remote_idg }}"
            state: present
            user_summary: Servires empresariales de NTP
            remote_server:
                - 10.10.1.1
                - 10.10.2.1
            refresh_interval: 1800

'''

RETURN = '''
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
__MODULE_NAME = "idg_ntp_service"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            user_summary=dict(type='str', required=False),  # Object description
            admin_state=dict(type='str', choices=['enabled', 'disabled'], default='enabled'),  # Administrative state
            remote_server=dict(type='list', default=[]),  # List of remote NTP servers
            refresh_interval=dict(type='int', default=900),
            state=dict(type='str', choices=['present', 'absent'], default='present'),  # Service's operational state
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True)  # IDG connection
        )

        # AnsibleModule instantiation
        module = AnsibleModule(
            argument_spec=module_args,
            supports_check_mode=True,
            # Interaction between parameters
            required_if=[['admin_state', 'enabled', ['remote_server']]]
        )

    else:
        # Failure AnsibleModule instance
        module = AnsibleModule(
            argument_spec={},
            check_invalid_arguments=False
        )
        module.fail_json(msg="The IDG utils modules is required")

    # Parameters
    state = module.params['state']
    admin_state = module.params['admin_state']
    remote_server = module.params['remote_server']
    refresh_interval = module.params['refresh_interval']
    domain_name = "default"  # System's level configurations are always do in default domain

    # Parse arguments to dict
    idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)

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

    # Quiesce
    ntpservice_msg = { "NTPService": {
                        "name": "NTP Service",
                        "RefreshInterval": refresh_interval,
                        "mAdminState": admin_state,
                        "RemoteServer": remote_server
                    }}

    ntpservice_disable_msg = { "mAdminState": "disabled" }


    if module.params['user_summary'] is not None:
        ntpservice_msg["NTPService"].update({"UserSummary": module.params['user_summary']})

    # Intermediate values ​​for result
    tmp_result = {"msg": None, "changed": False, "failed": None}

    #
    # Here the action begins
    #
    pdb.set_trace()

    try:
        # Get NTP Service status
        idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/NTPService", method='GET', id="get_ntpservice_status")

        if idg_mgmt.is_ok(idg_mgmt.last_call()):  # If the answer is correct

            if state == 'present':
                # Clean
                del idg_mgmt.last_call()["data"]["NTPService"]["_links"]

                if idg_mgmt.last_call()["data"]["NTPService"] != ntpservice_msg["NTPService"]:  # Need update or create
                    idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name)+ "/NTPService/NTP+Service", method="PUT", data=json.dumps(ntpservice_msg), id="set_ntpservice_configuration")

                    if idg_mgmt.is_ok(idg_mgmt.last_call()):
                        tmp_result['msg'] = idg_mgmt.status_text(idg_mgmt.last_call()["data"]["NTP_Service"])
                        tmp_result['changed'] = True
                    else:
                        # Opps can't update
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) +
                                         str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

                else:  # Ident configuration
                    tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

            else:  # state = absent

                if idg_mgmt.last_call()["data"]["NTPService"]["mAdminState"] == "enabled":  # Need change
                    idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name)+ "/NTPService/NTP+Service/mAdminState", method="PUT",
                                      data=json.dumps(ntpservice_disable_msg), id="disable_ntpservice")

                    if idg_mgmt.is_ok(idg_mgmt.last_call()):
                        tmp_result['msg'] = idg_mgmt.status_text(idg_mgmt.last_call()["data"]["mAdminState"])
                        tmp_result['changed'] = True
                    else:
                        # Opps can't update
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) +
                                         str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

                else:  # Ident configuration
                    tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE


        else:  # Can't read the settings
            module.fail_json(msg="Could not be read the current NTP service settings")

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
