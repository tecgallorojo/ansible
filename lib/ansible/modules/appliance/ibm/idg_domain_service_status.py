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
module: idg_domain_service_status
short_description: Lists local services
description:
  - Lists all local services that are listening for incoming connections.
version_added: "2.7"
options:

  filter:
    description:
      - Service name filter.

  ignore_case:
    description:
      - Perform case-insensitive matching.
    type: bool
    default: True

  domain:
    description:
      - Domain identifier.
    required: True

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower domain module
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

  - name: Show all active services
    idg_domain_services_status:
        idg_connection: "{{ remote_idg }}"
        domain: check-production
'''

RETURN = '''
domain_status:
  description:
    - List of found domains.
  returned: changed and success
  type: list
  sample:
    - [{'default'}]
'''

import json
import re
# import pdb

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
__MODULE_NAME = "idg_domain_service_status"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        module_args = dict(
            filter=dict(type='str', required=False, default=None),  # Service to search
            ignore_case=dict(type='bool', required=False, default=True),  # # Case-insensitive matching
            domain=dict(type='str', required=True),  # Domain name
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

    # Service to search
    service_filter = module.params['filter']
    filter_flags = re.IGNORECASE if module.params['ignore_case'] else 0

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
    tmp_result = {"msg": IDGUtils.COMPLETED_MESSAGE, "service_status": []}

    #
    # Here the action begins
    #
    # pdb.set_trace()

    try:
        # List of configured domains and their status
        sstatus_code, sstatus_msg, sstatus_data = idg_mgmt.api_call(IDGApi.URI_STATUS.format(domain_name) + "/ServicesStatus", method='GET')

        if sstatus_code == 200 and sstatus_msg == 'OK':  # If the answer is correct

            # List of existing services
            if "ServicesStatus" in sstatus_data.keys():
                if service_filter is not None:
                    active_services = [s for s in AbstractListDict(sstatus_data['ServicesStatus']).raw_data() if
                                       re.match(service_filter, s['ServiceName'], filter_flags)]
                else:
                    active_services = sstatus_data['ServicesStatus']

                tmp_result['service_status'] = active_services

            else:
                tmp_result['msg'] = sstatus_data['result']

        else:  # Can't read service's status
            module.fail_json(msg=IDGApi.GENERAL_STATELESS_ERROR.format(__MODULE_FULLNAME, domain_name) + str(ErrorHandler(sstatus_data['error'])))

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
