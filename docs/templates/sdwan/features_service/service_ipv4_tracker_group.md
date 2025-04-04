# Service IPv4 Tracker Group Feature

Configure IPv4 Tracker Group.

{{ doc_gen }}

### Examples

Example-1: Group-Based IPv4 Tracker for Monitoring Redundant DNS and NTP Services

A healthcare provider wants to ensure high availability and reliable connectivity to both its internal DNS server and NTP server hosted at the data center. These services are critical for application synchronization and name resolution. To enhance resilience, two individual IPv4 trackers are defined: one for the DNS server and another for the NTP server. The organization groups these trackers using an IPv4 tracker group with a logical and condition. This ensures that the system only considers the remote services to be “healthy” if both DNS and NTP are reachable. This configuration allows the SD-WAN fabric to make informed path and failover decisions based on composite service health.

This YAML configuration defines a service profile named DATA-CENTER-SERVICES-MONITOR containing two IPv4 trackers:DNS-TRACKER monitors the DNS server at 192.168.1.53 over UDP port 53.NTP-TRACKER monitors the NTP server at 192.168.1.60 over UDP port 123.

Both trackers are polled every 30 seconds and marked as down after 3 consecutive failures. The ipv4_tracker_groups section defines a group named CORE-SERVICES-TRACKER-GROUP that references both DNS-MON and NTP-MON using the and logical operator. This means the group is only considered healthy when both services are up. The grouping helps consolidate health checks for critical services and allows for smarter SD-WAN path selection or alerting if either service fails, ensuring consistent access to vital infrastructure.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: DATA-CENTER-SERVICES-MONITOR
        description: Service profile tracking DNS and NTP services
        ipv4_trackers:
          - name: DNS-TRACKER
            description: Monitors internal DNS server
            endpoint_ip: 192.168.1.53
            endpoint_port: 53
            endpoint_protocol: udp
            interval: 30
            multiplier: 3
            tracker_name: DNS-MON

          - name: NTP-TRACKER
            description: Monitors internal NTP server
            endpoint_ip: 192.168.1.60
            endpoint_port: 123
            endpoint_protocol: udp
            interval: 30
            multiplier: 3
            tracker_name: NTP-MON

        ipv4_tracker_groups:
          - name: CORE-SERVICES-TRACKER-GROUP
            description: Tracker group for DNS and NTP
            tracker_boolean: and
            trackers:
              - DNS-MON
              - NTP-MON
```
