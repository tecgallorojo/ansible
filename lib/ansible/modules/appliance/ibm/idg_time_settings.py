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
module: idg_time_settings
short_description: Current local time settings.
description:
  - This module configures the time zone set in the Time Configuration object and the date and time settings set in the System Control page.
version_added: "2.8"
options:

  time_zone:
    description:
      - The time zone to use in management interfaces.
      - The C(custom) method is not yet implemented
    choices:
        - HST10
        - AKST9AKDT
        - PST8PDT
        - MST7MDT
        - CST6CDT
        - EST5EDT
        - AST4ADT
        - UTC
        - GMT0BST
        - CET-1CEST
        - EET-2EEST
        - MSK-3MSD
        - AST-3
        - KRT-5
        - IST-5:30
        - NOVST-6NOVDT
        - CST-8 > CST
        - WST-8 > WST
        - JST-9 > JST
        - CST-9:30CDT
        - EST-10EDT
        - EST-10

  date:
    description:
      - The current local date settings set on the System Control page.

  time:
    description:
      - The current local time settings set on the System Control page.

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower idg_time_settings module
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
      - name: Configure Time Settings
        idg_time_settings:
            idg_connection: "{{ remote_idg }}"
            time_zone: CST6CDT

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
from datetime import datetime
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
__MODULE_NAME = "idg_time_settings"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            time_zone=dict(type='str', choices=["HST10", "AKST9AKDT", "PST8PDT", "MST7MDT", "CST6CDT", "EST5EDT", "AST4ADT", "UTC", "GMT0BST", "CET-1CEST",
                                                "EET-2EEST", "MSK-3MSD", "AST-3", "KRT-5", "IST-5:30", "NOVST-6NOVDT", "CST-8", "WST-8", "JST-9", "CST-9:30CDT",
                                                "EST-10EDT", "EST-10"]),  # Time zone
            date=dict(type='str'),
            time=dict(type='str'),
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

    # Parameters
    time_zone = module.params['time_zone']
    date = module.params['date']
    time = module.params['time']
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
    timezone_msg = {
        "LocalTimeZone": time_zone
    }

    # Intermediate values ​​for result
    tmp_result = {"msg": None, "changed": False, "failed": None}

    #
    # Here the action begins
    #
    pdb.set_trace()

    try:
        # Get time settings
        idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/TimeSettings", method='GET', id="get_time_settings")

        if idg_mgmt.is_ok(idg_mgmt.last_call()):  # If the answer is correct

            if (idg_mgmt.last_call()["data"]["TimeSettings"]["LocalTimeZone"] != time_zone) and (time_zone is not None):  # Need change de time zone

                # If the user is working in only check mode we do not want to make any changes
                IDGUtils.implement_check_mode(module)

                idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/TimeSettings/Time/LocalTimeZone", method='PUT', data=json.dumps(timezone_msg),
                                  id="set_local_timezone")

                if idg_mgmt.is_ok(idg_mgmt.last_call()):
                    tmp_result["changed"]=True
                    tmp_result["msg"] = idg_mgmt.last_call()["data"]["LocalTimeZone"]

            if date or time:  # New Date/Time values
                configured_datetime = datetime.strptime(idg_mgmt.call_by_id("get_time_settings")["data"]["TimeSettings"]["Time"], "%b %d, %Y %I:%M:%S %p")

                datetime_msg = {"SetTimeAndDate":{}}

                if date:
                    ndate = datetime.strptime(date, "%Y-%m-%d")
                    if configured_datetime.date() != ndate.date():
                        datetime_msg["SetTimeAndDate"].update({"Date": date})

                if time:
                    ntime = datetime.strptime(time, "%H:%M:%S")
                    if configured_datetime.time() != ntime.time():
                        datetime_msg["SetTimeAndDate"].update({"Time": time})

                if ("Date" in datetime_msg["SetTimeAndDate"].keys()) or ("Time" in datetime_msg["SetTimeAndDate"].keys()):
                    idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(datetime_msg),
                                      id="set_datetime")

                    if idg_mgmt.is_ok(idg_mgmt.last_call()):
                        tmp_result["changed"]=True
                        tmp_result["msg"] = idg_mgmt.last_call()["data"]["SetTimeAndDate"]
                    else:
                        module.fail_json(msg=IDGApi.GENERAL_STATELESS_ERROR.format(__MODULE_FULLNAME, domain_name)
                                         + str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

            if not tmp_result["changed"]:
                # The current configuration is identical to the new configuration, there is nothing to do
                tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

        else:  # Can't read the settings
            module.fail_json(msg="Could not be read the current time settings")

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
