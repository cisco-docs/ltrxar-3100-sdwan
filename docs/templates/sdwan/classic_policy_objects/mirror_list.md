# Mirror Lists

Specify configuration for packet mirroring.

{{ doc_gen }}

### Examples

Example-1: Traffic Mirroring for Network Monitoring in SD-WAN

In an SD-WAN deployment, traffic mirroring allows administrators to duplicate network traffic and send it to a monitoring system for analysis, security inspection, and troubleshooting. This use case defines a policy object that includes two mirror lists: SecurityMonitoring and PerformanceMonitoring. The SecurityMonitoring mirror list captures traffic from a critical network segment and forwards it to an Intrusion Detection System (IDS) for real-time threat analysis. The PerformanceMonitoring mirror list is used to send traffic to a Network Performance Monitoring (NPM) tool, helping administrators analyze bandwidth usage and latency issues. These mirror lists ensure that SD-WAN networks remain secure, optimized, and compliant with monitoring policies.


```yaml
sdwan:
  policy_objects:
    mirror_lists:
      - name: SecurityMonitoring
        remote_destination_ip: 203.0.113.10
        source_ip: 192.168.1.1
      - name: PerformanceMonitoring
        remote_destination_ip: 198.51.100.20
        source_ip: 10.0.0.1
```