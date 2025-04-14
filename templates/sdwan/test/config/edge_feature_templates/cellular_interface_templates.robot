*** Settings ***
Documentation   Verify Cellular Interface Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.cellular_interface_templates is defined %}

*** Test Cases ***
Get Cellular Interface Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="vpn-cedge-interface-cellular")]
    Set Suite Variable    ${r}

{% for cellular in sdwan.edge_feature_templates.cellular_interface_templates | default([]) %}

Verify Edge Feature Template Cellular Interface Feature template {{ cellular.name }}
    ${cellular_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{cellular.name }}")]
    Should Be Equal Value Json String    ${cellular_id}    $..templateName    {{ cellular.name }}    msg=name
    Should Be Equal Value Json Special_String    ${cellular_id}    $..templateDescription    {{ cellular.description | normalize_special_string }}    msg=description

    {% set dt_list_local = [] %}
    {% for item in cellular.device_types | default(defaults.sdwan.edge_feature_templates.cellular_interface_templates.device_types) %}
    {% set test = "vedge-" ~ item %}
    {% set _ = dt_list_local.append(test) %}
    {% endfor %}

    ${dt_list_remote}=    Get Value From Json    ${cellular_id}    $..deviceType
    ${dt_list_local}=    Create List    {{ dt_list_local | join('   ') }}
    Lists Should Be Equal    ${dt_list_remote[0]}    ${dt_list_local}    ignore_order=True    msg=device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{cellular.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["if-name"]    {{ cellular.interface_name_variable | default( cellular.interface_name | default("not_defined") ) }}    msg=interface name
    Should Be Equal Value Json String FT    ${r_id.json()}    $..description    {{ cellular.interface_description_variable | default( cellular.interface_description | default("not_defined") ) }}    msg=interface description
    Should Be Equal Value Json String FT    ${r_id.json()}    $..shutdown    {{ cellular.shutdown_variable | default( cellular.shutdown | default("not_defined") | lower() )}}    msg=shutdown
    
    ${rec_ipv4_dhcp_helpers_viptype}=    Get Value From Json    ${r_id.json()}    $["dhcp-helper"].vipType
    IF    ${rec_ipv4_dhcp_helpers_viptype} != []
        ${rec_ipv4_dhcp_helpers}=    Get Value From Json    ${r_id.json()}    $["dhcp-helper"].vipValue
        ${rec_ipv4_dhcp_helpers_variable}=    Get Value From Json    ${r_id.json()}    $["dhcp-helper"].vipVariableName
        ${exp_ipv4_dhcp_helpers_list}=    Create List    {{ cellular.dhcp_helpers | default("not_defined") | join('   ')}}
        IF    "${rec_ipv4_dhcp_helpers_viptype}[0]"=="constant"
            Lists Should Be Equal    ${rec_ipv4_dhcp_helpers[0]}    ${exp_ipv4_dhcp_helpers_list}    ignore_order=True    msg=dhcp helpers
        ELSE IF    "${rec_ipv4_dhcp_helpers_viptype}[0]"=="variableName"
            Should Be Equal As Strings    ${rec_ipv4_dhcp_helpers_variable[0]}    {{ cellular.dhcp_helpers_variable | default("not_defined") }}    msg=dhcp helpers variable
        ELSE
            Should Be Equal As Strings    not_defined    {{ cellular.dhcp_helpers_variable | default(cellular.dhcp_helpers | default("not_defined")) }}    msg=dhcp helpers
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ cellular.dhcp_helpers_variable | default(cellular.dhcp_helpers | default("not_defined")) }}    msg=dhcp helpers
    END

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["bandwidth-downstream"]    {{ cellular.bandwidth_downstream_variable | default(cellular.bandwidth_downstream | default("not_defined")) }}    msg=bandwidth downstream
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["bandwidth-upstream"]    {{ cellular.bandwidth_upstream_variable | default(cellular.bandwidth_upstream | default("not_defined")) }}    msg=bandwidth upstream
    Should Be Equal Value Json String FT    ${r_id.json()}    $..mtu    {{ cellular.ip_mtu_variable | default(cellular.ip_mtu | default("not_defined")) }}    msg=ip mtu

    ${rec_nat}=    Get Value From Json    ${r_id.json()}    $..nat..vipType
    ${rec_nat}=    Set Variable If    ${rec_nat} == []    not_defined    True
    Should Be Equal As Strings    ${rec_nat}    {{ cellular.nat | default("not_defined") }}    msg=nat

    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.refresh    {{ cellular.nat_refresh_mode_variable | default(cellular.nat_refresh_mode | default("not_defined")) }}    msg=nat refresh mode
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.["tcp-timeout"]    {{ cellular.nat_tcp_timeout_variable | default(cellular.nat_tcp_timeout | default("not_defined")) }}    msg=nat tcp timeout
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.["udp-timeout"]    {{ cellular.nat_udp_timeout_variable | default(cellular.nat_udp_timeout | default("not_defined")) }}    msg=nat udp timeout
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.["block-icmp-error"]    {{ cellular.nat_block_icmp_variable | default(cellular.nat_block_icmp | default("not_defined") | lower()) }}    msg=nat block icmp
    Should Be Equal Value Json String FT    ${r_id.json()}    $..nat.["respond-to-ping"]    {{ cellular.nat_respond_to_ping_variable | default(cellular.nat_respond_to_ping | default("not_defined") | lower()) }}    msg=nat respond to ping

    Should Be Equal Value Json List Length    ${r_id.json()}    $.nat..["port-forward"].vipValue    {{ cellular.nat_port_forwarding_rules | default([]) | length }}    msg=nat port forwarding rules length
    {% for port_fw in cellular.nat_port_forwarding_rules | default([]) %}
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["port-start"]    {{ port_fw.port_range_start_variable | default(port_fw.port_range_start | default("not_defined")) }}    msg=port fw port range start
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["port-end"]    {{ port_fw.port_range_end_variable | default(port_fw.port_range_end | default("not_defined")) }}    msg=port fw port range end
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}].proto    {{ port_fw.protocol | default("not_defined") }}    msg=port fw protocol
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["private-vpn"]    {{ port_fw.vpn_variable | default(port_fw.vpn | default("not_defined")) }}    msg=port fw vpn
    Should Be Equal Value Json String FT    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["private-ip-address"]    {{ port_fw.private_ip_variable | default(port_fw.private_ip | default("not_defined")) }}    msg=port fw private ip
    {% endfor %}

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].period    {{ cellular.adaptive_qos_period_variable | default(cellular.adaptive_qos_period | default("not_defined")) }}    msg=adaptive qos period
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].downstream.["bandwidth-down"]    {{ cellular.adaptive_qos_shaping_rate_downstream.default_variable | default(cellular.adaptive_qos_shaping_rate_downstream.default | default("not_defined")) }}    msg=adaptive qos shaping rate downstream default
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].downstream.range.dmax    {{ cellular.adaptive_qos_shaping_rate_downstream.maximum_variable | default(cellular.adaptive_qos_shaping_rate_downstream.maximum | default("not_defined")) }}    msg=adaptive qos shaping rate downstream maximum
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].downstream.range.dmin    {{ cellular.adaptive_qos_shaping_rate_downstream.minimum_variable | default(cellular.adaptive_qos_shaping_rate_downstream.minimum | default("not_defined")) }}    msg=adaptive qos shaping rate downstream minimum
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].upstream.["bandwidth-up"]    {{ cellular.adaptive_qos_shaping_rate_upstream.default_variable | default(cellular.adaptive_qos_shaping_rate_upstream.default | default("not_defined")) }}    msg=adaptive qos shaping rate upstream default
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].upstream.range.umax    {{ cellular.adaptive_qos_shaping_rate_upstream.maximum_variable | default(cellular.adaptive_qos_shaping_rate_upstream.maximum | default("not_defined")) }}    msg=adaptive qos shaping rate upstream maximum
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-adaptive"].upstream.range.umin    {{ cellular.adaptive_qos_shaping_rate_upstream.minimum_variable | default(cellular.adaptive_qos_shaping_rate_upstream.minimum | default("not_defined")) }}    msg=adaptive qos shaping rate upstream minimum
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["shaping-rate"]    {{ cellular.shaping_rate_variable | default(cellular.shaping_rate | default("not_defined")) }}    msg=shaping rate
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-map"]    {{ cellular.qos_map_variable | default(cellular.qos_map | default("not_defined")) }}    msg=qos map
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["qos-map-vpn"]    {{ cellular.vpn_qos_map_variable | default(cellular.vpn_qos_map | default("not_defined")) }}    msg=vpn qos map
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["rewrite-rule"].["rule-name"]    {{ cellular.rewrite_rule_variable | default(cellular.rewrite_rule | default("not_defined")) }}    msg=rewrite rule
    Should Be Equal Value Json String FT   ${r_id.json()}    $["access-list"].vipValue[?(@.direction.vipValue=="out")]..["acl-name"]    {{ cellular.ipv4_egress_access_list_variable | default(cellular.ipv4_egress_access_list | default("not_defined")) }}    msg=ipv4 egress access list
    Should Be Equal Value Json String FT   ${r_id.json()}    $["access-list"].vipValue[?(@.direction.vipValue=="in")]..["acl-name"]    {{ cellular.ipv4_ingress_access_list_variable | default(cellular.ipv4_ingress_access_list | default("not_defined")) }}    msg=ipv4 ingress access list
    Should Be Equal Value Json String FT   ${r_id.json()}    $.ipv6.["access-list"].vipValue[?(@.direction.vipValue=="out")]..["acl-name"]    {{ cellular.ipv6_egress_access_list_variable | default(cellular.ipv6_egress_access_list | default("not_defined")) }}    msg=ipv6 egress access list
    Should Be Equal Value Json String FT   ${r_id.json()}    $.ipv6.["access-list"].vipValue[?(@.direction.vipValue=="in")]..["acl-name"]    {{ cellular.ipv6_ingress_access_list_variable | default(cellular.ipv6_ingress_access_list | default("not_defined")) }}    msg=ipv6 ingress access list
    Should Be Equal Value Json String FT   ${r_id.json()}    $.policer.vipValue[?(@.direction.vipValue=="in")]..["policer-name"]    {{ cellular.ingress_policer_name | default("not_defined")}}    msg=ingress policer name
    Should Be Equal Value Json String FT   ${r_id.json()}    $.policer.vipValue[?(@.direction.vipValue=="out")]..["policer-name"]    {{ cellular.egress_policer_name | default("not_defined")}}    msg=egress policer name
    
    Should Be Equal Value Json List Length    ${r_id.json()}    $.arp.ip.vipValue    {{ cellular.static_arps | default([]) | length }}    msg=static arp entries length
    {% for static_arp in cellular.static_arps | default([]) %}
    Should Be Equal Value Json String FT    ${r_id.json()}    $.arp.ip.vipValue[{{ loop.index0 }}]["addr"]    {{ static_arp.ip_address_variable | default(static_arp.ip_address | default("not_defined")) }}    msg=static arp ip address
    Should Be Equal Value Json String FT    ${r_id.json()}    $.arp.ip.vipValue[{{ loop.index0 }}]["mac"]    {{ static_arp.mac_address_variable | default(static_arp.mac_address | default("not_defined")) }}    msg=static arp mac address
    Should Be Equal Value Json String    ${r_id.json()}    $.arp.ip.vipValue[{{ loop.index0 }}]["vipOptional"]    {{ static_arp.optional | default("not_defined") }}    msg=static arp optional
    {% endfor %}

    Should Be Equal Value Json String FT    ${r_id.json()}    $.pmtu    {{ cellular.path_mtu_discovery_variable | default(cellular.path_mtu_discovery | default("not_defined") | lower()) }}    msg=path mtu discovery
    Should Be Equal Value Json String FT    ${r_id.json()}    $.["tcp-mss-adjust"]    {{ cellular.tcp_mss_variable | default(cellular.tcp_mss | default("not_defined")) }}    msg=tcp mss
    Should Be Equal Value Json String FT    ${r_id.json()}    $.["clear-dont-fragment"]    {{ cellular.clear_dont_fragment_variable | default(cellular.clear_dont_fragment | default("not_defined") | lower()) }}    msg=clear dont fragment
    Should Be Equal Value Json String FT    ${r_id.json()}    $.["static-ingress-qos"]    {{ cellular.static_ingress_qos_variable | default(cellular.static_ingress_qos | default("not_defined")) }}    msg=static ingress qos
    Should Be Equal Value Json String FT    ${r_id.json()}    $.["autonegotiate"]    {{ cellular.autonegotiate_variable | default(cellular.autonegotiate | default("not_defined") | lower()) }}    msg=autonegotiate
    Should Be Equal Value Json String FT    ${r_id.json()}    $.["tloc-extension"]    {{ cellular.tloc_extension_variable | default(cellular.tloc_extension | default("not_defined")) }}    msg=tloc extension
    
    ${rec_tracker_viptype}=    Get Value From Json    ${r_id.json()}    $.["tracker"].vipType
    IF    ${rec_tracker_viptype} != []
       ${rec_tracker}=    Get Value From Json    ${r_id.json()}    $.["tracker"].vipValue
       ${rec_tracker_variable}=    Get Value From Json    ${r_id.json()}    $.["tracker"].vipVariableName
       IF    "${rec_tracker_viptype}[0]"=="constant"
            Should Be Equal As Strings    ${rec_tracker[0][0]}    {{ cellular.tracker | default("not_defined") }}    msg=tracker
       ELSE IF    "${rec_tracker_viptype}[0]"=="variableName"
            Should Be Equal As Strings    ${rec_tracker_variable[0]}    {{ cellular.tracker_variable | default("not_defined") }}    msg=tracker variable
       ELSE
            Should Be Equal As Strings    not_defined    {{ cellular.tracker_variable | default(cellular.tracker | default("not_defined")) }}    msg=tracker
       END
    ELSE
       Should Be Equal As Strings    not_defined    {{ cellular.tracker_variable | default(cellular.tracker | default("not_defined")) }}    msg=tracker
    END

    Should Be Equal Value Json String FT    ${r_id.json()}    $.["ip-directed-broadcast"]    {{ cellular.ip_directed_broadcast_variable | default(cellular.ip_directed_broadcast | default("not_defined") | lower()) }}    msg=ip directed broadcast

    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].all    {{ cellular.tunnel_interface.allow_service_all_variable | default(cellular.tunnel_interface.allow_service_all | default("not_defined") | lower()) }}    msg=tunnel interface allow service all
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].bgp    {{ cellular.tunnel_interface.allow_service_bgp_variable | default(cellular.tunnel_interface.allow_service_bgp | default("not_defined") | lower()) }}    msg=unnel interface allow service bgp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].dhcp    {{ cellular.tunnel_interface.allow_service_dhcp_variable | default(cellular.tunnel_interface.allow_service_dhcp | default("not_defined") | lower()) }}    msg=tunnel interface allow service dhcp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].dns    {{ cellular.tunnel_interface.allow_service_dns_variable | default(cellular.tunnel_interface.allow_service_dns | default("not_defined") | lower()) }}    msg=tunnel interface allow service dns
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].https    {{ cellular.tunnel_interface.allow_service_https_variable | default(cellular.tunnel_interface.allow_service_https | default("not_defined") | lower()) }}    msg=tunnel interface allow service https
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].icmp    {{ cellular.tunnel_interface.allow_service_icmp_variable | default(cellular.tunnel_interface.allow_service_icmp | default("not_defined") | lower()) }}    msg=tunnel interface allow service icmp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].netconf    {{ cellular.tunnel_interface.allow_service_netconf_variable | default(cellular.tunnel_interface.allow_service_netconf | default("not_defined") | lower()) }}    msg=tunnel interface allow service netconf
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].ntp    {{ cellular.tunnel_interface.allow_service_ntp_variable | default(cellular.tunnel_interface.allow_service_ntp | default("not_defined") | lower()) }}    msg=tunnel interface allow service ntp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].ospf    {{ cellular.tunnel_interface.allow_service_ospf_variable | default(cellular.tunnel_interface.allow_service_ospf | default("not_defined") | lower()) }}    msg=tunnel interface allow service ospf
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].snmp    {{ cellular.tunnel_interface.allow_service_snmp_variable | default(cellular.tunnel_interface.allow_service_snmp | default("not_defined") | lower()) }}    msg=tunnel interface allow service snmp
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].sshd    {{ cellular.tunnel_interface.allow_service_ssh_variable | default(cellular.tunnel_interface.allow_service_ssh | default("not_defined") | lower()) }}    msg=tunnel interface allow service ssh
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["allow-service"].stun    {{ cellular.tunnel_interface.allow_service_stun_variable | default(cellular.tunnel_interface.allow_service_stun | default("not_defined") | lower()) }}    msg=tunnel interface allow service stun
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.bind    {{ cellular.tunnel_interface.bind_loopback_tunnel_variable | default(cellular.tunnel_interface.bind_loopback_tunnel | default("not_defined")) }}    msg=tunnel interface bind loopback tunnel
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.border    {{ cellular.tunnel_interface.border_variable | default(cellular.tunnel_interface.border | default("not_defined") | lower()) }}    msg=tunnel interface border
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.carrier    {{ cellular.tunnel_interface.carrier_variable | default(cellular.tunnel_interface.carrier | default("not_defined")) }}    msg=tunnel interface carrier
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["clear-dont-fragment"]    {{ cellular.tunnel_interface.clear_dont_fragment_variable | default(cellular.tunnel_interface.clear_dont_fragment | default("not_defined") | lower()) }}    msg=tunnel interface clear dont fragment
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.color.value    {{ cellular.tunnel_interface.color_variable | default(cellular.tunnel_interface.color | default("not_defined")) }}    msg=tunnel interface color
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["core-region"]    {{ cellular.tunnel_interface.core_region_variable | default(cellular.tunnel_interface.core_region | default("not_defined")) }}    msg=tunnel interface core region
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["enable-core-region"]    {{ cellular.tunnel_interface.enable_core_region_variable | default(cellular.tunnel_interface.enable_core_region | default("not_defined") | lower()) }}    msg=tunnel interface enable core region

    ${rec_exc_cnt_grp_viptype}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipType
    IF    ${rec_exc_cnt_grp_viptype} != []
        ${rec_exc_cnt_grp}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipValue
        ${rec_exc_cnt_grp_variable}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipVariableName
        IF    "${rec_exc_cnt_grp_viptype}[0]"=="constant"
            Should Be Equal Value Json List Length    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipValue    {{ cellular.tunnel_interface.exclude_controller_groups | default([]) | length }}    msg=tunnel interface exclude controller groups length
            {% for group in cellular.tunnel_interface.exclude_controller_groups | default([]) %}
            Should Be Equal Value Json String    ${r_id.json()}    $.tunnel-interface.["exclude-controller-group-list"].vipValue[?(@ == {{ group }})]    {{ group }}    msg=tunnel interface exclude controller groups
            {% endfor %}
        ELSE IF    "${rec_exc_cnt_grp_viptype}[0]"=="variableName"
            Should Be Equal As Strings    ${rec_exc_cnt_grp_variable[0]}    {{ cellular.tunnel_interface.exclude_controller_groups_variable | default("not_defined") }}    msg=tunnel interface exclude controller groups variable
        ELSE
            Should Be Equal As Strings    not_defined    {{ cellular.tunnel_interface.exclude_controller_groups_variable | default(cellular.tunnel_interface.exclude_controller_groups | default("not_defined")) }}    msg=tunnel interface exclude controller groups
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ cellular.tunnel_interface.exclude_controller_groups_variable | default(cellular.tunnel_interface.exclude_controller_groups | default("not_defined")) }}    msg=exclude controller groups
    END

    ${rec_tun_grencap_viptype}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "gre")].encap.vipType
    IF    ${rec_tun_grencap_viptype} != []
        ${rec_tun_grencap}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "gre")].encap.vipValue
        IF    "${rec_tun_grencap_viptype}[0]"=="constant"
            ${gre_encap}=    Set Variable If     "${rec_tun_grencap}[0]" == "gre"    true    not_defined
            Should Be Equal As Strings    ${gre_encap}    {{ cellular.tunnel_interface.gre_encapsulation | default("not_defined") | lower() }}    msg=tunnel interface gre encapsulation
        ELSE
            Should Be Equal As Strings    not_defined    {{ cellular.tunnel_interface.gre_encapsulation | default("not_defined") }}    msg=tunnel interface gre encapsulation
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ cellular.tunnel_interface.gre_encapsulation | default("not_defined") }}    msg=tunnel interface gre encapsulation
    END

    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "gre")].preference    {{ cellular.tunnel_interface.gre_preference_variable | default(cellular.tunnel_interface.gre_preference | default("not_defined")) }}    msg=tunnel interface gre preference
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "gre")].weight    {{ cellular.tunnel_interface.gre_weight_variable | default(cellular.tunnel_interface.gre_weight | default("not_defined")) }}    msg=tunnel interface gre weight

    ${rec_tun_int_grp_viptype}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.group.vipType
    IF    ${rec_tun_int_grp_viptype} != []
        ${rec_tun_int_grp}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.group.vipValue
        ${rec_tun_int_grp_variable}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.group.vipVariableName
        IF    "${rec_tun_int_grp_viptype}[0]"=="constant"
            Should Be Equal As Strings    ${rec_tun_int_grp[0]}    {{ [cellular.tunnel_interface.group]|default(["not_defined"]) }}    msg=tunnel interface group
        ELSE IF    "${rec_tun_int_grp_viptype}[0]"=="variableName"
            Should Be Equal As Strings    ${rec_tun_int_grp_variable[0]}    {{ cellular.tunnel_interface.group_variable | default("not_defined") }}    msg=tunnel interface group variable
        ELSE
            Should Be Equal As Strings    not_defined    {{ cellular.tunnel_interface.group_variable | default(cellular.tunnel_interface.group | default("not_defined")) }}    msg=tunnel interface group
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ cellular.tunnel_interface.group_variable | default(cellular.tunnel_interface.group | default("not_defined")) }}    msg=tunnel interface group
    END

    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["hello-interval"]    {{ cellular.tunnel_interface.hello_interval_variable | default(cellular.tunnel_interface.hello_interval | default("not_defined")) }}    msg=tunnel interface hello interval
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["hello-tolerance"]    {{ cellular.tunnel_interface.hello_tolerance_variable | default(cellular.tunnel_interface.hello_tolerance | default("not_defined")) }}    msg=tunnel interface hello tolerance


    ${rec_tun_ipsecencap_viptype}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "ipsec")].encap.vipType
    IF    ${rec_tun_ipsecencap_viptype} != []
        ${rec_tun_ipsecencap}=    Get Value From Json    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "ipsec")].encap.vipValue
        IF    "${rec_tun_ipsecencap_viptype}[0]"=="constant"
            ${ipsec_encap}=    Set Variable If     "${rec_tun_ipsecencap}[0]" == "ipsec"    true    not_defined
            Should Be Equal As Strings    ${ipsec_encap}    {{ cellular.tunnel_interface.ipsec_encapsulation | default("not_defined") | lower() }}    msg=tunnel interface ipsec encapsulation
        ELSE
            Should Be Equal As Strings    not_defined    {{ cellular.tunnel_interface.ipsec_encapsulation | default("not_defined") }}    msg=tunnel interface ipsec encapsulation
        END
    ELSE
        Should Be Equal As Strings    not_defined    {{ cellular.tunnel_interface.ipsec_encapsulation | default("not_defined") }}    msg=tunnel interface ipsec encapsulation
    END

    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "ipsec")].preference    {{ cellular.tunnel_interface.ipsec_preference_variable | default(cellular.tunnel_interface.ipsec_preference | default("not_defined")) }}    msg=tunnel interface ipsec preference
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.encapsulation.vipValue[?(@.encap.vipValue == "ipsec")].weight    {{ cellular.tunnel_interface.ipsec_weight_variable | default(cellular.tunnel_interface.ipsec_weight | default("not_defined")) }}    msg=tunnel interface ipsec weight
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["last-resort-circuit"]    {{ cellular.tunnel_interface.last_resort_circuit_variable | default(cellular.tunnel_interface.last_resort_circuit | default("not_defined") | lower()) }}    msg=tunnel interface last resort circuit
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["low-bandwidth-link"]    {{ cellular.tunnel_interface.low_bandwidth_link_variable | default(cellular.tunnel_interface.low_bandwidth_link | default("not_defined") | lower()) }}    msg=tunnel interface low bandwidth link
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["max-control-connections"]    {{ cellular.tunnel_interface.max_control_connections_variable | default(cellular.tunnel_interface.max_control_connections | default("not_defined")) }}    msg=tunnel interface max control connections
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["nat-refresh-interval"]    {{ cellular.tunnel_interface.nat_refresh_interval_variable | default(cellular.tunnel_interface.nat_refresh_interval | default("not_defined")) }}    msg=tunnel interface nat refresh interval
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["network-broadcast"]    {{ cellular.tunnel_interface.network_broadcast_variable | default(cellular.tunnel_interface.network_broadcast | default("not_defined") | lower()) }}    msg=tunnel interface network broadcast
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["port-hop"]    {{ cellular.tunnel_interface.port_hop_variable | default(cellular.tunnel_interface.port_hop | default("not_defined") | lower()) }}    msg=tunnel interface port hop
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["tunnel-tcp-mss-adjust"]    {{ cellular.tunnel_interface.tcp_mss_variable | default(cellular.tunnel_interface.tcp_mss | default("not_defined")) }}    msg=tunnel interface tcp mss
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["tunnel-qos"].mode    {{ cellular.tunnel_interface.per_tunnel_qos_mode_variable | default(cellular.tunnel_interface.per_tunnel_qos_mode | default("not_defined")) }}    msg=tunnel interface per tunnel qos mode
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.color.restrict    {{ cellular.tunnel_interface.restrict_variable | default(cellular.tunnel_interface.restrict | default("not_defined") | lower()) }}    msg=tunnel interface restrict
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["secondary-region"]    {{ cellular.tunnel_interface.secondary_region_variable | default(cellular.tunnel_interface.secondary_region | default("not_defined")) }}    msg=tunnel interface secondary region
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["vbond-as-stun-server"]    {{ cellular.tunnel_interface.vbond_as_stun_server_variable | default(cellular.tunnel_interface.vbond_as_stun_server | default("not_defined") | lower()) }}    msg=tunnel interface vbond as stun server
    Should Be Equal Value Json String FT    ${r_id.json()}    $.tunnel-interface.["vmanage-connection-preference"]    {{ cellular.tunnel_interface.vmanage_connection_preference_variable | default(cellular.tunnel_interface.vmanage_connection_preference | default("not_defined")) }}    msg=tunnel interface vmanage connection preference


{% endfor %}

{% endif %}