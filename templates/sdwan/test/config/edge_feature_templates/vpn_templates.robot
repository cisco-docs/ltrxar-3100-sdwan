*** Settings ***
Documentation   Verify VPN Feature Template Configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.vpn_templates is defined %}

*** Test Cases ***
Get VPN Template(s)
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_vpn")]
    Set Suite Variable    ${r}

{% for vpn in sdwan.edge_feature_templates.vpn_templates | default([]) %}

Verify Edge Feature Template VPN Feature Template {{ vpn.name }}
    ${vpn_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ vpn.name }}")]
    Should Be Equal Value Json String    ${vpn_id}    $..templateName    {{ vpn.name }}    msg=name
    Should Be Equal Value Json Special_String    ${vpn_id}    $..templateDescription    {{ vpn.description | normalize_special_string }}    msg=description

{% set test_list = [] %}
{% for item in vpn.device_types | default(defaults.sdwan.edge_feature_templates.vpn_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${vpn_id}    $..deviceType
    ${test_list}=    Create List    {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list}[0]    ${test_list}    ignore_order=True    msg=device types

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{vpn.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $["ecmp-hash-key"].layer4.vipValue    {{ vpn.enhance_ecmp_keying | default("not_defined") | lower() }}    msg=enhance ecmp keying
    Should Be Equal Value Json String    ${r_id.json()}    $["ecmp-hash-key"].layer4.vipVariableName    {{ vpn.enhance_ecmp_keying_variable | default("not_defined") }}    msg=enhance ecmp keying variable
    Should Be Equal Value Json String    ${r_id.json()}    $.dns.vipValue[?(@.role.vipValue=="primary")]..["dns-addr"].vipValue    {{ vpn.ipv4_primary_dns_server | default("not_defined") }}    msg=ipv4 primary dns server
    Should Be Equal Value Json String    ${r_id.json()}    $.dns.vipValue[?(@.role.vipValue=="primary")]..["dns-addr"].vipVariableName    {{ vpn.ipv4_primary_dns_server_variable | default("not_defined") }}    msg=ipv4 primary dns server variable
    Should Be Equal Value Json String    ${r_id.json()}    $.dns.vipValue[?(@.role.vipValue=="secondary")]..["dns-addr"].vipValue    {{ vpn.ipv4_secondary_dns_server | default("not_defined") }}    msg=ipv4 secondary dns server
    Should Be Equal Value Json String    ${r_id.json()}    $.dns.vipValue[?(@.role.vipValue=="secondary")]..["dns-addr"].vipVariableName    {{ vpn.ipv4_secondary_dns_server_variable | default("not_defined") }}    msg=ipv4 secondary dns server variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["dns-ipv6"].vipValue[?(@.role.vipValue=="primary")]..["dns-addr"].vipValue    {{ vpn.ipv6_primary_dns_server | default("not_defined") }}    msg=ipv6 primary dns server
    Should Be Equal Value Json String    ${r_id.json()}    $..["dns-ipv6"].vipValue[?(@.role.vipValue=="primary")]..["dns-addr"].vipVariableName    {{ vpn.ipv6_primary_dns_server_variable | default("not_defined") }}    msg=ipv6 primary dns server variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["dns-ipv6"].vipValue[?(@.role.vipValue=="secondary")]..["dns-addr"].vipValue    {{ vpn.ipv6_secondary_dns_server | default("not_defined") }}    msg=ipv6 secondary dns server
    Should Be Equal Value Json String    ${r_id.json()}    $..["dns-ipv6"].vipValue[?(@.role.vipValue=="secondary")]..["dns-addr"].vipVariableName    {{ vpn.ipv6_secondary_dns_server_variable | default("not_defined") }}    msg=ipv6 secondary dns server variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["omp-admin-distance-ipv4"].vipValue    {{ vpn.omp_admin_distance_ipv4 | default("not_defined") }}    msg=omp admin distance ipv4
    Should Be Equal Value Json String    ${r_id.json()}    $..["omp-admin-distance-ipv4"].vipVariableName    {{ vpn.omp_admin_distance_ipv4_variable | default("not_defined") }}    msg=omp admin distance ipv4 variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["omp-admin-distance-ipv6"].vipValue    {{ vpn.omp_admin_distance_ipv6 | default("not_defined") }}    msg=omp admin distance ipv6
    Should Be Equal Value Json String    ${r_id.json()}    $..["omp-admin-distance-ipv6"].vipVariableName    {{ vpn.omp_admin_distance_ipv6_variable | default("not_defined") }}    msg=omp admin distance ipv6 variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["vpn-id"].vipValue    {{ vpn.vpn_id | default("not_defined") }}    msg=vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $.name.vipValue    {{ vpn.vpn_name | default("not_defined") }}    msg=vpn name
    Should Be Equal Value Json String    ${r_id.json()}    $.name.vipVariableName    {{ vpn.vpn_name_variable | default("not_defined") }}    msg=vpn name variable

    Should Be Equal Value Json List Length    ${r_id.json()}    $.host.vipValue    {{ vpn.ipv4_dns_hosts | default([]) | length + vpn.ipv6_dns_hosts | default([]) | length }}    msg=ipv4 dns hosts/ipv6 dns hosts length

{% for ipv4_host in vpn.ipv4_dns_hosts | default([]) %}

    ${hostname_det}=    Get Value From Json    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv4_host.hostname }}")].hostname
    Should Not be Empty   ${hostname_det}   msg=ipv4 hostname not present

    Should Be Equal Value Json String    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv4_host.hostname }}")].hostname.vipVariableName    {{ ipv4_host.hostname_variable | default("not_defined") }}    msg=ipv4 hostname variable

    ${rec_ips_list}=    Get Value From Json    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv4_host.hostname }}")].ip.vipValue
    ${exp_ips_list}=    Create List    {{ ipv4_host.ips | default([]) | join('   ') }}
    Lists Should Be Equal    ${rec_ips_list[0]}    ${exp_ips_list}    ignore_order=True    msg=ipv4 ips

    Should Be Equal Value Json String    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv4_host.hostname }}")].ip.vipVariableName    {{ ipv4_host.ips_variable | default("not_defined") }}    msg=ipv4 ips variable
    Should Be Equal Value Json String    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv4_host.hostname }}")].vipOptional    {{ ipv4_host.optional | default("not_defined") }}    msg=ipv4 optional

