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
module: idg_rest_mgmt
short_description: Generic and simple module to use the REST management interface
description:
  - Generic and simple module to use the REST management interfac of the IBM DataPower Gateway(IDG).
version_added: "2.7"
options:

  method:
    description:
      - Specifies a request method to use when communicating with the HTTP server
    default: GET
    required: True
    choices:
      - GET
      - POST
      - PUT
      - DELETE
      - OPTIONS

  uri:
    description:
      - URI of the request.
    required: True

  payload:
    description:
      - Request payloads.
    required: False

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

  - name: Get CPU status
    idg_rest_mgmt:
        idg_connection: "{{ remote_idg }}"
        uri: /mgmt/status/default/CPUUsage
'''

RETURN = '''
http_code:
  description:
    - HTTP response status code.
  returned: always
  type: int
  sample:
    - 100
    - 200

http_phrase:
  description:
  - HTTP reason phrase.
  returned: always
  type: string
  sample:
    - Continue
    - OK

payload:
  description:
  - Response message payload
  returned: failed and success
  type: dict
  sample: {
            "DomainStatus": {
                "CurrentCommand": "",
                "DebugEnabled": "off",
                "DiagEnabled": "off",
                "ProbeEnabled": "off",
                "QuiesceState": "",
                "SaveNeeded": "on",
                "TraceEnabled": "off"
            },
            "_links": {
                "doc": {
                    "href": "/mgmt/docs/status/DomainStatus"
                },
                "self": {
                    "href": "/mgmt/status/default/DomainStatus"
                }
            }
        }
'''

# Version control
__MODULE_NAME="idg_rest_mgmt"
__MODULE_VERSION="1.0"
__MODULE_FULLNAME=__MODULE_NAME + '-' + __MODULE_VERSION

import json
# import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native

# Common package of our implementation for IDG
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi
    HAS_IDG_DEPS = True
except ImportError:
    HAS_IDG_DEPS = False


def main():

    module_args = dict(
        method=dict(type='str', required=False, default='GET', choices=['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']),  # HTTP methods
        uri=dict(type='str', required=True),  # URI of the request
        payload=dict(type='raw', required=False),  # Payload
        idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True)  # IDG connection
    )

    # AnsibleModule instantiation
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # Validates the dependence of the utility module
    if not HAS_IDG_DEPS:
        module.fail_json(msg="The IDG utils module is required")

    try:

        # Parse arguments to dict
        idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)
        payload = json.dumps(module.params['payload']) if module.params['payload'] else None

        # Customize the result
        del result['name']

        result.update({"http_code": None, "http_phrase": None, "payload": None})

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

        # Do request
        result['http_code'], result['http_phrase'], result['payload'] = idg_mgmt.api_call(module.params['uri'], method=module.params['method'],
                                                                                          data=payload)
        result['msg'] = IDGUtils.COMPLETED_MESSAGE
        result['changed'] = True
        result['failed'] = True if result['http_code'] >= 400 else False

    except Exception as e:
        # Uncontrolled exception
        module.fail_json(msg=(IDGUtils.UNCONTROLLED_EXCEPTION + '. {0}').format(to_native(e)))
    else:
        # That's all folks!
        module.exit_json(**result)


if __name__ == '__main__':
    main()
