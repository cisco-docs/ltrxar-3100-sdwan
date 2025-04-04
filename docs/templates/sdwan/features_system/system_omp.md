# System OMP Feature
OMP template controls number of paths being advertised and installed, which protocols are by default redistributed into OMP, AS overlay number and also various timers: graceful restart, advertisment and hold.

{{ doc_gen }}

### Examples

Example-1: Basic OMP configuration is shown in example below. We want OMP only to advertise by default static and connected routes. Rest should be controlled by VPN template. Edges are allowed to advertise 16 paths and install 16 ECMP paths. Graceful restart is enabled with restart timer set to one day.

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: Basic system profile
        omp_templates:
          - name: FT-EDGE-OMP-01
            description: OMP base template
            ipv4_advertise_protocols:
              - ospf
              - connected
            ipv6_advertise_protocols:
              - ospf
              - connected
            ecmp_limit: 16
            send_path_limit: 16
            graceful_restart: true
            graceful_restart_timer: 86400
```
