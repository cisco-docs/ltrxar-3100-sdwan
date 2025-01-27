# AS Path List

AS Path list specifies one or more BGP AS paths.

{{ doc_gen }}

### Examples

The example below demonstrates how to configure an AS Path List with ID 10 that matches AS paths starting with 65100 or 65101 AS numbers.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      as_path_lists:
        - name: aspath_list10
          id: 10
          as_paths:
            - ^65100
            - ^65101
```

The example below demonstrates how to configure the AS Path List with ID 20 that matches AS paths ending with AS number 65999 or having AS number 65000 in AS path.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      as_path_lists:
        - name: aspath_list20
          id: 20
          as_paths:
            - 65999$
            - _65000_
```
