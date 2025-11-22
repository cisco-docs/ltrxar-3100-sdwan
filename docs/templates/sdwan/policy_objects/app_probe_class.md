# App Probe Class

The app probes class in Cisco SD-WAN policy object configurations is a policy object used to define how application traffic is marked and forwarded based on QoS parameters, this enabling optimized path selection in the SD-WAN fabric.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an App Probe Class containing multiple App Probes. Each App Probe is identified by its name and can include various probe configurations.
The forwarding_class is used to specify the class map that the App Probe belongs to, and mappings can include color and DSCP values.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      app_probe_classes:
        - name: app_probe1
          forwarding_class: bulk
          mappings:
            - color: blue
              dscp: 46
        - name: app_probe2
          forwarding_class: realtime
          mappings:
            - color: mpls
```
