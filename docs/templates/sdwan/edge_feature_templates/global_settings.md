# Global Settings Feature Template

Global Template contains information such Services, NAT64, Authentication, SSH Version.
Services includes HTTP(s) Server, FTP, IP Domain-lookup, ARP Proxy, RSH/RCP, Telnet(outbound), CDP, LLDP, Source Interface.
NAT64 TCP/UDP Timeouts can be configured from this template.
HTTP Authentication and SSH Version can also be globally set by using this template.
Other Settings include, TCP Keepalives, Console Logging, IP Source Routing, VTY Line Logging, SNMP IFINDEX, BOOTP Ignore.

{{ doc_gen }}

### Examples

Example-1: The following example demonstrates how to configure a SD-WAN Edge Global Feature Template. This is a mandatory field in the Cisco SD-WAN Edge Device Template. 


```yaml
sdwan:
  edge_feature_templates:
    global_settings_templates:
      - name: FT-CEDGE-GLOBAL-01
        description: Base cEdge Global Settings
        device_types:
          - C8000V
        cdp_variable: global_cdp_enable
        domain_lookup_variable: global_ip_domain_lookup_enable
        lldp: true
        http_server: false
```

Example-2: In the following example, SSH version is set to 2, HTTP(S) , FTP, Telnet, LLDP Services Disabled and CDP is enabled, source interface is set to variable

```yaml
sdwan:
  edge_feature_templates:
    global_settings_templates:
      - name: FT-CEDGE-GLOBAL-02
        description: Base cEdge Global Settings
        device_types:
          - C8000V
        cdp: true
        domain_lookup: false
        lldp: false
        http_server: false
        https_server: false
        ssh_version: 2
        ftp_passive: false
        telnet_outbound: false
        ip_source_routing_variable: ip_source_routing_enable    
```
