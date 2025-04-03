# OMP Feature Template

Change the graceful restart timers and advertisement timers and hold timers; change the number of paths advertised; configure an AS overlay number; choose which local protocols will be advertised into OMP; and change the number of equal-cost paths installed in the WAN Edge router.


{{ doc_gen }}

### Examples

Example-1: The example below shows the global configuration for OMP feature template.In the below example only OSPF , BGP and Connected routes are advertised into OMP. Equal cost multipath limit is set to 16 and similar configuration has been applied for send_path_limit as well. OMP graceful restart timer is set to 86400 seconds.

```yaml
sdwan:
  edge_feature_templates:
    omp_templates:
      - name: GLOBAL-OMP-V01
        description: global omp template for all devices
        ipv4_advertise_protocols:
          - ospf
          - connected
          - bgp
        ecmp_limit: 16
        graceful_restart: true
        send_path_limit: 16
        graceful_restart_timer: 86400

```
