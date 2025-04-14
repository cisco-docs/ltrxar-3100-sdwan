*** Settings ***
Documentation   Verify SVI Feature Template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.svi_interface_templates is defined %}

*** Test Cases ***
Get SVI Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="vpn-interface-svi")]
    Set Suite Variable    ${r}

{% for svi in sdwan.edge_feature_templates.svi_interface_templates | default([]) %}

Verify Edge Feature Template SVI Feature template {{ svi.name }}
    ${svi_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{svi.name }}")]
    Should Be Equal Value Json String    ${svi_id}    $..templateName    {{ svi.name }}    msg=name
    Should Be Equal Value Json Special_String    ${svi_id}    $..templateDescription    {{ svi.description | normalize_special_string }}    msg=description

{% set test_list = [] %}
{% for item in svi.device_types | default(defaults.sdwan.edge_feature_templates.svi_interface_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${svi_id}    $..deviceType
    ${test_list}=    Create List    {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{svi.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $["arp-timeout"].vipValue    {{ svi.arp_timeout | default("not_defined") }}    msg=arp timeout
    Should Be Equal Value Json String    ${r_id.json()}    $["arp-timeout"].vipVariableName    {{ svi.arp_timeout_variable | default("not_defined") }}    msg=arp timeout variable
    Should Be Equal Value Json String    ${r_id.json()}    $.description.vipValue    {{ svi.interface_description | default("not_defined") }}    msg=interface description
    Should Be Equal Value Json String    ${r_id.json()}    $.description.vipVariableName    {{ svi.interface_description_variable | default("not_defined") }}    msg=interface description variable
    Should Be Equal Value Json String    ${r_id.json()}    $["if-name"].vipValue    {{ svi.interface_name | default("not_defined") }}    msg=interface name
    Should Be Equal Value Json String    ${r_id.json()}    $["if-name"].vipVariableName    {{ svi.interface_name_variable | default("not_defined") }}    msg=interface name variable
    Should Be Equal Value Json String    ${r_id.json()}    $["ip-directed-broadcast"].vipValue    {{ svi.ip_directed_broadcast | default("not_defined") | lower() }}    msg=ip directed broadcast
    Should Be Equal Value Json String    ${r_id.json()}    $["ip-directed-broadcast"].vipVariableName    {{ svi.ip_directed_broadcast_variable | default("not_defined") }}    msg=ip directed broadcast variable
    Should Be Equal Value Json String    ${r_id.json()}    $.mtu.vipValue    {{ svi.ip_mtu | default("not_defined") }}    msg=ip mtu
    Should Be Equal Value Json String    ${r_id.json()}    $.mtu.vipVariableName    {{ svi.ip_mtu_variable | default("not_defined") }}    msg=ip mtu variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.address.vipValue    {{ svi.ipv4_address | default("not_defined") }}    msg=ipv4 address
    Should Be Equal Value Json String    ${r_id.json()}    $.ip.address.vipVariableName    {{ svi.ipv4_address_variable | default("not_defined") }}    msg=ipv4 address variable

    ${rec_ipv4_dhcp_helpers_list}=    Get Value From Json    ${r_id.json()}    $["dhcp-helper"].vipValue
    ${exp_ipv4_dhcp_helpers_list}=    Create List    {{ svi.ipv4_dhcp_helpers | default("not_defined") | join('   ') }}
    Lists Should Be Equal    ${rec_ipv4_dhcp_helpers_list[0]}    ${exp_ipv4_dhcp_helpers_list}    ignore_order=True    msg=ipv4 dhcp helpers

    Should Be Equal Value Json String    ${r_id.json()}    $["dhcp-helper"].vipVariableName    {{ svi.ipv4_dhcp_helpers_variable | default("not_defined") }}    msg=ipv4 dhcp helpers variable
    Should Be Equal Value Json String    ${r_id.json()}    $["access-list"].vipValue[?(@.direction.vipValue=="out")]..["acl-name"].vipValue    {{ svi.ipv4_egress_access_list | default("not_defined") }}    msg=ipv4 egress access list
    Should Be Equal Value Json String    ${r_id.json()}    $["access-list"].vipValue[?(@.direction.vipValue=="out")]..["acl-name"].vipVariableName    {{ svi.ipv4_egress_access_list_variable | default("not_defined") }}    msg=ipv4 egress access list variable
    Should Be Equal Value Json String    ${r_id.json()}    $["access-list"].vipValue[?(@.direction.vipValue=="in")]..["acl-name"].vipValue    {{ svi.ipv4_ingress_access_list | default("not_defined") }}    msg=ipv4 ingress access list
    Should Be Equal Value Json String    ${r_id.json()}    $["access-list"].vipValue[?(@.direction.vipValue=="in")]..["acl-name"].vipVariableName    {{ svi.ipv4_ingress_access_list_variable | default("not_defined") }}    msg=ipv4 ingress access list variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.address.vipValue    {{ svi.ipv6_address | default("not_defined") }}    msg=ipv6 address
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6.address.vipVariableName    {{ svi.ipv6_address_variable | default("not_defined") }}    msg=ipv6 address variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6["access-list"].vipValue[?(@.direction.vipValue=="out")]..["acl-name"].vipValue    {{ svi.ipv6_egress_access_list | default("not_defined") }}    msg=ipv6 egress access list
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6["access-list"].vipValue[?(@.direction.vipValue=="out")]..["acl-name"].vipVariableName    {{ svi.ipv6_egress_access_list_variable | default("not_defined") }}    msg=ipv6 egress access list variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6["access-list"].vipValue[?(@.direction.vipValue=="in")]..["acl-name"].vipValue    {{ svi.ipv6_ingress_access_list | default("not_defined") }}    msg=ipv6 ingress access list
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6["access-list"].vipValue[?(@.direction.vipValue=="in")]..["acl-name"].vipVariableName    {{ svi.ipv6_ingress_access_list_variable | default("not_defined") }}    msg=ipv6 ingress access list variable
    Should Be Equal Value Json String    ${r_id.json()}    $["intrf-mtu"].vipValue    {{ svi.mtu | default("not_defined") }}    msg=mtu
    Should Be Equal Value Json String    ${r_id.json()}    $["intrf-mtu"].vipVariableName    {{ svi.mtu_variable | default("not_defined") }}    msg=mtu variable
    Should Be Equal Value Json String    ${r_id.json()}    $.shutdown.vipValue    {{ svi.shutdown | default("not_defined") | lower() }}    msg=shutdown
    Should Be Equal Value Json String    ${r_id.json()}    $.shutdown.vipVariableName    {{ svi.shutdown_variable | default("not_defined") }}    msg=shutdown variable
    Should Be Equal Value Json String    ${r_id.json()}    $["tcp-mss-adjust"].vipValue    {{ svi.tcp_mss | default("not_defined") }}    msg=tcp mss
    Should Be Equal Value Json String    ${r_id.json()}    $["tcp-mss-adjust"].vipVariableName    {{ svi.tcp_mss_variable | default("not_defined") }}    msg=tcp mss variable

    ${ipv4_items}=    Get Value From Json    ${r_id.json()}    $.ip..["secondary-address"].vipValue
    ${ipv4_length}=    Get Length    ${ipv4_items[0]}
    Should Be Equal As Integers    ${ipv4_length}    {{ svi.ipv4_secondary_addresses | length }}    msg=ipv4 secondary addresses

{% for ipv4 in svi.ipv4_secondary_addresses | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["secondary-address"].vipValue[{{loop.index0}}].address.vipValue    {{ ipv4.address | default("not_defined") }}    msg=ipv4 secondary address
    Should Be Equal Value Json String    ${r_id.json()}    $.ip..["secondary-address"].vipValue[{{loop.index0}}].address.vipVariableName    {{ ipv4.address_variable | default("not_defined") }}    msg=ipv4 secondary address variable

{% endfor %}

    ${ipv4_vrrp_items}=    Get Value From Json    ${r_id.json()}    $.vrrp.vipValue
    ${ipv4_vrrp_length}=    Get Length    ${ipv4_vrrp_items[0]}
    Should Be Equal As Integers    ${ipv4_vrrp_length}    {{ svi.ipv4_vrrp_groups | length }}    msg=ipv4 vrrp groups

{% for vrrp_index in range(svi.ipv4_vrrp_groups | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}].ipv4.address.vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].address | default("not_defined") }}    msg=ipv4 vrrp group address
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}].ipv4.address.vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].address_variable | default("not_defined") }}    msg=ipv4 vrrp group address variable
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["grp-id"].vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].id | default("not_defined") }}    msg=ipv4 vrrp group id
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["grp-id"].vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].id_variable | default("not_defined") }}    msg=ipv4 vrrp group id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}].vipOptional    {{ svi.ipv4_vrrp_groups[vrrp_index].optional | default("not_defined") }}    msg=ipv4 vrrp group optional
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}].priority.vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].priority | default("not_defined") }}    msg=ipv4 vrrp group priority
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}].priority.vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].priority_variable | default("not_defined") }}    msg=ipv4 vrrp group priority variable
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}].timer.vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].timer | default("not_defined") }}    msg=ipv4 vrrp group timer
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}].timer.vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].timer_variable | default("not_defined") }}    msg=ipv4 vrrp group timer variable
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["tloc-change-pref"].vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].tloc_preference_change | default("not_defined") | lower() }}    msg=tloc preference change
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}].value.vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].tloc_preference_change_value | default("not_defined") }}    msg=tloc preference change value
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}].value.vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].tloc_preference_change_value_variable | default("not_defined") }}    msg=tloc preference change value variable
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["track-prefix-list"].vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].track_prefix_list | default("not_defined") }}    msg=ipv4 vrrp group track prefix list
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["track-prefix-list"].vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].track_prefix_list_variable | default("not_defined") }}    msg=ipv4 vrrp group track prefix list variable
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["track-omp"].vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].track_omp | default("not_defined") | lower() }}    msg=ipv4 vrrp group track omp
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["track-omp"].vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].track_omp_variable | default("not_defined") }}    msg=ipv4 vrrp group track omp variable

    ${vrrp_sec_add_items}=    Get Value From Json    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["ipv4-secondary"].vipValue
    ${vrrp_sec_add_length}=    Get Length    ${vrrp_sec_add_items[0]}
    Should Be Equal As Integers    ${vrrp_sec_add_length}    {{ svi.ipv4_vrrp_groups[vrrp_index].secondary_addresses | length }}    msg=ipv4 vrrp group secondary addresses

