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
module: idg_object
short_description: Handles the actions of exporting, importing and the state of objects within a specific domain.
description:
  - Handles the actions of exporting, importing and the state of objects within a specific domain.
version_added: "2.8"
options:

  domain:
    description:
      - Domain identifier.
    required: True

  state:
    description:
      - Specifies the action of: C(exported), C(imported), C(enabled), C(disabled).
    required: True
    choices:
      - imported
      - exported
      - enabled
      - disabled

  user_summary:
    description:
      - A descriptive summary only when I(state=exported).

  persisted:
    description:
      - Export from persisted or running configuration?
      - Only be taken into account when I(state=exported)
    default: False
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

  objects:
    description:
      - List of objects to export. Only when I(state=exported)

extends_documentation_fragment: idg

author:
  - David Grau Merconchini (@dgraum)
'''

EXAMPLES = '''
- name: Test DataPower object module
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

    - name: Export object
      idg_object:
        domain: "{{ source_domain }}"
        idg_connection: "{{ remote_idg }}"
        state: exported
        user_summary: Very specific change
        objects:
            - class: XMLManager
              name: XMLManager-1
              ref-objects: True
              ref-files: True
      register: export_out

    - name: Import object
      idg_object:
        name: "{{ target_domain }}"
        idg_connection: "{{ remote_idg }}"
        state: imported
        overwrite_objects: True
        input_file: "{{ export_out['file'] }}"
'''

RETURN = '''
domain:
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
__MODULE_NAME = "idg_object"
__MODULE_VERSION = "1.0"
__MODULE_FULLNAME = __MODULE_NAME + '-' + __MODULE_VERSION


# Return dictionary with the inventory of states
def get_status_summary(list_dict):
    s = {}
    for i in list_dict:
        if i['status'] not in s.keys():
            s.update({i['status']: 1})
        else:
            s[i['status']] += 1
    return s


