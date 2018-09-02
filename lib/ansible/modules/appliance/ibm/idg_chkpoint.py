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
module: idg_chkpoint
short_description: Manages IBM DataPower Gateway(IDG) domains configuration checkpoints.
description:
  - Manages IBM DataPower Gateway(IDG) domains configuration checkpoints.
version_added: "2.7"
options:

  name:
    description:
      - Checkpoint identifier.
    required: True

  domain:
    description:
      - Domain identifier.
    required: True

  state:
    description:
      - Specifies the current state of the checkpoint inside the domain.
      - C(present), C(absent). Create or remove a checkpoint.
      - C(restored) return the domain configuration at the time that the checkpoint was created.
    default: present
    required: False
    choices:
      - present
      - absent
      - restored

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower checkpoint module
  connection: local
  hosts: localhost
  vars:
    domain_name: test
    chkpoint_name: checkpoint1
    remote_idg:
        server: idghost
        server_port: 5554
        user: admin
        password: admin
        validate_certs: false
        timeout: 15

  tasks:

  - name: Create checkpoint
    idg_chkpoint:
        name: "{{ chkpoint_name }}"
        domain: "{{ domain_name }}"
        idg_connection: "{{ remote_idg }}"
        state: present

  # Uncontrollable modifications

  - name: Restore from checkpoint
    idg_chkpoint:
        name: "{{ chkpoint_name }}"
        domain: "{{ domain_name }}"
        idg_connection: "{{ remote_idg }}"
        state: restored

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
    - The name of the checkpoint that is being worked on.
  returned: changed and success
  type: string
  sample:
    - checkpoint1

