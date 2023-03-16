# SLA Class List

A SLA class defines the maximum jitter, maximum latency, maximum packet loss, or a combination of these values, for the Cisco SD-WAN data plane tunnels. The SLA classes are used in Application-Aware Routing Policies.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      sla:
        - name: Best-Effort
          description: Best Effort SLA
          entries:
          - jitter: '500'
            latency: '500'
            loss: '5'
```
