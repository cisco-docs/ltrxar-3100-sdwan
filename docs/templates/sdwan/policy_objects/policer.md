# Policer List

Configure policers to control the maximum rate of traffic sent or received on an interface, and to partition a network into multiple priority levels.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      policer:
        - name: POLICER-BRANCH
          description: Policer for branch sites
          entries:
            - burst: '2000000'
              exceed: remark
              rate: '250000000'
```
