# App Probe Class

An application probe class (app-probe-class) defines the forwarding class and DSCP marking for each color over which BFD probes are sent. When router has app-probe-class configured, the BFD packets are sent for each SLA app-probe-class separately in a round-robin manner.

{{ doc_gen }}

### Examples

Example-1 : The below example shows an app_probe_class configured for REALTIME applications.
forwarding_class has been referenced to CLASS-REALTIME class map which has been already defined as a policy object.
The color of the tloc is public-internet and dscp marking has been set to 46.

```yaml
sdwan:
  policy_objects:
    app_probe_classes:
      - name: REALTIME_PROBE
        forwarding_class: CLASS-REALTIME
        mappings: 
          - color: public-internet
            dscp: 46
        
```
