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
module: idg_host_alias
short_description: Configure host alias entry
description:
  - A host alias is a map between a local IP address to a local alias.
  - The host alias is resolved like a static host entry.
  - Host aliases provide a level of abstraction between concrete network addresses and configuration.
version_added: "2.8"
options:

  entrys:
    description:
      - Host alias list.

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower idg_host_alias module
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
        idg_host_alias:
            idg_connection: "{{ remote_idg }}"
            entrys:
                - name: CORE-XML-SERVICES
                  ip_address: 192.168.1.2
                  state: enabled
                - name: DB-SERVER
                  ip_address: 192.168.1.10
                  state: enabled

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
__MODULE_NAME = "idg_host_alias"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def translate(d):
    t = {"IPAddress": d["ip_address"], "mAdminState": d["admin_state"], "name": d["name"]}
    if "user_summary" in d.keys() and d["user_summary"]:
        t.update({"UserSummary": d["user_summary"]})
    return t


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            entrys=dict(type='list'),  # List of hosts alias
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
    if module.params['entrys'] == []:
        module.fail_json(msg='Need data in the "entrys" field')

    entrys = [translate(e) for e in module.params['entrys']]

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

    # Intermediate values ​​for result
    tmp_result = {"msg": None, "changed": False, "failed": None}

    #
    # Here the action begins
    #
    pdb.set_trace()

    try:

        # Get host alias configuration
        idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/HostAlias", method='GET', id="get_hosts_alias")

        if idg_mgmt.is_ok(idg_mgmt.last_call()):  # If the answer is correct

            exist = []
            for hc in idg_mgmt.call_by_id("get_hosts_alias")["data"]["HostAlias"]:
                exist += [h for h in entrys if (h["name"] == hc["name"] and h["IPAddress"] == hc["IPAddress"]) and (h not in exist)]

            if exist == [] or (entrys.sort(key=lambda host: host["IPAddress"]) != exist.sort(key=lambda host: host["IPAddress"])):

                # If the user is working in only check mode we do not want to make any changes
                IDGUtils.implement_check_mode(module)

                nh = [h for h in entrys if h not in exist]

                for h in nh:
                    hosts_alias_msg = {"HostAlias": h}
                    # Set host alias configuration
                    idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/HostAlias", method='POST', data=json.dumps(hosts_alias_msg),
                                      id="set_hostsalias")

                    if idg_mgmt.is_created(idg_mgmt.last_call()):  # If the answer is correct
                        tmp_result['changed'] = True
                        tmp_result['msg'] = idg_mgmt.last_call()["data"][h["name"]]
                    else:
                        module.fail_json(msg=IDGApi.GENERAL_STATELESS_ERROR.format(__MODULE_FULLNAME, domain_name)
                                         + str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))
            else:
                tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

        else:  # Can't read the settings
            module.fail_json(msg="Could not be read the current host alias settings")

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
