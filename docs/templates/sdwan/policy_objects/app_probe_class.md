# App Probe Class

An application probe class (app-probe-class) defines the forwarding class and DSCP marking for each color over which BFD probes are sent. When router has app-probe-class configured, the BFD packets are sent for each SLA app-probe-class separately in a round-robin manner.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    app_probe_classes:
      - name: low-latency-data-probe
        forwarding_class: transactional-data
        mappings:
          - color: custom1
            dscp: 0
          - color: private1
            dscp: 41
```