{% for sec_add_index in range(svi.ipv4_vrrp_groups[vrrp_index].secondary_addresses | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["ipv4-secondary"].vipValue[{{ sec_add_index }}].address.vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].secondary_addresses[sec_add_index].address | default("not_defined") }}    msg=ipv4 vrrp secondary address
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["ipv4-secondary"].vipValue[{{ sec_add_index }}].address.vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].secondary_addresses[sec_add_index].address_variable | default("not_defined") }}    msg=ipv4 vrrp secondary address variable

{% endfor %}

    ${vrrp_track_obj_items}=    Get Value From Json    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["tracking-object"].vipValue
    ${vrrp_track_obj_length}=    Get Length    ${vrrp_track_obj_items[0]}
    Should Be Equal As Integers    ${vrrp_track_obj_length}    {{ svi.ipv4_vrrp_groups[vrrp_index].tracking_objects | length }}    msg=tracking objects

{% for track_obj_index in range(svi.ipv4_vrrp_groups[vrrp_index].tracking_objects | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["tracking-object"].vipValue[{{ track_obj_index }}]..["track-action"].vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].tracking_objects[track_obj_index].action | default("not_defined") }}    msg=action
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["tracking-object"].vipValue[{{ track_obj_index }}]..["track-action"].vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].tracking_objects[track_obj_index].action_variable | default("not_defined") }}    msg=action variable
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["tracking-object"].vipValue[{{ track_obj_index }}].decrement.vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].tracking_objects[track_obj_index].decrement_value | default("not_defined") }}    msg=decrement value
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["tracking-object"].vipValue[{{ track_obj_index }}].decrement.vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].tracking_objects[track_obj_index].decrement_value_variable | default("not_defined") }}    msg=decrement value variable
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["tracking-object"].vipValue[{{ track_obj_index }}].name.vipValue    {{ svi.ipv4_vrrp_groups[vrrp_index].tracking_objects[track_obj_index].id | default("not_defined") }}    msg=tracking object id
    Should Be Equal Value Json String    ${r_id.json()}    $.vrrp.vipValue[{{ vrrp_index }}]..["tracking-object"].vipValue[{{ track_obj_index }}].name.vipVariableName    {{ svi.ipv4_vrrp_groups[vrrp_index].tracking_objects[track_obj_index].id_variable | default("not_defined") }}    msg=tracking object id variable

