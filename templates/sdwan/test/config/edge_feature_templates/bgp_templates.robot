*** Settings ***
Documentation   Verify BGP Feature Template Configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    bgp_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.bgp_templates is defined %}

*** Test Cases ***
Get BGP Feature Template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_bgp")]
    Set Suite Variable    ${r}

{% for bgp in sdwan.edge_feature_templates.bgp_templates | default([]) %}

Verify Edge Feature BGP Configuration Template {{ bgp.name }}
    ${bgp_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ bgp.name }}")]
    Should Be Equal Value Json String    ${bgp_id}    $..templateName    {{ bgp.name }}    msg=name
    Should Be Equal Value Json String    ${bgp_id}    $..templateDescription    {{ bgp.description }}    msg=description

{% set test_list = [] %}
{% for item in bgp.device_types | default(defaults.sdwan.edge_feature_templates.bgp_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=  Get Value From Json   ${r}   $[?(@..templateName=="{{ bgp.name }}")].deviceType
    ${test_list}=   Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list}[0]    ${test_list}    ignore_order=True    msg= {{ bgp.name }} template device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{bgp.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}
    Set Suite Variable   ${r_id}
 
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.med.always-compare.vipValue    {{ bgp.always_compare_med | default("not_defined") | lower() }}    msg=always compare med
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.med.always-compare.vipVariableName    {{ bgp.always_compare_med_variable | default("not_defined") }}    msg=always compare med variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].as-num.vipValue    {{ bgp.as_number | default("not_defined") }}    msg=as number
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].as-num.vipVariableName    {{ bgp.as_number_variable | default("not_defined") }}    msg=as number variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.compare-router-id.vipValue    {{ bgp.compare_router_id | default("not_defined") | lower() }}    msg=compare router id
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.compare-router-id.vipVariableName    {{ bgp.compare_router_id_variable | default("not_defined") }}    msg=compare router id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.med.deterministic.vipValue    {{ bgp.deterministic_med | default("not_defined") | lower() }}    msg=deterministic med
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.med.deterministic.vipVariableName    {{ bgp.deterministic_med_variable | default("not_defined") }}    msg=deterministic med variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].distance.external.vipValue    {{ bgp.distance_external | default("not_defined") }}    msg=distance external
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].distance.external.vipVariableName    {{ bgp.distance_external_variable | default("not_defined") }}    msg=distance external variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].distance.local.vipValue    {{ bgp.distance_local | default("not_defined") }}    msg=distance local
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].distance.local.vipVariableName    {{ bgp.distance_local_variable | default("not_defined") }}    msg=distance local variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].distance.internal.vipValue    {{ bgp.distance_internal | default("not_defined") }}    msg=distance internal
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].distance.internal.vipVariableName    {{ bgp.distance_internal_variable | default("not_defined") }}    msg=distance internal variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].timers.holdtime.vipValue    {{ bgp.holdtime | default("not_defined") }}    msg=holdtime
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].timers.holdtime.vipVariableName    {{ bgp.holdtime_variable | default("not_defined") }}    msg=holdtime variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].timers.keepalive.vipValue    {{ bgp.keepalive | default("not_defined") }}    msg=keepalive
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].timers.keepalive.vipVariableName    {{ bgp.keepalive_variable | default("not_defined") }}    msg=keepalive variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.med.missing-as-worst.vipValue    {{ bgp.missing_med_as_worst | default("not_defined") | lower() }}    msg=missing med as worst
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.med.missing-as-worst.vipVariableName    {{ bgp.missing_med_as_worst_variable | default("not_defined") }}    msg=missing med as worst variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.as-path.multipath-relax.vipValue    {{ bgp.multipath_relax | default("not_defined") | lower() }}    msg=multipath relax
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].best-path.as-path.multipath-relax.vipVariableName    {{ bgp.multipath_relax_variable | default("not_defined") }}    msg=multipath relax variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].propagate-aspath.vipValue    {{ bgp.propagate_as_path | default("not_defined") | lower() }}    msg=propagate as path
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].propagate-aspath.vipVariableName    {{ bgp.propagate_as_path_variable | default("not_defined") }}    msg=propagate as path variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].propagate-community.vipValue    {{ bgp.propagate_community | default("not_defined") | lower() }}    msg=propagate community
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].propagate-community.vipVariableName    {{ bgp.propagate_community_variable | default("not_defined") }}    msg=propagate community variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].router-id.vipValue    {{ bgp.router_id | default("not_defined") }}    msg=router id
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].router-id.vipVariableName    {{ bgp.router_id_variable | default("not_defined") }}    msg=router id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].shutdown.vipValue    {{ bgp.shutdown | default("not_defined") | lower() }}    msg=shutdown
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].shutdown.vipVariableName    {{ bgp.shutdown_variable | default("not_defined") }}    msg=shutdown variable

