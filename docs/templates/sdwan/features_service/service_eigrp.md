# Service EIGRP Feature

This feature enables EIGRP routing protocol, allowing the device to exchange routing information with service-side devices.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a service EIGRP feature with Autonomous System ID 111, Network (100.2.2.3/24), Authentication Type is md5, MD5 Key (key id is 2, authentication key is password123), Interface (interface name is GigabitEthernet4, shutdown is false and summary address (10.0.0.1/24)).

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        eigrp_features:
          - name: service_eigrp
            description: service eigrp feature
            autonomous_system_id: 111
            networks: 
              - network_address: 100.2.2.0
                subnet_mask: 255.255.255.0
            authentication_type: md5
            md5_keys:
              - key_id: 2
                key_string: password123
            interfaces: 
              - name: GigabitEthernet4
                shutdown: false
                summary_addresses:
                  - network_address: 10.0.0.0
                    subnet_mask: 255.255.255.0
```
