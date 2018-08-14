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

      organizational_unit1:
        description:
          - First additional organizational unit.

      organizational_unit2:
        description:
          - Second additional organizational unit.

      organizational_unit3:
        description:
          - Third additional organizational unit.

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

  prefix_name:
    description:
      - Specifies a common prefix for the generated private key, CSR, and self-signed certificate.
      - If not specified, the value of the common_name parameter is used to generate one.

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

  using_key:
    description:
      - Specify the name of an existing key object. The action creates a new certificate and CSR for this key. The action does not create a new key.

  hsm:
    description:
      - Creates the private key on the HSM instead of in memory.
    default: False
    type: bool

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
        prefix_name: pki-api
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
  returned: success and I(gen_sscert=True)
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
import copy
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
          "country": dict(type='str'),
          "state": dict(type='str'),
          "locality": dict(type='str'),
          "organization": dict(type='str'),
          "organizational_unit":dict(type='str'),
          "organizational_unit1":dict(type='str'),
          "organizational_unit2":dict(type='str'),
          "organizational_unit3":dict(type='str'),
          "common_name": dict(type='str', required=True),
          "days": dict(type='int', default=365)
        }

        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True),  # IDG connection
            certificate_data=dict(type='dict', options=certificate_spec, required=True),  # Certificate data
            ldap_reverse_order=dict(type='bool', default=False),
            domain=dict(type='str', required=True),  # Domain
            prefix_name=dict(type='str', required=False),  # prefix for the generated private key, CSR, and certificate
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

    CRYPTO_FORMAT_EXT="pem"  # Cryptographic file extension
    CSR_EXT="csr"
    CRYPTO_KEY_POSTFIX="privkey"
    CRYPTO_SSC_POSTFIX="sscert"

    TMP_DIR="temporary:/"
    CERT_DIR="cert:/"

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
    create_tpl = { "Keygen": {
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
        "FileName": module.params['prefix_name'],
        "PasswordAlias": module.params['password_alias'],
        "ExportKey": IDGUtils.str_on_off(module.params['export_key']),
        "ExportSSCert": IDGUtils.str_on_off(module.params['export_sscert']),
        "GenSSCert": IDGUtils.str_on_off(module.params['gen_sscert']),
        "HSM": IDGUtils.str_on_off(module.params['hsm']),
        "UsingKey": module.params['using_key']
    }}

    create_msg = copy.deepcopy(create_tpl)
    for k, v in create_tpl['Keygen'].items():
        if v is None:
            del create_msg['Keygen'][k]

    URI_KEYGEN = IDGApi.URI_ACTION.format(domain_name)

    # Intermediate values ​​for result
    tmp_result = {"domain": domain_name, "msg": None, "changed": None, "key-file": None, "sscert-file": None, "csr-file": None}

    #
    # Here the action begins
    #

    pdb.set_trace()
    try:

        code, msg, data = idg_mgmt.api_call(URI_KEYGEN, method='POST', data=json.dumps(create_msg))

        if code == 200 and msg == 'OK':  # If the answer is correct
            tmp_result['msg'] = data['Keygen']
            tmp_result['changed'] = True

            # Directories
            key_dir = TMP_DIR if module.params['export_key'] else CERT_DIR

            if "FileName" in create_msg["Keygen"].keys():
                tmp_result['key-file'] = key_dir + create_msg["Keygen"]["FileName"] + '-' + CRYPTO_KEY_POSTFIX + '.' + CRYPTO_FORMAT_EXT
                if module.params['gen_sscert']:
                    ssc_dir = TMP_DIR if module.params['export_sscert'] else CERT_DIR
                    tmp_result['sscert-file'] = ssc_dir + create_msg["Keygen"]["FileName"] + '-' + CRYPTO_SSC_POSTFIX + '.' + CRYPTO_FORMAT_EXT
                tmp_result['csr-file'] = TMP_DIR + create_msg["Keygen"]["FileName"] + '.' + CSR_EXT

            else:
                tmp_result['key-file'] = key_dir + create_msg["Keygen"]["CN"] + '-' + CRYPTO_KEY_POSTFIX + '.' + CRYPTO_FORMAT_EXT
                if module.params['gen_sscert']:
                    ssc_dir = TMP_DIR if module.params['export_sscert'] else CERT_DIR
                    tmp_result['sscert-file'] = ssc_dir + create_msg["Keygen"]["CN"] + '-' + CRYPTO_SSC_POSTFIX + '.' + CRYPTO_FORMAT_EXT
                tmp_result['csr-file'] = TMP_DIR + create_msg["Keygen"]["CN"] + '.' + CSR_EXT

        else:  # Wrong request
            module.fail_json(msg=IDGApi.GENERAL_STATELESS_ERROR.format(__MODULE_FULLNAME, domain_name) + str(ErrorHandler(data['error'])))

        #
        # Finish
        #
        # Customize the result
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
