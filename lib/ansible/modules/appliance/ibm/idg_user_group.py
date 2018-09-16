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
module: idg_user_group
short_description: Create or edit user groups and their access privileges.
description:
  - Create or edit user groups and their access privileges.
version_added: "2.8"
options:

  domain:
    description:
      - Domain identifier.
    required: True

  state:
    description:
      - Specifies the current state of the user group inside the domain.
      - C(present), C(absent). Create or remove.
    default: present
    required: False
    choices:
      - present
      - absent

  name:
    description:
      - User group identifier.
    required: True

  user_summary:
    description:
      - Descriptive summary for the configuration.

  admin_state:
    description:
      - Define the administrative state of the domain.
      - C(enabled), To make active.
      - C(disabled), To make inactive.
    default: enabled
    choices:
      - enabled
      - disabled

  access_profile:
    description:
      - The set of access policies that define the access privileges for members of the group.
      - When more than one policy applies to a resource, the most specific policy is used.
    default:
      - ["*/*/*?Access=r"]

  command_group:
    description:
      - The command groups to which the user group has CLI access.
      - This property is superceded by the access profile when role-based management is applied to the CLI.

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower idg_user_group module
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
        idg_user_group:
            idg_connection: "{{ remote_idg }}"
            name: validators
            domain: bill.prod
            state: present
            user_summary: Responsible for the validation of quality and operation
            command_group:
              - status

'''

RETURN = '''
domain:
  description:
    - The name of the domain.
  returned: always
  type: string
  sample:
    - core-security-wrap
    - DevWSOrchestration

name:
  description:
    - The name of the user group that is being worked on.
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
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi, ErrorHandler, AbstractListStr, AbstractListDict
    HAS_IDG_DEPS = True
except ImportError:
    try:
        from library.module_utils.idg_common import result, idg_endpoint_spec, IDGUtils
        from library.module_utils.idg_rest_mgmt import IDGApi, ErrorHandler, AbstractListStr, AbstractListDict
        HAS_IDG_DEPS = True
    except ImportError:
        pass