{% endfor %}

{% for ipv6_host in vpn.ipv6_dns_hosts | default([]) %}

    ${hostname_det}=    Get Value From Json    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv6_host.hostname }}")].hostname
    Should Not be Empty   ${hostname_det}   msg=ipv6 hostname not present

    Should Be Equal Value Json String    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv6_host.hostname }}")].hostname.vipVariableName    {{ ipv6_host.hostname_variable | default("not_defined") }}    msg=ipv6 hostname variable

    ${rec_ips_list}=    Get Value From Json    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv6_host.hostname }}")].ip.vipValue
    ${exp_ips_list}=    Create List    {{ ipv6_host.ips | default([]) | join('   ') }}
    Lists Should Be Equal    ${rec_ips_list[0]}    ${exp_ips_list}    ignore_order=True    msg=ipv6 ips

    Should Be Equal Value Json String    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv6_host.hostname }}")].ip.vipVariableName    {{ ipv6_host.ips_variable | default("not_defined") }}    msg=ipv6 ips variable
    Should Be Equal Value Json String    ${r_id.json()}    $.host.vipValue[?(@.hostname.vipValue=="{{ ipv6_host.hostname }}")].vipOptional    {{ ipv6_host.optional | default("not_defined") }}    msg=ipv6 optional

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.ip..["gre-route"].vipValue    {{ vpn.ipv4_static_gre_routes | default([]) | length }}    msg=ipv4 static gre routes length

{% for ipv4_gre in vpn.ipv4_static_gre_routes | default([]) %}

    ${rec_int_list}=    Get Value From Json    ${r_id.json()}    $.ip..["gre-route"].vipValue[{{ loop.index0 }}].interface.vipValue
    ${exp_int_list}=    Create List    {{ ipv4_gre.interfaces | default([]) | join('   ') }}
    Lists Should Be Equal    ${rec_int_list[0]}    ${exp_int_list}    ignore_order=True    msg=gre interfaces

    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["gre-route"].vipValue[{{ loop.index0 }}].interface.vipVariableName    {{ ipv4_gre.interfaces_variable | default("not_defined") }}    msg=gre interfaces variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["gre-route"].vipValue[{{ loop.index0 }}].prefix.vipValue    {{ ipv4_gre.prefix | default("not_defined") }}    msg=gre prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["gre-route"].vipValue[{{ loop.index0 }}].prefix.vipVariableName    {{ ipv4_gre.prefix_variable | default("not_defined") }}    msg=gre prefix variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["gre-route"].vipValue[{{ loop.index0 }}].vipOptional    {{ ipv4_gre.optional | default("not_defined") }}    msg=gre optional

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.ip..["ipsec-route"].vipValue    {{ vpn.ipv4_static_ipsec_routes | default([]) | length }}    msg=ipv4 static ipsec routes length

{% for ipv4_ipsec in vpn.ipv4_static_ipsec_routes | default([]) %}

    ${rec_int_list}=    Get Value From Json    ${r_id.json()}    $.ip..["ipsec-route"].vipValue[{{ loop.index0 }}].interface.vipValue
    ${exp_int_list}=    Create List    {{ ipv4_ipsec.interfaces | default([]) | join('   ') }}
    Lists Should Be Equal    ${rec_int_list[0]}    ${exp_int_list}    ignore_order=True    msg=ipsec interfaces

    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["ipsec-route"].vipValue[{{ loop.index0 }}].interface.vipVariableName    {{ ipv4_ipsec.interfaces_variable | default("not_defined") }}    msg=ipsec interfaces variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["ipsec-route"].vipValue[{{ loop.index0 }}].prefix.vipValue    {{ ipv4_ipsec.prefix | default("not_defined") }}    msg=ipsec prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["ipsec-route"].vipValue[{{ loop.index0 }}].prefix.vipVariableName    {{ ipv4_ipsec.prefix_variable | default("not_defined") }}    msg=ipsec prefix variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["ipsec-route"].vipValue[{{ loop.index0 }}].vipOptional    {{ ipv4_ipsec.optional | default("not_defined") }}    msg=ipsec optional

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.ip.route.vipValue    {{ vpn.ipv4_static_routes | default([]) | length }}    msg=ipv4 static routes length

