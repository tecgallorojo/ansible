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
module: idg_domain_config
short_description: Manages IBM DataPower Gateway(IDG) domains configurations actions.
description:
  - Manages IBM DataPower Gateway(IDG) domains configurations actions.
version_added: "2.8"
options:
  name:
    description:
      - Domain identifier.
    required: True

  state:
    description:
      - Specifies the current state of the domain.
        C(reseted) will delete all configured services within the domain.
        C(exported), C(imported), C(saved) domain settings
        C(restarted) all services will be stoped and started.
      - Be particularly careful about changing the status C(reseted).
        These will B(deletes all configuration) data in the domain.
      - The status to C(restarted) will affect all configured services within the domain.
        C(restarted) all the configuration that has not been saved will be lost.

    default: saved
    required: True
    choices:
      - restarted
      - reseted
      - imported
      - exported
      - saved

  user_summary:
    description:
      - A descriptive summary for the export.

  all_files:
    description:
      - Include all files in the local directory for the domain?
      - Only be taken into account when I(state=exported)
    default: False
    type: bool

  persisted:
    description:
      - Export from persisted or running configuration?
      - Only be taken into account when I(state=exported)
    default: False
    type: bool

  internal_files:
    description:
      - Export internal configuration files?
      - Only be taken into account when I(state=exported)
    default: True
    type: bool

  input_file:
    description:
      - The base64-encoded BLOB to import
      - Only be taken into account when I(state=imported)

  overwrite_files:
    description:
      - Overwrite local files
      - Only be taken into account when I(state=imported)
    default: False
    type: bool

  overwrite_objects:
    description:
      - Overwrite objects that exist
      - Only be taken into account when I(state=imported)
    default: False
    type: bool

  dry_run:
    description:
      - Import package (on) or validate the import operation without importing (off).
      - Only be taken into account when I(state=imported)
    default: False
    type: bool

  rewrite_local_ip:
    description:
      - The local address bindings of services in the import package are rewritten on import to their equivalent interfaces
      - Only be taken into account I(state=imported)
    default: False
    type: bool

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower domain configuration module
  connection: local
  hosts: localhost
  vars:
    source_domain: test1
    target_domain: test2
    remote_idg:
        server: idghosts
        server_port: 5554
        user: admin
        password: admin
        validate_certs: false
        timeout: 15

  tasks:

    - name: Export domain
      idg_domain_config:
        name: "{{ source_domain }}"
        idg_connection: "{{ remote_idg }}"
        state: exported
        all_files: True
        user_summary: Midnight backup
      register: export_out

    - name: Import domain
      idg_domain_config:
        name: "{{ target_domain }}"
        idg_connection: "{{ remote_idg }}"
        state: imported
        overwrite_files: True
        overwrite_objects: True
        input_file: "{{ export_out['file'] }}"

    - name: Save domain
      idg_domain_config:
        name: "{{ target_domain }}"
        idg_connection: "{{ remote_idg }}"
        state: saved

    - name: Restart domain
      idg_domain:
        name: "{{ domain_name }}"
        idg_connection: "{{ remote_idg }}"
        state: restarted

'''

RETURN = '''
name:
  description:
    - The name of the domain that is being worked on.
  returned: always
  type: string
  sample:
    - core-security-wrap
    - DevWSOrchestration

