# CLI Policies

The concept of centralized CLI policy refers to the ability to manage and configure Cisco SD-WAN centralized policies by mean of directly inputting command-line policy commands on a text editor provided by the vManage GUI.

Centralized CLI policies offer more granular control over CLI configurations and helps override limitations imposed by Policy Builder, providing support for specific use cases that cannot leverage the Policy Buildir capabilities.

These policies can then be activated to be applied to the SD-WAN deployment.

{{ doc_gen }}

### Examples

Example-1: Defining CLI-Based Control Policies for Traffic Routing

This use case focuses on configuring a centralized CLI-based policy for controlling traffic routing preferences in an SD-WAN deployment. The customer intends to prioritize traffic based on hub locations, allowing a preferred east hub for certain traffic flows. The configuration specifies the use of a control policy that directs traffic to a specific TLOC (Transport Location) list for routing, applying a preference score to influence routing decisions. If traffic does not match the defined criteria, the default action is to reject it. 

The YAML provided below outlines a centralized CLI policy for managing traffic routing preferences to the east hub. The policy named CLI_policy1 defines a sequence that matches traffic directed to the East-hub-tloc TLOC. It applies an action to accept this traffic and set the preference to 50 to prioritize it. If traffic does not match this rule, the default action is to reject it. This configuration ensures that traffic targeting the East hub is prioritized while other traffic is rejected by default, ensuring strict control over routing preferences.

``` yaml
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
    activated_policy: CLI_policy1
```  