{% endfor %}

{% endfor %}

    ${dhcp_helper_v6_items}=    Get Value From Json    ${r_id.json()}    $.ipv6..["dhcp-helper-v6"].vipValue
    ${dhcp_helper_v6_length}=    Get Length    ${dhcp_helper_v6_items[0]}
    Should Be Equal As Integers    ${dhcp_helper_v6_length}    {{ svi.ipv6_dhcp_helpers | length }}    msg=ipv6 dhcp helpers

{% for ipv6_dhcp_helper in svi.ipv6_dhcp_helpers %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6..["dhcp-helper-v6"].vipValue[{{loop.index0}}].address.vipValue    {{ ipv6_dhcp_helper.address | default("not_defined") }}    msg=ipv6 dhcp helper address
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6..["dhcp-helper-v6"].vipValue[{{loop.index0}}].address.vipVariableName    {{ ipv6_dhcp_helper.address_variable | default("not_defined") }}    msg=ipv6 dhcp helper address variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6..["dhcp-helper-v6"].vipValue[{{loop.index0}}].vpn.vipValue    {{ ipv6_dhcp_helper.vpn_id | default("not_defined") }}    msg=vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6..["dhcp-helper-v6"].vipValue[{{loop.index0}}].vpn.vipVariableName    {{ ipv6_dhcp_helper.vpn_id_variable | default("not_defined") }}    msg=vpn id variable

{% endfor %}

    ${ipv6_items}=    Get Value From Json    ${r_id.json()}    $.ipv6["secondary-address"].vipValue
    ${ipv6_length}=    Get Length    ${ipv6_items[0]}
    Should Be Equal As Integers    ${ipv6_length}    {{ svi.ipv6_secondary_addresses | length }}     msg=ipv6 secondary addresses

{% for ipv6 in svi.ipv6_secondary_addresses | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6["secondary-address"].vipValue[{{loop.index0}}].address.vipValue    {{ ipv6.address | default("not_defined") }}    msg=ipv6 secondary address
    Should Be Equal Value Json String    ${r_id.json()}    $.ipv6["secondary-address"].vipValue[{{loop.index0}}].address.vipVariableName    {{ ipv6.address_variable | default("not_defined") }}    msg=ipv6 secondary address variable

{% endfor %}

    ${ipv6_vrrp_items}=    Get Value From Json    ${r_id.json()}    $["ipv6-vrrp"].vipValue
    ${ipv6_vrrp_length}=    Get Length    ${ipv6_vrrp_items[0]}
    Should Be Equal As Integers    ${ipv6_vrrp_length}    {{ svi.ipv6_vrrp_groups | length }}    msg=ipv6 vrrp groups

{% for ipv6_vrrp_index in range(svi.ipv6_vrrp_groups | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}]..["grp-id"].vipValue    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].id | default("not_defined") }}    msg=ipv6 vrrp group id
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}]..["grp-id"].vipVariableName    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].id_variable | default("not_defined") }}    msg=ipv6 vrrp group id variable
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}].ipv6.vipValue..prefix.vipValue    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].global_prefix | default("not_defined") }}    msg=global prefix
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}].ipv6.vipValue..prefix.vipVariableName    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].global_prefix_variable | default("not_defined") }}    msg=global prefix variable
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}].ipv6.vipValue..["ipv6-link-local"].vipValue    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].link_local_address | default("not_defined") }}    msg=link local address
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}].ipv6.vipValue..["ipv6-link-local"].vipVariableName    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].link_local_address_variable | default("not_defined") }}    msg=link local address variable
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}].vipOptional    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].optional | default("not_defined") }}    msg=ipv6 vrrp group optional
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}].priority.vipValue    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].priority | default("not_defined") }}    msg=ipv6 vrrp group priority
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}].priority.vipVariableName    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].priority_variable | default("not_defined") }}    msg=ipv6 vrrp group priority variable
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}].timer.vipValue    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].timer | default("not_defined") }}    msg=ipv6 vrrp group timer
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}].timer.vipVariableName    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].timer_variable | default("not_defined") }}    msg=ipv6 vrrp group timer variable
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}]..["track-prefix-list"].vipValue    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].track_prefix_list | default("not_defined") }}    msg=ipv6 vrrp group track prefix list
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}]..["track-prefix-list"].vipVariableName    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].track_prefix_list_variable | default("not_defined") }}    msg=ipv6 vrrp group track prefix list variable
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}]..["track-omp"].vipValue    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].track_omp | default("not_defined") | lower() }}    msg=ipv6 vrrp group track omp
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}]..["track-omp"].vipVariableName    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].track_omp_variable | default("not_defined") }}    msg=ipv6 vrrp group track omp variable

    ${ipv6_vrrp_sec_add_items}=    Get Value From Json    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}]..["ipv6-secondary"].vipValue
    ${ipv6_vrrp_sec_add_length}=    Get Length    ${ipv6_vrrp_sec_add_items[0]}
    Should Be Equal As Integers    ${ipv6_vrrp_sec_add_length}    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].secondary_addresses | length }}    msg=ipv6 vrrp group secondary addresses

