# CLI Policies

The concept of centralized CLI policy refers to the ability to manage and configure Cisco SD-WAN centralized policies by mean of directly inputting command-line policy commands on a text editor provided by the vManage GUI.

Centralized CLI policies offer more granular control over CLI configurations and helps override limitations imposed by Policy Builder, providing support for specific use cases that cannot leverage the Policy Buildir capabilities.

These policies can then be activated to be applied to the SD-WAN deployment.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    cli_policies:
      - name: CLI_policy1
        description: CLI policy1
        policy_definition: |
          ! policy
          control-policy Prefer-east-hub
              sequence 1
              match tloc
                tloc-list East-hub-tloc
              !
              action accept
                set
                preference 50
                !
              !
              !
            default-action reject
          !
    activated_policy: CP1     
```                   
