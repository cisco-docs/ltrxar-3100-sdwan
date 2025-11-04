# Zone-Based Firewall

Zone-Based Firewall defines the matching conditions and actions to configure a firewall policy.

Note: When using "protocol_names" in match_criterias, also populate the "protocols" and "destination_ports" with corresponding values. The full list of "protocol_names" amd their corresponding "protocols" and "destination_ports" can be accessed at `https://<vmanage-ip>/app/json/application_protocol.json`. when chosing the "protocol_names" as either "tcp" or "udp", "destination_ports" is not mandatory.

{{ doc_gen }}

### Examples

Example-1: Securing Guest Network with Internet-Only Access

A retail chain wants to provide a secure guest Wi-Fi network that allows internet access while preventing access to the internal corporate network. This ensures that guests can browse the internet freely without reaching sensitive company resources. By implementing strict security controls, the retail chain can enhance cybersecurity while offering a seamless browsing experience for customers.

To achieve this, an SD-WAN security policy using Zone-Based Firewall (ZBFW) rules is implemented. This policy leverages network segmentation to isolate guest users from the corporate environment while maintaining secure internet access. The key components of this approach include zones (Guest_WiFi, Corporate_LAN, and Internet), security policies to regulate traffic flow, ZBFW rules to define allowed and blocked connections, and zone pairs to establish relationships between different network segments.

In this setup, the Guest_WiFi zone (VPN ID 200) is configured to block access to the Corporate_LAN (VPN ID 300) while allowing unrestricted access to the Internet (VPN ID 400). To enforce this, a firewall rule explicitly denies traffic from 10.0.200.0/24 (Guest_WiFi) to 10.0.100.0/24 (Corporate_LAN), ensuring that corporate assets remain protected. Simultaneously, another rule permits traffic from 10.0.200.0/24 to 0.0.0.0/0, enabling guest users to access the internet without restrictions.

The zone pairs further enforce these policies by controlling communication between different network segments. Traffic from Guest_WiFi to Corporate_LAN is explicitly blocked, ensuring that guests cannot access internal systems. Meanwhile, traffic from Guest_WiFi to the Internet is allowed, providing seamless internet connectivity for guests. This structured approach ensures a secure and scalable guest network while protecting corporate resources from unauthorized access.


```yaml
sdwan:
  security_policies:
    definitions:
      zone_based_firewall:
        - name: Guest_WiFi_ZBFW
          description: ZBFW policy to allow internet access and block corporate access
          default_action_type: drop
          rules:
            - id: 1
              name: Block_Corporate_Access
              base_action: drop
              match_criterias:
                  source_ip_prefix: 10.0.200.0/24
                  destination_ip_prefix: 10.0.100.0/24
            - id: 2
              name: Allow_Internet_Access
              base_action: pass
              match_criterias:
                  source_ip_prefix: 10.0.200.0/24
                  destination_ip_prefix: 0.0.0.0/0
          zone_pairs:
            - source_zone: Guest_WiFi
              destination_zone: Corporate_LAN
            - source_zone: Guest_WiFi
              destination_zone: Internet
```
The security policy YAML mentioned above will only be effective if the following zone pairs YAML is created.

```yaml
sdwan:
  policy_objects:
    zones:
      - name: Guest_WiFi
        vpn_ids:
          - 200
      - name: Corporate_LAN
        vpn_ids:
          - 300
      - name: Internet
        vpn_ids:
          - 400
```

Example-2: Enhancing Network Security by Restricting Remote Access Protocols

A network administrator wants to enhance security by blocking SSH (port 22) and Telnet (port 23) traffic between two network zones, vpn110 and vpn120. SSH and Telnet are commonly used for remote access, but unauthorized access through these protocols can pose security risks. To prevent potential threats, an SD-WAN Zone-Based Firewall (ZBFW) policy is implemented to explicitly drop any SSH or Telnet traffic between these zones while maintaining control over network communication.

