# VPN Interface IPsec Feature Template

Configure a standard IPsec interface, the interface name, the admin status, the IKEv2 parameters, the IPsec parameters, the tunnel source interface, the tunnel destination, the IP maximum transmission unit (MTU), the Transmission Control Protocol maximum segment size (TCP MSS), and more.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    ipsec_interface_templates:
      - name: FT-CEDGE-IPSEC101-V01
        description: "Manual IPSec Tunnel #1"
        dead_peer_detection_interval: 20
        interface_description: "Manual IPSec tunnel #1"
        interface_name: ipsec101
        ike:
          pre_shared_key_local_id: localid@acme.com
          pre_shared_key_variable: vpn0_ipsec101_pre_shared_key
          ciphersuite: aes256-cbc-sha1
          group: 14
          rekey_interval: 14400
          version: 2
        ipsec:
          ciphersuite: null-sha1
          rekey_interval: 28800
          perfect_forward_secrecy: none
        mtu: 1400
        shutdown: false
        tcp_mss: 1360
        tunnel_destination_variable: vpn0_ipsec101_tunnel_dest_ip
        tunnel_source_interface_variable: vpn0_ipsec101_source_wan_if
```
