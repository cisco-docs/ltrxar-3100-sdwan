# Intrusion Prevention Policy

An IPS (Intrusion Prevention System) policy in Cisco SD-WAN helps detect and prevent security threats by inspecting network traffic and blocking malicious activities.

A policy is defined by providing the settings that dictate the operational mode of the Snort engine and actions invoked by the matching of specific signatures (Snort rules).

{{ doc_gen }}

### Examples

```yaml
sdwan:
  security_policies:
    definitions:
      intrusion_prevention:
        - name: IPS_Test_Policy
          description: SaC_IPS_Test_Policy
          mode: security
          inspection_mode: protection
          log_level: alert
          signature_set: balanced
          target_vpns:
            - 10
            - 20
```