The provided YAML defines an SD-WAN security policy using Zone-Based Firewall (ZBFW) rules to block SSH and Telnet traffic between two network zones, vpn110 and vpn120. The security policy, named ssh_ZBFW_1, is designed to enhance network security by explicitly denying access to these remote access protocols. The default action type is set to drop, meaning any traffic not explicitly allowed by the rules will be blocked. A specific firewall rule, Block_SSH_Telnet_1, is created with ID 1 to block SSH (port 22) and Telnet (port 23) traffic using TCP (protocol ID 6). The rule ensures that any attempt to establish an SSH or Telnet session between these zones is denied. Additionally, a zone pair is defined, specifying that traffic originating from vpn110 and destined for vpn120 will be subject to this policy. This configuration helps prevent unauthorized remote access attempts, reducing the risk of security breaches and ensuring better control over network communication.

```yaml
sdwan:
  security_policies:
    definitions:
      zone_based_firewall:
        - name: ssh_ZBFW_1
          description: ZBFW policy to block SSH and Telnet
          default_action_type: drop
          rules:
            - id: 1
              name: Block_SSH_Telnet_1
              base_action: drop
              match_criterias:
                protocols:
                  - 6  # TCP
                destination_ports:
                  - 22  # SSH
                  - 23  # Telnet
          zone_pairs:
            - source_zone: vpn110
              destination_zone: vpn120
```
The security policy YAML mentioned above will only be effective if the following zone pairs YAML is created.

```yaml
sdwan:
  policy_objects:
    zones:
      - name: vpn110
        vpn_ids:
          - 110
      - name: vpn120
        vpn_ids:
          - 120
```

Example-3: In this example it is shown how we could reference the Port Lists to match the Source and Destination Ports in a zone based firewall Security Policy. 

```yaml
sdwan:
  security_policies:
    definitions:
      zone_based_firewall:
        - name: ZONE-BASED-FIREWALL-01
          description: ZONE-BASED-FIREWALL-01
          default_action_type: drop
          rules:
            - id: 1
              name: Rule_1
              base_action: pass
              match_criterias:
                source_port_lists:
                  - Test_source_ports
                destination_port_lists:
                  - Test_Device_access_ports
                  - Test_Web_Ports
```
The security policy YAML mentioned above will only be effective if the following Port Lists are created under policy objects.

```yaml
sdwan:
  policy_objects:
    port_lists:
      - name: Test_source_ports
        ports:
          - 5062-6083
      - name: Test_Device_access_ports
        ports:
          - 22
          - 23
      - name: Test_Web_Ports
        ports:
          - 443
          - 80
```

Example-4: The NextGen Firewall (Unified Firewall) Policy

The next gen firewall is a zone based firewall with mode defined as unified. The local_application_list element defined here would reference the application list under a given rule unlike in zone based firewall policy in security mode, where this element used to refer application list to block.
When the mode field is not defined, it would consider the zone based firewall policy in default security mode.
Only the Next Gen Firewall i.e. Zone based Firewall with mode unified can be referenced in Unified Security Policy.

```yaml
sdwan:
  security_policies:
    definitions:
      zone_based_firewall:
        - name: NGFW-TF-AK
          description: NextGen FW for Unified Security Policy
          mode: unified
          default_action_type: pass
          rules:
            - id: 1
              name: Rule 1
              base_action: inspect
              match_criterias:
                source_data_prefix_lists:
                  - ZBFW_SDPL_1_uni1
                  - ZBFW_SDPL_2_uni1
                source_fqdn_lists:
                  - ZBFW_SFL_1_uni1
                  - ZBFW_SFL_2_uni1
                source_geo_locations:
                  - DZA
                  - AGO
                destination_port_ranges:
                  - from: 8443
                    to: 8447
                local_application_list: ZBFW_LAL_1_uni1
              actions:
                log: true
```
The unified firewall policy YAML mentioned above will only be effective only if the respective YAML for policy objects is created for elements referenced under source_data_prefix_lists, source_fqdn_lists, local_application_list.