{% for ipv6_sec_add_index in range(svi.ipv6_vrrp_groups[ipv6_vrrp_index].secondary_addresses | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}]..["ipv6-secondary"].vipValue[{{ ipv6_sec_add_index }}].prefix.vipValue    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].secondary_addresses[ipv6_sec_add_index].address | default("not_defined") }}    msg=ipv6 vrrp secondary address
    Should Be Equal Value Json String    ${r_id.json()}    $["ipv6-vrrp"].vipValue[{{ ipv6_vrrp_index }}]..["ipv6-secondary"].vipValue[{{ ipv6_sec_add_index }}].prefix.vipVariableName    {{ svi.ipv6_vrrp_groups[ipv6_vrrp_index].secondary_addresses[ipv6_sec_add_index].address_variable | default("not_defined") }}    msg=ipv6 vrrp secondary address variable

{% endfor %}

{% endfor %}

    ${arp_items}=    Get Value From Json    ${r_id.json()}    $.arp.ip.vipValue
    ${arp_length}=    Get Length    ${arp_items[0]}
    Should Be Equal As Integers    ${arp_length}    {{ svi.static_arps | length }}    msg=static arps

{% for arp in svi.static_arps %}

    Should Be Equal Value Json String    ${r_id.json()}    $.arp.ip.vipValue[{{loop.index0}}].addr.vipValue    {{ arp.ip_address | default("not_defined") }}    msg=ip address
    Should Be Equal Value Json String    ${r_id.json()}    $.arp.ip.vipValue[{{loop.index0}}].addr.vipVariableName    {{ arp.ip_address_variable | default("not_defined") }}    msg=ip address variable
    Should Be Equal Value Json String    ${r_id.json()}    $.arp.ip.vipValue[{{loop.index0}}].mac.vipValue    {{ arp.mac_address | default("not_defined") }}    msg=mac address
    Should Be Equal Value Json String    ${r_id.json()}    $.arp.ip.vipValue[{{loop.index0}}].mac.vipVariableName    {{ arp.mac_address_variable | default("not_defined") }}    msg=mac address variable
    Should Be Equal Value Json String    ${r_id.json()}    $.arp.ip.vipValue[{{loop.index0}}].vipOptional    {{ arp.optional | default("not_defined") }}    msg=arp optional

{% endfor %}

{% endfor %}

{% endif %}
