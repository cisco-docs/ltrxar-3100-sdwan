# SLA Class List

A SLA class defines the maximum jitter, maximum latency, maximum packet loss, or a combination of these values, for the Cisco SD-WAN data plane tunnels. The SLA classes are used in Application-Aware Routing Policies.

{{ doc_gen }}

### Examples

Example-1: The following example demonstrates how to configure an SLA class.
The sla class `SLA-REALTIME` has a jitter of 20ms, a latency of 100ms, and a loss of 1%, with a fallback criteria of jitter and a jitter variance of 40ms.

```yaml
sdwan:
  policy_objects:
    sla_classes:
      - name: SLA-REALTIME
        jitter_ms: 20
        latency_ms: 100
        loss_percentage: 1
        fallback_best_tunnel_criteria: jitter
        fallback_best_tunnel_jitter: 40
```
