# System Feature Template

Configure basic system information, such as site ID, system IP, time zone, hostname, device groups, GPS coordinates, port hopping, and port offset.

{{ doc_gen }}

### Examples

Example-1 : SD-WAN Edge System Template: Base Configuration for CEDGE

The system_templates section within edge_feature_templates defines foundational system settings for SD-WAN edge devices. These templates provide standardized configurations that can be applied across multiple edge devices, ensuring consistency and automation in deployment.

The template, named FT-CEDGE-SYSTEM-01, acts as a base system template for configuring Cisco Edge (CEDGE) devices with essential system-level parameters. It includes settings for timezone, system descriptions, location-based variables (latitude & longitude), hostname, system IP, and idle timeouts. Additionally, it enables on-demand tunnels with an idle timeout configuration, ensuring that resources are optimized when tunnels are not actively used.

Furthermore, the template includes an endpoint tracker for monitoring static routes, which helps maintain network resiliency by tracking predefined endpoints. The static route tracker operates with a 300ms threshold, a 20-second interval, and a multiplier of 1, ensuring that the system detects failures and adapts accordingly.

```yaml
sdwan:
  edge_feature_templates:
    system_templates:
      - name: FT-CEDGE-SYSTEM-01
        description: "Base Cisco System template"
        timezone: Europe/Warsaw
        system_description_variable: system_description
        latitude_variable: system_latitude
        longitude_variable: system_longitude
        hostname_variable: system_hostname
        idle_timeout: 300
        location_variable: system_location
        on_demand_tunnel: true
        on_demand_tunnel_idle_timeout: 300
        site_id_variable: site_id
        system_ip_variable: system_ip
        enhanced_app_aware_routing: conservative
        endpoint_trackers:
          - name: static_route_tracker
            threshold: 300
            interval: 20
            multiplier: 1
            type: static-route
            endpoint_ip_variable: static_route_tracker_ip
```