msg:
  description:
    - Message returned by the device API.
  returned: always
  type: string
  sample:
    - Configuration was created.
    - Unknown error for (https://idg-host1:5554/mgmt/domains/config/). <open_url error timed out>

results:
  description:
    - Import result detail
  returned: when successfull imported
  type: complex
  contains:
      exec-script-results:
          description: Result of the execution of the import scripts
          returned: success
          type: complex
      export-details:
          description: Export details
          returned: success
          type: complex
      file-copy-log:
          description: Record of the copying files process
          returned: success
          type: complex
      imported-debug:
          description: Detail when importing debugging configurations
          returned: success
          type: complex
      imported-files:
          description: Detail when importing files
          returned: success
          type: complex
      imported-objects:
          description: Imported objects
          returned: success
          type: complex
'''

import json
#import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native

# Common package of our implementation for IDG
HAS_IDG_DEPS = False
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi
    HAS_IDG_DEPS = True
except ImportError:
    try:
        from library.module_utils.idg_common import result, idg_endpoint_spec, IDGUtils
        from library.module_utils.idg_rest_mgmt import IDGApi
        HAS_IDG_DEPS = True
    except ImportError:
        pass

# Version control
__MODULE_NAME = "idg_domain_config"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            state=dict(type='str', choices=['restarted', 'exported', 'imported', 'reseted', 'saved'], default='saved'),  # Domain's operational state
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True),  # IDG connection
            name=dict(type='str', required=True),  # Domain to work
            # for Export
            user_summary=dict(type='str'),  # Backup comment
            all_files=dict(type='bool', default=False),  # Include all files in the local: directory for the domain
            persisted=dict(type='bool', default=False),  # Export from persisted or running configuration
            internal_files=dict(type='bool', default=True),  # Export internal configuration file
            # for Import
            input_file=dict(type='str', required=False, no_log=True),  # The base64-encoded BLOB to import
            overwrite_files=dict(type='bool', default=False),  # Overwrite files that exist
            overwrite_objects=dict(type='bool', default=False),  # Overwrite objects that exist
            dry_run=dict(type='bool', default=False),  # Import package (on) or validate the import operation without importing (off).
            rewrite_local_ip=dict(type='bool', default=False)  # The local address binding to their equivalent interfaces in appliance
            # TODO !!!
            # DeploymentPolicy
        )

        # AnsibleModule instantiation
        module = AnsibleModule(
            argument_spec=module_args,
            supports_check_mode=True,
            # Interaction between parameters
            required_if=[['state', 'imported', ['input_file']]]
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
    domain_name = module.params['name']

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

    # Variable to store the status of the action
    action_result = ''

    # Configuration template for the domain
    export_action_msg = {"Export": {
        "Format": "ZIP",
        "UserComment": module.params['user_summary'],
        "AllFiles": IDGUtils.str_on_off(module.params['all_files']),
        "Persisted": IDGUtils.str_on_off(module.params['persisted']),
        "IncludeInternalFiles": IDGUtils.str_on_off(module.params['internal_files'])
        # TODO
        # "DeploymentPolicy":""
    }}

    import_action_msg = {"Import": {
        "Format": "ZIP",
        "InputFile": module.params['input_file'],
        "OverwriteFiles": IDGUtils.str_on_off(module.params['overwrite_files']),
        "OverwriteObjects": IDGUtils.str_on_off(module.params['overwrite_objects']),
        "DryRun": IDGUtils.str_on_off(module.params['dry_run']),
        "RewriteLocalIP": IDGUtils.str_on_off(module.params['rewrite_local_ip'])
        # TODO
        # "DeploymentPolicy": "name",
        # "DeploymentPolicyParams": "name",
    }}

    # Action messages
    # Restart
    restart_act_msg = {"RestartThisDomain": {}}
    # Reset
    reset_act_msg = {"ResetThisDomain": {}}
    # Save
    save_act_msg = {"SaveConfig": {}}

    # Intermediate values ​​for result
    tmp_result = {"name": domain_name, "msg": None, "file": None, "changed": None, "failed": None}

    #
    # Here the action begins
    #
    # pdb.set_trace()

    try:
        # List of configured domains
        idg_mgmt.api_call(IDGApi.URI_DOMAIN_LIST, method='GET', id="list_domains")

        if idg_mgmt.is_ok(idg_mgmt.last_call()):  # If the answer is correct

            # List of existing domains
            configured_domains = IDGUtils.domains_list(idg_mgmt.last_call()["data"]['domain'])

            if domain_name in configured_domains:  # Domain EXIST.

                if state == 'exported':
                    # If the user is working in only check mode we do not want to make any changes
                    IDGUtils.implement_check_mode(module)

                    # export and finish
                    idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(export_action_msg), id="export_domain")

                    if idg_mgmt.is_accepted(idg_mgmt.last_call()):
                        # Asynchronous actions export accepted. Wait for complete
                        idg_mgmt.api_event_sink(IDGApi.URI_ACTION.format(domain_name), href=idg_mgmt.last_call()["data"]['_links']['location']['href'], state=state)

                        if idg_mgmt.is_ok(idg_mgmt.last_call()):
                            # Export ok
                            tmp_result['file'] = idg_mgmt.last_call()["data"]['result']['file']
                            tmp_result['msg'] = idg_mgmt.last_call()["data"]["status"].capitalize()
                            tmp_result['changed'] = False
                        else:
                            # Can't retrieve the export
                            module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))

                    else:
                        # Export not accepted
                        module.fail_json(msg=IDGApi.ERROR_ACCEPTING_ACTION.format(state, domain_name))

                elif state == 'reseted':

                    # If the user is working in only check mode we do not want to make any changes
                    IDGUtils.implement_check_mode(module)

                    # Reseted domain
                    idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(reset_act_msg), id="reset_domain")

                    if idg_mgmt.is_accepted(idg_mgmt.last_call()):
                        # Asynchronous actions reset accepted. Wait for complete
                        idg_mgmt.api_event_sink(IDGApi.URI_ACTION.format(domain_name), href=idg_mgmt.last_call()["data"]['_links']['location']['href'], state=state)

                        if idg_mgmt.is_ok(idg_mgmt.last_call()):
                            # Reseted successfully
                            tmp_result['msg'] = idg_mgmt.last_call()["data"]["status"].capitalize()
                            tmp_result['changed'] = True
                        else:
                            # Can't retrieve the reset result
                            module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))

                    else:
                        # Reseted not accepted
                        module.fail_json(msg=IDGApi.ERROR_ACCEPTING_ACTION.format(state, domain_name))

                elif state == 'saved':

                    idg_mgmt.api_call(IDGApi.URI_DOMAIN_STATUS, method='GET', id="get_domain_status")

                    if idg_mgmt.is_ok(idg_mgmt.last_call()):

                        if isinstance(idg_mgmt.last_call()["data"]['DomainStatus'], dict):
                            domain_save_needed = idg_mgmt.last_call()["data"]['DomainStatus']['SaveNeeded']
                        else:
                            domain_save_needed = [d['SaveNeeded'] for d in idg_mgmt.last_call()["data"]['DomainStatus'] if d['Domain'] == domain_name][0]

                        # Saved domain
                        if domain_save_needed != 'off':

                            # If the user is working in only check mode we do not want to make any changes
                            IDGUtils.implement_check_mode(module)

                            idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(save_act_msg), id="save_domain")

                            if idg_mgmt.is_ok(idg_mgmt.last_call()):
                                # Successfully processed synchronized action save
                                tmp_result['msg'] = idg_mgmt.status_text(idg_mgmt.last_call()["data"]['SaveConfig'])
                                tmp_result['changed'] = True
                            else:
                                # Can't saved
                                module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))
                        else:
                            # Domain is save
                            tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

                elif state == 'restarted':  # Restart domain
                    # If the user is working in only check mode we do not want to make any changes
                    IDGUtils.implement_check_mode(module)

                    idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(restart_act_msg), id="restart_domain")

                    if idg_mgmt.is_accepted(idg_mgmt.last_call()):
                        # Asynchronous actions restart accepted. Wait for complete
                        idg_mgmt.api_event_sink(IDGApi.URI_ACTION.format(domain_name),
                                                href=idg_mgmt.call_by_id("restart_domain")["data"]['_links']['location']['href'], state=state)

                        if idg_mgmt.is_ok(idg_mgmt.last_call()):
                            # Restarted successfully
                            tmp_result['msg'] = idg_mgmt.last_call()["data"]["status"].capitalize()
                            tmp_result['changed'] = True
                        else:
                            # Can't retrieve the restart result
                            module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))

                    else:
                        # Can't restarted
                        module.fail_json(msg=IDGApi.ERROR_ACCEPTING_ACTION.format(state, domain_name))

                elif state == 'imported':

                    # If the user is working in only check mode we do not want to make any changes
                    IDGUtils.implement_check_mode(module)

                    # Import
                    # pdb.set_trace()
                    idg_mgmt.api_call(IDGApi.URI_ACTION.format(domain_name), method='POST', data=json.dumps(import_action_msg), id="import_domain")

                    if idg_mgmt.is_accepted(idg_mgmt.last_call()):
                        # Asynchronous actions import accepted. Wait for complete
                        idg_mgmt.api_event_sink(IDGApi.URI_ACTION.format(domain_name), href=idg_mgmt.last_call()["data"]['_links']['location']['href'],
                                                state=state)

                        if idg_mgmt.is_ok(idg_mgmt.last_call()):
                            # Export completed
                            import_results = idg_mgmt.last_call()["data"]['result']['Import']['import-results']
                            if import_results['detected-errors'] != 'false':
                                # Import failed
                                tmp_result['msg'] = 'Import failed with error code: "' + import_results['detected-errors']['error'] + '"'
                                tmp_result['changed'] = False
                                tmp_result['failed'] = True
                            else:
                                # Import success
                                tmp_result.update({"results": []})  # Add result details
                                tmp_result['results'].append({"export-details": import_results['export-details']})  # Export action detail
                                # Elements of the export to incorporate in the final result
                                relevant_results = {"exec-script-results": "cfg-result",
                                                    "file-copy-log": "file-result",
                                                    "imported-objects": "object",
                                                    "imported-files": "file",
                                                    "imported-debug": "debug"}

                                for k, v in relevant_results.items():  # Add all elements
                                    tmp_result['results'].append(IDGUtils.format_import_result(import_results,element=k,detail=v))

                                tmp_result['msg'] = idg_mgmt.last_call()["data"]['status'].capitalize()
                                tmp_result['changed'] = True
                        else:
                            # Can't retrieve the import result
                            module.fail_json(msg=IDGApi.ERROR_RETRIEVING_RESULT.format(state, domain_name))

                    else:
                        # Imported not accepted
                        module.fail_json(msg=IDGApi.ERROR_ACCEPTING_ACTION.format(state, domain_name))

            else:  # Domain NOT EXIST.
                # pdb.set_trace()
                # Opps can't work the configuration of non-existent domain
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
