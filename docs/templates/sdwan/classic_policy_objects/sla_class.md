# SLA Class

A SLA class defines the maximum jitter, maximum latency, maximum packet loss, or a combination of these values, for the Cisco SD-WAN data plane tunnels. The SLA classes are used in Application-Aware Routing Policies.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    sla_classes:
      - name: Best-Effort
        latency_ms: 200
        loss_percentage: 1
        fallback_best_tunnel_criteria: latency
        fallback_best_tunnel_latency: 50
```
