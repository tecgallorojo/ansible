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
module: idg_domain_status
short_description: List of domains and their configurations
description:
  - List of domains present in the IBM DataPower Gateway(IDG) and their configurations.
version_added: "2.7"
options:

  filter:
    description:
      - Domain name filter.

  ignore_case:
    description:
      - Perform case-insensitive matching.
    type: bool
    default: True

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

  - name: Display a specific domain
    idg_domain_status:
        idg_connection: "{{ remote_idg }}"
        name: "{{ domain_name }}"
    vars:
        - domain_name: ProdDomain

  - name: Show all domains
    idg_domain_status:
        idg_connection: "{{ remote_idg }}"
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
import yaml
# import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native

# Common package of our implementation for IDG
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi, ErrorHandler
    HAS_IDG_DEPS = True
except ImportError:
    HAS_IDG_DEPS = False

# Version control
__MODULE_NAME = yaml.load(DOCUMENTATION)['module']
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():

    try:
        module_args = dict(
            filter=dict(type='str', required=False, default=None),  # Domain to search
            ignore_case=dict(type='bool', required=False, default=True),  # Domain to search
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True)  # IDG connection
        )

        # AnsibleModule instantiation
        module = AnsibleModule(
            argument_spec=module_args,
            supports_check_mode=True
        )

        # Validates the dependence of the utility module
        if not HAS_IDG_DEPS:
            module.fail_json(msg="The IDG utils modules is required")

        # Parse arguments to dict
        idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)

        # Domain to search
        domain_filter = module.params['filter']
        filter_flags = re.IGNORECASE if module.params['ignore_case'] else 0

        # Customize the result
        del result['name']

        result.update({"domain_status": []})  # Add domain_status to result

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

        #
        # Here the action begins
        #

        # pdb.set_trace()

        # List of configured domains and their status
        dstatus_code, dstatus_msg, dstatus_data = idg_mgmt.api_call(IDGApi.URI_DOMAIN_STATUS, method='GET')

        if dstatus_code == 200 and dstatus_msg == 'OK':  # If the answer is correct

            # List of existing domains
            if isinstance(dstatus_data['DomainStatus'], dict):  # if has only default domain
                configured_domains = [dstatus_data['DomainStatus'] if (domain_filter is None) or
                                                                      (re.match(domain_filter, dstatus_data['DomainStatus']['Domain'], filter_flags))
                                      else None]
            else:
                if domain_filter is not None:
                    configured_domains = [d for d in dstatus_data['DomainStatus'] if re.match(domain_filter, d['Domain'], filter_flags)]
                else:
                    configured_domains = dstatus_data['DomainStatus']

            if configured_domains != [] and configured_domains != [None]:
                for d in configured_domains:

                    if d is None:  # don't process it
                        continue

                    for field in ["DebugEnabled", "DiagEnabled", "ProbeEnabled", "SaveNeeded", "TraceEnabled"]:
                        d.update({field: IDGUtils.bool_on_off(d[field])})

                    # Get domain configuration
                    dconf_code, dconf_msg, dconf_data = idg_mgmt.api_call(IDGApi.URI_DOMAIN_CONFIG.format(d['Domain']), method='GET')

                    ds = {}  # State of each domain
                    if dconf_code == 200 and dconf_msg == 'OK':
                        ds.update(d)  # Add status data

                        # Add configuration data
                        ds.update({"mAdminState": dconf_data["Domain"]["mAdminState"]})
                        if 'UserSummary' in dconf_data["Domain"]:
                            ds.update({"UserSummary": dconf_data["Domain"]["UserSummary"]})
                        else:
                            ds.update({"UserSummary": ""})

                        result['domain_status'].append(ds)  # Add domain

                    else:
                        # Can't read domain configuration
                        module.fail_json(msg="Unable to get configuration from domain {0}.".format(d['Domain']))

                result['msg'] = IDGUtils.COMPLETED_MESSAGE

            else:
                # Domain not exist
                module.fail_json(msg=IDGApi.ERROR_NOT_DOMAIN)

        else:  # Can't read domain's lists
            module.fail_json(msg=IDGApi.ERROR_GET_DOMAIN_LIST)

    except (NameError, UnboundLocalError) as e:
        # Very early error
        module_except = AnsibleModule(argument_spec={})
        module_except.fail_json(msg=to_native(e))

    except Exception as e:
        # Uncontrolled exception
        module.fail_json(msg=(IDGUtils.UNCONTROLLED_EXCEPTION + '. {0}').format(to_native(e)))
    else:
        # That's all folks!
        module.exit_json(**result)


if __name__ == '__main__':
    main()
