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
          - name: Cflowd_Policy_v01
            description: Sample Cflowd Policy
            active_flow_timeout: 100
            inactive_flow_timeout: 10
            sampling_interval: 10
            flow_refresh: 120
            protocol: ipv4
            tos: true
            remarked_dscp: true
            collectors:
              - vpn: 1
                ip_address: 10.0.0.1
                port: 2048
                transport: transport_tcp
                source_interface: Ethernet1
                export_spreading: enable
```