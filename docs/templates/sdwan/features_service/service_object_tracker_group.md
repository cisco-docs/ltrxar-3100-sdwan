# Service Object Tracker Group Feature

Configure Service Object Tracker Group.

{{ doc_gen }}

### Examples

Example-1: Intelligent WAN Path Failover Using Object Tracker Groups

A global retail company operates multiple branch offices connected to two data centers via SD-WAN. To ensure high availability, they need a mechanism to monitor multiple network paths and automatically trigger failover if both primary and secondary paths become unreachable. By using object_tracker_groups, the IT team can group multiple object_trackers and apply logical conditions (AND or OR) to determine network status dynamically.

In this scenario, two routes (192.168.10.0/24 for DC1 and 192.168.20.0/24 for DC2) are tracked within VPN 20. If either of the routes is reachable, the SD-WAN device continues normal operations. However, if both routes are down, a failover action can be triggered to reroute traffic through an alternate path.

This YAML defines a service profile (BRANCH-WAN-FAILOVER) that implements intelligent network monitoring with failover logic. The configuration consists of:
1.Two Object Trackers (DC1-ROUTE-TRACKER and DC2-ROUTE-TRACKER) : Each tracker monitors the reachability of a data center route (192.168.10.0/24 and 192.168.20.0/24), Assigned within VPN 20 to ensure the correct SD-WAN segment is monitored.
2.Object Tracker Group (DC-TRACKER-GROUP): Groups the two trackers together under a failover condition (tracker_boolean: and), The and condition ensures that a failover is only triggered if both routes are down, If at least one route remains available, normal operations continue.

By implementing this object tracker group, the retail company ensures automatic failover decisions based on real-time network reachability, reducing downtime and maintaining seamless business operations.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: BRANCH-WAN-FAILOVER
        description: Monitors multiple WAN routes for failover decisions
        object_trackers:
          - name: DC1-ROUTE-TRACKER
            description: Tracks reachability of Data Center 1
            id: 201
            type: Route
            route_ip: 192.168.10.0
            route_mask: 255.255.255.0
            vpn_id: 20
            
          - name: DC2-ROUTE-TRACKER
            description: Tracks reachability of Data Center 2
            id: 202
            type: Route
            route_ip: 192.168.20.0
            route_mask: 255.255.255.0
            vpn_id: 20

        object_tracker_groups:
          - name: DC-TRACKER-GROUP
            description: Grouping DC1 and DC2 route trackers for failover logic
            id: 301
            tracker_boolean: and
            trackers:
              - DC1-ROUTE-TRACKER
              - DC2-ROUTE-TRACKER
```
