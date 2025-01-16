# VPN Interface GRE Feature Template

Configure a standard GRE interface, the interface name, the admin status, the tunnel source interface / ip address, the tunnel destination, the IP maximum transmission unit (MTU), the Transmission Control Protocol maximum segment size (TCP MSS), and more.

{{ doc_gen }}

### Examples

This example shows how to configure GRE interface feature template with interface name, interface description as variable, admin state (shutdown), tunnel source interface name, tunnel destination ip address, ip address of interface, ip mtu, tcp mss, clear dont fragment, rewrite rule, ipv4 ingress and egress access list, tracker and application.

```yaml
sdwan:
  edge_feature_templates:
    gre_interface_templates:
      - name: FT-CEDGE-GRE101-V01
        description: "GRE Tunnel #1"
        interface_name: gre1
        interface_description: "GRE tunnel to Site #2"
        shutdown: false
        tunnel_source_interface: Ge1/0
        tunnel_destination: 10.10.33.2
        ip_address: 10.10.10.1/30
        ip_mtu: 1500
        tcp_mss: 1460
        clear_dont_fragment: true
        rewrite_rule: REWRITE-RULE-MPLS
        ipv4_egress_access_list: QOS_ACL_OUT
        ipv4_ingress_access_list: QOS_ACL_IN
        tracker: 1
        application: sig
```
