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
module: idg_crypto_certificate
short_description: Manages the public key portion of a private/public key pair, as for RSA or DSA, plus the certificate with which the key pair is used.
description:
  - Manages the public key portion of a private/public key pair plus the certificate
version_added: "2.7"
options:

  name:
    description:
      - Public key or certificate object identifier
    required: True

  domain:
    description:
      - Domain identifier.
    required: True

  state:
    description:
      - Specifies the current state of the key object inside the domain.
      - C(present), C(absent). Create or remove a object.
    default: present
    choices:
      - present
      - absent

  object_class:
    description:
      - Refers to the type of object, C(key), C(public-key).
    default: key
    choices:
      - key
      - public-key

  admin_state:
    description:
      - Define the administrative state of the object.
      - C(enabled), To make active.
      - C(disabled), To make inactive.
    default: enabled
    choices:
      - enabled
      - disabled

  file_name:
    description:
      - Specifies the file that contains the public key or certificate.

  ignore_expiration:
    description:
      - Whether to allow certificate-creation outside of expiration values
      - It is only taken when I(object_class=public-key)
    default: False
    type: bool

  password_alias:
    description:
      - The alias of the password required to access the file containing the public key and certificate.

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower crypto_certificate module
  connection: local
  hosts: localhost
  vars:
    domain_name: test
    cert_name: portal-cert
    remote_idg:
        server: idghost
        server_port: 5554
        user: admin
        password: admin
        validate_certs: false
        timeout: 15

  tasks:

  - name: Create crypto certificate object
    idg_crypto_object:
        name: "{{ cert_name }}"
        domain: "{{ domain_name }}"
        idg_connection: "{{ remote_idg }}"
        state: present
        file_name: cert:/portal-sscert.pem
        password_alias: portal-password

  - name: Delete crypto certificate object
    idg_crypto_object:
        name: "{{ key_name }}"
        domain: "{{ domain_name }}"
        idg_connection: "{{ remote_idg }}"
        state: absent

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
    - The name of the crypto certificate object.
  returned: always
  type: string
  sample:
    - portal-sscert.pem

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
__MODULE_NAME = "idg_crypto_certificate"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            state=dict(type='str', choices=['present', 'absent'], default='present'),  # Object state
            object_class=dict(type='str', choices=['key', 'public-key'], default='key'),  # class type
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True),  # IDG connection
            domain=dict(type='str', required=True),  # Domain
            name=dict(type='str', required=True),  # Object name
            admin_state=dict(type='str', choices=['enabled', 'disabled'], default='enabled'),  # Administrative state
            file_name=dict(type='str'),  # File with the public key
            ignore_expiration=dict(type='bool', default=False),
            password_alias=dict(type='str')
        )

        # AnsibleModule instantiation
        module = AnsibleModule(
            argument_spec=module_args,
            supports_check_mode=True,
            required_if=[
                ["state", "present", ["file_name"]]
            ]
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
    object_name = module.params['name']
    file_name = module.params['file_name']
    password_alias = module.params['password_alias']
    admin_state = module.params['admin_state']
    object_class = module.params['object_class']

    ignore_expiration = IDGUtils.str_on_off(module.params['ignore_expiration'])

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
    if object_class == 'public-key':
        # Create crypto certificate object
        REQ_OBJECT_ID="CryptoCertificate"
        create_msg = {REQ_OBJECT_ID: {"name": object_name, "mAdminState": admin_state, "Filename": file_name, "IgnoreExpiration": ignore_expiration, "Alias": {"value": password_alias }}}
        CRYPTOOBJ_URI_CFG = IDGApi.URI_CONFIG.format(domain_name) + "/" + REQ_OBJECT_ID
    else:
        # Create crypto key object
        REQ_OBJECT_ID="CryptoKey"
        create_msg = {REQ_OBJECT_ID: {"name": object_name, "mAdminState": admin_state, "Filename": file_name, "Alias": {"value": password_alias }}}
        CRYPTOOBJ_URI_CFG = IDGApi.URI_CONFIG.format(domain_name) + "/" + REQ_OBJECT_ID

    # Intermediate values ​​for result
    tmp_result = {"name": object_name, "domain": domain_name, "msg": None, "changed": None, "failed": None}

    #
    # Here the action begins
    #
    # pdb.set_trace()
    try:
        # List of configured domains
        chk_code, chk_msg, chk_data = idg_mgmt.api_call(CRYPTOOBJ_URI_CFG, method='GET')

        if chk_code == 200 and chk_msg == 'OK':  # If the answer is correct

            if REQ_OBJECT_ID in chk_data.keys():
                exist_obj = True if object_name in AbstractListDict(chk_data[REQ_OBJECT_ID]).values(key="name") else False
            else:
                exist_obj = False

            if state == 'present':
                if not exist_obj:  # Create it
                    create_code, create_msg, create_data = idg_mgmt.api_call(CRYPTOOBJ_URI_CFG, method='POST',
                                                                             data=json.dumps(create_msg))
                    if create_code == 201 and create_msg == 'Created':
                        tmp_result['msg'] = create_data[object_name]
                        tmp_result['changed'] = True

                    else:  # Can't read IDG status
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(create_data['error'])))

                else:  # Update
                    ck_code, ck_msg, ck_data = idg_mgmt.api_call(CRYPTOOBJ_URI_CFG + "/" + object_name, method='GET')

                    if ck_code == 200 and ck_msg == 'OK':

                        del ck_data[REQ_OBJECT_ID]['PasswordAlias']
                        if "Alias" in ck_data[REQ_OBJECT_ID].keys():
                            del ck_data[REQ_OBJECT_ID]['Alias']['href']

                        if ck_data[REQ_OBJECT_ID] != create_msg[REQ_OBJECT_ID]:
                            del_code, del_msg, del_data = idg_mgmt.api_call(CRYPTOOBJ_URI_CFG + "/" + object_name, method='DELETE')

                            if del_code == 200 and del_msg == 'OK':

                                create_code, create_msg, create_data = idg_mgmt.api_call(CRYPTOOBJ_URI_CFG, method='POST',
                                                                                         data=json.dumps(create_msg))
                                if create_code == 201 and create_msg == 'Created':
                                    tmp_result['msg'] = create_data[object_name]
                                    tmp_result['changed'] = True

                                else:  # Can't read IDG status
                                    module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name)
                                                     + str(ErrorHandler(create_data['error'])))

                            else:  # Can't remove for update object
                                module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(ck_data['error'])))
                        else:
                            tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

                    else:  # Can't read IDG status
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(ck_data['error'])))

            else:  #state == 'absent':
                if not exist_obj:  # Create it
                    tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

                else:
                    del_code, del_msg, del_data = idg_mgmt.api_call(CRYPTOOBJ_URI_CFG + "/" + object_name, method='DELETE')

                    if del_code == 200 and del_msg == 'OK':
                        tmp_result['msg'] = del_data[object_name]
                        tmp_result['changed'] = True

                    else:  # Can't remove for update object
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(del_data['error'])))

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