{% for v4_route_index in range(vpn.ipv4_static_routes | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}].dhcp.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].next_hop_dhcp | default("not_defined") | lower() }}    msg=ipv4 next hop dhcp
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}].null0.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].next_hop_null0 | default("not_defined") | lower() }}    msg=ipv4 next hop null0
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}].distance.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].next_hop_null0_distance | default("not_defined") }}    msg=ipv4 next hop null0 distance
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}].distance.vipVariableName    {{ vpn.ipv4_static_routes[v4_route_index].next_hop_null0_distance_variable | default("not_defined") }}    msg=ipv4 next hop null0 distance variable

    ${dia_val}=    Get Value From Json    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}].vpn.vipValue
{% if vpn.ipv4_static_routes[v4_route_index].next_hop_dia | default("not_defined") | lower() == "true" %}
    IF    ${dia_val} == []
        ${r_value}=    Set Variable    not_defined
    ELSE
        ${r_value}=    Set Variable If    "${dia_val[0]}" == "0"    true
    END
    Should Be Equal As Strings    ${r_value}    {{ vpn.ipv4_static_routes[v4_route_index].next_hop_dia | lower() }}    msg=ipv4 next hop dia
{% elif vpn.ipv4_static_routes[v4_route_index].next_hop_dia | default("not_defined") | lower() == "false" %}
    IF    ${dia_val} == []
        ${r_value}=    Set Variable    false
    ELSE
        ${r_value}=    Set Variable    ${dia_val[0]}
    END
    Should Be Equal As Strings    ${r_value}    {{ vpn.ipv4_static_routes[v4_route_index].next_hop_dia | lower() }}    msg=ipv4 next hop dia
{% elif vpn.ipv4_static_routes[v4_route_index].next_hop_dia | default("not_defined") == "not_defined" %}
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}].vpn.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].next_hop_dia | default("not_defined") }}    msg=ipv4 next hop dia
{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}].vipOptional    {{ vpn.ipv4_static_routes[v4_route_index].optional | default("not_defined") }}    msg=ipv4 optional
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}].prefix.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].prefix | default("not_defined") }}    msg=ipv4 prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}].prefix.vipVariableName    {{ vpn.ipv4_static_routes[v4_route_index].prefix_variable | default("not_defined") }}    msg=ipv4 prefix variable

    Should Be Equal Value Json List Length    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop"].vipValue    {{ vpn.ipv4_static_routes[v4_route_index].next_hops | default([]) | length }}    msg=ipv4 next hops length

{% for v4_hop_index in range(vpn.ipv4_static_routes[v4_route_index].next_hops | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop"].vipValue[{{ v4_hop_index }}].address.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].next_hops[v4_hop_index].address | default("not_defined") }}    msg=ipv4 hop address
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop"].vipValue[{{ v4_hop_index }}].address.vipVariableName    {{ vpn.ipv4_static_routes[v4_route_index].next_hops[v4_hop_index].address_variable | default("not_defined") }}    msg=ipv4 hop address variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop"].vipValue[{{ v4_hop_index }}].distance.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].next_hops[v4_hop_index].distance | default("not_defined") }}    msg=ipv4 hop distance
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop"].vipValue[{{ v4_hop_index }}].distance.vipVariableName    {{ vpn.ipv4_static_routes[v4_route_index].next_hops[v4_hop_index].distance_variable | default("not_defined") }}    msg=ipv4 hop distance variable

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop-with-track"].vipValue    {{ vpn.ipv4_static_routes[v4_route_index].track_next_hops | default([]) | length }}    msg=ipv4 track next hops length

{% for v4_track_index in range(vpn.ipv4_static_routes[v4_route_index].track_next_hops | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop-with-track"].vipValue[{{ v4_track_index }}].address.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].track_next_hops[v4_track_index].address | default("not_defined") }}    msg=ipv4 track address
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop-with-track"].vipValue[{{ v4_track_index }}].address.vipVariableName    {{ vpn.ipv4_static_routes[v4_route_index].track_next_hops[v4_track_index].address_variable | default("not_defined") }}    msg=ipv4 track address variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop-with-track"].vipValue[{{ v4_track_index }}].distance.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].track_next_hops[v4_track_index].distance | default("not_defined") }}    msg=ipv4 track distance
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop-with-track"].vipValue[{{ v4_track_index }}].distance.vipVariableName    {{ vpn.ipv4_static_routes[v4_route_index].track_next_hops[v4_track_index].distance_variable | default("not_defined") }}    msg=ipv4 track distance variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop-with-track"].vipValue[{{ v4_track_index }}].tracker.vipValue    {{ vpn.ipv4_static_routes[v4_route_index].track_next_hops[v4_track_index].tracker | default("not_defined") }}    msg=ipv4 track tracker
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.route.vipValue[{{ v4_route_index }}]["next-hop-with-track"].vipValue[{{ v4_track_index }}].tracker.vipVariableName    {{ vpn.ipv4_static_routes[v4_route_index].track_next_hops[v4_track_index].tracker_variable | default("not_defined") }}    msg=ipv4 track tracker variable

{% endfor %}

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.ip..["service-route"].vipValue    {{ vpn.ipv4_static_service_routes | default([]) | length }}    msg=ipv4 static service routes length

