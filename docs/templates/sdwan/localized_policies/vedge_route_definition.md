# vEdge Route Definition

Configure route policies.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      vedgeRoute:
        - name: ROUTE-MAP-SET-OMPTAG
          description: "Set OMP tag based on community list"
          parameters:
            defaultAction:
              type: accept
            sequences:
              - actions:
                  - parameter:
                      - field: ompTag
                        value: "1122334455"
                    type: set
                baseAction: accept
                match:
                  entries:
                    - field: community
                      matchFlag: or
                      ref: COMMUNITY-REGION1
                sequenceId: 10
                sequenceIpType: ipv4
                sequenceName: Route
                sequenceType: vedgeRoute
```
