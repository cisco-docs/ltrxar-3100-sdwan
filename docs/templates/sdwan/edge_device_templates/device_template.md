# Device Template

Device templates define a device's complete operational configuration. A device template consists of a number of feature templates.

{{ doc_gen }}

### Examples

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
