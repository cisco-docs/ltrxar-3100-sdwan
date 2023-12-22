# Policer List

Configure policers to control the maximum rate of traffic sent or received on an interface, and to partition a network into multiple priority levels.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    policers:
      - name: POLICER-BRANCH
        burst_bytes: 2000000
        exceed_action: remark
        rate_bps: 250000000
```