{% for ipv4_service in vpn.ipv4_static_service_routes | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["service-route"].vipValue[{{ loop.index0 }}].prefix.vipValue    {{ ipv4_service.prefix | default("not_defined") }}    msg=ipv4 service prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["service-route"].vipValue[{{ loop.index0 }}].prefix.vipVariableName    {{ ipv4_service.prefix_variable | default("not_defined") }}    msg=ipv4 service prefix variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["service-route"].vipValue[{{ loop.index0 }}].service.vipValue    {{ ipv4_service.service | default("not_defined") }}    msg=ipv4 service

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.ipv6.route.vipValue    {{ vpn.ipv6_static_routes | default([]) | length }}    msg=ipv6 static routes length

{% for v6_route_index in range(vpn.ipv6_static_routes | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}].nat.vipValue    {{ vpn.ipv6_static_routes[v6_route_index].nat | default("not_defined") }}    msg=ipv6 nat
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}].nat.vipVariableName    {{ vpn.ipv6_static_routes[v6_route_index].nat_variable | default("not_defined") }}    msg=ipv6 nat variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}].null0.vipValue    {{ vpn.ipv6_static_routes[v6_route_index].next_hop_null0 | default("not_defined") | lower() }}    msg=ipv6 next hop null0

    ${dia_val}=    Get Value From Json    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}].vpn.vipValue
{% if vpn.ipv6_static_routes[v6_route_index].next_hop_dia | default("not_defined") | lower() == "true" %}
    IF    ${dia_val} == []
        ${r_value}=    Set Variable    not_defined
    ELSE
        ${r_value}=    Set Variable If    "${dia_val[0]}" == "0"    true
    END
    Should Be Equal As Strings    ${r_value}    {{ vpn.ipv6_static_routes[v6_route_index].next_hop_dia | lower() }}    msg=ipv6 next hop dia
{% elif vpn.ipv6_static_routes[v6_route_index].next_hop_dia | default("not_defined") | lower() == "false" %}
    IF    ${dia_val} == []
        ${r_value}=    Set Variable    false
    ELSE
        ${r_value}=    Set Variable    ${dia_val[0]}
    END
    Should Be Equal As Strings    ${r_value}    {{ vpn.ipv6_static_routes[v6_route_index].next_hop_dia | lower() }}    msg=ipv6 next hop dia
{% elif vpn.ipv6_static_routes[v6_route_index].next_hop_dia | default("not_defined") == "not_defined" %}
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}].vpn.vipValue    {{ vpn.ipv6_static_routes[v6_route_index].next_hop_dia | default("not_defined") }}    msg=ipv6 next hop dia
{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}].vipOptional    {{ vpn.ipv6_static_routes[v6_route_index].optional | default("not_defined") }}    msg=ipv6 optional
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}].prefix.vipValue    {{ vpn.ipv6_static_routes[v6_route_index].prefix | default("not_defined") }}    msg=ipv6 prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}].prefix.vipVariableName    {{ vpn.ipv6_static_routes[v6_route_index].prefix_variable | default("not_defined") }}    msg=ipv6 prefix variable

    Should Be Equal Value Json List Length    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}]..["next-hop"].vipValue    {{ vpn.ipv6_static_routes[v6_route_index].next_hops | default([]) | length }}    msg=ipv6 next hops length

{% for v6_hop_index in range(vpn.ipv6_static_routes[v6_route_index].next_hops | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}]["next-hop"].vipValue[{{ v6_hop_index }}].address.vipValue    {{ vpn.ipv6_static_routes[v6_route_index].next_hops[v6_hop_index].address | default("not_defined") }}    msg=ipv6 hop address
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}]["next-hop"].vipValue[{{ v6_hop_index }}].address.vipVariableName    {{ vpn.ipv6_static_routes[v6_route_index].next_hops[v6_hop_index].address_variable | default("not_defined") }}    msg=ipv6 hop address variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}]["next-hop"].vipValue[{{ v6_hop_index }}].distance.vipValue    {{ vpn.ipv6_static_routes[v6_route_index].next_hops[v6_hop_index].distance | default("not_defined") }}    msg=ipv6 hop distance
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.route.vipValue[{{ v6_route_index }}]["next-hop"].vipValue[{{ v6_hop_index }}].distance.vipVariableName    {{ vpn.ipv6_static_routes[v6_route_index].next_hops[v6_hop_index].distance_variable | default("not_defined") }}    msg=ipv6 hop distance variable

{% endfor %}

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.nat.natpool.vipValue    {{ vpn.nat_pools | default([]) | length }}    msg=nat pools length

{% for nat_pool in vpn.nat_pools | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}].direction.vipValue    {{ nat_pool.direction | default("not_defined") }}    msg=nat pool direction
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}].direction.vipVariableName    {{ nat_pool.direction_variable | default("not_defined") }}    msg=nat pool direction variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}].name.vipValue    {{ nat_pool.id | default("not_defined") }}    msg=nat pool id
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}].name.vipVariableName    {{ nat_pool.id_variable | default("not_defined") }}    msg=nat pool id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}].overload.vipValue    {{ nat_pool.overload | default("not_defined") | lower() }}    msg=nat pool overload
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}].overload.vipVariableName    {{ nat_pool.overload_variable | default("not_defined") }}    msg=nat pool overload variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}]["prefix-length"].vipValue    {{ nat_pool.prefix_length | default("not_defined") }}    msg=nat pool prefix length
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}]["prefix-length"].vipVariableName    {{ nat_pool.prefix_length_variable | default("not_defined") }}    msg=nat pool prefix length variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}]["range-start"].vipValue    {{ nat_pool.range_start | default("not_defined") }}    msg=nat pool range start
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}]["range-start"].vipVariableName    {{ nat_pool.range_start_variable | default("not_defined") }}    msg=nat pool range start variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}]["range-end"].vipValue    {{ nat_pool.range_end | default("not_defined") }}    msg=nat pool range end
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}]["range-end"].vipVariableName    {{ nat_pool.range_end_variable | default("not_defined") }}    msg=nat pool range end variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}]["tracker-id"].vipValue    {{ nat_pool.tracker_id | default("not_defined") }}    msg=nat pool tracker id
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.natpool.vipValue[{{ loop.index0 }}]["tracker-id"].vipVariableName    {{ nat_pool.tracker_id_variable | default("not_defined") }}    msg=nat pool tracker id variable

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.nat64.v4.pool.vipValue    {{ vpn.nat64_pools | default([]) | length }}    msg=nat64 pools length

