# Cisco Secure Internet Gateway Feature Template

Configure an Umbrella SIG service with pairs of active/standby tunnel interfaces. Per tunnel interface, configure the interface name, the admin status, the IKEv2 parameters, the IPSec parameters, the tunnel source interface, the tunnel destination, the IP maximum transmission unit (MTU), the Transmission Control Protocol maximum segment size (TCP MSS), and more.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_secure_internet_gateway:
      - name: FT-CEDGE-SIG-UMBRELLA01
        description: Umbrella SIG 1x HA Tunnel
        parameters:
          interface:
            - application: sig
              auto: 'true'
              dead-peer-detection:
                dpd-interval: 10
                dpd-retries: 3
              if-name: ipsec1
              ike:
                authentication-type:
                  pre-shared-key-dynamic: 'true'
                ike-rekey-interval: 14400
                ike-version: 2
              ip:
                unnumbered: 'true'
              ipsec:
                ipsec-ciphersuite: aes256-cbc-sha1
                ipsec-rekey-interval: 28800
              mtu: 1400
              tcp-mss-adjust: 1360
              tunnel-dc-preference: primary-dc
              tunnel-destination: dynamic
              tunnel-set: secure-internet-gateway-umbrella
              tunnel-source-interface: DEVICE_VARIABLE;sig_tunnel1_source_interface
            - application: sig
              auto: 'true'
              dead-peer-detection:
                dpd-interval: 10
                dpd-retries: 3
              if-name: ipsec2
              ike:
                authentication-type:
                  pre-shared-key-dynamic: 'true'
                ike-rekey-interval: 14400
                ike-version: 2
              ip:
                unnumbered: 'true'
              ipsec:
                ipsec-ciphersuite: aes256-cbc-sha1
                ipsec-rekey-interval: 28800
              mtu: 1400
              tcp-mss-adjust: 1360
              tunnel-dc-preference: secondary-dc
              tunnel-destination: dynamic
              tunnel-set: secure-internet-gateway-umbrella
              tunnel-source-interface: DEVICE_VARIABLE;sig_tunnel2_source_interface
          service:
            - ha-pairs:
                interface-pair:
                  - active-interface: ipsec1
                    active-interface-weight: 1
                    backup-interface: ipsec2
                    backup-interface-weight: 1
              svc-type: sig
          tracker-src-ip: DEVICE_VARIABLE;sig_tracker_srcip
          vpn-id: 0
```
