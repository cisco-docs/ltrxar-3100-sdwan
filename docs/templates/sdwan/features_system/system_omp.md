# System OMP Feature

OMP template controls number of paths being advertised and installed, which protocols are by default redistributed into OMP, AS overlay number and also various timers: graceful restart, advertisment and hold.

{{ doc_gen }}

### Examples

Example-1: This example shows how to configure OMP feature which advertises IPv4 and IPv6 connected and OSPF routes into OMP, setting ECMP limit and send-path-limit to 16, enabling graceful restart and setting a greaceful restart timer.

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: Basic system profile
        omp:
          name: omp
          description: OMP base template
          advertise_ipv4_connected: true
          advertise_ipv4_ospf: true
          advertise_ipv6_connected: true
          advertise_ipv6_ospf: true
          ecmp_limit: 16
          send_path_limit: 16
          graceful_restart: true
          graceful_restart_timer: 86400
```
