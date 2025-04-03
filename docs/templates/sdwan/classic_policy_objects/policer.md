# Policer List

Configure policers to control the maximum rate of traffic sent or received on an interface, and to partition a network into multiple priority levels.

{{ doc_gen }}

### Examples

Example-1: This example shows the configuration of a policer set to 10 Mbps, a burst rate to 15 KBytes and the policer is exceeded, the action is drop.

```yaml
sdwan:
  policy_objects:
    policers:
      - name: Policer_Drop_10Mbps
        burst_bytes: 15000
        exceed_action: drop
        rate_bps: 10240000
```

Example-2: This example shows the configuration of a policer set to 50 Mbps, a burst rate to 15 KBytes and the policer is exceeded, the action is Remark.


```yaml
sdwan:
  policy_objects:
    policers:
      - name: Policer_Remark_50Mbps
        burst_bytes: 15000
        exceed_action: remark
        rate_bps: 50000000
```

Example-3: This example shows the configuration of two different policers one set to 50 Mbps and the second set to 10 Mbps.

```yaml
sdwan:
  policy_objects:
    policers:
      - name: Policer_Drop_10Mbps
        burst_bytes: 15000
        exceed_action: drop
        rate_bps: 10240000
      - name: Policer_Remark_50Mbps
        burst_bytes: 15000
        exceed_action: remark
        rate_bps: 50000000
```