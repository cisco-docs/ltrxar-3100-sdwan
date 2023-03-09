# AS Path List

AS Path list specifies one or more BGP AS paths.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    lists:
      asPath:
        - name: ASPATH-PRIVATE
          description: "Private AS Path list"
          entries:
          - asPath: ^65100
          - asPath: ^65101
```