{% for nat64_pool in vpn.nat64_pools | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.nat64.v4.pool.vipValue[{{ loop.index0 }}].name.vipValue    {{ nat64_pool.name }}    msg=nat64 pool name
    Should Be Equal Value Json String    ${r_id.json()}    $.nat64.v4.pool.vipValue[{{ loop.index0 }}].overload.vipValue    {{ nat64_pool.overload | default("not_defined") | lower() }}    msg=nat64 pool overload
    Should Be Equal Value Json String    ${r_id.json()}    $.nat64.v4.pool.vipValue[{{ loop.index0 }}].overload.vipVariableName    {{ nat64_pool.overload_variable | default("not_defined") }}    msg=nat64 pool overload variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat64.v4.pool.vipValue[{{ loop.index0 }}]["start-address"].vipValue    {{ nat64_pool.range_start | default("not_defined") }}    msg=nat64 pool range start
    Should Be Equal Value Json String    ${r_id.json()}    $.nat64.v4.pool.vipValue[{{ loop.index0 }}]["start-address"].vipVariableName    {{ nat64_pool.range_start_variable | default("not_defined") }}    msg=nat64 pool range start variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat64.v4.pool.vipValue[{{ loop.index0 }}]["end-address"].vipValue    {{ nat64_pool.range_end | default("not_defined") }}    msg=nat64 pool range end
    Should Be Equal Value Json String    ${r_id.json()}    $.nat64.v4.pool.vipValue[{{ loop.index0 }}]["end-address"].vipVariableName    {{ nat64_pool.range_end_variable | default("not_defined") }}    msg=nat64 pool range end variable

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.omp.advertise.vipValue    {{ vpn.omp_advertise_ipv4_routes | default([]) | length }}    msg=omp advertise ipv4 routes length

{% for v4_omp_index in range(vpn.omp_advertise_ipv4_routes | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}].protocol.vipValue    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].protocol | default("not_defined") }}    msg=ipv4 omp protocol
    Should Be Equal Value Json String    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}].protocol.vipVariableName    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].protocol_variable | default("not_defined") }}    msg=ipv4 omp protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}]["route-policy"].vipValue    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].route_policy | default("not_defined") }}    msg=ipv4 omp route policy
    Should Be Equal Value Json String    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}]["route-policy"].vipVariableName    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].route_policy_variable | default("not_defined") }}    msg=ipv4 omp route policy variable

    Should Be Equal Value Json List Length    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}]["prefix-list"].vipValue    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].networks | default([]) | length }}    msg=ipv4 omp networks length

{% for v4_omp_net_index in range(vpn.omp_advertise_ipv4_routes[v4_omp_index].networks | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}]["prefix-list"].vipValue[{{ v4_omp_net_index }}]["aggregate-only"].vipValue    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].networks[v4_omp_net_index].aggregate_only | default("not_defined") | lower() }}    msg=ipv4 omp network aggregate only
    Should Be Equal Value Json String    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}]["prefix-list"].vipValue[{{ v4_omp_net_index }}]["aggregate-only"].vipVariableName    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].networks[v4_omp_net_index].aggregate_only_variable | default("not_defined") }}    msg=ipv4 omp network aggregate only variable
    Should Be Equal Value Json String    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}]["prefix-list"].vipValue[{{ v4_omp_net_index }}]["prefix-entry"].vipValue    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].networks[v4_omp_net_index].prefix | default("not_defined") }}    msg=ipv4 omp network prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}]["prefix-list"].vipValue[{{ v4_omp_net_index }}]["prefix-entry"].vipVariableName    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].networks[v4_omp_net_index].prefix_variable | default("not_defined") }}    msg=ipv4 omp network prefix variable
    Should Be Equal Value Json String    ${r_id.json()}    $.omp.advertise.vipValue[{{ v4_omp_index }}]["prefix-list"].vipValue[{{ v4_omp_net_index }}].vipOptional    {{ vpn.omp_advertise_ipv4_routes[v4_omp_index].networks[v4_omp_net_index].optional | default("not_defined") }}    msg=ipv4 omp network optional

{% endfor %}

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue    {{ vpn.omp_advertise_ipv6_routes | default([]) | length }}    msg=omp advertise ipv6 routes length

{% for v6_omp_index in range(vpn.omp_advertise_ipv6_routes | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}].protocol.vipValue    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].protocol | default("not_defined") }}    msg=ipv6 omp protocol
    Should Be Equal Value Json String    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}].protocol.vipVariableName    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].protocol_variable | default("not_defined") }}    msg=ipv6 omp protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}]["route-policy"].vipValue    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].route_policy | default("not_defined") }}    msg=ipv6 omp route policy
    Should Be Equal Value Json String    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}]["route-policy"].vipVariableName    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].route_policy_variable | default("not_defined") }}    msg=ipv6 omp route policy variable

    Should Be Equal Value Json List Length    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}]["prefix-list"].vipValue    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].networks | default([]) | length }}    msg=ipv6 omp networks length

