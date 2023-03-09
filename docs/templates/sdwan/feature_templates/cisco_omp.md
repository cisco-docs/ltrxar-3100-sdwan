# Cisco OMP Feature Template

Change the graceful restart timers and advertisement timers and hold timers; change the number of paths advertised; configure an AS overlay number; choose which local protocols will be advertised into OMP; and change the number of equal-cost paths installed in the WAN Edge router.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_omp:
      - name: FT-CEDGE-OMP-01
        description: "OMP base template"
        parameters:
          advertise:
          - protocol: connected
          ecmp-limit: 16
          graceful-restart: 'true'
          send-path-limit: 16
          timers:
            graceful-restart-timer: 86400
```
