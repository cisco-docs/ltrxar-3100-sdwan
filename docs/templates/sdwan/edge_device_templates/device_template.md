# Device Template

Device templates define a device's complete operational configuration. A device template consists of a number of feature templates.


device_model: ("ASR-1001-HX", "ASR-1001-X", "ASR-1002-HX", "ASR-1002-X", "ASR-1006-X", "C1101-4P", "C1101-4PLTEP", "C1101-4PLTEPW", "C1109-2PLTEGB", "C1109-2PLTEUS", "C1109-2PLTEVZ", "C1109-4PLTE2P", "C1109-4PLTE2PW", "C1111-4P", "C1111-4PLTEEA", "C1111-4PLTELA", "C1111-4PW", "C1111-8P", "C1111-8PLTEEA", "C1111-8PLTEEAW", "C1111-8PLTELA", "C1111-8PLTELAW", "C1111-8PW", "C1111X-8P", "C1112-8P", "C1112-8PLTEEA", "C1112-8PLTEEAWE", "C1112-8PWE", "C1113-8P", "C1113-8PLTEEA", "C1113-8PLTEEAW", "C1113-8PLTELA", "C1113-8PLTELAWZ", "C1113-8PLTEW", "C1113-8PM", "C1113-8PMLTEEA", "C1113-8PMWE", "C1113-8PW", "C1116-4P", "C1116-4PLTEEA", "C1116-4PLTEEAWE", "C1116-4PWE", "C1117-4P", "C1117-4PLTEEA", "C1117-4PLTEEAW", "C1117-4PLTELA", "C1117-4PLTELAWZ", "C1117-4PM", "C1117-4PMLTEEA", "C1117-4PMLTEEAWE", "C1117-4PMWE", "C1117-4PW", "C1118-8P", "C1121-4P", "C1121-4PLTEP", "C1121-8P", "C1121-8PLTEP", "C1121-8PLTEPW", "C1121X-8P", "C1121X-8PLTEP", "C1121X-8PLTEPW", "C1126-8PLTEP", "C1126X-8PLTEP", "C1127-8PLTEP", "C1127-8PMLTEP", "C1127X-8PLTEP", "C1127X-8PMLTEP", "C1128-8PLTEP", "C1131-8PLTEPW", "C1131-8PW", "C1131X-8PLTEPW", "C1131X-8PW", "C1161-8P", "C1161-8PLTEP", "C1161X-8P", "C1161X-8PLTEP", "C8000V", "C8200-1N-4T", "C8200L-1N-4T", "C8300-1N1S-4T2X", "C8300-1N1S-6T", "C8300-2N2S-4T2X", "C8300-2N2S-6T", "C8500-12X", "C8500-12X4QC", "C8500-20X6C", "C8500L-8S4X", "IR-1101", "IR-1821", "IR-1831", "IR-1833", "IR-1835", "IR-8140H", "IR-8140H-P", "IR-8340", "ISR-4221", "ISR-4221X", "ISR-4321", "ISR-4331", "ISR-4351", "ISR-4431", "ISR-4451-X", "ISR-4461", "ISR1100-4G-XE", "ISR1100-4GLTEGB-XE", "ISR1100-4GLTENA-XE", "ISR1100-6G-XE", "ISR1100X-4G-XE", "ISR1100X-6G-XE")

{{ doc_gen }}

### Examples

Example-1: The following example demonstrates how to configure a Device Template with required and optional templates, you can add multiple "ethernet_interface_templates" to each VPN template. Also Service VPN (anything other than vpn_0 and vpn_512 can consist of multiple Service VPNs under the "vpn_service_templates". Additional templates such as Add-On CLI Template, Local Policy Templates, Security Templates, Thousandeye templates also can be attached in the specific device templates. 
The "device_model" must be selected from the list above. It can contain more than one device type, but some feature templates may not be compatible with all device models such 4G-LTE cards, therefore user must be aware of the compatibility requirements.


```yaml
sdwan:
 edge_device_templates:
    - name: DT-C8000V-TEST
      description: "Test device template"
      device_model: C8000V
      aaa_template: FT-AAA-01-TEST
      bfd_template: FT-BFD-01-TEST
      omp_template: FT-OMP-01-TEST
      security_template: FT-SECURITY-01-TEST
      system_template: FT-SYSTEM-01-TEST
      logging_template: FT-LOGGING-01-TEST
      ntp_template: FT-NTP-01-TEST
      banner_template: FT-BANNER-01-TEST
      snmp_template: FT-SNMP-01-TEST
      global_settings_template: FT-GLOBAL-01-TEST
      localized_policy: LOCAL-POLICY-TEMPLATE-01-TEST
      security_policy:
        name: SP-FW-IPS-01-TEST
        container_profile: utd-prod-01
      cli_template: FT-CLI-01-TEST
      vpn_0_template:
        name: FT-VPN0-01-TEST
        ethernet_interface_templates:
          - name: FT-VPN0-ETH1
          - name: FT-VPN0-ETH2
        ipsec_interface_templates:
          - name: FT-VPN0-IPSEC1
            dhcp_server_template: FT-DHCP-01-TEST
        svi_interface_templates:
          - name: FT-VPN0-SVI1
        ospf_template: FT-OSPF-01-TEST
        bgp_template: FT-BGP-01-TEST
        secure_internet_gateway_template: FT-SIG-TEST
        sig_credentials_template: FT-SIG-CRED-TEST
      vpn_512_template:
        name: FT-VPN512-01-TEST
        ethernet_interface_templates:
          - name: FT-VPN512-ETH1
          - name: FT-VPN512-ETH2
        svi_interface_templates:
          - name: FT-VPN512-SVI1
      vpn_service_templates:
        - name: FT-VPN1-01-TEST
          ethernet_interface_templates:
            - name: FT-VPN0-ETH1
              dhcp_server_template: FT-DHCP-02-TEST
          svi_interface_templates:
            - name: FT-VPN2-SVI1
              dhcp_server_template: FT-DHCP-03-TEST
          ipsec_interface_templates:
            - name: FT-VPN2-IPSEC1
              dhcp_server_template: FT-DHCP-04-TEST
          ospf_template: FT-OSPF-02-TEST
          bgp_template: FT-BGP-02-TEST
      switchport_templates:
        - name: FT-SW1-PORT1-TEST
        - name: FT-SW1-PORT2-TEST
      thousandeyes_template: FT-THOUSANDEYES-01-TEST
```

Example-2: The following template represents the minimum required configuration for a device template to be attached to a Cisco SD-WAN Edge Device. device_model, name, description, system_template, logging_template, bfd_template, omp_template, security_template, vpn_0_template, vpn_512_template, global_settings_template


```yaml
sdwan:
 edge_device_templates:
    - name: DT-C8000V-TEST
      description: "Test device template"
      device_model: C8000V
      bfd_template: FT-BFD-01-TEST
      omp_template: FT-OMP-01-TEST
      security_template: FT-SECURITY-01-TEST
      system_template: FT-SYSTEM-01-TEST
      logging_template: FT-LOGGING-01-TEST
      global_settings_template: FT-GLOBAL-01-TEST
      vpn_0_template:
        name: FT-VPN0-01-TEST
        ethernet_interface_templates:
          - name: FT-VPN0-ETH1
      vpn_512_template:
        name: FT-VPN512-01-TEST
        ethernet_interface_templates:
          - name: FT-VPN512-ETH1
          
```

