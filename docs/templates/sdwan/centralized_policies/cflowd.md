# Cflowd Definition

The example below shows definition of cflowd policy definition.

{{ doc_gen }}

### Examples

Example-1: In the below example , cflows policy has been defined to use timeouts for active,inactive flows in seconds.The sampling rate has been set to 30 seconds and flow refresh to 60seconds.
There are two collectors defined one in each of service vpn 112 and 101 respectively.For each of the collector , IP address , port number and source_interface has been defined.

```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        cflowd:
          - name: CFLOW_DEFINITION_TEST2
            description: CFLOW_DEFINITION_TEST2
            active_flow_timeout: 30
            inactive_flow_timeout: 3600
            sampling_interval: 30
            flow_refresh: 60
            protocol: ipv4
            tos: true
            remarked_dscp: true
            collectors:
              - vpn: 112
                ip_address: 173.36.118.129
                port: 2048
                transport: transport_udp
                source_interface: GigabitEthernet0
                export_spreading: enable
              - vpn: 101
                ip_address: 173.36.118.130
                port: 2048
                transport: transport_udp
                source_interface: GigabitEthernet1
                export_spreading: enable
```
