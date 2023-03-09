# Device Template

Device templates define a device's complete operational configuration. A device template consists of a number of feature templates.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_device_templates:
    device_template:
      - name: DT-C8000V-TEST
        template: DT-CEDGE
        description: "Test device template"
        parameters:
          device_model: C8000V
          localized_policy: LOCAL-POLICY-TEMPLATE-03
          feature_templates:
            - templateName: FT-CEDGE-AAA-01
              templateType: cedge_aaa
            - templateName: FT-CEDGE-GLOBAL-01
              templateType: cedge_global
            - templateName: FT-CEDGE-BANNER-01
              templateType: cisco_banner
            - templateName: FT-CEDGE-BFD-01
              templateType: cisco_bfd
            - templateName: FT-CEDGE-OMP-01
              templateType: cisco_omp
            - templateName: FT-CEDGE-SECURITY-01
              templateType: cisco_security
            - templateName: FT-CEDGE-SNMPV3-01
              templateType: cisco_snmp
            - subTemplates:
              - templateName: FT-CEDGE-WAN-TLOC1
                templateType: cisco_vpn_interface
              - templateName: FT-CEDGE-WAN-TLOC2
                templateType: cisco_vpn_interface
              - templateName: FT-CEDGE-LAN-PHYS1
                templateType: cisco_vpn_interface
              templateName: FT-CEDGE-VPN0-01
              templateType: cisco_vpn
            - subTemplates:
              - templateName: FT-CEDGE-VPN1-LAN1
                templateType: cisco_vpn_interface
              - templateName: FT-CEDGE-VPN1-LAN2
                templateType: cisco_vpn_interface
              - templateName: FT-CEDGE-BGP-VPN1
                templateType: cisco_bgp
              templateName: FT-CEDGE-VPN1-01
              templateType: cisco_vpn
            - subTemplates:
              - templateName: FT-CEDGE-VPN511-LOOPBACK511
                templateType: cisco_vpn_interface
              templateName: FT-CEDGE-VPN511-01
              templateType: cisco_vpn
            - subTemplates:
              - templateName: FT-CEDGE-VPN512-OOB
                templateType: cisco_vpn_interface
              templateName: FT-CEDGE-VPN512-01
              templateType: cisco_vpn
            - templateName: FT-CEDGE-CLI-01
              templateType: cli-template
            - subTemplates:
              - templateName: FT-CEDGE-NTP-01
                templateType: cisco_ntp
              - templateName: FT-CEDGE-LOGGING-01
                templateType: cisco_logging
              templateName: FT-CEDGE-SYSTEM-01
              templateType: cisco_system
```
