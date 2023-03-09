# ACL Definition

Access lists configured through localized data policy are called explicit ACLs. Explicit ACLs can be applied to any interface in any VPN on the device.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      acl:
        - name: ACL-TLOCEXT-DSCP
          description: "Set traffic class based on DSCP on inbound tloc-extension"
          parameters:
            defaultAction:
              type: accept
            sequences:
              - actions:
                  - parameter:
                      ref: CLASS-REALTIME
                    type: class
                  - parameter: 10-CLASS-REALTIME
                    type: count
                baseAction: accept
                match:
                  entries:
                    - field: dscp
                      value: "46"
                sequenceId: 10
                sequenceIpType: ipv4
                sequenceName: Access Control List
                sequenceType: acl
```
