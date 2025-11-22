# Policy Group

Policy groups simplify the experience of configuring and deploying various policies on Cisco Catalyst SD-WAN devices.

{{ doc_gen }}

### Examples

Example-1: The example below defines a policy group named emea_policy and assignes application priority profile.

```yaml
sdwan:
  policy_groups:
    - name: emea_policy
      description: policy group for branches in EMEA
      application_priority: emea_app_priority
```
