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
module: idg_status
short_description: Status of the most important parameters of the device
description:
  - Status of the most important parameters of the device.
version_added: "2.7"
options:

  parameters:
    description: >
      Define a list of types of parameters to retrieve. The parameters are grouped in the following categories:
      C(All), C(Battery), C(Crypto), C(Sensors), C(DateTime), C(Temperature), C(Network), C(Failure), C(Firmware), C(Platform), C(Library), C(License),
      C(NTP), C(Raid), C(SNMP), C(Cloud), C(Balanced), C(Services), C(Standby), C(System)
    default:
        - All
    required: True

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Get DataPower status
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

  - name: Get system status
    idg_status:
        idg_connection: "{{ remote_idg }}"
        parameters: ["System"]

'''

RETURN = '''
status:
  description:
  - Recovered states
  returned: success
  type: list
  sample: [
            {
                "DateTime": [
                    {
                        "DateTimeStatus": {
                            "bootuptime2": "0 days 00:11:49",
                            "time": "Sun Jul 22 10:03:03 2018",
                            "timezone": "EDT",
                            "tzspec": "EST5EDT,M3.2.0/2:00,M11.1.0/2:00",
                            "uptime2": "0 days 00:03:52"
                        }
                    }
                ]
            }
        ]
'''

import json
import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native

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
__MODULE_NAME = "idg_status"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        module_args = dict(
            parameters=dict(type='list', required=False, default=['All']),  # Parameters to recover
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

    # pdb.set_trace()

    # Parse arguments to dict
    idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)

    parameters = set()
    if isinstance(module.params['parameters'], list):
        parameters = {x.lower() for x in module.params['parameters']} if module.params['parameters'] != [] else {'all'}
        if 'all' in parameters and len(parameters) > 1:
            parameters = {'all'}
            module.warn('If specify "All" the rest of the parameters are ignored')
    else:
        module.fail_json(msg='If "parameters" is specified, a list is required')

    result.update({"status": []})

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

    _DOMAIN = "default"
    _STATUS_DEFAULT = "/mgmt/status/" + _DOMAIN + "/"

    status_db = [
        {"param": "Battery", "href": _STATUS_DEFAULT + "Battery"},
        {"param": "Crypto", "href": _STATUS_DEFAULT + "CryptoEngineStatus2"},
        {"param": "Crypto", "href": _STATUS_DEFAULT + "CryptoHwDisableStatus"},
        {"param": "Crypto", "href": _STATUS_DEFAULT + "CryptoModeStatus"},
        {"param": "Crypto", "href": _STATUS_DEFAULT + "LunaLatency"},
        {"param": "Sensors", "href": _STATUS_DEFAULT + "CurrentSensors"},
        {"param": "Sensors", "href": _STATUS_DEFAULT + "PowerSensors"},
        {"param": "DateTime", "href": _STATUS_DEFAULT + "DateTimeStatus"},
        {"param": "DateTime", "href": _STATUS_DEFAULT + "DateTimeStatus2"},
        {"param": "Temperature", "href": _STATUS_DEFAULT + "EnvironmentalFanSensors"},
        {"param": "Temperature", "href": _STATUS_DEFAULT + "TemperatureSensors"},
        {"param": "Network", "href": _STATUS_DEFAULT + "EthernetInterfaceStatus"},
        {"param": "Network", "href": _STATUS_DEFAULT + "IPAddressStatus"},
        {"param": "Network", "href": _STATUS_DEFAULT + "IPMulticastStatus"},
        {"param": "Network", "href": _STATUS_DEFAULT + "LinkAggregationMemberStatus"},
        {"param": "Network", "href": _STATUS_DEFAULT + "LinkAggregationStatus"},
        {"param": "Network", "href": _STATUS_DEFAULT + "LinkStatus"},
        {"param": "Network", "href": _STATUS_DEFAULT + "NetworkInterfaceStatus"},
        {"param": "Network", "href": _STATUS_DEFAULT + "VlanInterfaceStatus2"},
        {"param": "Failure", "href": _STATUS_DEFAULT + "FailureNotificationStatus2"},
        {"param": "Firmware", "href": _STATUS_DEFAULT + "FirmwareStatus"},
        {"param": "Firmware", "href": _STATUS_DEFAULT + "FirmwareVersion2"},
        {"param": "Platform", "href": _STATUS_DEFAULT + "Hypervisor3"},
        {"param": "Platform", "href": _STATUS_DEFAULT + "VirtualPlatform3"},
        {"param": "Library", "href": _STATUS_DEFAULT + "LibraryVersion"},
        {"param": "License", "href": _STATUS_DEFAULT + "LicenseStatus"},
        {"param": "NTP", "href": _STATUS_DEFAULT + "NTPRefreshStatus"},
        {"param": "Raid", "href": _STATUS_DEFAULT + "RaidArrayStatus"},
        {"param": "Raid", "href": _STATUS_DEFAULT + "RaidBatteryBackUpStatus"},
        {"param": "Raid", "href": _STATUS_DEFAULT + "RaidBatteryModuleStatus"},
        {"param": "Raid", "href": _STATUS_DEFAULT + "RaidLogicalDriveStatus"},
        {"param": "Raid", "href": _STATUS_DEFAULT + "RaidPartitionStatus"},
        {"param": "Raid", "href": _STATUS_DEFAULT + "RaidPhysicalDriveStatus"},
        {"param": "SNMP", "href": _STATUS_DEFAULT + "SNMPStatus"},
        {"param": "Cloud", "href": _STATUS_DEFAULT + "SecureCloudConnectorConnectionsStatus"},
        {"param": "Balanced", "href": _STATUS_DEFAULT + "SelfBalancedStatus2"},
        {"param": "Balanced", "href": _STATUS_DEFAULT + "SelfBalancedTable"},
        {"param": "Services", "href": _STATUS_DEFAULT + "ServicesMemoryStatus2"},
        {"param": "Services", "href": _STATUS_DEFAULT + "ServicesStatus"},
        {"param": "Standby", "href": _STATUS_DEFAULT + "StandbyStatus2"},
        {"param": "System", "href": _STATUS_DEFAULT + "SystemUsage"},
        {"param": "System", "href": _STATUS_DEFAULT + "SystemUsage2Table"},
        {"param": "System", "href": _STATUS_DEFAULT + "FilesystemStatus"},
        {"param": "System", "href": _STATUS_DEFAULT + "MemoryStatus"},
        {"param": "System", "href": _STATUS_DEFAULT + "CPUUsage"}
    ]

    #
    # Here the action begins
    #
    pdb.set_trace()

    try:
        # Do request
        status_results = []
        pset = set()

        for s in status_db:
            pl = []
            if (s['param'].lower() in parameters or parameters == {'all'}) and (s['param'] not in pset):
                pset.add(s['param'])

                for s1 in status_db:
                    if s1['param'] == s['param']:

                        resource = s1['href'].rsplit('/', 1)[-1]

                        idg_mgmt.api_call(s1['href'], method='GET', id="get_appliance_status")

                        if idg_mgmt.is_ok(idg_mgmt.last_call()):
                            del(idg_mgmt.last_call()["data"]['_links'])

                            if 'result' in idg_mgmt.last_call()["data"].keys() and idg_mgmt.last_call()["data"]['result'] == "No status retrieved.":
                                idg_mgmt.last_call()["data"].update({resource: idg_mgmt.last_call()["data"]['result']})
                                del(idg_mgmt.last_call()["data"]['result'])

                            pl.append(idg_mgmt.last_call()["data"])
                        else:  # Can't retrieve the status
                            module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(resource, _DOMAIN))

            if pl:
                status_results.append({s['param']: pl})

        #
        # Finish
        #
        # Customize the result
        del result['name']
        # Update
        result['msg'] = IDGUtils.COMPLETED_MESSAGE
        result['changed'] = False
        result['status'] = status_results

    except Exception as e:
        # Uncontrolled exception
        module.fail_json(msg=(IDGUtils.UNCONTROLLED_EXCEPTION + '. {0}').format(to_native(e)))
    else:
        # That's all folks!
        module.exit_json(**result)


if __name__ == '__main__':
    main()
