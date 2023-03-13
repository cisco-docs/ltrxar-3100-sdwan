# Cisco VPN Interface IPSec Feature Template

Configure a standard IPSec interface, the interface name, the admin status, the IKEv2 parameters, the IPSec parameters, the tunnel source interface, the tunnel destination, the IP maximum transmission unit (MTU), the Transmission Control Protocol maximum segment size (TCP MSS), and more.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_vpn_interface_ipsec:
      - name: FT-CEDGE-IPSEC101-V01
        description: 'Manual IPSec Tunnel #1'
        parameters:
          dead-peer-detection:
            dpd-interval: 20
          description: 'Manual IPSec tunnel #1'
          if-name: ipsec101
          ike:
            authentication-type:
              pre-shared-key:
                ike-local-id: localid@acme.com
                pre-shared-secret: presharedsecret
            ike-ciphersuite: aes256-cbc-sha1
            ike-group: '14'
            ike-rekey-interval: 14400
            ike-version: 2
          ipsec:
            ipsec-ciphersuite: null-sha1
            ipsec-rekey-interval: 28800
            perfect-forward-secrecy: none
          mtu: 1400
          shutdown: 'false'
          tcp-mss-adjust: 1360
          tunnel-destination: DEVICE_VARIABLE;vpn0_ipsec101_tunnel_dest_ip
          tunnel-source-interface: DEVICE_VARIABLE;vpn0_ipsec101_source_wan_if
```
