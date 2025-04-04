# IPv4 Device Access Policy Definition

The control plane of Cisco WAN Edge devices process the data traffic for local services like, SSH and SNMP, from a set of sources. It is important to protect the CPU from device access traffic by applying the filter to avoid malicious traffic.

Access policies define the rules that traffic must meet to pass through an interface.
The below examples define rules to identify from where ssh and snmp traffic can be allowed.

{{ doc_gen }}

### Examples

Example-1 : The below configurations define sequence 10 , 15 and 20 source addresses from which SSH can be allowed and a counter_name is associated to each sequence.
Seqence 25 defines from which source addresses SNMP traffic can be allowed.The default action of drop has been configured.

```yaml
sdwan:
  localized_policies:
    definitions:
      ipv4_device_access_policies:
        name: ACL-DEVICEACCESSPOLICY-01
          description: SSH and SNMP access control
          default_action: drop
          sequences:
            - id: 10
              base_action: accept
              match_criterias:
                source_ip_prefix: 10.10.0.0/16
                destination_port: 22
              counter_name: SEQ10-SSH
            - id: 15
              base_action: accept
              match_criterias:
                source_ip_prefix: 192.168.1.5/32
                destination_port: 22
              counter_name: SEQ15-SSH-VMANAGE
            - id: 20
              base_action: accept
              match_criterias:
                source_ip_prefix: 10.0.10.0/24
                destination_port: 22
              counter_name: SEQ15-SSH
            - id: 25
              base_action: accept
              match_criterias:
                source_ip_prefix: 10.0.10.0/24
                destination_port: 161
              counter_name: SEQ20-SNMP
```
