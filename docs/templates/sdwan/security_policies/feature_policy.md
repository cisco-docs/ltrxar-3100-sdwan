# Security Policy

Policy combines one or more Security policy definitions to create a Policy based on use-case. These policies can then be attached to device templates.

{{ doc_gen }}

### Examples

Example-1:Ensuring Secure and Optimized SaaS Connectivity for Branch Networks

A company with multiple branch offices wants to ensure secure and optimized access to trusted SaaS applications while blocking all other internet traffic. Employees in branch offices should be able to access essential cloud services, such as Amazon Web Services (AWS) and Amazon S3, but all other external traffic should be restricted. Additionally, the organization wants to maintain visibility and logging of this traffic through an external syslog server. To achieve this, an SD-WAN Zone-Based Firewall (ZBFW) policy is implemented, along with a feature policy to optimize SaaS traffic while maintaining security.

The provided YAML defines an SD-WAN security policy that restricts internet access from branch offices to only approved SaaS applications, blocking all other external traffic. The zones include Branch_Offices (VPN ID 100) representing internal branch networks and Internet (VPN ID 400) for external cloud access. An application list named Allow_Trusted_SaaS specifies trusted applications such as Amazon, AWS, Amazon S3, and CloudFront, ensuring that only these services are accessible. The Zone-Based Firewall (ZBFW) policy named Cloud_Access_ZBFW_10 enforces this access control by allowing traffic only to destinations that match the trusted SaaS list while blocking all other traffic by default. A zone pair is defined to apply this policy to traffic moving from Branch_Offices to the Internet.

Additionally, a feature policy named Direct_Cloud_Access_10 is implemented to optimize SaaS traffic while maintaining security. This policy applies the firewall policy and includes monitoring settings, enabling match_stats_per_filter for tracking network activity and sending security logs to an external syslog server (192.168.1.100). The failure mode is set to open, allowing traffic to pass even if external security services fail.

This configuration ensures that employees in branch offices can securely access only trusted cloud applications, improving security and performance while maintaining visibility and control over network traffic. By enforcing strict access policies and monitoring mechanisms, the organization can reduce security risks while ensuring seamless access to critical cloud services.


```yaml
sdwan:
  security_policies:
    feature_policies:
      - name: Direct_Cloud_Access_10
        description: Policy to optimize SaaS traffic while maintaining security
        use_case: custom
        firewall_policies:
          - Cloud_Access_ZBFW_10
        additional_settings:
          firewall:
            match_stats_per_filter: true
          ips_url_amp:
            external_syslog_server:
              vpn_id: 400
              server_ip: "192.168.1.100"
            failure_mode: open
```

The security policy YAML mentioned above will only be effective if the following policy objects and application lists YAML is created.


```yaml
sdwan:
  policy_objects:
    zones:
      - name: Branch_Offices
        vpn_ids:
          - 100
      - name: Internet
        vpn_ids:
          - 400
    application_lists:
      - name: Allow_Trusted_SaaS
        applications:
          - amazon
          - amazon-web-services
          - amazon-instant-video
          - amazon-cloudfront
          - amazon-ec2
          - amazon-s3
  security_policies:
    definitions:
      zone_based_firewall:
        - name: Cloud_Access_ZBFW_10
          description: ZBFW policy to allow trusted SaaS applications
          default_action_type: drop
          rules:
            - id: 1
              name: Allow_Trusted_SaaS_Traffic
              base_action: pass
              match_criterias:
                destination_ip_prefix_variable: Allow_Trusted_SaaS
          zone_pairs:
            - source_zone: Branch_Offices
              destination_zone: Internet
```

Example-2: Mitigating DDoS Attacks with SYN Flood Protection

A large enterprise is facing periodic SYN flood attacks on its internet-facing applications, which can overwhelm network resources and degrade service availability. To combat this, a Zone-Based Firewall (ZBFW) policy is implemented within the SD-WAN security framework. The solution enforces a tcp_syn_flood_limit to restrict excessive SYN requests and prevent malicious traffic from disrupting legitimate services. Additionally, high-speed logging is enabled to capture real-time attack data for monitoring and analysis.

