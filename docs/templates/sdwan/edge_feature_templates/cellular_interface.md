# VPN Interface Cellular Feature Template

Configure a standard Cellular interface, the interface name, the admin status, the tunnel parameters, the NAT parameters, the ACL/QOS parameters, the ARP entries and more.

{{ doc_gen }}

### Examples

This example shows how to configure cellular interface feature template with interface name, admin state (shutdown), list of dhcp helper ip address with 2 servers, bandwidth upstream and downstream in kbps, ip mtu, tunnel interface with color, allowed service and carrier, nat, nat refresh mode and static arp as a list with 1 ip address and associated mac address.

```yaml
sdwan:
  edge_feature_templates:
    cellular_interface_templates:
      - name: FT-CEDGE-CELL101-V01
        description: "Cellular Interface #1"
        interface_name: cellular0/1/0
        shutdown: false
        dhcp_helpers:
          - 10.10.3.4
          - 10.10.4.5
        bandwidth_downstream: 128
        bandwidth_upstream: 128
        ip_mtu: 1428
        tunnel_interface:
          color: 3g
          allow_service_all: true
          carrier: carrier1
        nat: true
        nat_refresh_mode: outbound
        static_arps:
          - ip_address: 10.10.99.3
            mac_address: 00:00:00:00:00:01
```
