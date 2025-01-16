# Cellular Controller Feature Template

Configure a standard Cellular Controller, the cellular interface name, the primary SIM slot, the SIM failover parameters, and more.

{{ doc_gen }}

### Examples

This example shows how to configure cellular controller feature template with cellular interface id, primary sim slot, sim failover timeout and sim failover retry as variable.

```yaml
sdwan:
  edge_feature_templates:
    cellular_controller_templates:
      - name: FT-CEDGE-CELL_CNTRL101-V01
        description: "Cellular Controller #1"
        cellular_interface_id: 0/1/0
        primary_sim_slot: 1
        sim_failover_retries_variable: celcon_simfor_1
        sim_failover_timeout: 4
```