{% set ip_list = [] %}
{% set _ = ip_list.append(bgp.ipv4_address_family) %}
{% set _ = ip_list.append(bgp.ipv6_address_family) %}
{% for ip_type in ip_list %}
{% set ip_index = ip_list.index(ip_type) %}

{% if ip_type == bgp.ipv4_address_family %}
{% set af = 'ipv4_address_family' %}
{% elif ip_type == bgp.ipv6_address_family %}
{% set af = 'ipv6_address_family' %}
{% endif %}
Verify Edge Feature BGP Configuration With Address FamilyTemplate {{ af }}

    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{loop.index0}}].default-information.originate.vipValue    {{ ip_type.default_information_originate | default("not_defined") | lower()}}    msg= default information originate
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{loop.index0}}].default-information.originate.vipVariableName    {{ ip_type.default_information_originate_variable | default("not_defined") }}    msg=default information originate variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{loop.index0}}].maximum-paths.paths.vipValue    {{ ip_type.maximum_paths| default("not_defined") }}    msg=maximum paths
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{loop.index0}}].maximum-paths.paths.vipVariableName    {{ ip_type.maximum_paths_variable | default("not_defined") }}    msg=maximum paths variable

    ${family_type}=    Get Value From Json    ${r_id.json()}    $..["bgp"].address-family.vipValue[{{loop.index0}}].family-type.vipValue
    IF  $family_type == ['ipv4-unicast']
        ${aggregate_addresses}=   Set Variable   'aggregate-address'
    ELSE IF   $family_type == ['ipv6-unicast']
        ${aggregate_addresses}=   Set Variable   'ipv6-aggregate-address'
    ELSE IF   $family_type == []
        ${aggregate_addresses}=   Set Variable   ' '
    END
    Should Be Equal Value Json List Length    ${r_id.json()}    $..["bgp"].address-family.vipValue[{{loop.index0}}].${aggregate_addresses}.vipValue    {{ ip_type.aggregate_addresses | length }}    msg=aggregate addresses length
{% for aggregate in ip_type.aggregate_addresses | default([]) %} 
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${aggregate_addresses}.vipValue[{{loop.index0}}].prefix.vipValue    {{ aggregate.prefix | default("not_defined") }}    msg=aggregate prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${aggregate_addresses}.vipValue[{{loop.index0}}].prefix.vipVariableName    {{ aggregate.prefix_variable | default("not_defined") }}    msg=aggregate prefix variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${aggregate_addresses}.vipValue[{{loop.index0}}].as-set.vipValue    {{ aggregate.as_set_path | default("not_defined") | lower() }}    msg=as set path
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${aggregate_addresses}.vipValue[{{loop.index0}}].as-set.vipVariableName    {{ aggregate.as_set_path_variable | default("not_defined") }}    msg=as set path variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${aggregate_addresses}.vipValue[{{loop.index0}}].summary-only.vipValue    {{ aggregate.summary_only | default("not_defined") | lower() }}    msg=aggregate summary only
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${aggregate_addresses}.vipValue[{{loop.index0}}].summary-only.vipVariableName    {{ aggregate.summary_only_variable | default("not_defined") }}    msg=aggregate summary only variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${aggregate_addresses}.vipValue[{{loop.index0}}].vipOptional    {{ aggregate.optional | default("not_defined") }}    msg=aggregate optional
{% endfor %}
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[0].table-map.name.vipValue    {{ ip_type.table_map_policy| default("not_defined") }}    msg=table map policy
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[0].table-map.name.vipVariableName    {{ ip_type.table_map_policy_variable | default("not_defined") }}    msg=table map policy variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[0].table-map.filter.vipValue    {{ ip_type.table_map_filter| default("not_defined") | lower() }}    msg=table map filter policy
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[0].table-map.filter.vipVariableName    {{ ip_type.table_map_filter_variable | default("not_defined") }}    msg=table map filter policy variable

    IF    $family_type == ['ipv4-unicast']
        ${ip_type}=   Set Variable   'ipv4-unicast'
    ELSE IF    $family_type == ['ipv6-unicast']
        ${ip_type}=   Set Variable   'ipv6-unicast'
    ELSE IF   $family_type == []
        ${ip_type}=   Set Variable   ' '
    END
    Should Be Equal Value Json List Length    ${r_id.json()}    $..["bgp"].address-family.vipValue[?(@.family-type.vipValue==${ip_type})].redistribute.vipValue    {{ ip_type.redistributes | length }}    msg=redistributes length    
{% for redistribute in ip_type.redistributes | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[?(@.family-type.vipValue==${ip_type})].redistribute.vipValue[{{loop.index0}}].protocol.vipValue    {{ redistribute.protocol | default("not_defined") }}    msg=redistribute protocol
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[?(@.family-type.vipValue==${ip_type})].redistribute.vipValue[{{loop.index0}}].protocol.vipVariableName    {{ redistribute.protocol_variable | default("not_defined") }}    msg=redistribute protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[?(@.family-type.vipValue==${ip_type})].redistribute.vipValue[{{loop.index0}}].route-policy.vipValue    {{ redistribute.route_policy | default("not_defined") }}    msg=route policy
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[?(@.family-type.vipValue==${ip_type})].redistribute.vipValue[{{loop.index0}}].route-policy.vipVariableName    {{ redistribute.route_policy_variable | default("not_defined") }}    msg=route policy variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[?(@.family-type.vipValue==${ip_type})].redistribute.vipValue[{{loop.index0}}].vipOptional   {{ redistribute.optional | default("not_defined") }}    msg=redistribute optional
{% endfor %}

{% if ip_type == bgp.ipv4_address_family %}
{% set neighbor1 = 'neighbor' %}
{% elif ip_type == bgp.ipv6_address_family %}
{% set neighbor1 = 'ipv6-neighbor' %}
{% endif %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $..["bgp"].{{neighbor1}}.vipValue    {{ ip_type.neighbors | length }}    msg=neighbors length

{% for neighbor in ip_type.neighbors | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address.vipValue    {{ neighbor.address | default("not_defined") }}    msg=neighbor address
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address.vipVariableName    {{ neighbor.address_variable | default("not_defined") }}    msg=neighbor address variable

    Should Be Equal Value Json List Length    ${r_id.json()}    $..["bgp"].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue    {{ neighbor.address_families | length }}    msg=neighbors address families length
{% for address_family in neighbor.address_families | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].family-type.vipValue    {{ address_family.family_type | default("not_defined") }}    msg=address family type
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].maximum-prefixes.prefix-num.vipValue    {{ address_family.maximum_prefixes | default("not_defined") }}    msg=address family maximum prefixes
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].maximum-prefixes.prefix-num.vipVariableName    {{ address_family.maximum_prefixes_variable | default("not_defined") }}    msg=address family maximum prefixes variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].maximum-prefixes.restart.vipValue    {{ address_family.maximum_prefixes_restart | default("not_defined") }}    msg=address family maximum prefixes restart
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].maximum-prefixes.restart.vipVariableName    {{ address_family.maximum_prefixes_restart_variable | default("not_defined") }}    msg=address family maximum prefixes restart variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].maximum-prefixes.threshold.vipValue    {{ address_family.maximum_prefixes_threshold | default("not_defined") }}    msg=address family maximum prefixes threshold
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].maximum-prefixes.threshold.vipVariableName    {{ address_family.maximum_prefixes_threshold_variable | default("not_defined") }}    msg=address family maximum prefixes threshold variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].maximum-prefixes.warning-only.vipValue    {{ address_family.maximum_prefixes_warning_only | default("not_defined") | lower() }}    msg=address family maximum prefixes warning only
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].maximum-prefixes.warning-only.vipVariableName    {{ address_family.maximum_prefixes_warning_only_variable | default("not_defined") }}    msg=address family maximum prefixes warning only variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].route-policy.vipValue[?(@.direction.vipValue=="in")]..["pol-name"].vipValue    {{ address_family.route_policy_in | default("not_defined") }}    msg=address family route policy in
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].route-policy.vipValue[?(@.direction.vipValue=="in")]..["pol-name"].vipVariableName    {{ address_family.route_policy_in_variable | default("not_defined") }}    msg=address family family route policy in variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].route-policy.vipValue[?(@.direction.vipValue=="out")]..["pol-name"].vipValue    {{ address_family.route_policy_out | default("not_defined") }}    msg=address family route policy out
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].route-policy.vipValue[?(@.direction.vipValue=="in")]..["pol-name"].vipVariableName    {{ address_family.route_policy_out_variable | default("not_defined") }}    msg=address family family route policy out variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].address-family.vipValue[{{loop.index0}}].vipOptional   {{ address_family.optional | default("not_defined") }}    msg=address family optional
{% endfor %}

    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].allowas-in.as-number.vipValue    {{ neighbor.allow_as_in | default("not_defined") }}    msg=neighbor allow as
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].allowas-in.as-number.vipVariableName    {{ neighbor.allow_as_in_variable | default("not_defined") }}    msg=variable neighbor allow as
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].as-override.vipValue    {{ neighbor.as_override | default("not_defined") | lower() }}    msg=neighbor as override
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].as-override.vipVariableName    {{ neighbor.as_override_variable | default("not_defined") }}    msg=variable neighbor as override
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].description.vipValue    {{ neighbor.description | default("not_defined") }}    msg=neighbor description
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].description.vipVariableName    {{ neighbor.description_variable | default("not_defined") }}    msg=neighbor description variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].ebgp-multihop.vipValue    {{ neighbor.ebgp_multihop | default("not_defined") }}    msg=neighbor ebgp multihop
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].ebgp-multihop.vipVariableName    {{ neighbor.ebgp_multihop_variable | default("not_defined") }}    msg=neighbor ebgp multihop variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].next-hop-self.vipValue    {{ neighbor.next_hop_self | default("not_defined") | lower() }}    msg=neighbor next hop self
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].next-hop-self.vipVariableName    {{ neighbor.next_hop_self_variable | default("not_defined") }}    msg=neighbor next hop self variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].password.vipValue    {{ neighbor.password | default("not_defined") }}    msg=neighbor password
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].password.vipVariableName    {{ neighbor.password_variable | default("not_defined") }}    msg=neighbor password variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].remote-as.vipValue    {{ neighbor.remote_as | default("not_defined") }}    msg=neighbor remote as
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].remote-as.vipVariableName    {{ neighbor.remote_as_variable | default("not_defined") }}    msg=neighbor remote as variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].send-community.vipValue    {{ neighbor.send_community | default("not_defined") | lower() }}    msg=neighbor send community
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].send-community.vipVariableName    {{ neighbor.send_community_variable | default("not_defined") }}    msg=neighbor send community variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].send-ext-community.vipValue    {{ neighbor.send_extended_community | default("not_defined") | lower() }}    msg=neighbor send extended community
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].send-ext-community.vipVariableName    {{ neighbor.send_extended_community_variable | default("not_defined") }}    msg=neighbor send extended community variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].send-label.vipValue    {{ neighbor.send_label | default("not_defined") | lower() }}    msg=neighbor send label
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].send-label.vipVariableName    {{ neighbor.send_label_variable | default("not_defined") }}    msg=neighbor send label variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].send-label-explicit.vipValue    {{ neighbor.send_label_explicit_null | default("not_defined") | lower() }}    msg=neighbor send label explicit null
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].send-label-explicit.vipVariableName    {{ neighbor.send_label_explicit_null_variable | default("not_defined") }}    msg=neighbor send label explicit null variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].shutdown.vipValue    {{ neighbor.shutdown | default("not_defined") | lower() }}    msg=neighbor shutdown
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].shutdown.vipVariableName    {{ neighbor.shutdown_variable | default("not_defined") }}    msg=neighbor shutdown variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].update-source.if-name.vipValue    {{ neighbor.source_interface | default("not_defined") }}    msg=neighbor source interface
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].update-source.if-name.vipVariableName    {{ neighbor.source_interface_variable | default("not_defined") }}    msg=neighbor source interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].timers.keepalive.vipValue    {{ neighbor.keepalive | default("not_defined") }}    msg=neighbor keepalive
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].timers.keepalive.vipVariableName    {{ neighbor.keepalive_variable | default("not_defined") }}    msg=neighbor keepalive variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].timers.holdtime.vipValue    {{ neighbor.holdtime | default("not_defined") }}    msg=neighbor holdtime
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].timers.holdtime.vipVariableName    {{ neighbor.holdtime_variable | default("not_defined") }}    msg=neighbor holdtime variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].{{neighbor1}}.vipValue[{{loop.index0}}].vipOptional   {{ neighbor.optional | default("not_defined") }}    msg=neighbor optional
{% endfor %}

    ${family_type}=    Get Value From Json    ${r_id.json()}    $..["bgp"].address-family.vipValue[{{loop.index0}}].family-type.vipValue
    IF  $family_type == ['ipv4-unicast']
        ${network_type}=   Set Variable   'network'
    ELSE IF   $family_type == ['ipv6-unicast']
        ${network_type}=   Set Variable   'ipv6-network'
    ELSE IF   $family_type == []
        ${network_type}=   Set Variable   ' '
    END

    Should Be Equal Value Json List Length    ${r_id.json()}    $..["bgp"].address-family.vipValue[{{loop.index0}}].${network_type}.vipValue    {{ ip_type.networks | length }}    msg=networks length
{% for network in ip_type.networks | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${network_type}.vipValue[{{loop.index0}}].prefix.vipValue    {{ network.prefix | default("not_defined") }}    msg=network prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${network_type}.vipValue[{{loop.index0}}].prefix.vipVariableName    {{ network.prefix_variable | default("not_defined") }}    msg=network prefix variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].address-family.vipValue[{{ip_index}}].${network_type}.vipValue[{{loop.index0}}].vipOptional    {{ network.optional | default("not_defined") }}    msg=network optional
{% endfor %}

