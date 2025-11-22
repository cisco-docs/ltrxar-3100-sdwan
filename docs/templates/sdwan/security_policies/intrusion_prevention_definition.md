# Intrusion Prevention Policy

An IPS (Intrusion Prevention System) policy in Cisco SD-WAN helps detect and prevent security threats by inspecting network traffic and blocking malicious activities.

A policy is defined by providing the settings that dictate the operational mode of the Snort engine and actions invoked by the matching of specific signatures (Snort rules).

{{ doc_gen }}

### Examples

Example-1:Enforcing Compliance for Regulatory Requirements

The organization needs to enforce regulatory compliance by restricting non-compliant applications from internet-bound traffic. This policy aims to ensure that only approved and compliant applications are allowed to access the internet, preventing any unauthorized or non-compliant applications from being used. It also ensures that security events related to these activities are logged for future audits and compliance checks, helping the organization maintain transparency and control over its internet traffic.

The YAML configuration defines a feature policy named Regulatory_Compliance, which enforces compliance for internet-bound traffic by restricting access to certain applications. The application list Restrict_Non_Compliant_Apps specifies the approved applications, such as various Amazon services (e.g., Amazon Web Services, EC2, S3, CloudFront), and blocks non-compliant applications from accessing the internet. This policy is linked with an intrusion prevention policy named Compliance_IPS_Policy, which prevents any non-compliant traffic from passing through the network. The firewall settings ensure that an audit trail is maintained for all events, with high-speed logging configured to send logs to an external server at 192.168.5.100 on port 514, enabling efficient log collection. Additionally, the IPS settings forward logs to another external syslog server located at 192.168.5.101.

The intrusion prevention policy (Compliance_IPS_Policy) operates in protection mode with a log level of alert, ensuring that any attempts to bypass the compliance rules are detected and logged. The policy is applied to VPN ID 400, which represents the zone for internet-bound traffic. This configuration ensures that only compliant applications can access the internet, and any attempts to violate this policy are blocked and logged for audit and security purposes.

```yaml
sdwan:
  security_policies:
    definitions:
      intrusion_prevention:
        - name: Compliance_IPS_Policy
          description: IPS policy to prevent non-compliant traffic
          mode: security
          inspection_mode: protection
          log_level: alert
          signature_set: security
          target_vpns:
            - 400
```
The security policy YAML mentioned above will only be effective if the following policy objects abd security policy is created.

```yaml
sdwan:
  policy_objects:
    application_lists:
      - name: Restrict_Non_Compliant_Apps
        applications:
          - amazon
          - amazon-web-services
          - amazon-instant-video
          - amazon-cloudfront
          - amazon-ec2
          - amazon-s3
  security_policies:
    definitions:
      feature_policies:
        - name: Regulatory_Compliance
          description: Policy to enforce compliance for internet-bound traffic
          use_case: compliance
          intrusion_prevention_policy: Compliance_IPS_Policy
          firewall_policies:
            - Restrict_Non_Compliant_Apps
          additional_settings:
            firewall:
              audit_trail: true
              high_speed_logging:
                vpn_id: 400
                server_ip: "192.168.5.100"
                server_port: 514
            ips_url_amp:
              external_syslog_server:
                vpn_id: 400
                server_ip: "192.168.5.101"
```

Example-2: IPS policy for branch office security
 
The organization needs to provide secure direct internet access for its branch offices while maintaining a robust security posture. This use case ensures that branch offices can securely access the internet without passing through the corporate network, while also preventing potential threats and unauthorized access through an intrusion prevention policy (IPS). This setup is critical for ensuring both seamless internet access and the protection of branch offices from cyber threats.

The YAML configuration defines a feature policy named Secure_Internet_Access, which enables secure direct internet access for branch offices. The policy is designed to secure internet-bound traffic by leveraging an intrusion prevention policy (Branch_IPS_Policy) to inspect and protect the traffic. The Secure_Internet_Access policy is configured with the use case custom, allowing the branch offices to securely access the internet without routing through the corporate network. The policy also includes settings for forwarding IPS logs to an external syslog server at 192.168.3.100 (VPN ID 200), ensuring real-time monitoring and audit of network traffic. The failure mode is set to close, meaning if the syslog server is unavailable, traffic will be blocked, preventing any unlogged events from occurring.

The intrusion prevention policy (Branch_IPS_Policy) operates in security mode, with protection inspection mode enabled to actively block malicious traffic while maintaining alerts on detected threats. The policy applies to VPNs 100 and 200, covering the relevant branch office networks and ensuring that only secure traffic passes through. The IPS system uses a balanced signature set to provide optimal security without compromising performance, making sure the branch offices have secure internet access while preventing cyber threats.


```yaml
sdwan:
  security_policies:
    definitions:
      intrusion_prevention:
        - name: Branch_IPS_Policy
          description: IPS policy for branch office security
          mode: security
          inspection_mode: protection
          log_level: alert
          signature_set: balanced
          target_vpns:
            - 100
            - 200
```
The security policy YAML mentioned above will only be effective if the following policy objects abd security policy is created.

```yaml
sdwan:
  security_policies:
    definitions:
      feature_policies:
        - name: Secure_Internet_Access
          description: Policy to enable secure internet access for branch offices
          use_case: custom
          intrusion_prevention_policy: Branch_IPS_Policy
          additional_settings:
            ips_url_amp:
              external_syslog_server:
                vpn_id: 200
                server_ip: "192.168.3.100"
              failure_mode: close
```