def main():
    # Validates the dependence of the utility module
    if HAS_IDG_DEPS:
        # Arguments/parameters that a user can pass to the module
        module_args = dict(
            state=dict(type='str', choices=['exported', 'imported', 'enabled', 'disabled']),
            idg_connection=dict(type='dict', options=idg_endpoint_spec, required=True),  # IDG connection
            domain=dict(type='str', required=True),  # Domain to work
            # for Export
            user_summary=dict(type='str'),  # Backup comment
            persisted=dict(type='bool', default=False),  # Export from persisted or running configuration
            internal_files=dict(type='bool', default=True),  # Export internal configuration file
            # for Import
            input_file=dict(type='str', required=False, no_log=True),  # The base64-encoded BLOB to import
            overwrite_files=dict(type='bool', default=False),  # Overwrite files that exist
            overwrite_objects=dict(type='bool', default=False),  # Overwrite objects that exist
            dry_run=dict(type='bool', default=False),  # Import package (on) or validate the import operation without importing (off).
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

    # Commands groups
    valid_class = [
        "AAAPolicy",  # AAA Policy
        "AccessControlList",  # Access Control List
        "TAM",  # Access Manager Client
        "ISAMReverseProxyJunction",  # Access Manager Junction (deprecated)
        "ISAMReverseProxy",  # Access Manager Reverse Proxy (deprecated)
        "ISAMRuntime",  # Access Manager Runtime (deprecated)
        "AccessProfile",  # Access Profile
        "AnalyticsEndpoint",  # Analytics Endpoint
        "APIClientIdentification",  # API Client Identification Action
        "APICollection",  # API Collection
        "APIConnectGatewayService",  # API Connect Gateway Service
        "APIContext",  # API Context Action
        "APICORS",  # API CORS Action
        "APIDefinition",  # API Definition
        "APIExecute",  # API Execute Action
        "APIGateway",  # API Gateway
        "APILDAPRegistry",  # API LDAP Registry
        "OperationRateLimit",  # API Operation Rate Limit
        "APIOperation",  # API Operation
        "APIPath",  # API Path
        "APIPlan",  # API Plan
        "APIRateLimit",  # API Rate Limit Action
        "APIResult",  # API Result Action
        "APIRouting",  # API Routing Action
        "APIRule",  # API Rule
        "APISecurity",  # API Security Action
        "APISecurityAPIKey",  # API Security API Key
        "APISecurityBasicAuth",  # API Security Basic Authentication
        "APISecurityOAuthReq",  # API Security OAuth Requirement
        "APISecurityOAuth",  # API Security OAuth
        "APISecurityRequirement",  # API Security Requirement
        "APISecurityTokenManager",  # API Security Token Manager
        "Domain",  # Application Domain
        "AppSecurityPolicy",  # Application Security Policy
        "AS1PollerSourceProtocolHandler",  # AS1 Poller Handler
        "AS2SourceProtocolHandler",  # AS2 Handler
        "AS3SourceProtocolHandler",  # AS3 Handler
        "AssemblyActionGatewayScript",  # Assembly GatewayScript Action
        "AssemblyActionJWTGenerate",  # Assembly Generate JWT Action
        "AssemblyActionInvoke",  # Assembly Invoke Action
        "AssemblyActionJson2Xml",  # Assembly JSON to XML Action
        "AssemblyActionMap",  # Assembly Map Action
        "AssemblyActionOAuth",  # Assembly OAuth Action
        "AssemblyActionParse",  # Assembly Parse Action
        "AssemblyActionSetVar",  # Assembly Set Variable Action
        "AssemblyLogicSwitch",  # Assembly Switch Action
        "AssemblyActionThrow",  # Assembly Throw Action
        "AssemblyActionUserSecurity",  # Assembly User Security Action
        "AssemblyActionJWTValidate",  # Assembly Validate JWT Action
        "AssemblyActionXml2Json",  # Assembly XML to JSON Action
        "AssemblyActionXSLT",  # Assembly XSLT Action
        "Assembly",  # Assembly
        "AuditLog",  # Audit Log Settings
        "B2BCPACollaboration",  # B2B CPA Collaboration
        "B2BCPA",  # B2B CPA
        "B2BGateway",  # B2B Gateway
        "B2BProfileGroup",  # B2B Partner Profile Group
        "B2BProfile",  # B2B Partner Profile
        "B2BPersistence",  # B2B Persistence
        "B2BXPathRoutingPolicy",  # B2B XPath Routing Policy
        "SecureBackupMode",  # Backup Mode
        "CloudConnectorService",  # Cloud Connector Service
        "CloudGatewayService",  # Cloud Gateway Service
        "SecureCloudConnector",  # Cloud Instance (deprecated)
        "CompactFlash",  # Compact Flash
        "CompileOptionsPolicy",  # Compile Options Policy
        "ConfigSequence",  # Configuration Sequence
        "ConformancePolicy",  # Conformance Policy
        "CookieAttributePolicy",  # Cookie Attribute Policy
        "B2BCPAReceiverSetting",  # CPA Receiver Setting
        "B2BCPASenderSetting",  # CPA Sender Setting
        "CRLFetch",  # CRL Retrieval
        "CertMonitor",  # Crypto Certificate Monitor
        "CryptoCertificate",  # Crypto Certificate
        "CryptoFWCred",  # Crypto Firewall Credentials
        "CryptoIdentCred",  # Crypto Identification Credentials
        "CryptoKey",  # Crypto Key
        "CryptoProfile",  # Crypto Profile
        "CryptoSSKey",  # Crypto Shared Secret Key
        "CryptoValCred",  # Crypto Validation Credentials
        "MCFCustomRule",  # Custom Rule Message Content Filter
        "DeploymentPolicyParametersBinding",  # Deployment Policy Variables
        "ConfigDeploymentPolicy",  # Deployment Policy
        "DFDLSettings",  # DFDL Settings
        "DNSNameService",  # DNS Settings
        "DocumentCryptoMap",  # Document Crypto Map
        "DomainAvailability",  # Domain Availability
        "DomainSettings",  # Domain Settings
        "EBMS2SourceProtocolHandler",  # ebMS2 Handler
        "EBMS3SourceProtocolHandler",  # ebMS3 Handler
        "EthernetInterface",  # Ethernet Interface
        "WXSGrid",  # eXtreme Scale Grid
        "ErrorReportSettings",  # Failure Notification
        "FTPFilePollerSourceProtocolHandler",  # FTP Poller Handler
        "FTPQuoteCommands",  # FTP Quoted Commands
        "FTPServerSourceProtocolHandler",  # FTP Server Handler
        "GatewayPeering",  # Gateway Peering
        "GWScriptSettings",  # GatewayScript Settings
        "HostAlias",  # Host Alias
        "FormsLoginPolicy",  # HTML Forms Login Policy
        "HTTPSourceProtocolHandler",  # HTTP Handler
        "MCFHttpHeader",  # HTTP Header Message Content Filter
        "HTTPInputConversionMap",  # HTTP Input Conversion Map
        "MCFHttpMethod",  # HTTP Method Message Content Filter
        "HTTPService",  # HTTP Service
        "MCFHttpURL",  # HTTP URL Message Content Filter
        "HTTPSSourceProtocolHandler",  # HTTPS Handler
        "MQSourceProtocolHandler",  # IBM MQ Handler
        "MQQMGroup",  # IBM MQ Queue Manager Group
        "MQQM",  # IBM MQ Queue Manager
        "MQFTESourceProtocolHandler",  # IBM MQFTE Handler
        "ILMTScanner",  # ILMT Disconnected Scanner
        "ImportPackage",  # Import Configuration File
        "IMSCalloutSourceProtocolHandler",  # IMS Callout Handler
        "IMSConnectSourceProtocolHandler",  # IMS Connect Handler
        "IMSConnect",  # IMS Connect
        "IncludeConfig",  # Include Configuration File
        "InteropService",  # Interoperability Test Service
        "IPMulticast",  # IP Multicast
        "IPMILanChannel",  # IPMI LAN Channel
        "IPMIUser",  # IPMI User
        "IScsiChapConfig",  # iSCSI CHAP
        "IScsiHBAConfig",  # iSCSI Host Bus Adapter
        "IScsiInitiatorConfig",  # iSCSI Initiator
        "IScsiTargetConfig",  # iSCSI Target
        "IScsiVolumeConfig",  # iSCSI Volume
        "JSONSettings",  # JSON Settings
        "JWEHeader",  # JWE Header
        "JWERecipient",  # JWE Recipient
        "JWSSignature",  # JWS Signature
        "AAAJWTGenerator",  # JWT Generator
        "AAAJWTValidator",  # JWT Validator
        "CryptoKerberosKDC",  # Kerberos KDC Server
        "CryptoKerberosKeytab",  # Kerberos Keytab
        "Language",  # Language
        "LDAPConnectionPool",  # LDAP Connection Pool
        "LDAPSearchParameters",  # LDAP Search Parameters
        "LinkAggregation",  # Link Aggregation Interface
        "LoadBalancerGroup",  # Load Balancer Group
        "LogLabel",  # Log Category
        "LogTarget",  # Log Target
        "LunaPartition",  # Luna HSM Partition
        "Luna",  # Luna HSM
        "Matching",  # Matching Rule
        "AS2ProxySourceProtocolHandler",  # MEIG AS2 Proxy Handler
        "MessageContentFilters",  # Message Content Filters
        "CountMonitor",  # Message Count Monitor
        "DurationMonitor",  # Message Duration Monitor
        "FilterAction",  # Message Filter Action
        "MessageMatching",  # Message Matching
        "MessageType",  # Message Type
        "MTOMPolicy",  # MTOM Policy
        "MPGWErrorAction",  # Multi-Protocol Gateway Error Action
        "MPGWErrorHandlingPolicy",  # Multi-Protocol Gateway Error Policy
        "MultiProtocolGateway",  # Multi-Protocol Gateway
        "NameValueProfile",  # Name-Value Profile
        "NetworkSettings",  # Network Settings
        "NFSClientSettings",  # NFS Client Settings
        "NFSDynamicMounts",  # NFS Dynamic Mounts
        "NFSFilePollerSourceProtocolHandler",  # NFS Poller Handler
        "NFSStaticMount",  # NFS Static Mounts
        "ZosNSSClient",  # NSS Client
        "NTPService",  # NTP Service
        "OAuthSupportedClientGroup",  # OAuth Client Group
        "OAuthSupportedClient",  # OAuth Client Profile
        "OAuthProviderSettings",  # OAuth Provider Settings
        "ODRConnectorGroup",  # ODR Connector Group
        "ODR",  # On Demand Router
        "ParseSettings",  # Parse Settings
        "PasswordAlias",  # Password Map Alias
        "Pattern",  # Pattern
        "PeerGroup",  # Peer Group
        "PolicyAttachments",  # Policy Attachment
        "PolicyParameters",  # Policy Parameters
        "POPPollerSourceProtocolHandler",  # POP Poller Handler
        "StylePolicyAction",  # Processing Action
        "ProcessingMetadata",  # Processing Metadata
        "StylePolicy",  # Processing Policy
        "StylePolicyRule",  # Processing Rule
        "ProductInsights",  # Product Insights
        "QuotaEnforcementServer",  # Quota Enforcement Server
        "RADIUSSettings",  # RADIUS Settings
        "RaidVolume",  # RAID Array
        "SimpleCountMonitor",  # Rate Limiter
        "RBMSettings",  # RBM Settings
        "JOSERecipientIdentifier",  # Recipient Identifier
        "RestMgmtInterface",  # REST Management Interface
        "SAMLAttributes",  # SAML Attributes
        "SchemaExceptionMap",  # Schema Exception Map
        "SecureGatewayClient",  # Secure Gateway Client
        "WebAppSessionPolicy",  # Session Management Policy
        "SFTPFilePollerSourceProtocolHandler",  # SFTP Poller Handler
        "SSHServerSourceProtocolHandler",  # SFTP Server Handler
        "ShellAlias",  # Shell Alias (deprecated)
        "JOSESignatureIdentifier",  # Signature Identifier
        "SLMAction",  # SLM Action
        "SLMCredClass",  # SLM Credential Class
        "SLMPolicy",  # SLM Policy
        "SLMRsrcClass",  # SLM Resource Class
        "SLMSchedule",  # SLM Schedule
        "SMTPServerConnection",  # SMTP Server Connection
        "SNMPSettings",  # SNMP Settings
        "SOAPHeaderDisposition",  # SOAP Header Disposition Table
        "SocialLoginPolicy",  # Social Login Policy
        "SQLRuntimeSettings",  # SQL Data Source Runtime Settings
        "SQLDataSource",  # SQL Data Source
        "SSHClientProfile",  # SSH Client Profile
        "SSHDomainClientProfile",  # SSH Domain Client Profile
        "SSHServerProfile",  # SSH Server Profile
        "SSHService",  # SSH Service
        "SSLClientProfile",  # SSL Client Profile
        "SSLSNIMapping",  # SSL Host Name Mapping
        "SSLProxyProfile",  # SSL Proxy Profile (deprecated)
        "SSLProxyService",  # SSL Proxy Service
        "SSLServerProfile",  # SSL Server Profile
        "SSLSNIServerProfile",  # SSL SNI Server Profile
        "StandaloneStandbyControl",  # Standalone Standby Control
        "StandaloneStandbyControlInterface",  # StandaloneStandbyControlInterface
        "XTCProtocolHandler",  # Stateful Raw XML Handler
        "StatelessTCPSourceProtocolHandler",  # Stateless Raw XML Handler
        "Statistics",  # Statistic Settings
        "ZHybridTargetControlService",  # Sysplex Distributor Target Control Service
        "SystemSettings",  # System Settings
        "TCPProxyService",  # TCP Proxy Service
        "TelnetService",  # Telnet Service
        "Tenant",  # Tenant
        "Throttler",  # Throttle Settings
        "TibcoEMSSourceProtocolHandler",  # TIBCO EMS Handler
        "TibcoEMSServer",  # TIBCO EMS
        "TimeSettings",  # Time Settings
        "TFIMEndpoint",  # Tivoli Federated Identity Manager
        "UDDIRegistry",  # UDDI Registry (deprecated)
        "UDDISubscription",  # UDDI Subscription (deprecated)
        "URLMap",  # URL Map
        "URLRefreshPolicy",  # URL Refresh Policy
        "URLRewritePolicy",  # URL Rewrite Policy
        "User",  # User Account
        "HTTPUserAgent",  # User Agent
        "UserGroup",  # User Group
        "VLANInterface",  # VLAN Interface
        "WebAppErrorHandlingPolicy",  # Web Application Firewall Error Policy
        "WebAppFW",  # Web Application Firewall
        "WebB2BViewer",  # Web B2B Viewer Management Service
        "WebGUI",  # Web Management Service
        "WebAppRequest",  # Web Request Profile
        "WebAppResponse",  # Web Response Profile
        "WSGateway",  # Web Service Proxy
        "WebServicesAgent",  # Web Services Management Agent
        "WebServiceMonitor",  # Web Services Monitor
        "WebTokenService",  # Web Token Service
        "WCCService",  # WebSphere Cell
        "WebSphereJMSSourceProtocolHandler",  # WebSphere JMS Handler
        "WebSphereJMSServer",  # WebSphere JMS
        "WSEndpointRewritePolicy",  # WS-Proxy Endpoint Rewrite
        "WSStylePolicy",  # WS-Proxy Processing Policy
        "WSStylePolicyRule",  # WS-Proxy Processing Rule
        "WSRRSavedSearchSubscription",  # WSRR Saved Search Subscription
        "WSRRServer",  # WSRR Server
        "WSRRSubscription",  # WSRR Subscription
        "XACMLPDP",  # XACML Policy Decision Point
        "XC10Grid",  # XC10 Grid (deprecated)
        "xmltrace",  # XML File Capture
        "XMLFirewallService",  # XML Firewall Service
        "MgmtInterface",  # XML Management Interface
        "XMLManager",  # XML Manager
        "MCFXPath",  # XPath Message Content Filter
        "XPathRoutingMap",  # XPath Routing Map
        "XSLCoprocService",  # XSL Coprocessor Service
        "XSLProxyService"  # XSL Proxy Service
    ]

    # Parse arguments to dict
    idg_data_spec = IDGUtils.parse_to_dict(module, module.params['idg_connection'], 'IDGConnection', IDGUtils.ANSIBLE_VERSION)

    # Status & domain
    state = module.params['state']
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

    # Configuration template for the domain
    export_action_msg = {"Export": {
        "Format": "ZIP",
        "Persisted": IDGUtils.str_on_off(module.params['persisted']),
        "IncludeInternalFiles": IDGUtils.str_on_off(module.params['internal_files']),
        "Object": AbstractListStr(module.params["objects"]).optimal()
    }}

    # Optional parameters
    # Comments
    if module.params['user_summary'] is not None:
        usergroup_msg["Export"].update({"UserSummary": module.params['user_summary']})

    import_action_msg = {"Import": {
        "Format": "ZIP",
        "InputFile": module.params['input_file'],
        "OverwriteFiles": IDGUtils.str_on_off(module.params['overwrite_files']),
        "OverwriteObjects": IDGUtils.str_on_off(module.params['overwrite_objects']),
        "DryRun": IDGUtils.str_on_off(module.params['dry_run'])
    }}

    # Action messages
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
                            tmp_result['changed'] = True
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
                                tmp_result.update({"results": []})  # Update to result
                                tmp_result['results'].append({"export-details": import_results['export-details']})

                                # EXEC-SCRIPT-RESULTS
                                try:
                                    exec_script_results = import_results['exec-script-results']
                                    try:
                                        if isinstance(exec_script_results['cfg-result'], list):

                                            tmp_result['results'].append({"exec-script-results":
                                                                         {"summary": {"total": len(exec_script_results['cfg-result']),
                                                                                      "status": get_status_summary(exec_script_results['cfg-result'])},
                                                                          "detail": exec_script_results['cfg-result']}})
                                        else:
                                            tmp_result['results'].append({"exec-script-results": exec_script_results['cfg-result']})

                                    except Exception as e:
                                        tmp_result['results'].append({"exec-script-results": exec_script_results})

                                except Exception as e:
                                    pass

                                try:
                                    tmp_result['results'].append({"file-copy-log": import_results['file-copy-log']['file-result']})
                                except Exception as e:
                                    pass

                                try:
                                    tmp_result['results'].append({"imported-debug": import_results['imported-debug']})
                                except Exception as e:
                                    pass

                                # IMPORTED-FILES
                                try:
                                    imported_files = import_results['imported-files']
                                    try:
                                        if isinstance(imported_files['file'], list):

                                            tmp_result['results'].append({"imported-files": {"summary": {"total": len(imported_files['file']),
                                                                                                         "status": get_status_summary(imported_files['file'])},
                                                                                             "detail": imported_files['file']}})
                                        else:
                                            tmp_result['results'].append({"imported-files": imported_files['file']})

                                    except Exception as e:
                                        tmp_result['results'].append({"imported-files": imported_files})

                                except Exception as e:
                                    pass

                                # IMPORTED-OBJECTS
                                try:
                                    imported_objects = import_results['imported-objects']
                                    try:
                                        if isinstance(imported_objects['object'], list):

                                            tmp_result['results'].append({"imported-objects":
                                                                         {"summary": {"total": len(imported_objects['object']),
                                                                                      "status": get_status_summary(imported_objects['object'])},
                                                                          "detail": imported_objects['object']}})
                                        else:
                                            tmp_result['results'].append({"imported-objects": imported_objects['object']})

                                    except Exception as e:
                                        tmp_result['results'].append({"imported-objects": imported_objects})

                                except Exception as e:
                                    pass

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
