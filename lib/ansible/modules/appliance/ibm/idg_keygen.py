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
module: idg_keygen
short_description: Generates a public-private key pair and a certificate signing request files (CSR)
description:
  - Generates a public-private key pair and a certificate signing request (CSR) files in a specific domain.
  - The parameters I(hsm), I(hsm_name) are available on only an HSM-equipped DataPower Gateway.
version_added: "2.7"
options:

  certificate_data:
    description:
      - The Base Standard for PKI(X.509) certificate data
      - For the chain fields use a text string up to 64 characters in length.
      - If the string contains spaces, enclose in double quotation marks.

    required: True
    suboptions:

      country:
        description:
          - The ISO two-character country identifier.

      locality:
        description:
          - The city or town name.

      state:
        description:
          - The unabbreviated state or province name.

      organization:
        description:
          - The organization name.

      organizational_unit:
        description:
          - Organizational unit name.

      common_name:
        description:
          - Fully qualified domain name of the server.
        required: True

      days:
        description:
          - specifies the validity period in days for the self-signed certificate.
        default: 365

  ldap_reverse_order:
    description:
      - Indicate whether to create the LDAP entry in reverse RDN order.
    default: False
    type: bool

  domain:
    description:
      - Domain identifier.
    required: True

  file_name:
    description:
      - Specifies a common prefix for the generated private key, CSR, and self-signed certificate.

  password_alias:
    description:
      - Optionally specifies the password alias map that defines the alias that maps to the cleartext password.

  key_type:
    description:
      - Indicates the type of key to generate. The following values are supported. The default value is C(RSA).
      - C(RSA). Generates RSA keys.
      - C(ECDSA). Generates Elliptic Curve Digital Signature Algorithm (ECDSA) keys. This does not apply to an HSM-equipped DataPower Gateway.
    default: RSA
    choices:
      - RSA
      - ECDSA

  key_length:
    description:
      - Indicates the length of the generated C(RSA) keys.
      - This keyword is required only when the key type set by the I(key_type=RSA).
    default: 2048
    choices:
      - 1024
      - 2048
      - 4096

  digest:
    description:
      - Specifies the hash algorithm of the generated RSA keys.
      - This keyword is required only when the key type set by the I(key_type=RSA).
    default: sha256
    choices:
      - sha1
      - sha256

  ecdsa_curve:
    description:
      - Specifies the elliptic curve to use to generate the C(ECDSA) keys.
      - This keyword is required only when the I(key_type=ECDSA).
    default: secp256r1
    choices:
        - sect163k1
        - sect163r1
        - sect163r2
        - sect193r1
        - sect193r2
        - sect233k1
        - sect233r1
        - sect239k1
        - sect283k1
        - sect283r1
        - sect409k1
        - sect409r1
        - sect571k1
        - sect571r1
        - secp160k1
        - secp160r1
        - secp160r2
        - secp192k1
        - secp192r1
        - secp224k1
        - secp224r1
        - secp256k1
        - secp256r1
        - secp384r1
        - secp521r1
        - brainpoolP256r1
        - brainpoolP384r1
        - brainpoolP512r1

  export_key:
    description:
      - Creates a copy of the private key in the U(temporary:) directory in addition to the one in the U(cert:) directory.
      - You cannot specify this parameter when you create the key on an HSM-equipped DataPower Gateway.
    default: False
    type: bool

  export_sscert:
    description:
      - Creates a copy of the self-signed certificate in the U(temporary:) directory in addition to the one in the U(cert:) directory.
    default: False
    type: bool

  hsm:
    description:
      - Creates the private key on the HSM instead of in memory.
    default: False
    type: bool

  hsm_name:
    description:
      - A label for the key created on the HSM. If not specified, the value of the object-name parameter is used.

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: DataPower passwordalias module
  connection: local
  hosts: localhost
  vars:
    domain_name: test
    passw_map_alias: api-security-password
    remote_idg:
        server: idghost
        server_port: 5554
        user: admin
        password: admin
        validate_certs: false
        timeout: 15

  tasks:

  - name: Create public-private key pair and a CSR
    idg_keygen:
        certificate_data: "{{ content }}"
        domain: "{{ domain_name }}"
        file_name: pki-api
        idg_connection: "{{ remote_idg }}"
        password_alias: "{{ passw_map_alias }}"
    vars:
        content:
          country: MX
          locality: CDMX
          organization: MyProject
          organizational_unit: '"MyProject security"'
          common_name: www.myproject.mx

