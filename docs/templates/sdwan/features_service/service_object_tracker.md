# Service Object Tracker Feature

Configure Service Object Tracker for interface, SIG or route.

{{ doc_gen }}

### Examples

Example-1: Automated WAN Route Monitoring for Branch Connectivity

A financial institution operates multiple branch offices connected to the main data center through SD-WAN. To ensure seamless connectivity and proactive failure detection, the IT team needs to track the reachability of key WAN routes. By using object_trackers, the institution can monitor a specific route within a VPN (vpn_id: 10), checking its availability dynamically. If the route to the data center (192.168.100.0/24) becomes unreachable, the SD-WAN system can trigger failover mechanisms, such as switching traffic to a backup path. This setup enhances network resilience by ensuring continuous access to critical banking applications.

This YAML defines an object_tracker within a service profile named BRANCH-WAN-MONITORING. The configuration does the following: Defines a tracker (DC-ROUTE-TRACKER) to monitor the reachability of the 192.168.100.0/24 route, Uses type: route, meaning it specifically tracks network reachability rather than an interface or SIG. Assigns vpn_id: 10, ensuring the monitoring occurs within the correct SD-WAN VPN instance, Uses id: 101, a unique identifier for this tracker within the system.

By implementing this configuration, the financial institution can dynamically track WAN connectivity status and respond to failures by rerouting traffic or triggering alerts, ensuring high availability of critical banking services.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: BRANCH-WAN-MONITORING
        description: Object tracker for WAN route monitoring in VPN 10
        object_trackers:
          - name: DC-ROUTE-TRACKER
            description: Monitors reachability of data center route
            id: 101
            type: route
            route_ip: 192.168.100.0
            route_mask: 255.255.255.0
            vpn_id: 10
```
