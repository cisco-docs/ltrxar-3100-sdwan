# Cflowd Definition

Cflowd monitors traffic flowing through Cisco IOS XE SD-WAN devices in the overlay network and exports flow information to a collector.

A Cflowd policy defines a configuration template used to define settings and parameters for collecting flow data from network traffic. A data policy that defines traffic match parameters and that includes the action "cflowd" is required to effectively export flow information based on the parameters defined by the Cflowd template.

{{ doc_gen }}

### Examples

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