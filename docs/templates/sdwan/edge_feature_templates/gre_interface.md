# VPN Interface GRE Feature Template

Configure a standard GRE interface, the interface name, the admin status, the tunnel source interface / ip address, the tunnel destination, the IP maximum transmission unit (MTU), the Transmission Control Protocol maximum segment size (TCP MSS), and more.

{{ doc_gen }}

### Examples

Example-1: This example shows how to configure GRE interface feature template with interface name, interface description as variable, admin state (shutdown), tunnel source interface name, tunnel destination ip address, ip address of interface, ip mtu, tcp mss, clear dont fragment, rewrite rule, ipv4 ingress and egress access list, tracker and application.

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
Example-2: This example shows how to configure two GRE tunnel interfaces for primary and backup connections to zScaler SIG. It uses variables for GRE tunnel source interface and IP address and GRE tunnel destination IP. It uses a variable for shutdown for ease of operation. It uses adjusted IP MTU and TCP MSS to cater for GRE and TCP/IP headers respectively.     

```yaml
sdwan:
  edge_feature_templates:
    gre_interface_templates:
      - name: VPN0-ZScaler-GRE-Tunnel1
        description: ZScaler Tunnel1
        interface_name: gre1
        interface_description: Tunnel 1 Interface to ZScaler
        shutdown_variable: gre1_shut
        tunnel_source_interface_variable: zscaler_gre_tunnel1_source_interface
        tunnel_destination_variable: zscaler_gre_tunnel1_destination
        ip_address_variable: zscaler_tunnel1_ipv4_address
        ip_mtu: 1476
        tcp_mss: 1436
      - name: VPN0-ZScaler-GRE-Tunnel2
        description: ZScaler Tunnel2
        interface_name: gre2
        interface_description: Tunnel 2 Interface to ZScaler
        shutdown_variable: gre2_shut
        tunnel_source_interface_variable: zscaler_gre_tunnel2_source_interface
        tunnel_destination_variable: zscaler_gre_tunnel2_destination
        ip_address_variable: zscaler_tunnel2_ipv4_address
        ip_mtu: 1476
        tcp_mss: 1436
```
