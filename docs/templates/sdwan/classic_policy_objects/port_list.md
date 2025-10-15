# Port List

Port List defines the group of Layer 4 Port attribute that can be used in Security Policies.

{{ doc_gen }}

### Examples

Example-1: This example shows how to configure Port list consisting ports 22 and 23.

```yaml
sdwan:
  policy_objects:
    port_lists:
      - name: Test_Device_access_ports
        ports:
          - 22
          - 23
```

Example-2: This example shows how to configure port range in the elements of the list. The Port list consists of range of ports 8080-8082 i.e. port numbers 8080,8081,8082. Similarly the range of ports in 65529-65534.

```yaml
sdwan:
  policy_objects:
    port_lists:
      - name: Other_Range_Ports
        ports:
          - 8080-8082
          - 65529-65534
```
