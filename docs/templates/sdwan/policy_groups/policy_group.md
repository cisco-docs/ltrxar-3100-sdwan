# Policy Group

Policy groups simplify the experience of configuring and deploying various policies on Cisco Catalyst SD-WAN devices.

{{ doc_gen }}

### Examples

Example-1: The example below defines a policy group named emea_policy and assigns an application priority profile.

```yaml
sdwan:
  policy_groups:
    - name: emea_policy
      description: policy group for branches in EMEA
      application_priority: emea_app_priority
```

Example-2: The example below defines a policy group with an NGFW security profile.

```yaml
sdwan:
  policy_groups:
    - name: branch_security_policy
      description: policy group with NGFW security for branch sites
      ngfw_security: ngfw_profile
```