'''

RETURN = '''
key-file:
  description:
    - The name generated private key.
  returned: success
  type: string
  sample:
    - portal-key.pem

sscert-file:
  description:
    - The name generated self-signed certificate.
  returned: success
  type: string
  sample:
    - portal-server.pem

csr-file:
  description:
    - The name generated certificate signing request.
  returned: success
  type: string
  sample:
    - portal-server.pem

msg:
  description:
    - Message returned by the device API.
  returned: always
  type: string
  sample:
    - Configuration was created.
'''

import json
import pdb

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native

# Common package of our implementation for IDG
HAS_IDG_DEPS = False
try:
    from ansible.module_utils.appliance.ibm.idg_common import result, idg_endpoint_spec, IDGUtils
    from ansible.module_utils.appliance.ibm.idg_rest_mgmt import IDGApi, AbstractListDict, ErrorHandler
    HAS_IDG_DEPS = True
except ImportError:
    try:
        from library.module_utils.idg_common import result, idg_endpoint_spec, IDGUtils
        from library.module_utils.idg_rest_mgmt import IDGApi, AbstractListDict, ErrorHandler
        HAS_IDG_DEPS = True
    except ImportError:
        pass

# Version control
__MODULE_NAME = "idg_keygen"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:

        certificate_spec = {
          "country": dict(type='str', default=''),
          "state": dict(type='str', default=''),
          "locality": dict(type='str', default=''),
          "organization": dict(type='str', default=''),
          "organizational_unit":dict(type='str', default=''),
          "organizational_unit1":dict(type='str', default=''),
          "organizational_unit2":dict(type='str', default=''),
          "organizational_unit3":dict(type='str', default=''),
          "common_name": dict(type='str', required=True),
          "days": dict(type='int', default=365)
        }

        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True),  # IDG connection
            certificate_data=dict(type='dict', options=certificate_spec, required=True),  # Certificate data
            ldap_reverse_order=dict(type='bool', default=False),
            domain=dict(type='str', required=True),  # Domain
            file_name=dict(type='str', required=False),  # prefix for the generated private key, CSR, and certificate
            password_alias=dict(type='str'),
            key_type=dict(type='str', choices=['RSA', 'ECDSA'], default='RSA'),
            key_length=dict(type='int', choices=[1024, 2048, 4096], default=2048),
            digest=dict(type='str', choices=['sha1', 'sha256'], default='sha256'),
            ecdsa_curve=dict(type='str', choices=["sect163k1", "sect163r1", "sect163r2", "sect193r1", "sect193r2", "sect233k1", "sect233r1", "sect239k1",
                                                  "sect283k1", "sect283r1", "sect409k1", "sect409r1", "sect571k1", "sect571r1", "secp160k1", "secp160r1",
                                                  "secp160r2", "secp192k1", "secp192r1", "secp224k1", "secp224r1", "secp256k1", "secp256r1", "secp384r1",
                                                  "secp521r1", "brainpoolP256r1", "brainpoolP384r1", "brainpoolP512r1"], default='secp256r1'),
            using_key=dict(type='str'),
            export_key=dict(type='bool', default=False),
            export_sscert=dict(type='bool', default=False),
            gen_sscert=dict(type='bool', default=False),
            gen_object=dict(type='bool', default=False),
            # Validate relation HSM/Object OJO
            hsm=dict(type='bool', default=False),
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
    certificate_data = IDGUtils.parse_to_dict(module, module.params['certificate_data'], 'CertificateData', IDGUtils.ANSIBLE_VERSION)

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

    # Create
    create_msg = { "Keygen": {
        "LDAPOrder": IDGUtils.str_on_off(module.params['ldap_reverse_order']),
        "C": certificate_data['country'],
        "ST": certificate_data['state'],
        "L": certificate_data['locality'],
        "O": certificate_data['organization'],
        "OU": certificate_data['organizational_unit'],
        "OU1": certificate_data['organizational_unit1'],
        "OU2": certificate_data['organizational_unit2'],
        "OU3": certificate_data['organizational_unit3'],
        "CN": certificate_data['common_name'],
        "Days": certificate_data['days'],
        "KeyType": module.params['key_type'],
        "KeyLength": module.params['key_length'],
        "Digest": module.params['digest'],
        "ECDSACurve": module.params['ecdsa_curve'],
        "FileName": module.params['file_name'],
        "PasswordAlias": module.params['password_alias'],
        "ExportKey": IDGUtils.str_on_off(module.params['export_key']),
        "ExportSSCert": IDGUtils.str_on_off(module.params['export_sscert']),
        "GenSSCert": IDGUtils.str_on_off(module.params['gen_sscert']),
        "HSM": IDGUtils.str_on_off(module.params['hsm']),
        "UsingKey": module.params['using_key']
    }}

    for k, v in create_msg['Keygen'].items():
        if str(v).strip() == '':
            del create_msg['Keygen'][k]

    URI_KEYGEN = IDGApi.URI_ACTION.format(domain_name)
    # Variable to store the status of the action
    action_result = ''

    # Intermediate values ​​for result
    tmp_result = {"name": pam_name, "domain": domain_name, "msg": None, "changed": None}

    #
    # Here the action begins
    #

    # pdb.set_trace()
    try:

        # List of configured password alias in domain
        chk_code, chk_msg, chk_data = idg_mgmt.api_call(URI_PAM_CONFIG, method='GET')

        if chk_code == 200 and chk_msg == 'OK':  # If the answer is correct

            if 'PasswordAlias' in chk_data.keys():
                pams = AbstractListDict(chk_data['PasswordAlias'])
            else:
                pams = AbstractListDict({})

            if state == 'present':

                # If the user is working in only check mode we do not want to make any changes
                IDGUtils.implement_check_mode(module)

                if pam_name not in pams.values(key='name'):  # Create

                    create_code, create_msg, create_data = idg_mgmt.api_call(URI_PAM_CONFIG, method='POST', data=json.dumps(create_msg))

                    if create_code == 201 and create_msg == 'Created':
                        # Create successfully
                        tmp_result['msg'] = create_data[pam_name]
                        tmp_result['changed'] = True

                    else:
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(create_data['error'])))

                else:  # Update
                    upd_code, upd_msg, upd_data = idg_mgmt.api_call(URI_PAM_CONFIG + '/' + pam_name, method='PUT', data=json.dumps(create_msg))

                    if upd_code == 200 and upd_msg == 'OK':
                        # Update successfully
                        tmp_result['msg'] = upd_data[pam_name]
                        tmp_result['changed'] = True

                    else:
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(upd_data['error'])))

            elif state == 'absent':

                # If the user is working in only check mode we do not want to make any changes
                IDGUtils.implement_check_mode(module)

                if pam_name in pams.values(key='name'):

                    rem_code, rem_msg, rem_data = idg_mgmt.api_call(URI_PAM_CONFIG + '/' + pam_name, method='DELETE')

                    if rem_code == 200 and rem_msg == 'OK':
                        # Update successfully
                        tmp_result['msg'] = rem_data[pam_name]
                        tmp_result['changed'] = True

                    else:
                        module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(rem_data['error'])))

                else:
                    tmp_result['msg'] = IDGUtils.IMMUTABLE_MESSAGE

        else:  # Can't read password alias status
            module.fail_json(msg=IDGApi.GENERAL_ERROR.format(__MODULE_FULLNAME, state, domain_name) + str(ErrorHandler(chk_data['error'])))

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