{% for v6_omp_net_index in range(vpn.omp_advertise_ipv6_routes[v6_omp_index].networks | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}]["prefix-list"].vipValue[{{ v6_omp_net_index }}]["aggregate-only"].vipValue    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].networks[v6_omp_net_index].aggregate_only | default("not_defined") | lower() }}    msg=ipv6 omp network aggregate only
    Should Be Equal Value Json String    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}]["prefix-list"].vipValue[{{ v6_omp_net_index }}]["aggregate-only"].vipVariableName    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].networks[v6_omp_net_index].aggregate_only_variable | default("not_defined") }}    msg=ipv6 omp network aggregate only variable
    Should Be Equal Value Json String    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}]["prefix-list"].vipValue[{{ v6_omp_net_index }}]["prefix-entry"].vipValue    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].networks[v6_omp_net_index].prefix | default("not_defined") }}    msg=ipv6 omp network prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}]["prefix-list"].vipValue[{{ v6_omp_net_index }}]["prefix-entry"].vipVariableName    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].networks[v6_omp_net_index].prefix_variable | default("not_defined") }}    msg=ipv6 omp network prefix variable
    Should Be Equal Value Json String    ${r_id.json()}    $.omp["ipv6-advertise"].vipValue[{{ v6_omp_index }}]["prefix-list"].vipValue[{{ v6_omp_net_index }}].vipOptional    {{ vpn.omp_advertise_ipv6_routes[v6_omp_index].networks[v6_omp_net_index].optional | default("not_defined") }}    msg=ipv6 omp network optional

{% endfor %}

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.nat..["port-forward"].vipValue    {{ vpn.port_forwarding_rules | default([]) | length }}    msg=port forwarding rules length

{% for port_fw in vpn.port_forwarding_rules | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["pool-name"].vipValue    {{ port_fw.nat_pool_id }}    msg=port fw nat pool id
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["pool-name"].vipVariableName    {{ port_fw.nat_pool_id_variable }}    msg=port fw nat pool id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}].proto.vipValue    {{ port_fw.protocol }}    msg=port fw protocol
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}].proto.vipVariableName    {{ port_fw.protocol_variable }}    msg=port fw protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["source-ip"].vipValue    {{ port_fw.source_ip }}    msg=port fw source ip
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["source-ip"].vipVariableName    {{ port_fw.source_ip_variable }}    msg=port fw source ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["source-port"].vipValue    {{ port_fw.source_port }}    msg=port fw source port
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["source-port"].vipVariableName    {{ port_fw.source_port_variable }}    msg=port fw source port variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["translate-ip"].vipValue    {{ port_fw.translate_ip }}    msg=port fw translate ip
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["translate-ip"].vipVariableName    {{ port_fw.translate_ip_variable }}    msg=port fw translate ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["translate-port"].vipValue    {{ port_fw.translate_port }}    msg=port fw translate port
    Should Be Equal Value Json String    ${r_id.json()}    $.nat..["port-forward"].vipValue[{{ loop.index0 }}]["translate-port"].vipVariableName    {{ port_fw.translate_port_variable }}    msg=port fw translate port variable

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $["route-export"].vipValue    {{ vpn.route_global_exports | default([]) | length }}    msg=route global exports length