{% if ip_type == bgp.ipv4_address_family %}
{% set target_type = 'route-target-ipv4' %}
{% elif ip_type == bgp.ipv6_address_family %}
{% set target_type = 'route-target-ipv6' %}
{% endif %}

    Should Be Equal Value Json List Length   ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue    {{ ip_type.route_targets | length }}    msg=route target length

{% for target_index in range(ip_type.route_targets | default([]) | length()) %}
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue[{{ target_index }}].vpn-id.vipValue    {{ ip_type.route_targets[target_index].vpn_id | default("not_defined") }}    msg=route target vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue[{{ target_index }}].vpn-id.vipVariableName    {{ ip_type.route_targets[target_index].vpn_id_variable | default("not_defined") }}    msg=route target vpn id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue[{{ target_index }}].vipOptional    {{ ip_type.route_targets[target_index].optional | default("not_defined") }}    msg=route target optional

    Should Be Equal Value Json List Length   ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue[{{target_index}}].import.vipValue    {{ ip_type.route_targets[target_index].imports | length }}    msg=route target imports length
{% for import_index in range(ip_type.route_targets[target_index].imports | default([]) | length()) %}
{% if ip_type.route_targets[target_index].imports[import_index].asn_ip != not_defined %}    
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue[{{target_index}}].import.vipValue..asn-ip..vipValue    {{ ip_type.route_targets[target_index].imports[import_index].asn_ip | default("not_defined") }}    msg=route target import asn ip
{% else %}
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue[{{target_index}}].import.vipValue..asn-ip..vipVariableName    {{ ip_type.route_targets[target_index].imports[import_index].asn_ip_variable | default("not_defined") }}    msg=route target import asn ip variable
{% endif %}
{% endfor %}
    Should Be Equal Value Json List Length   ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue[{{target_index}}].export.vipValue    {{ ip_type.route_targets[target_index].exports | length }}    msg=route target exports length
{% for export_index in range(ip_type.route_targets[target_index].exports | default([]) | length()) %}
{% if ip_type.route_targets[target_index].exports[export_index].asn_ip != not_defined %}
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue[{{target_index}}].export.vipValue..asn-ip..vipValue    {{ ip_type.route_targets[target_index].exports[export_index].asn_ip | default("not_defined") }}    msg=route target export asn ip
{% else %}
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].target.{{ target_type }}.vipValue[{{target_index}}].export.vipValue..asn-ip..vipVariableName    {{ ip_type.route_targets[target_index].exports[export_index].asn_ip_variable | default("not_defined") }}    msg=route target export asn ip variable
{% endif %}
{% endfor %}

{% endfor %}
{% endfor %}

Verify Edge Feature BGP Configuration With MPLS Interfaces
    Should Be Equal Value Json List Length    ${r_id.json()}    $.[bgp].mpls-interface.vipValue    {{ bgp.mpls_interfaces | length }}    msg=mpls interfaces length
{% for mpls_int in bgp.mpls_interfaces | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].mpls-interface.vipValue[{{loop.index0}}].if-name.vipValue    {{ mpls_int.interface_name | default("not_defined") }}    msg=mpls interfaces list
    Should Be Equal Value Json String    ${r_id.json()}    $.[bgp].mpls-interface.vipValue[{{loop.index0}}].if-name.vipVariableName    {{ mpls_int.interface_name_variable | default("not_defined") }}    msg=mpls interfaces list variable
{% endfor %}

{% endfor %}
{% endif %}
