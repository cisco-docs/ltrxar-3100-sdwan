# Cellular Profile Feature Template

Configure a standard Cellular Profile, the profile id, the APN, the network type, the authentication and more.

{{ doc_gen }}

### Examples

This example shows how to configure cellular profile feature template with profile id, Access point name, Packet data network type and authentication type as none.

```yaml
sdwan:
  edge_feature_templates:
    cellular_profile_templates:
      - name: FT-CEDGE-IPSEC101-V01
        description: "Manual IPSec Tunnel #1"
        profile_id: 1
        access_point_name: data4all
        packet_data_network_type: ipv4
        authentication_type: none
```