The YAML configuration defines two zones (vpn110 and vpn120) to segregate network traffic. A zone-based firewall policy named DDoS_Mitigation_FW is created to mitigate SYN flood attacks. This policy drops all traffic by default but includes a rule (Mitigate_SYN_Flood) that allows HTTP (port 80) and HTTPS (port 443) traffic while enforcing a SYN flood limit of 100,000 connections. A zone pair is defined between vpn110 (source) and vpn120 (destination), ensuring that traffic between these zones follows the firewall rules.

To enhance security further, a feature policy named DDoS_Mitigation references the firewall policy and includes high-speed logging to track attack patterns. Logging is configured to send data to an external syslog server (192.168.2.100) on VPN ID 100, ensuring security teams receive real-time insights. This comprehensive setup provides an effective, scalable defense against SYN flood attacks, ensuring network resilience and service availability.

```yaml
sdwan:
    feature_policies:
      - name: DDoS_Mitigation
        description: Policy to mitigate SYN flood attacks on internet-facing applications
        use_case: custom
        firewall_policies:
          - DDoS_Mitigation_FW
        additional_settings:
          firewall:
            high_speed_logging:
              vpn_id: 100
              server_ip: "192.168.2.100"
              server_port: 514
```
The feature policies YAML mentioned above will only be effective if the following policy objects and security policies YAML is created.

```yaml
sdwan:
  policy_objects:
    zones:
      - name: vpn110
        vpn_ids:
          - 110
      - name: vpn120
        vpn_ids:
          - 120
  security_policies:
    definitions:
      zone_based_firewall:
        - name: DDoS_Mitigation_FW
          description: Zone-based firewall policy to mitigate SYN flood attacks
          default_action_type: drop
          rules:
            - id: 1
              name: Mitigate_SYN_Flood
              base_action: pass
              match_criterias:
                protocols:
                  - 6  # TCP
                destination_ports:
                  - 80   # HTTP
                  - 443  # HTTPS
              tcp_syn_flood_limit: 100000
          zone_pairs:
            - source_zone: vpn110
              destination_zone: vpn120
```

Example-3: Logging and Monitoring for Security Compliance

Government agencies are required to maintain logs of all security events for compliance audits, ensuring adherence to regulatory standards. To address this, a zone-based firewall policy is implemented to log all traffic traversing the network. This approach enables detailed tracking of security events, helping auditors verify compliance and detect potential threats.

The YAML configuration defines a firewall policy (Compliance_FW) within SD-WAN security policies, which is applied to traffic within VPN 300. The policy allows all traffic (default_action_type: pass) but ensures that every session is logged (log: true). This firewall policy is then linked to the Security_Compliance_Logging feature policy, which includes high-speed logging and external syslog server integration. These settings enable real-time monitoring of security events, with logs being sent to an external syslog server (192.168.4.101) for centralized analysis.

By leveraging audit trails, firewall logging, and external syslog integration, this solution ensures that all security-related activities are recorded, providing an effective framework for regulatory compliance and proactive threat monitoring.

```yaml
sdwan:
  security_policies:
    definitions:
      feature_policies:
        - name: Security_Compliance_Logging
          description: Policy to log all security events for compliance audits
          use_case: custom
          firewall_policies:
            - Compliance_FW
          additional_settings:
            firewall:
              audit_trail: true
              high_speed_logging:
                vpn_id: 300
                server_ip: "192.168.4.100"
                server_port: 514
            ips_url_amp:
              external_syslog_server:
                vpn_id: 300
                server_ip: "192.168.4.101"
```

The feature policy YAML mentioned above will only be effective if the following policy objects and security policies YAML is created.

```yaml
sdwan:
  policy_objects:
    zones:
      - name: vpn300
        vpn_ids:
          - 300
  security_policies:
    definitions:
      zone_based_firewall:
        - name: Compliance_FW
          description: Zone-based firewall policy for security logging
          default_action_type: pass
          rules:
            - id: 1
              name: Log_All_Traffic
              base_action: pass
              match_criterias:
                protocols:
                  - 6
              log: true
          zone_pairs:
            - source_zone: vpn300
              destination_zone: vpn300
```