# Version control
__MODULE_NAME = "idg_user_group"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            domain=dict(type='str', required=True),  # Domain
            name=dict(type='str', required=True),  # User group name
            user_summary=dict(type='str', required=False),  # Description
            state=dict(type='str', choices=['present', 'absent'], default='present'),
            admin_state=dict(type='str', choices=['enabled', 'disabled'], default='enabled'),  # Administrative state
            access_profile=dict(type='list', default=["*/*/*?Access=r"]),  # Access policies
            command_group=dict(type='list'),  # CLI access command groups
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

    # Commands groups
    valid_commands_groups = [
        "aaapolicy",  # AAA Policy
        "acl",  # Access Control List
        "assembly",  # Assembly Actions
        "b2b",  # B2B
        "common",  # Common commands
        "compile-options",  # Compile Options
        "config-management",  # Configuration Management
        "configuration",  # Configuration
        "crl",  # CRL
        "quota-enforcement",  # Quota Enforcement
        "crypto",  # Cryptography
        "device-management",  # Device Management
        "diagnostics",  # Diagnostics
        "document-crypto-map",  # Document Crypto Map
        "domain",  # Domain
        "failure-notification",  # Failure Notification
        "file-management",  # File Management
        "firewallcred",  # Firewall Credentials
        "flash",  # Flash
        "httpserv",  # HTTP Service
        "input-conversion",  # Input Conversion Map
        "interface",  # Interface
        "load-balancer",  # Load Balancer
        "logging",  # Logging
        "matching",  # Matching
        "messages",  # Messages
        "monitors",  # Monitors
        "mpgw",  # Multi-Protocol Gateway
        "mq-qm",  # IBM MQ Queue Manager
        "network",  # Network
        "radius",  # RADIUS
        "rbm",  # RBM
        "schema-exception-map",  # Schema Exception Map
        "service-monitor",  # Web Service Monitor
        "snmp",  # SNMP Settings
        "sql",  # SQL Data Source
        "sslforwarder",  # SSL Proxy Service
        "stylesheetaction",  # Processing Action
        "stylesheetpolicy",  # Processing Policy
        "stylesheetrule",  # Processing Rule
        "system",  # System
        "tam",  # IBM Security Access Manager and Tivoli Federated Identity Manager
        "tcpproxy",  # TCP Proxy Service
        "urlmap",  # URL Map
        "urlrefresh",  # URL Refresh Policy
        "urlrewrite",  # URL Rewrite Policy
        "useragent",  # User Agent
        "usergroup",  # User and User Group
        "validation",  # Validation Credentials
        "webservice",  # Web Service Proxy
        "wsm-agent",  # Web Services Management Agent
        "xmlfirewall",  # XML Firewall
        "xmlmgr",  # XML Manager
        "xpath-routing",  # XPath Routing Map
        "xslcoproc",  # XSL Coprocessor
        "xslproxy",  # XSL Proxy
    ]

    # Parse arguments to dict
    idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)

    # Domain to work
    domain_name = module.params['domain']

    # Status
    state = module.params['state']
    admin_state = module.params['admin_state']
    usergroup_name = module.params['name']

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
    tmp_result = {"name": usergroup_name, "domain": domain_name, "msg": None, "changed": False, "failed": None}

    # Configuration template for the object
    usergroup_msg = {"UserGroup": {
        "name": usergroup_name,
        "mAdminState": admin_state,
        "AccessPolicies": AbstractListStr(module.params["access_profile"]).optimal()
    }}

    # Optional parameters
    # Comments
    if module.params['user_summary'] is not None:
        usergroup_msg["UserGroup"].update({"UserSummary": module.params['user_summary']})

    command_group = module.params['command_group']

    # Commands Groups
    if command_group is not None:
        if not all(c in valid_commands_groups for c in command_group):
            module.fail_json(msg="The command groups must belong to one of the valid values")
        usergroup_msg["UserGroup"].update({"CommandGroup": AbstractListStr(command_group).optimal() })

    #
    # Here the action begins
    #
    pdb.set_trace()

    try:

        # Get host alias configuration
        idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/UserGroup", method='GET', id="get_user_groups")

        if idg_mgmt.is_ok(idg_mgmt.last_call()):  # If the answer is correct

            exist_user_group = False
            exist_user_group_name = False
            if "UserGroup" in idg_mgmt.last_call()["data"].keys():
                for ug in idg_mgmt.last_call()["data"]["UserGroup"]:
                    del ug["_links"]  # Clean
                    if usergroup_msg["UserGroup"] == ug:
                        exist_user_group = True
                        break
                    elif usergroup_msg["UserGroup"]["name"] == ug["name"]:
                        exist_user_group_name = True
                        break

            if state == "present" and not exist_user_group:  # Requires the creation or modification of the group

                # If the user is working in only check mode we do not want to make any changes
                IDGUtils.implement_check_mode(module)

                idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/UserGroup/" + usergroup_name , method='PUT',
                                  data=json.dumps(usergroup_msg), id="do_user_group")

            elif state == "absent" and (exist_user_group or exist_user_group_name): # Requires remove the group

                    # If the user is working in only check mode we do not want to make any changes
                    IDGUtils.implement_check_mode(module)

                    idg_mgmt.api_call(IDGApi.URI_CONFIG.format(domain_name) + "/UserGroup/" + usergroup_name , method='DELETE', id="delete_user_group")

            else:  # Nothing to do
                tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

            if idg_mgmt.last_call()["id"] != "get_user_groups":  # Some modification to the configuration was required
                if idg_mgmt.is_created(idg_mgmt.last_call()) or idg_mgmt.is_ok(idg_mgmt.last_call()):
                    tmp_result['msg'] = idg_mgmt.last_call()["data"][usergroup_name]
                    tmp_result['changed'] = True

                else:
                    module.fail_json(msg=IDGApi.ERROR_REACH_STATE.format(__MODULE_FULLNAME, state, domain_name) +
                                     str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

        else:  # Can't read the settings
            module.fail_json(msg="Could not be read the current user group settings")

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
