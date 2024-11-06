# AS Path List

AS Path list specifies one or more BGP AS paths.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    as_path_lists:
      - name: ASPATH-PRIVATE
        as_paths:
          - ^65100
          - ^65101
```
