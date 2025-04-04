# Secure Internet Gateway Feature Template

Configure an Umbrella SIG service with pairs of active/standby tunnel interfaces. Per tunnel interface, configure the interface name, the admin status, the IKEv2 parameters, the IPSec parameters, the tunnel source interface, the tunnel destination, the IP maximum transmission unit (MTU), the Transmission Control Protocol maximum segment size (TCP MSS), and more.

{{ doc_gen }}

### Examples

Example-1: SIG Configuration for Secure and Resilient SD-WAN Connectivity

A company wants to implement a Secure Internet Gateway (SIG) for its SD-WAN edge devices to ensure secure internet access. The SIG will route internet-bound traffic via Cisco Umbrella with high availability configured for redundancy. The company requires IPsec tunnels for secure communication and IKE authentication for encryption.

The Netascode YAML configuration for Secure Internet Gateway (SIG) enables a consistent and automated approach to deploying security and routing policies across diverse SD-WAN edge devices. It defines high-availability interface pairs with failover priorities, configures IPsec and GRE tunnels using secure encryption (e.g., AES-256-GCM), and integrates SIG providers like Cisco Umbrella and Zscaler with options to specify primary and secondary data centers. The configuration also includes dynamic tracking to monitor internet path health, ensuring seamless failover, while customizable settings such as MTU, TCP MSS, and DPD enhance tunnel performance. This YAML-driven method simplifies large-scale SD-WAN deployments by standardizing configurations, reducing errors, and supporting centralized policy enforcement.

```yaml
sdwan:
  edge_feature_templates:
    secure_internet_gateway_templates:
      - name: Corp-SIG-Umbrella
        description: Secure Internet Gateway for SD-WAN Edge
        device_types:
          - ISR-4331
          - ISR-4351
        high_availability_interface_pairs:
          - active_interface: ipsec1
            active_interface_weight: 100
            backup_interface: ipsec2
            backup_interface_weight: 50
        interfaces:
          - name: ipsec1
            description: Primary IPsec Tunnel
            ike_ciphersuite: aes256-cbc-sha2
            ipsec_ciphersuite: aes256-gcm
            tunnel_type: ipsec
            tunnel_dc_preference: primary-dc
          - name: ipsec2
            description: Backup IPsec Tunnel
            ike_ciphersuite: aes256-cbc-sha2
            ipsec_ciphersuite: aes256-gcm
            tunnel_type: ipsec
            tunnel_dc_preference: secondary-dc
        sig_provider: umbrella
        umbrella_primary_data_center: us-east
        umbrella_secondary_data_center: us-west
        trackers:
          - name: "SIG-Health"
            endpoint_api_url: https://api.umbrella.com/health
            interval: 60
            multiplier: 3
            threshold: 200
```