msg:
  description:
    - Message returned by the device API.
  returned: always
  type: string
  sample:
    - Completed
    - Cannot find Configuration Checkpoint 'checkpoint1'
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
__MODULE_NAME = "idg_chkpoint"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            state=dict(type='str', choices=['present', 'absent', 'restored'], default='present'),  # Checkpoint state
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True),  # IDG connection
            domain=dict(type='str', required=True),  # Domain
            name=dict(type='str', required=True)  # Checkpoint
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

    # Status & domain
    state = module.params['state']
    domain_name = module.params['domain']
    chkpoint_name = module.params['name']

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

    # Action messages:
    CHKPOINT_STATUS="DomainCheckpointStatus"

    # Save checkpoint
    save_act_msg = {"SaveCheckpoint": {"ChkName": chkpoint_name}}

    # Rollback checkpoint
    rollback_act_msg = {"RollbackCheckpoint": {"ChkName": chkpoint_name}}

    # Remove checkpoint
    remove_act_msg = {"RemoveCheckpoint": {"ChkName": chkpoint_name}}

    # Variable to store the status of the action
    action_result = ''

    # Intermediate values ​​for result
    tmp_result = {"name": chkpoint_name, "domain": domain_name, "msg": None, "changed": None, "failed": None}

    #
    # Here the action begins
    #
    pdb.set_trace()

    try:
        # List of configured domains
        idg_mgmt.api_call(IDGApi.URI_DOMAIN_LIST, method='GET', id="list_domains")

        if idg_mgmt.is_ok(idg_mgmt.last_call()):  # If the answer is correct

            # List of existing domains
            configured_domains = IDGUtils.domains_list(idg_mgmt.last_call()["data"]['domain'])

            if domain_name in configured_domains:  # Domain EXIST.

                idg_mgmt.api_call(IDGApi.URI_STATUS.format(domain_name) + "/" + CHKPOINT_STATUS, method='GET', id="list_chkpoints")
                if idg_mgmt.is_ok(idg_mgmt.last_call()):
                    chkpoints = AbstractListDict(idg_mgmt.last_call()["data"][CHKPOINT_STATUS])
                else:
                    module.fail_json(msg=IDGApi.ERROR_REACH_STATE.format(__MODULE_FULLNAME, state, domain_name) + " Unable to get " + CHKPOINT_STATUS)

                if state == 'present':

                    if chkpoint_name not in chkpoints.values(key="ChkName"):

                        # If the user is working in only check mode we do not want to make any changes
                        IDGUtils.implement_check_mode(module)

                        idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(save_act_msg), id="create_chkpoint")

                        if idg_mgmt.is_accepted(idg_mgmt.last_call()):
                            # Asynchronous actions save accepted. Wait for complete
                            idg_mgmt.api_event_sink(IDGApi.URI_ACTION.format(domain_name), href=idg_mgmt.last_call()["data"]['_links']['location']['href'],
                                                    state=state)

                            if idg_mgmt.is_ok(idg_mgmt.last_call()):
                                if idg_mgmt.last_call()["data"]["status"] == 'error':
                                    module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) +
                                                     str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))

                                else:
                                    tmp_result['msg'] = idg_mgmt.last_call()["data"]["status"].capitalize()
                                    tmp_result['changed'] = True
                            else:
                                # Can't retrieve the create checkpoint result
                                module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))

                        else:
                            # Create checkpoint not accepted
                            module.fail_json(msg=IDGApi.ERROR_ACCEPTING_ACTION.format(state, domain_name))
                    else:
                        tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

                elif state == 'absent':

                    if chkpoint_name in chkpoints.values(key="ChkName"):

                        # If the user is working in only check mode we do not want to make any changes
                        IDGUtils.implement_check_mode(module)

                        # pdb.set_trace()
                        idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(remove_act_msg), id="remove_chkpoint")

                        if idg_mgmt.is_ok(idg_mgmt.last_call()):
                            # Successfully processed synchronized action
                            tmp_result['msg'] = idg_mgmt.status_text(idg_mgmt.last_call()["data"]['RemoveCheckpoint'])
                            tmp_result['changed'] = True

                        else:
                            # Create checkpoint not accepted
                            module.fail_json(msg=IDGApi.ERROR_ACCEPTING_ACTION.format(state, domain_name))

                    else:
                        tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

                elif state == 'restored':

                    if chkpoint_name in chkpoints.values(key="ChkName"):

                        # If the user is working in only check mode we do not want to make any changes
                        IDGUtils.implement_check_mode(module)

                        idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(rollback_act_msg), id="restore_from_chkpoint")

                        if idg_mgmt.is_accepted(idg_mgmt.last_call()):
                            # Asynchronous actions remove accepted. Wait for complete
                            idg_mgmt.api_event_sink(IDGApi.URI_ACTION.format(domain_name), href=idg_mgmt.last_call()["data"]['_links']['location']['href'], state=state)

                            if idg_mgmt.is_ok(idg_mgmt.last_call()):

                                if idg_mgmt.last_call()["data"]['status'] == 'error':
                                    module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) +
                                                         str(ErrorHandler(idg_mgmt.last_call()["data"]['error'])))
                                else:
                                    tmp_result['msg'] = idg_mgmt.last_call()["data"]['status'].capitalize()
                                    tmp_result['changed'] = True
                            else:
                                # Can't retrieve the create checkpoint result
                                module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))
                        else:
                            # Create checkpoint not accepted
                            module.fail_json(msg=IDGApi.ERROR_ACCEPTING_ACTION.format(state, domain_name))

                    else:
                        # Can't work the configuration of non-existent checkpoint
                        module.fail_json(msg=(IDGApi.ERROR_REACH_STATE).format(state, domain_name) + " CheckPoint not exist.")

            else:  # Domain NOT EXIST.
                # Can't work the configuration of non-existent domain
                module.fail_json(msg=(IDGApi.ERROR_REACH_STATE + " " + IDGApi.ERROR_NOT_DOMAIN).format(state, domain_name))

        else:  # Can't read domain's lists
            module.fail_json(msg=IDGApi.ERROR_GET_DOMAIN_LIST)

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
