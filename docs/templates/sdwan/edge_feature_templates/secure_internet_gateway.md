# Secure Internet Gateway Feature Template

Configure an Umbrella SIG service with pairs of active/standby tunnel interfaces. Per tunnel interface, configure the interface name, the admin status, the IKEv2 parameters, the IPSec parameters, the tunnel source interface, the tunnel destination, the IP maximum transmission unit (MTU), the Transmission Control Protocol maximum segment size (TCP MSS), and more.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    secure_internet_gateway_templates:
      - name: FT-CEDGE-SIG-UMBRELLA01
        description: Umbrella SIG 1x HA Tunnel
        interfaces:
          - dpd_interval: 10
            dpd_retries: 3
            name: ipsec1
            ike_rekey_interval: 14400
            ipsec_ciphersuite: aes256-cbc-sha1
            mtu: 1400
            tcp_mss: 1360
            tunnel_dc_preference: primary-dc
            sig_provider: secure-internet-gateway-umbrella
            tunnel_source_interface_variable: sig_tunnel1_source_interface
          - dpd_interval: 10
            dpd_retries: 3
            name: ipsec2
            ike_rekey_interval: 14400
            ipsec_ciphersuite: aes256-cbc-sha1
            mtu: 1400
            tcp_mss: 1360
            tunnel_dc_preference: secondary-dc
            sig_provider: secure-internet-gateway-umbrella
            tunnel_source_interface_variable: sig_tunnel1_source_interface
        high_availability_interface_pairs:
          - active_interface: ipsec1
            active_interface_weight: 1
            backup_interface: ipsec2
            backup_interface_weight: 1
        tracker_source_ip_variable: sig_tracker_src_ip
```
