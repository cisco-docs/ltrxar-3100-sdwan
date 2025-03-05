*** Settings ***
Documentation   Verify Ethernet Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates    ethernet_interface_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.ethernet_interface_templates is defined%}

*** Test Cases ***
Get Ethernet Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_vpn_interface")]
    Set Suite Variable    ${r}

{% for eit in sdwan.edge_feature_templates.ethernet_interface_templates | default([]) %}

Verify Edge Feature Template Ethernet Feature template {{ eit.name }}
    ${eit_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ eit.name }}")]
    Should Be Equal Value Json String    ${eit_id}    $..templateName    {{ eit.name }}    msg=name
    Should Be Equal Value Json String    ${eit_id}    $..templateDescription    {{ eit.description }}    msg=description

    {% set dt_list_local = [] %}
    {% for item in eit.device_types | default(defaults.sdwan.edge_feature_templates.ethernet_interface_templates.device_types) %}
    {% set test = "vedge-" ~ item %}
    {% set _ = dt_list_local.append(test) %}
    {% endfor %}
    ${dt_list_remote}=    Get Value From Json    ${eit_id}    $..deviceType
    ${dt_list_local}=    Create List    {{ dt_list_local | join('   ') }}
    Lists Should Be Equal    ${dt_list_remote[0]}    ${dt_list_local}    ignore_order=True    msg=device type

    ${template_id}=    Get Value From Json   ${r}   $[?(@.templateName=="{{ eit.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}
    
    ${adaptive_qos_remote}=   Get Value From Json   ${r_id.json()}        $..["qos-adaptive"]..vipType
    ${adaptive_qos_remote}=   Set Variable If    ${adaptive_qos_remote} == []    false    true
    Should Be Equal As Strings    ${adaptive_qos_remote}    {{ eit.adaptive_qos | default("false") | lower() }}    msg=adaptive qos

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].period    {{ eit.adaptive_qos_period_variable | default(eit.adaptive_qos_period | default("not_defined")) }}    msg=adaptive qos period
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].upstream.["bandwidth-up"]    {{ eit.adaptive_qos_shaping_rate_upstream.default_variable | default(eit.adaptive_qos_shaping_rate_upstream.default | default("not_defined")) }}    msg=adaptive qos shaping rate upstream
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].upstream.range.umin    {{ eit.adaptive_qos_shaping_rate_upstream.minimum_variable | default(eit.adaptive_qos_shaping_rate_upstream.minimum | default("not_defined")) }}    msg=adaptive qos shaping rate upstream minimum
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].upstream.range.umax    {{ eit.adaptive_qos_shaping_rate_upstream.maximum_variable | default(eit.adaptive_qos_shaping_rate_upstream.maximum | default("not_defined")) }}    msg=adaptive qos shaping rate upstream maximum
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].downstream.["bandwidth-down"]    {{ eit.adaptive_qos_shaping_rate_downstream.default_variable | default(eit.adaptive_qos_shaping_rate_downstream.default | default("not_defined")) }}    msg=adaptive qos shaping rate downstream default
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].downstream.range.dmin    {{ eit.adaptive_qos_shaping_rate_downstream.minimum_variable | default(eit.adaptive_qos_shaping_rate_downstream.minimum | default("not_defined")) }}    msg=adaptive qos shaping rate downstream minimum
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].downstream.range.dmax    {{ eit.adaptive_qos_shaping_rate_downstream.maximum_variable | default(eit.adaptive_qos_shaping_rate_downstream.maximum | default("not_defined")) }}    msg=adaptive qos shaping rate downstream maximum
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["arp-timeout"]    {{ eit.arp_timeout_variable | default(eit.arp_timeout | default("not_defined")) }}    msg=arp timeout
    Should Be Equal Value Json String FT    ${r_id.json()}    $..autonegotiate    {{ eit.autonegotiate_variable | default(eit.autonegotiate | default("not_defined") | lower()) }}    msg=autonegotiate
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["auto-bandwidth-detect"]    {{ eit.bandwidth_auto_detect_variable | default(eit.bandwidth_auto_detect | default("not_defined") | lower()) }}    msg=bandwidth auto detect
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["bandwidth-downstream"]    {{ eit.bandwidth_downstream_variable | default(eit.bandwidth_downstream | default("not_defined")) }}    msg=bandwidth downstream
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["bandwidth-upstream"]    {{ eit.bandwidth_upstream_variable | default(eit.bandwidth_upstream | default("not_defined")) }}    msg=bandwidth upstream
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["block-non-source-ip"]    {{ eit.block_non_source_ip_variable | default(eit.block_non_source_ip | default("not_defined") | lower()) }}    msg=block non source ip
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["dhcp-distance"]    {{ eit.dhcp_distance_variable | default(eit.dhcp_distance | default("not_defined")) }}    msg=dhcp distance
    Should Be Equal Value Json String FT    ${r_id.json()}    $..duplex    {{ eit.duplex_variable | default(eit.duplex | default("not_defined")) }}    msg=duplex

    ${enable_sgt_remote_vt}=   Get Value From Json   ${r_id.json()}        $..trustsec.enable.vipType
    ${enable_sgt_remote_vv}=   Get Value From Json   ${r_id.json()}        $..trustsec.enable.vipValue
    ${enable_sgt_remote}=   Set Variable If    ${enable_sgt_remote_vt} == ['constant'] and ${enable_sgt_remote_vv} == ['true']    true    false
    Should Be Equal As Strings    ${enable_sgt_remote}    {{ eit.enable_sgt | default("false") | lower() }}    msg=enable sgt

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["tloc-extension-gre-from"].src-ip    {{ eit.gre_tunnel_source_ip_variable | default(eit.gre_tunnel_source_ip | default("not_defined")) }}    msg=gre tunnel source ip
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["tloc-extension-gre-from"].xconnect    {{ eit.gre_tunnel_xconnect_variable | default(eit.gre_tunnel_xconnect | default("not_defined")) }}    msg=gre tunnel xconnect
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["icmp-redirect-disable"]    {{ eit.icmp_redirect_disable_variable | default(eit.icmp_redirect_disable | default("not_defined") | lower()) }}    msg=icmp redirect disable
    Should Be Equal Value Json String FT    ${r_id.json()}    $..description    {{ eit.interface_description_variable | default(eit.interface_description | default("not_defined")) }}    msg=interface description
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["if-name"]    {{ eit.interface_name_variable | default(eit.interface_name | default("not_defined")) }}    msg=interface name
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["ip-directed-broadcast"]    {{ eit.ip_directed_broadcast_variable | default(eit.ip_directed_broadcast | default("not_defined") | lower()) }}    msg=ip directed broadcast
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["iperf-server"]    {{ eit.iperf_server_variable | default(eit.iperf_server | default("not_defined")) }}    msg=iperf server
    Should Be Equal Value Json String FT    ${r_id.json()}    $.["access-list"].vipValue[?(@.direction.vipValue=="in")]..["acl-name"]    {{ eit.ipv4_ingress_access_list_variable | default(eit.ipv4_ingress_access_list | default("not_defined")) }}    msg=ipv4 ingress access list
    Should Be Equal Value Json String FT    ${r_id.json()}    $.["access-list"].vipValue[?(@.direction.vipValue=="out")]..["acl-name"]    {{ eit.ipv4_egress_access_list_variable | default(eit.ipv4_egress_access_list | default("not_defined")) }}    msg=ipv4 egress access list
    Should Be Equal Value Json String FT    ${r_id.json()}    $..ipv6.["access-list"].vipValue[?(@.direction.vipValue=="in")]..["acl-name"]    {{ eit.ipv6_ingress_access_list_variable | default(eit.ipv6_ingress_access_list | default("not_defined")) }}    msg=ipv6 ingress access list
    Should Be Equal Value Json String FT    ${r_id.json()}    $..ipv6.["access-list"].vipValue[?(@.direction.vipValue=="out")]..["acl-name"]    {{ eit.ipv6_egress_access_list_variable | default(eit.ipv6_egress_access_list | default("not_defined")) }}    msg=ipv6 egress access list
    Should Be Equal Value Json String FT    ${r_id.json()}    $..ip.address    {{ eit.ipv4_address_variable | default(eit.ipv4_address | default("not_defined")) }}    msg=ip address
    
    ${ipv4_address_dhcp_remote}=   Get Value From Json   ${r_id.json()}        $..ip..["dhcp-client"].vipValue
    ${ipv4_address_dhcp_remote}=   Set Variable If    ${ipv4_address_dhcp_remote} == ['true']    true    false
    Should Be Equal As Strings    ${ipv4_address_dhcp_remote}    {{ eit.ipv4_address_dhcp | default("false") | lower() }}    msg=ipv4 address dhcp

    ${rec_ipv4_dhcp_helpers_viptype}=    Get Value From Json    ${r_id.json()}    $["dhcp-helper"].vipType
    IF    ${rec_ipv4_dhcp_helpers_viptype} != []
        ${rec_ipv4_dhcp_helpers}=    Get Value From Json    ${r_id.json()}    $["dhcp-helper"].vipValue
        ${rec_ipv4_dhcp_helpers_variable}=    Get Value From Json    ${r_id.json()}    $["dhcp-helper"].vipVariableName
        ${exp_ipv4_dhcp_helpers_list}=    Create List    {{ eit.ipv4_dhcp_helpers | default("not_defined") | join('   ')}}
        IF    "${rec_ipv4_dhcp_helpers_viptype}[0]"=="constant"
            Lists Should Be Equal    ${rec_ipv4_dhcp_helpers[0]}    ${exp_ipv4_dhcp_helpers_list}    ignore_order=True    msg=ipv4 dhcp helpers
        ELSE IF    "${rec_ipv4_dhcp_helpers_viptype}[0]"=="variableName"
            Should Be Equal As Strings    ${rec_ipv4_dhcp_helpers_variable[0]}    {{ eit.ipv4_dhcp_helpers_variable | default("not_defined") }}    msg=ipv4 dhcp helpers variable
        ELSE
            Should Be Equal As Strings    not_defined    {{ eit.ipv4_dhcp_helpers_variable | default(eit.ipv4_dhcp_helpers | default("not_defined")) }}    msg=ipv4 dhcp helpers
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ eit.ipv4_dhcp_helpers_variable | default(eit.ipv4_dhcp_helpers | default("not_defined")) }}    msg=ipv4 dhcp helpers
    END

    ${ipv4_nat_remote_const}=   Get Value From Json   ${r_id.json()}        $..nat[?(@.vipType == "constant")]
    ${ipv4_nat_remote_var}=   Get Value From Json   ${r_id.json()}        $..nat[?(@.vipType == "variableName")]
    ${ipv4_nat_remote}=    Set Variable    ${ipv4_nat_remote_const} + ${ipv4_nat_remote_var}
    ${ipv4_nat_remote}=   Set Variable If    ${ipv4_nat_remote} == []   false    true
    Should Be Equal As Strings    ${ipv4_nat_remote}    {{ eit.ipv4_nat | default("false") | lower() }}    msg=ipv4 nat

    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.interface.loopback-interface    {{ eit.ipv4_nat_inside_source_loopback_interface_variable | default(eit.ipv4_nat_inside_source_loopback_interface | default("not_defined")) }}    msg=nat inside source loopback interface
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.overload    {{ eit.ipv4_nat_overload_variable | default(eit.ipv4_nat_overload | default("not_defined") | lower()) }}    msg=nat overload
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.natpool.prefix-length    {{ eit.ipv4_nat_pool_prefix_length_variable | default(eit.ipv4_nat_pool_prefix_length | default("not_defined")) }}    msg=nat pool prefix length
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.natpool.range-end    {{ eit.ipv4_nat_pool_range_end_variable | default(eit.ipv4_nat_pool_range_end | default("not_defined")) }}    msg=nat pool range end
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.natpool.range-start    {{ eit.ipv4_nat_pool_range_start_variable | default(eit.ipv4_nat_pool_range_start | default("not_defined")) }}    msg=nat pool range start
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.tcp-timeout    {{ eit.ipv4_nat_tcp_timeout_variable | default(eit.ipv4_nat_tcp_timeout | default("not_defined")) }}    msg=IPv4 nat tcp timeout
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.udp-timeout    {{ eit.ipv4_nat_udp_timeout_variable | default(eit.ipv4_nat_udp_timeout | default("not_defined")) }}    msg=IPv4 nat udp timeout
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.nat-choice    {{ eit.ipv4_nat_type_variable | default(eit.ipv4_nat_type | default("not_defined")) }}    msg=ipv4 nat type
    
    Should Be Equal Value Json List Length    ${r_id.json()}    $..nat.["static-port-forward"].vipValue    {{ eit.ipv4_port_forwarding_rules | default([]) | length }}    msg=ipv4 port forwarding rules length
    {% for port_fw in eit.ipv4_port_forwarding_rules | default([]) %}
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["static-port-forward"].vipValue[{{ loop.index0 }}].proto    {{ port_fw.protocol_variable | default(port_fw.protocol | default("not_defined")) }}    msg=port fw protocol
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["static-port-forward"].vipValue[{{ loop.index0 }}].source-ip    {{ port_fw.source_ip_variable | default(port_fw.source_ip | default("not_defined")) }}    msg=port fw source ip
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["static-port-forward"].vipValue[{{ loop.index0 }}].source-port    {{ port_fw.source_port_variable | default(port_fw.source_port | default("not_defined")) }}    msg=port fw source port
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["static-port-forward"].vipValue[{{ loop.index0 }}].translate-ip    {{ port_fw.translate_ip_variable | default(port_fw.translate_ip | default("not_defined")) }}    msg=port fw translate ip
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["static-port-forward"].vipValue[{{ loop.index0 }}].translate-port    {{ port_fw.translate_port_variable | default(port_fw.translate_port | default("not_defined")) }}    msg=port fw translate port
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["static-port-forward"].vipValue[{{ loop.index0 }}].source-vpn    {{ port_fw.source_vpn_id_variable | default(port_fw.source_vpn_id | default("not_defined")) }}    msg=port fw source vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["static-port-forward"].vipValue[{{ loop.index0 }}].vipOptional    {{ port_fw.optional | default("not_defined") }}    msg=port fw optional
    {% endfor %}

    Should be Equal Value Json List Length    ${r_id.json()}    $..ip.["secondary-address"].vipValue    {{ eit.ipv4_secondary_addresses | default([]) | length }}    msg=ipv4 secondary addresses length
    {% for sec_addr in eit.ipv4_secondary_addresses | default([]) %}
    ${sec_addr_vt}=   Get Value From Json   ${r_id.json()}    $..ip.["secondary-address"].vipValue[{{ loop.index0 }}]..vipType
    IF  "${sec_addr_vt}[0]" == "constant"
        ${sec_addr_vv}=   Get Value From Json   ${r_id.json()}    $..ip.["secondary-address"].vipValue[{{ loop.index0 }}]..vipValue
    ELSE IF  "${sec_addr_vt}[0]" == "variableName"
        ${sec_addr_vv}=   Get Value From Json   ${r_id.json()}    $..ip.["secondary-address"].vipValue[{{ loop.index0 }}]..vipVariableName
    ELSE
        ${sec_addr_vv}=   Set Variable    []
    END
    Should Be Equal As Strings    ${sec_addr_vv[0]}    {{ sec_addr.address_variable | default(sec_addr.address | default("not_defined")) }}    msg=ipv4 secondary address
    {% endfor %}
    
    Should be Equal Value Json List Length    ${r_id.json()}    $.nat.static.vipValue    {{ eit.ipv4_static_nat_rules | default([]) | length }}    msg=ipv4 static nat rules length
    {% for static_nat in eit.ipv4_static_nat_rules | default([]) %}
    Should Be Equal Value Json String FT  ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}].source-ip    {{ static_nat.source_ip_variable | default(static_nat.source_ip | default("not_defined")) }}    msg=static nat source ip
    Should Be Equal Value Json String FT  ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}].translate-ip    {{ static_nat.translate_ip_variable | default(static_nat.translate_ip | default("not_defined")) }}    msg=static nat translate ip
    Should Be Equal Value Json String FT  ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}].source-vpn    {{ static_nat.source_vpn_id_variable | default(static_nat.source_vpn_id | default("not_defined")) }}    msg=static nat source vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}].vipOptional    {{ static_nat.optional | default("not_defined") }}    msg=static nat optional
    {% endfor %}

    Should be Equal Value Json List Length    ${r_id.json()}    $.vrrp.vipValue    {{ eit.ipv4_vrrp_groups | default([]) | length }}    msg=ipv4 vrrp groups length
    {% for vrrp_group in eit.ipv4_vrrp_groups | default([]) %}
    Should Be Equal Value Json String FT    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].ipv4.address    {{ vrrp_group.address_variable | default(vrrp_group.address | default("not_defined")) }}    msg=ipv4 vrrp groups address
    Should Be Equal Value Json String FT    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].grp-id    {{ vrrp_group.id_variable | default(vrrp_group.id | default("not_defined")) }}    msg=ipv4 vrrp groups id
    Should Be Equal Value Json String FT    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].priority    {{ vrrp_group.priority_variable | default(vrrp_group.priority | default("not_defined")) }}    msg=ipv4 vrrp groups priority
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].vipOptional    {{ vrrp_group.optional | default("not_defined") }}    msg=ipv4 vrrp groups optional
    Should Be Equal Value Json String FT    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].timer    {{ vrrp_group.timer_variable | default(vrrp_group.timer | default("not_defined")) }}    msg=ipv4 vrrp groups timer
    Should Be Equal Value Json String FT    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].tloc-change-pref    {{ vrrp_group.tloc_preference_change | default("not_defined") | lower() }}    msg=ipv4 vrrp groups tloc preference change
    Should Be Equal Value Json String FT    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].value    {{ vrrp_group.tloc_preference_change_value_variable | default(vrrp_group.tloc_preference_change_value | default("not_defined")) }}    msg=ipv4 vrrp groups tloc preference change value
    Should Be Equal Value Json String FT    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].track-prefix-list    {{ vrrp_group.track_prefix_list_variable | default(vrrp_group.track_prefix_list | default("not_defined")) }}    msg=ipv4 vrrp groups track prefix list
    Should Be Equal Value Json String FT    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].track-omp    {{ vrrp_group.track_omp_variable | default(vrrp_group.track_omp | default("not_defined")) | lower() }}    msg=ipv4 vrrp groups track omp
    Should be Equal Value Json List Length    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].tracking-object.vipValue    {{ vrrp_group.tracking_objects | default([]) | length }}    msg=ipv4 vrrp groups tracking objects length
    ${ipv4_vrrp_track_objects}=    Get Value From Json    ${r_id.json()}    $.vrrp.vipValue[{{ loop.index0 }}].tracking-object
    {% for tracking_object in vrrp_group.tracking_objects | default([]) %}
    Should Be Equal Value Json String FT    ${ipv4_vrrp_track_objects}[0]    $.vipValue[{{ loop.index0 }}].name    {{ tracking_object.id_variable | default(tracking_object.id | default("not_defined")) }}    msg=ipv4 vrrp groups tracking object id
    Should Be Equal Value Json String FT    ${ipv4_vrrp_track_objects}[0]    $.vipValue[{{ loop.index0 }}].track-action    {{ tracking_object.action_variable | default(tracking_object.action | default("not_defined")) }}    msg=ipv4 vrrp groups tracking object action
    Should Be Equal Value Json String FT    ${ipv4_vrrp_track_objects}[0]    $.vipValue[{{ loop.index0 }}].decrement    {{ tracking_object.decrement_value_variable | default(tracking_object.decrement_value | default("not_defined")) }}    msg=ipv4 vrrp groups tracking object decrement value
    {% endfor %}
    {% endfor %}

    Should Be Equal Value Json String FT    ${r_id.json()}    $.ipv6.address    {{ eit.ipv6_address_variable | default(eit.ipv6_address | default("not_defined")) }}    msg=ipv6 address
    
    Should Be Equal Value Json List Length    ${r_id.json()}    $.ipv6.dhcp-helper-v6.vipValue    {{ eit.ipv6_dhcp_helpers | default([]) | length }}    msg=ipv6 dhcp helpers length
    {% for dhcp_helper in eit.ipv6_dhcp_helpers | default([]) %}
    Should Be Equal Value Json String FT    ${r_id.json()}    $.ipv6.dhcp-helper-v6.vipValue[{{ loop.index0 }}].address    {{ dhcp_helper.address_variable | default(dhcp_helper.address | default("not_defined")) }}    msg=ipv6 dhcp helper address
    Should Be Equal Value Json String FT    ${r_id.json()}    $.ipv6.dhcp-helper-v6.vipValue[{{ loop.index0 }}].vpn    {{ dhcp_helper.vpn_id_variable | default(dhcp_helper.vpn_id | default("not_defined")) }}    msg=ipv6 dhcp helper vpn id
    {% endfor %}
    
    ${ipv6_nat_presence_nat64}=   Get Value From Json   ${r_id.json()}    $..nat64..vipValue
    ${ipv6_nat_presence_nat66}=   Get Value From Json   ${r_id.json()}    $..nat66
    ${ipv6_nat_presence}=    Set Variable    ${ipv6_nat_presence_nat64} + ${ipv6_nat_presence_nat66}
    ${ipv6_nat_presence}=   Set Variable If    ${ipv6_nat_presence} == []    false    true
    Should Be Equal as Strings    ${ipv6_nat_presence}    {{ eit.ipv6_nat | default("false") | lower() }}    msg=ipv6 nat
    
    ${ipv6_nat_type}=    Set Variable If    ${ipv6_nat_presence_nat64} == []    not_defined    nat64
    ${ipv6_nat_type}=    Set Variable If    ${ipv6_nat_presence_nat66} == []    ${ipv6_nat_type}    nat66
    Should Be Equal As Strings    ${ipv6_nat_type}    {{ eit.ipv6_nat_type | default("not_defined") }}    msg=ipv6 nat type

    Should be Equal Value Json List Length    ${r_id.json()}    $..ipv6.["secondary-address"].vipValue    {{ eit.ipv6_secondary_addresses | default([]) | length }}    msg=ipv6 secondary addresses length
    {% for sec_addr in eit.ipv6_secondary_addresses | default([]) %}
    ${sec_addr_vt}=   Get Value From Json   ${r_id.json()}    $..ipv6.["secondary-address"].vipValue[{{ loop.index0 }}]..vipType
    IF  "${sec_addr_vt}[0]" == "constant"
        ${sec_addr_vv}=   Get Value From Json   ${r_id.json()}    $..ipv6.["secondary-address"].vipValue[{{ loop.index0 }}]..vipValue
    ELSE IF  "${sec_addr_vt}[0]" == "variableName"
        ${sec_addr_vv}=   Get Value From Json   ${r_id.json()}    $..ipv6.["secondary-address"].vipValue[{{ loop.index0 }}]..vipVariableName
    ELSE
        ${sec_addr_vv}=   Set Variable    []
    END
    Should Be Equal As Strings    ${sec_addr_vv[0]}    {{ sec_addr.address_variable | default(sec_addr.address | default("not_defined")) }}    msg=ipv6 secondary address
    {% endfor %}

    Should be Equal Value Json List Length    ${r_id.json()}    $.nat66.static-nat66.vipValue    {{ eit.ipv6_static_nat_rules | default([]) | length }}    msg=ipv6 static nat rules length
    {% for static_nat in eit.ipv6_static_nat_rules | default([]) %}
    Should Be Equal Value Json String FT  ${r_id.json()}    $.nat66.static-nat66.vipValue[{{ loop.index0 }}].source-prefix    {{ static_nat.source_prefix_variable | default(static_nat.source_prefix | default("not_defined")) }}    msg=static nat source prefix
    Should Be Equal Value Json String FT  ${r_id.json()}    $.nat66.static-nat66.vipValue[{{ loop.index0 }}].translated-source-prefix    {{ static_nat.translated_source_prefix_variable | default(static_nat.translated_source_prefix | default("not_defined")) }}    msg=static nat translated source prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.nat66.static-nat66.vipValue[{{ loop.index0 }}].vipOptional    {{ static_nat.optional | default("not_defined") }}    msg=static nat optional
    Should Be Equal Value Json String FT  ${r_id.json()}    $.nat66.static-nat66.vipValue[{{ loop.index0 }}].source-vpn-id    {{ static_nat.source_vpn_id_variable | default(static_nat.source_vpn_id | default("not_defined")) }}    msg=static nat source vpn id
    {% endfor %}

    Should be Equal Value Json List Length    ${r_id.json()}    $.ipv6-vrrp.vipValue    {{ eit.ipv6_vrrp_groups | default([]) | length }}    msg=ipv6 vrrp groups length
    {% for vrrp_group in eit.ipv6_vrrp_groups | default([]) %}
    Should Be Equal Value Json String FT    ${r_id.json()}    $.ipv6-vrrp.vipValue[{{ loop.index0 }}].grp-id    {{ vrrp_group.id_variable | default(vrrp_group.id | default("not_defined")) }}    msg=ipv6 vrrp groups id
    Should Be Equal Value Json String FT    ${r_id.json()}    $.ipv6-vrrp.vipValue[{{ loop.index0 }}].priority    {{ vrrp_group.priority_variable | default(vrrp_group.priority | default("not_defined")) }}    msg=ipv6 vrrp groups priority
    Should Be Equal Value Json String FT    ${r_id.json()}    $.ipv6-vrrp.vipValue[{{ loop.index0 }}].timer    {{ vrrp_group.timer_variable | default(vrrp_group.timer | default("not_defined")) }}    msg=ipv6 vrrp groups timer
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6-vrrp.vipValue[{{ loop.index0 }}].vipOptional    {{ vrrp_group.optional | default("not_defined") }}    msg=ipv6 vrrp groups optional
    Should Be Equal Value Json String FT    ${r_id.json()}    $.ipv6-vrrp.vipValue[{{ loop.index0 }}].track-prefix-list    {{ vrrp_group.track_prefix_list_variable | default(vrrp_group.track_prefix_list | default("not_defined")) }}    msg=ipv6 vrrp groups track prefix list
    Should Be Equal Value Json String FT    ${r_id.json()}    $.ipv6-vrrp.vipValue[{{ loop.index0 }}].track-omp    {{ vrrp_group.track_omp_variable | default(vrrp_group.track_omp | default("not_defined")) | lower() }}    msg=ipv6 vrrp groups track omp
    Should be Equal Value Json String FT    ${r_id.json()}    $.ipv6-vrrp.vipValue[{{ loop.index0 }}].ipv6..["ipv6-link-local"]    {{ vrrp_group.link_local_address_variable | default(vrrp_group.link_local_address | default("not_defined")) }}    msg=ipv6 vrrp groups link local address
    Should be Equal Value Json String FT    ${r_id.json()}    $.ipv6-vrrp.vipValue[{{ loop.index0 }}].ipv6..["prefix"]    {{ vrrp_group.global_prefix_variable | default(vrrp_group.global_prefix | default("not_defined")) }}    msg=ipv6 vrrp groups global prefix
    {% endfor %}

    Should Be Equal Value Json String FT    ${r_id.json()}    $.load-interval    {{ eit.load_interval_variable | default(eit.load_interval | default("not_defined")) }}    msg=load interval
    Should Be Equal Value Json String FT    ${r_id.json()}    $.mac-address    {{ eit.mac_address_variable | default(eit.mac_address | default("not_defined")) }}    msg=mac address
    Should Be Equal Value Json String FT    ${r_id.json()}    $.media-type    {{ eit.media_type_variable | default(eit.media_type | default("not_defined")) }}    msg=media type
    Should Be Equal Value Json String FT    ${r_id.json()}    $.intrf-mtu    {{ eit.mtu_variable | default(eit.mtu | default("not_defined")) }}    msg=mtu
    Should Be Equal Value Json String FT    ${r_id.json()}    $.rewrite-rule.rule-name    {{ eit.rewrite_rule_variable | default(eit.rewrite_rule | default("not_defined")) }}    msg=rewrite rule
    Should Be Equal Value Json String FT    ${r_id.json()}    $.shaping-rate    {{ eit.shaping_rate_variable | default(eit.shaping_rate | default("not_defined")) }}    msg=shaping rate
    Should Be Equal Value Json String FT    ${r_id.json()}    $.shutdown    {{ eit.shutdown_variable | default(eit.shutdown | default("not_defined") | lower()) }}    msg=shutdown

    Should be Equal Value Json List Length    ${r_id.json()}    $.arp.ip.vipValue    {{ eit.static_arps | default([]) | length }}    msg=static arps length
    {% for static_arp in eit.static_arps | default([]) %}
    Should Be Equal Value Json String FT    ${r_id.json()}    $.arp.ip.vipValue[{{ loop.index0 }}].mac    {{ static_arp.mac_address_variable | default(static_arp.mac_address | default("not_defined")) }}    msg=static arp mac address
    Should Be Equal Value Json String FT    ${r_id.json()}    $.arp.ip.vipValue[{{ loop.index0 }}].addr    {{ static_arp.ip_address_variable | default(static_arp.ip_address | default("not_defined")) }}    msg=static arp ip address
    Should Be Equal Value Json String    ${r_id.json()}    $.arp.ip.vipValue[{{ loop.index0 }}].vipOptional    {{ static_arp.optional | default("not_defined") }}    msg=static arp optional
    {% endfor %}

    Should Be Equal Value Json String FT    ${r_id.json()}    $.trustsec.static.sgt    {{ eit.static_sgt_variable | default(eit.static_sgt | default("not_defined")) }}    msg=static sgt
    Should Be Equal Value Json String FT    ${r_id.json()}    $.trustsec.enforcement.enable    {{ eit.sgt_enforcement | default("not_defined") | lower() }}    msg=sgt enforcement
    Should Be Equal Value Json String FT    ${r_id.json()}    $.trustsec.enforcement.sgt    {{ eit.sgt_enforcement_tag_variable | default(eit.sgt_enforcement_tag | default("not_defined")) }}    msg=sgt enforcement tag
    Should Be Equal Value Json String FT    ${r_id.json()}    $.trustsec.propagate.sgt    {{ eit.sgt_propagation | default("not_defined") | lower() }}    msg=sgt propagation
    Should Be Equal Value Json String FT    ${r_id.json()}    $.trustsec.static.trusted    {{ eit.sgt_trusted | default("not_defined") | lower() }}    msg=sgt trusted

    Should Be Equal Value Json String FT    ${r_id.json()}    $.speed    {{ eit.speed_variable | default(eit.speed | default("not_defined")) }}    msg=speed
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tcp-mss-adjust    {{ eit.tcp_mss_variable | default(eit.tcp_mss | default("not_defined")) }}    msg=tcp mss
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tloc-extension    {{ eit.tloc_extension_variable | default(eit.tloc_extension | default("not_defined")) }}    msg=tloc extension

    ${rec_tracker_viptype}=    Get Value From Json    ${r_id.json()}    $.["tracker"].vipType
    IF    ${rec_tracker_viptype} != []
       ${rec_tracker}=    Get Value From Json    ${r_id.json()}    $.["tracker"].vipValue
       ${rec_tracker_variable}=    Get Value From Json    ${r_id.json()}    $.["tracker"].vipVariableName
       IF    "${rec_tracker_viptype}[0]"=="constant"
            Should Be Equal As Strings    ${rec_tracker[0][0]}    {{ eit.tracker | default("not_defined") }}    msg=tracker
       ELSE IF    "${rec_tracker_viptype}[0]"=="variableName"
            Should Be Equal As Strings    ${rec_tracker_variable[0]}    {{ eit.tracker_variable | default("not_defined") }}    msg=tracker variable
       ELSE
            Should Be Equal As Strings    not_defined    {{ eit.tracker_variable | default(eit.tracker | default("not_defined")) }}    msg=tracker
       END
    ELSE
       Should Be Equal As Strings    not_defined    {{ eit.tracker_variable | default(eit.tracker | default("not_defined")) }}    msg=tracker
    END


    Should Be Equal Value Json String FT    ${r_id.json()}    $.qos-map    {{ eit.qos_map_variable | default(eit.qos_map | default("not_defined")) }}    msg=qos map
    Should Be Equal Value Json String FT    ${r_id.json()}    $.qos-map-vpn    {{ eit.vpn_qos_map_variable | default(eit.vpn_qos_map | default("not_defined")) }}    msg=vpn qos map
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].all    {{ eit.tunnel_interface.allow_service_all_variable | default(eit.tunnel_interface.allow_service_all | default("not_defined") | lower()) }}    msg=tunnel interface allow service all
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].bgp    {{ eit.tunnel_interface.allow_service_bgp_variable | default(eit.tunnel_interface.allow_service_bgp | default("not_defined") | lower()) }}    msg=unnel interface allow service bgp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].dhcp    {{ eit.tunnel_interface.allow_service_dhcp_variable | default(eit.tunnel_interface.allow_service_dhcp | default("not_defined") | lower()) }}    msg=tunnel interface allow service dhcp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].dns    {{ eit.tunnel_interface.allow_service_dns_variable | default(eit.tunnel_interface.allow_service_dns | default("not_defined") | lower()) }}    msg=tunnel interface allow service dns
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].https    {{ eit.tunnel_interface.allow_service_https_variable | default(eit.tunnel_interface.allow_service_https | default("not_defined") | lower()) }}    msg=tunnel interface allow service https
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].icmp    {{ eit.tunnel_interface.allow_service_icmp_variable | default(eit.tunnel_interface.allow_service_icmp | default("not_defined") | lower()) }}    msg=tunnel interface allow service icmp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].netconf    {{ eit.tunnel_interface.allow_service_netconf_variable | default(eit.tunnel_interface.allow_service_netconf | default("not_defined") | lower()) }}    msg=tunnel interface allow service netconf
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].ntp    {{ eit.tunnel_interface.allow_service_ntp_variable | default(eit.tunnel_interface.allow_service_ntp | default("not_defined") | lower()) }}    msg=tunnel interface allow service ntp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].ospf    {{ eit.tunnel_interface.allow_service_ospf_variable | default(eit.tunnel_interface.allow_service_ospf | default("not_defined") | lower()) }}    msg=tunnel interface allow service ospf
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].snmp    {{ eit.tunnel_interface.allow_service_snmp_variable | default(eit.tunnel_interface.allow_service_snmp | default("not_defined") | lower()) }}    msg=tunnel interface allow service snmp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].sshd    {{ eit.tunnel_interface.allow_service_ssh_variable | default(eit.tunnel_interface.allow_service_ssh | default("not_defined") | lower()) }}    msg=tunnel interface allow service ssh
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].stun    {{ eit.tunnel_interface.allow_service_stun_variable | default(eit.tunnel_interface.allow_service_stun | default("not_defined") | lower()) }}    msg=tunnel interface allow service stun
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.bind    {{ eit.tunnel_interface.bind_loopback_tunnel_variable | default(eit.tunnel_interface.bind_loopback_tunnel | default("not_defined")) }}    msg=tunnel interface bind loopback tunnel
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.border    {{ eit.tunnel_interface.border_variable | default(eit.tunnel_interface.border | default("not_defined") | lower()) }}    msg=tunnel interface border
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.carrier    {{ eit.tunnel_interface.carrier_variable | default(eit.tunnel_interface.carrier | default("not_defined")) }}    msg=tunnel interface carrier
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["clear-dont-fragment"]    {{ eit.tunnel_interface.clear_dont_fragment_variable | default(eit.tunnel_interface.clear_dont_fragment | default("not_defined") | lower()) }}    msg=tunnel interface clear dont fragment
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.color.value    {{ eit.tunnel_interface.color_variable | default(eit.tunnel_interface.color | default("not_defined")) }}    msg=tunnel interface color
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["core-region"]    {{ eit.tunnel_interface.core_region_variable | default(eit.tunnel_interface.core_region | default("not_defined")) }}    msg=tunnel interface core region
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["enable-core-region"]    {{ eit.tunnel_interface.enable_core_region_variable | default(eit.tunnel_interface.enable_core_region | default("not_defined") | lower()) }}    msg=tunnel interface enable core region

    ${rec_exc_cnt_grp_viptype}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipType
    IF    ${rec_exc_cnt_grp_viptype} != []
        ${rec_exc_cnt_grp}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipValue
        ${rec_exc_cnt_grp_variable}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipVariableName
        IF    "${rec_exc_cnt_grp_viptype}[0]"=="constant"
            Should Be Equal Value Json List Length    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipValue    {{ eit.tunnel_interface.exclude_controller_groups | default([]) | length }}    msg=tunnel interface exclude controller groups length
            {% for group in eit.tunnel_interface.exclude_controller_groups | default([]) %}
            Should Be Equal Value Json String    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipValue[?(@ == {{ group }})]    {{ group }}    msg=tunnel interface exclude controller groups
            {% endfor %}
        ELSE IF    "${rec_exc_cnt_grp_viptype}[0]"=="variableName"
            Should Be Equal As Strings    ${rec_exc_cnt_grp_variable[0]}    {{ eit.tunnel_interface.exclude_controller_groups_variable | default("not_defined") }}    msg=tunnel interface exclude controller groups variable
        ELSE
            Should Be Equal As Strings    not_defined    {{ eit.tunnel_interface.exclude_controller_groups_variable | default(eit.tunnel_interface.exclude_controller_groups | default("not_defined")) }}    msg=tunnel interface exclude controller groups
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ eit.tunnel_interface.exclude_controller_groups_variable | default(eit.tunnel_interface.exclude_controller_groups | default("not_defined")) }}    msg=exclude controller groups
    END

    ${rec_tun_grencap_viptype}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "gre")].encap.vipType
    IF    ${rec_tun_grencap_viptype} != []
        ${rec_tun_grencap}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "gre")].encap.vipValue
        IF    "${rec_tun_grencap_viptype}[0]"=="constant"
            ${gre_encap}=    Set Variable If     "${rec_tun_grencap}[0]" == "gre"    true    not_defined
            Should Be Equal As Strings    ${gre_encap}    {{ eit.tunnel_interface.gre_encapsulation | default("not_defined") | lower() }}    msg=tunnel interface gre encapsulation
        ELSE
            Should Be Equal As Strings    not_defined    {{ eit.tunnel_interface.gre_encapsulation | default("not_defined") }}    msg=tunnel interface gre encapsulation
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ eit.tunnel_interface.gre_encapsulation | default("not_defined") }}    msg=tunnel interface gre encapsulation
    END

    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "gre")].preference    {{ eit.tunnel_interface.gre_preference_variable | default(eit.tunnel_interface.gre_preference | default("not_defined")) }}    msg=tunnel interface gre preference
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "gre")].weight    {{ eit.tunnel_interface.gre_weight_variable | default(eit.tunnel_interface.gre_weight | default("not_defined")) }}    msg=tunnel interface gre weight

    ${rec_tun_int_grp_viptype}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.group.vipType
    IF    ${rec_tun_int_grp_viptype} != []
        ${rec_tun_int_grp}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.group.vipValue
        ${rec_tun_int_grp_variable}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.group.vipVariableName
        IF    "${rec_tun_int_grp_viptype}[0]"=="constant"
            Should Be Equal As Strings    ${rec_tun_int_grp[0][0]}    {{ eit.tunnel_interface.group |default("not_defined") }}    msg=tunnel interface group
        ELSE IF    "${rec_tun_int_grp_viptype}[0]"=="variableName"
            Should Be Equal As Strings    ${rec_tun_int_grp_variable[0]}    {{ eit.tunnel_interface.group_variable | default("not_defined") }}    msg=tunnel interface group variable
        ELSE
            Should Be Equal As Strings    not_defined    {{ eit.tunnel_interface.group_variable | default(eit.tunnel_interface.group | default("not_defined")) }}    msg=tunnel interface group
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ eit.tunnel_interface.group_variable | default(eit.tunnel_interface.group | default("not_defined")) }}    msg=tunnel interface group
    END

    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["hello-interval"]    {{ eit.tunnel_interface.hello_interval_variable | default(eit.tunnel_interface.hello_interval | default("not_defined")) }}    msg=tunnel interface hello interval
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["hello-tolerance"]    {{ eit.tunnel_interface.hello_tolerance_variable | default(eit.tunnel_interface.hello_tolerance | default("not_defined")) }}    msg=tunnel interface hello tolerance

    ${rec_tun_ipsecencap_viptype}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "ipsec")].encap.vipType
    IF    ${rec_tun_ipsecencap_viptype} != []
        ${rec_tun_ipsecencap}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "ipsec")].encap.vipValue
        IF    "${rec_tun_ipsecencap_viptype}[0]"=="constant"
            ${ipsec_encap}=    Set Variable If     "${rec_tun_ipsecencap}[0]" == "ipsec"    true    not_defined
            Should Be Equal As Strings    ${ipsec_encap}    {{ eit.tunnel_interface.ipsec_encapsulation | default("not_defined") | lower() }}    msg=tunnel interface ipsec encapsulation
        ELSE
            Should Be Equal As Strings    not_defined    {{ eit.tunnel_interface.ipsec_encapsulation | default("not_defined") }}    msg=tunnel interface ipsec encapsulation
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ eit.tunnel_interface.ipsec_encapsulation | default("not_defined") }}    msg=tunnel interface ipsec encapsulation
    END

    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "ipsec")].preference    {{ eit.tunnel_interface.ipsec_preference_variable | default(eit.tunnel_interface.ipsec_preference | default("not_defined")) }}    msg=tunnel interface ipsec preference
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "ipsec")].weight    {{ eit.tunnel_interface.ipsec_weight_variable | default(eit.tunnel_interface.ipsec_weight | default("not_defined")) }}    msg=tunnel interface ipsec weight
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["last-resort-circuit"]    {{ eit.tunnel_interface.last_resort_circuit_variable | default(eit.tunnel_interface.last_resort_circuit | default("not_defined") | lower()) }}    msg=tunnel interface last resort circuit
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["low-bandwidth-link"]    {{ eit.tunnel_interface.low_bandwidth_link_variable | default(eit.tunnel_interface.low_bandwidth_link | default("not_defined") | lower()) }}    msg=tunnel interface low bandwidth link
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["max-control-connections"]    {{ eit.tunnel_interface.max_control_connections_variable | default(eit.tunnel_interface.max_control_connections | default("not_defined")) }}    msg=tunnel interface max control connections
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["nat-refresh-interval"]    {{ eit.tunnel_interface.nat_refresh_interval_variable | default(eit.tunnel_interface.nat_refresh_interval | default("not_defined")) }}    msg=tunnel interface nat refresh interval
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["network-broadcast"]    {{ eit.tunnel_interface.network_broadcast_variable | default(eit.tunnel_interface.network_broadcast | default("not_defined") | lower()) }}    msg=tunnel interface network broadcast
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["port-hop"]    {{ eit.tunnel_interface.port_hop_variable | default(eit.tunnel_interface.port_hop | default("not_defined") | lower()) }}    msg=tunnel interface port hop
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["tunnel-tcp-mss-adjust"]    {{ eit.tunnel_interface.tcp_mss_variable | default(eit.tunnel_interface.tcp_mss | default("not_defined")) }}    msg=tunnel interface tcp mss
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["tunnel-qos"].mode    {{ eit.tunnel_interface.per_tunnel_qos_mode_variable | default(eit.tunnel_interface.per_tunnel_qos_mode | default("not_defined")) }}    msg=tunnel interface per tunnel qos mode
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.color.restrict    {{ eit.tunnel_interface.restrict_variable | default(eit.tunnel_interface.restrict | default("not_defined") | lower()) }}    msg=tunnel interface restrict
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["secondary-region"]    {{ eit.tunnel_interface.secondary_region_variable | default(eit.tunnel_interface.secondary_region | default("not_defined")) }}    msg=tunnel interface secondary region
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["vbond-as-stun-server"]    {{ eit.tunnel_interface.vbond_as_stun_server_variable | default(eit.tunnel_interface.vbond_as_stun_server | default("not_defined") | lower()) }}    msg=tunnel interface vbond as stun server
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["vmanage-connection-preference"]    {{ eit.tunnel_interface.vmanage_connection_preference_variable | default(eit.tunnel_interface.vmanage_connection_preference | default("not_defined")) }}    msg=tunnel interface vmanage connection preference
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["tunnels-bandwidth"]    {{ eit.tunnel_interface.per_tunnel_qos_bandwidth_percent_variable | default(eit.tunnel_interface.per_tunnel_qos_bandwidth_percent | default("not_defined")) }}    msg=tunnel interface per tunnel qos bandwidth percent
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["propagate-sgt"]    {{ eit.tunnel_interface.propagate_sgt_variable | default(eit.tunnel_interface.propagate_sgt | default("not_defined") | lower()) }}    msg=tunnel interface propagate sgt

{% endfor %}
{% endif %}