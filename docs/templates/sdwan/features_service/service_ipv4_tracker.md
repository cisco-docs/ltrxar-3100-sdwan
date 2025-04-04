# Service IPv4 Tracker Feature

Configure IPv4 Endpoint Tracker for IP, URL or TCP/UDP.

{{ doc_gen }}

### Examples

Example-1: IPv4 Tracker for Monitoring Internal DNS Server Reachability

A financial organization wants to ensure continuous connectivity to its internal DNS server hosted at 10.10.10.53 from branch locations. If the DNS server becomes unreachable, dynamic routing decisions need to be triggered to reroute the traffic. To accomplish this, the organization configures an IPv4 tracker within the SD-WAN service profile. The tracker monitors the DNS server over UDP port 53, with a check interval of 30 seconds and a multiplier of 3, ensuring the server is considered down only after three consecutive failures. This proactive monitoring setup enhances network resilience and DNS reliability for critical applications.

This YAML defines a service profile named EMPLOYEE-LAN-PROFILE that includes a single ipv4_tracker named DNS-Tracker. The tracker is configured to monitor the internal DNS server at IP 10.10.10.53 using UDP protocol on port 53. The interval is set to 30 seconds, meaning it checks the server every 30 seconds. The multiplier of 3 ensures that the tracker marks the endpoint as unreachable only after 3 consecutive failures. The threshold value of 200 milliseconds allows for latency tolerance. The tracker is identified by the tracker_name field DNS-MONITOR. This setup enables automated health checking of the DNS server, improving service assurance and enabling intelligent SD-WAN routing decisions based on real-time reachability.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: EMPLOYEE-LAN-PROFILE
        description: Service profile with IPv4 Tracker for internal DNS
        ipv4_trackers:
          - name: DNS-Tracker
            description: Tracker for internal DNS server
            endpoint_ip: 10.10.10.53
            endpoint_port: 53
            endpoint_protocol: udp
            interval: 30
            multiplier: 3
            threshold: 200
            tracker_name: DNS-MONITOR
```
