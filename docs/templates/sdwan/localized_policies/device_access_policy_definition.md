# Device Access Policy Definition

The control plane of Cisco vEdge devices process the data traffic for local services like, SSH and SNMP, from a set of sources. It is important to protect the CPU from device access traffic by applying the filter to avoid malicious traffic.

Access policies define the rules that traffic must meet to pass through an interface.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      deviceAccessPolicy:
        - name: ACL-DEVICEACCESSPOLICY-01
          description: "SSH and SNMP access control"
          parameters:
            defaultAction:
              type: drop
            sequences:
              - actions:
                  - parameter: SEQ10-SSH
                    type: count
                baseAction: accept
                match:
                  entries:
                    - field: sourceIp
                      value: 10.254.1.0/24
                    - field: destinationIp
                      value: 10.253.7.0/24
                    - field: destinationPort
                      value: "22"
                sequenceId: 10
                sequenceIpType: ipv4
                sequenceName: Device Access Control List
                sequenceType: deviceaccesspolicy
```