{% for rt_gl_exp_index in range(vpn.route_global_exports | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $["route-export"].vipValue[{{ rt_gl_exp_index }}].protocol.vipValue    {{ vpn.route_global_exports[rt_gl_exp_index].protocol | default("not_defined") }}    msg=route global export protocol
    Should Be Equal Value Json String    ${r_id.json()}    $["route-export"].vipValue[{{ rt_gl_exp_index }}].protocol.vipVariableName    {{ vpn.route_global_exports[rt_gl_exp_index].protocol_variable | default("not_defined") }}    msg=route global export protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $["route-export"].vipValue[{{ rt_gl_exp_index }}]["route-policy"].vipValue    {{ vpn.route_global_exports[rt_gl_exp_index].route_policy | default("not_defined") }}    msg=route global export route policy

    Should Be Equal Value Json List Length    ${r_id.json()}    $["route-export"].vipValue[{{ rt_gl_exp_index }}].redistribute.vipValue    {{ vpn.route_global_exports[rt_gl_exp_index].redistributes | default([]) | length }}    msg=route global exports redistributes length

{% for rt_gl_exp_red_index in range(vpn.route_global_exports[rt_gl_exp_index].redistributes | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $["route-export"].vipValue[{{ rt_gl_exp_index }}].redistribute.vipValue[{{ rt_gl_exp_red_index }}].protocol.vipValue    {{ vpn.route_global_exports[rt_gl_exp_index].redistributes[rt_gl_exp_red_index].protocol | default("not_defined") }}    msg=route global export redistribute protocol
    Should Be Equal Value Json String    ${r_id.json()}    $["route-export"].vipValue[{{ rt_gl_exp_index }}].redistribute.vipValue[{{ rt_gl_exp_red_index }}].protocol.vipVariableName    {{ vpn.route_global_exports[rt_gl_exp_index].redistributes[rt_gl_exp_red_index].protocol_variable | default("not_defined") }}    msg=route global export redistribute protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $["route-export"].vipValue[{{ rt_gl_exp_index }}].redistribute.vipValue[{{ rt_gl_exp_red_index }}]["route-policy"].vipValue    {{ vpn.route_global_exports[rt_gl_exp_index].redistributes[rt_gl_exp_red_index].route_policy | default("not_defined") }}    msg=route global export redistribute route policy

{% endfor %}

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $["route-import"].vipValue    {{ vpn.route_global_imports | default([]) | length }}    msg=route global imports length

{% for rt_gl_imp_index in range(vpn.route_global_imports | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $["route-import"].vipValue[{{ rt_gl_imp_index }}].protocol.vipValue    {{ vpn.route_global_imports[rt_gl_imp_index].protocol | default("not_defined") }}    msg=route global import protocol
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import"].vipValue[{{ rt_gl_imp_index }}].protocol.vipVariableName    {{ vpn.route_global_imports[rt_gl_imp_index].protocol_variable | default("not_defined") }}    msg=route global import protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import"].vipValue[{{ rt_gl_imp_index }}]["route-policy"].vipValue    {{ vpn.route_global_imports[rt_gl_imp_index].route_policy | default("not_defined") }}    msg=route global import route policy

    Should Be Equal Value Json List Length    ${r_id.json()}    $["route-import"].vipValue[{{ rt_gl_imp_index }}].redistribute.vipValue    {{ vpn.route_global_imports[rt_gl_imp_index].redistributes | default([]) | length }}    msg=route global imports redistributes length

{% for rt_gl_imp_red_index in range(vpn.route_global_imports[rt_gl_imp_index].redistributes | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $["route-import"].vipValue[{{ rt_gl_imp_index }}].redistribute.vipValue[{{ rt_gl_imp_red_index }}].protocol.vipValue    {{ vpn.route_global_imports[rt_gl_imp_index].redistributes[rt_gl_imp_red_index].protocol | default("not_defined") }}    msg=route global import redistribute protocol
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import"].vipValue[{{ rt_gl_imp_index }}].redistribute.vipValue[{{ rt_gl_imp_red_index }}].protocol.vipVariableName    {{ vpn.route_global_imports[rt_gl_imp_index].redistributes[rt_gl_imp_red_index].protocol_variable | default("not_defined") }}    msg=route global import redistribute protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import"].vipValue[{{ rt_gl_imp_index }}].redistribute.vipValue[{{ rt_gl_imp_red_index }}]["route-policy"].vipValue    {{ vpn.route_global_imports[rt_gl_imp_index].redistributes[rt_gl_imp_red_index].route_policy | default("not_defined") }}    msg=route global import redistribute route policy

{% endfor %}

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $["route-import-from"].vipValue    {{ vpn.route_vpn_imports | default([]) | length }}    msg=route vpn imports length

{% for rt_vpn_imp_index in range(vpn.route_vpn_imports | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}].protocol.vipValue    {{ vpn.route_vpn_imports[rt_vpn_imp_index].protocol | default("not_defined") }}    msg=route vpn import protocol
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}].protocol.vipVariableName    {{ vpn.route_vpn_imports[rt_vpn_imp_index].protocol_variable | default("not_defined") }}    msg=route vpn import protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}]["route-policy"].vipValue    {{ vpn.route_vpn_imports[rt_vpn_imp_index].route_policy | default("not_defined") }}    msg=route vpn import route policy
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}]["route-policy"].vipVariableName    {{ vpn.route_vpn_imports[rt_vpn_imp_index].route_policy_variable | default("not_defined") }}    msg=route vpn import route policy variable
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}]["source-vpn"].vipValue    {{ vpn.route_vpn_imports[rt_vpn_imp_index].source_vpn_id | default("not_defined") }}    msg=route vpn import source vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}]["source-vpn"].vipVariableName    {{ vpn.route_vpn_imports[rt_vpn_imp_index].source_vpn_id_variable | default("not_defined") }}    msg=route vpn import source vpn id variable

    Should Be Equal Value Json List Length    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}].redistribute.vipValue    {{ vpn.route_vpn_imports[rt_vpn_imp_index].redistributes | default([]) | length }}    msg=route vpn imports redistributes length

{% for rt_vpn_imp_red_index in range(vpn.route_vpn_imports[rt_vpn_imp_index].redistributes | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}].redistribute.vipValue[{{ rt_vpn_imp_red_index }}].protocol.vipValue    {{ vpn.route_vpn_imports[rt_vpn_imp_index].redistributes[rt_vpn_imp_red_index].protocol | default("not_defined") }}    msg=route vpn import redistribute protocol
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}].redistribute.vipValue[{{ rt_vpn_imp_red_index }}].protocol.vipVariableName    {{ vpn.route_vpn_imports[rt_vpn_imp_index].redistributes[rt_vpn_imp_red_index].protocol_variable | default("not_defined") }}    msg=route vpn import redistribute protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}].redistribute.vipValue[{{ rt_vpn_imp_red_index }}]["route-policy"].vipValue    {{ vpn.route_vpn_imports[rt_vpn_imp_index].redistributes[rt_vpn_imp_red_index].route_policy | default("not_defined") }}    msg=route vpn import redistribute route policy
    Should Be Equal Value Json String    ${r_id.json()}    $["route-import-from"].vipValue[{{ rt_vpn_imp_index }}].redistribute.vipValue[{{ rt_vpn_imp_red_index }}]["route-policy"].vipVariableName    {{ vpn.route_vpn_imports[rt_vpn_imp_index].redistributes[rt_vpn_imp_red_index].route_policy_variable | default("not_defined") }}    msg=route vpn import redistribute route policy variable

