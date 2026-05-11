# NGFW Security Policy

Configure Next-Generation Firewall (NGFW) policies and profile-level security settings. Use this model to control traffic between zones, inspect selected flows with advanced inspection, and apply shared limits/logging behavior at profile scope.

{{ doc_gen }}

### Examples

Example-1: Securing Guest Network with Internet-Only Access

A retail chain provides guest Wi-Fi at branch locations. Guests must have unrestricted internet access but must never reach the internal corporate network. Employee workstations at the same branch also break out to the internet and require deep inspection of all web and SaaS traffic. Three zones are used: `Guest_WiFi` (VPN 200), `Corporate_LAN` (VPN 300), and `Internet` (untrusted). Guest-to-corporate traffic is explicitly dropped by matching source 10.0.200.0/24 to destination 10.0.100.0/24. Guest internet access is allowed. Employee internet traffic is inspected with an advanced inspection profile that performs IPS on web and approved SaaS destinations. Profile-level settings enforce a SYN flood limit and configure failure mode to close so no traffic bypasses the inspection engine.

```yaml
sdwan:
  feature_profiles:
    ngfw_security_profiles:
      - name: Branch-NGFW-Profile
        description: Guest isolation and employee internet inspection at branch sites
        policies:
          - name: Guest-To-Corporate-Block
            default_action: drop
            source_zone: Guest_WiFi
            destination_zones:
              - Corporate_LAN
            sequences:
              - sequence_id: 1
                sequence_name: Block-Corporate-Access
                match_entries:
                  source_data_ipv4_prefixes:
                    - 10.0.200.0/24
                  destination_data_ipv4_prefixes:
                    - 10.0.100.0/24
                base_action: drop
          - name: Guest-To-Internet
            default_action: drop
            source_zone: Guest_WiFi
            destination_zones:
              - untrusted
            sequences:
              - sequence_id: 1
                sequence_name: Allow-DNS
                sequence_type: ngfirewall
                match_entries:
                  protocol_names:
                    - dns
                  destination_ports:
                    - 53
                base_action: pass
                actions:
                  log: true
              - sequence_id: 2
                sequence_name: Allow-Internet-Access
                match_entries:
                  source_data_ipv4_prefixes:
                    - 10.0.200.0/24
                  protocols:
                    - 6
                  destination_ports:
                    - 80
                    - 443
                base_action: pass
                actions:
                  log: true

          - name: Employee-To-Internet
            default_action: drop
            source_zone: Corporate_LAN
            destination_zones:
              - untrusted
            sequences:
              - sequence_id: 1
                sequence_name: Allow-DNS
                sequence_type: ngfirewall
                match_entries:
                  protocol_names:
                    - dns
                  destination_ports:
                    - 53
                base_action: pass
                actions:
                  log: true
              - sequence_id: 2
                sequence_name: Inspect-Web-Traffic
                match_entries:
                  protocols:
                    - 6
                  destination_ports:
                    - 80
                    - 443
                base_action: inspect
                actions:
                  log: true
                  advanced_inspection_profile: Branch-AIP-Full
              - sequence_id: 3
                sequence_name: Inspect-SaaS-Apps
                match_entries:
                  application_list: Approved-SaaS-Apps
                  destination_fqdn_lists:
                    - Trusted-SaaS-Domains
                base_action: inspect
                actions:
                  log: true
                  advanced_inspection_profile: Branch-AIP-Full
        settings:
          advanced_inspection_profile: Branch-AIP-Full
          audit_trail: "on"
          failure_mode: close
          tcp_syn_flood_limit: 10000
          max_incomplete_tcp_limit: 1000
          max_incomplete_udp_limit: 500
          unified_logging: "on"
          app_hosting:
            nat: false
            download_url_database_on_device: false
            resource_profile: medium
```

The example above expects the following policy objects to exist:

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: Branch-Service-Profile
        lan_vpns:
          - name: guest_wifi_vpn      # referenced by security zone Guest_WiFi
            vpn_id: 200
          - name: corporate_lan_vpn   # referenced by security zone Corporate_LAN
            vpn_id: 300
    policy_object_profile:
      security_zones:
        - name: Guest_WiFi
          vpns:
            - guest_wifi_vpn
        - name: Corporate_LAN
          vpns:
            - corporate_lan_vpn
      security_fqdn_lists:
        - name: Trusted-SaaS-Domains
          fqdns:
            - "*.office365.com"
            - "*.salesforce.com"
            - "*.okta.com"
      security_local_application_lists:
        - name: Approved-SaaS-Apps
          applications:
            - ms-office365
            - salesforce
      security_advanced_inspection_profiles:
        - name: Branch-AIP-Full
          tls_action: never_decrypt
          intrusion_prevention: Branch-IPS-Policy
      security_intrusion_prevention_profiles:
        - name: Branch-IPS-Policy
          inspection_mode: protection
          signature_set: balanced
          alert_log_level: emergency
```

---

Example-2: Restricting Remote Access Protocols and Mitigating DDoS Attacks

A large enterprise wants to enhance security by blocking SSH (port 22) and Telnet (port 23) traffic from the internet zone to the internal network (vpn110 → vpn120), as unauthorized access through these protocols poses significant risk. The same deployment is periodically targeted by SYN flood attacks on internet-facing HTTP/HTTPS applications. To address both concerns in a single NGFW profile, SSH and Telnet are explicitly dropped, HTTP/HTTPS traffic is permitted with a SYN flood connection limit, and high-speed logging captures real-time attack data. Profile-level `tcp_syn_flood_limit` restricts excessive SYN requests before they overwhelm network resources.

```yaml
sdwan:
  feature_profiles:
    ngfw_security_profiles:
      - name: DDoS-Mitigation-NGFW-Profile
        description: Block remote access protocols and enforce SYN flood protection
        policies:
          - name: vpn110-To-vpn120
            default_action: drop
            source_zone: vpn110
            destination_zones:
              - vpn120
            sequences:
              - sequence_id: 1
                sequence_name: Block-SSH-Telnet
                match_entries:
                  protocols:
                    - 6
                  destination_ports:
                    - 22
                    - 23
                base_action: drop
              - sequence_id: 2
                sequence_name: Allow-HTTP-HTTPS
                match_entries:
                  protocols:
                    - 6
                  destination_ports:
                    - 80
                    - 443
                base_action: pass
                actions:
                  log: true
        settings:
          audit_trail: "on"
          failure_mode: open
          tcp_syn_flood_limit: 100000
          max_incomplete_tcp_limit: 2000
          max_incomplete_udp_limit: 1000
          unified_logging: "on"
```

The example above expects the following policy objects to exist:

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: Branch-Service-Profile
        lan_vpns:
          - name: vpn110_lan   # referenced by security zone vpn110
            vpn_id: 110
          - name: vpn120_lan   # referenced by security zone vpn120
            vpn_id: 120
    policy_object_profile:
      security_zones:
        - name: vpn110
          vpns:
            - vpn110_lan
        - name: vpn120
          vpns:
            - vpn120_lan
```