{% endfor %}

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.service.vipValue    {{ vpn.services | default([]) | length }}    msg=services length

{% for service in vpn.services | default([]) %}

    ${rec_add_list}=    Get Value From Json    ${r_id.json()}    $.service.vipValue[{{ loop.index0 }}].address.vipValue
    ${rec_add_list}=    Run Keyword If    ${rec_add_list} == []    Create List    
...                 ELSE    Set Variable    ${rec_add_list[0]}   
    ${exp_add_list}=    Create List    {{ service.addresses | default([]) | join('   ') }}
    Lists Should Be Equal    ${rec_add_list}    ${exp_add_list}    ignore_order=True    msg=service addresses

    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue[{{ loop.index0 }}].address.vipVariableName    {{ service.addresses_variable | default("not_defined") }}    msg=service addresses variable
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue[{{ loop.index0 }}]["svc-type"].vipValue    {{ service.service_type | default("not_defined") }}    msg=service type
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue[{{ loop.index0 }}]["track-enable"].vipValue    {{ service.track_enable | default("not_defined") | lower() }}    msg=service track enable
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue[{{ loop.index0 }}]["track-enable"].vipVariableName    {{ service.track_enable_variable | default("not_defined") }}    msg=service track enable variable

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.nat.static.vipValue    {{ vpn.static_nat_rules | default([]) | length }}    msg=static nat rules length

{% for st_nat_rule in vpn.static_nat_rules | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["static-nat-direction"].vipValue    {{ st_nat_rule.direction | default("not_defined") }}    msg=static nat rule direction
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["static-nat-direction"].vipVariableName    {{ st_nat_rule.direction_variable | default("not_defined") }}    msg=static nat rule direction variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["pool-name"].vipValue    {{ st_nat_rule.nat_pool_id | default("not_defined") }}    msg=static nat rule nat pool id
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["pool-name"].vipVariableName    {{ st_nat_rule.nat_pool_id_variable | default("not_defined") }}    msg=static nat rule nat pool id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}].vipOptional    {{ st_nat_rule.optional | default("not_defined") }}    msg=static nat rule optional
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["source-ip"].vipValue    {{ st_nat_rule.source_ip | default("not_defined") }}    msg=static nat rule source ip
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["source-ip"].vipVariableName    {{ st_nat_rule.source_ip_variable | default("not_defined") }}    msg=static nat rule source ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["tracker-id"].vipValue    {{ st_nat_rule.tracker_id | default("not_defined") }}    msg=static nat rule tracker id
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["tracker-id"].vipVariableName    {{ st_nat_rule.tracker_id_variable | default("not_defined") }}    msg=static nat rule tracker id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["translate-ip"].vipValue    {{ st_nat_rule.translate_ip | default("not_defined") }}    msg=static nat rule translate ip
    Should Be Equal Value Json String    ${r_id.json()}    $.nat.static.vipValue[{{ loop.index0 }}]["translate-ip"].vipVariableName    {{ st_nat_rule.translate_ip_variable | default("not_defined") }}    msg=static nat rule translate ip variable

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $.nat["subnet-static"].vipValue    {{ vpn.static_nat_subnet_rules | default([]) | length }}    msg=static nat subnet rules length

{% for st_nat_sub_rule in vpn.static_nat_subnet_rules | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["static-nat-direction"].vipValue    {{ st_nat_sub_rule.direction | default("not_defined") }}    msg=static nat subnet rule direction
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["static-nat-direction"].vipVariableName    {{ st_nat_sub_rule.direction_variable | default("not_defined") }}    msg=static nat subnet rule direction variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}].vipOptional    {{ st_nat_sub_rule.optional | default("not_defined") }}    msg=static nat subnet rule optional
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["prefix-length"].vipValue    {{ st_nat_sub_rule.prefix_length | default("not_defined") }}    msg=static nat subnet rule prefix length
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["prefix-length"].vipVariableName    {{ st_nat_sub_rule.prefix_length_variable | default("not_defined") }}    msg=static nat subnet rule prefix length variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["source-ip-subnet"].vipValue    {{ st_nat_sub_rule.source_ip_subnet | default("not_defined") }}    msg=static nat subnet rule source ip subnet
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["source-ip-subnet"].vipVariableName    {{ st_nat_sub_rule.source_ip_subnet_variable | default("not_defined") }}    msg=static nat subnet rule source ip subnet variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["tracker-id"].vipValue    {{ st_nat_sub_rule.tracker_id | default("not_defined") }}    msg=static nat subnet rule tracker id
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["tracker-id"].vipVariableName    {{ st_nat_sub_rule.tracker_id_variable | default("not_defined") }}    msg=static nat subnet rule tracker id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["translate-ip-subnet"].vipValue    {{ st_nat_sub_rule.translate_ip_subnet | default("not_defined") }}    msg=static nat subnet rule translate ip subnet
    Should Be Equal Value Json String    ${r_id.json()}    $.nat["subnet-static"].vipValue[{{ loop.index0 }}]["translate-ip-subnet"].vipVariableName    {{ st_nat_sub_rule.translate_ip_subnet_variable | default("not_defined") }}    msg=static nat subnet rule translate ip subnet variable

{% endfor %}

{% endfor %}

{% endif %}
