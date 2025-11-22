*** Settings ***
Documentation   Verify Service Feature Profile Configuration BGP Features
Name            Service Profiles BGP Features
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     service_profiles    bgp
Resource        ../../../sdwan_common.resource


{% set profile_bgp_list = [] %}
{% for profile in sdwan.get('feature_profiles', {}).get('service_profiles', {}) %}
 {% if profile.bgp_features is defined %}
  {% set _ = profile_bgp_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_bgp_list != [] %}

*** Test Cases ***
Get Service Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.service_profiles | default([]) %}
{% if profile.bgp_features is defined %}

Verify Feature Profiles Service Profiles {{ profile.name }} BGP Feature
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    Set Suite Variable    ${profile}
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}
    ${service_bgp_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}/routing/bgp
    Set Suite Variable    ${service_bgp_res}
    ${service_bgp}=    Get Value From Json    ${service_bgp_res.json()}    $..payload
    Run Keyword If    ${service_bgp} == []    Fail    BGP feature(s) expected to be configured within the service profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${service_bgp}

    # Extract route policies since they might be used in BGP
    ${route_policies_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id}[0]/route-policy
    Set Suite Variable    ${route_policies_res}

{% for bgp in profile.bgp_features | default([]) %}
    Log    === BGP: {{ bgp.name }} ===
    
    # for each bgp find the corresponding one in the json and check parameters:
    ${service_bgp_{{ bgp.name }}_raw}=    Get Value From Json    ${service_bgp}    $[?(@.name=='{{ bgp.name }}')]
    ${service_bgp_{{ bgp.name }}}=    Set Variable If    ${service_bgp_{{ bgp.name }}_raw} == []    not_defined    ${service_bgp_{{ bgp.name }}_raw[0]}

    Should Be Equal Value Json String    ${service_bgp_{{ bgp.name }}}    $..name    {{ bgp.name }}    msg=name
    Should Be Equal Value Json Special_String    ${service_bgp_{{ bgp.name }}}    $..description    {{ bgp.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.alwaysCompare    {{ bgp.always_compare_med | default('not_defined') }}    {{ bgp.always_compare_med_variable | default('not_defined') }}    msg=bgp.always_compare_med    var_msg=bgp.always_compare_med_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.asNum    {{ bgp.as_number | default('not_defined') }}    {{ bgp.as_number_variable | default('not_defined') }}    msg=bgp.as_number    var_msg=bgp.as_number
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.routerId    {{ bgp.router_id | default('not_defined') }}    {{ bgp.router_id_variable | default('not_defined') }}    msg=bgp.router_id    var_msg=bgp.router_id_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.deterministic    {{ bgp.deterministic_med | default('not_defined') }}    {{ bgp.deterministic_med_variable | default('not_defined') }}    msg=bgp.deterministic_med    var_msg=bgp.deterministic_med_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.external    {{ bgp.external_routes_distance | default('not_defined') }}    {{ bgp.external_routes_distance_variable | default('not_defined') }}    msg=bgp.external_routes_distance    var_msg=bgp.external_routes_distance_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.holdtime    {{ bgp.hold_time | default('not_defined') }}    {{ bgp.hold_time_variable | default('not_defined') }}    msg=bgp.hold_time    var_msg=bgp.hold_time_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.internal    {{ bgp.internal_routes_distance | default('not_defined') }}    {{ bgp.internal_routes_distance_variable | default('not_defined') }}    msg=bgp.internal_routes_distance    var_msg=bgp.internal_routes_distance_variable

    Log    =====IPv4 Aggregate Addresses=====
{% if bgp.ipv4_aggregate_addresses is defined and bgp.get('ipv4_aggregate_addresses', [])|length > 0 %}
{% for aggregate in bgp.ipv4_aggregate_addresses | default([]) %}
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.aggregateAddress[{{ loop.index0 }}].asSet    {{ aggregate.as_set_path | default('not_defined') }}     {{ aggregate.as_set_path_variable | default('not_defined') }}     msg=bgp.ipv4_aggregate_addresses.as_path_set     var_msg=bgp.ipv4_aggregate_addresses.as_path_set_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.aggregateAddress[{{ loop.index0 }}].prefix.address    {{ aggregate.network_address | default('not_defined') }}     {{ aggregate.network_address_variable | default('not_defined') }}     msg=bgp.ipv4_aggregate_addresses.network_address     var_msg=bgp.ipv4_aggregate_addresses.network_address_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.aggregateAddress[{{ loop.index0 }}].prefix.mask    {{ aggregate.subnet_mask | default('not_defined') }}     {{ aggregate.subnet_mask_variable | default('not_defined') }}     msg=bgp.ipv4_aggregate_addresses.subnet_mask     var_msg=bgp.ipv4_aggregate_addresses.subnet_mask_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.aggregateAddress[{{ loop.index0 }}].summaryOnly    {{ aggregate.summary_only | default('not_defined') }}     {{ aggregate.summary_only_variable | default('not_defined') }}     msg=bgp.ipv4_aggregate_addresses.summary_only     var_msg=bgp.ipv4_aggregate_addresses.summary_only_variable
{% endfor %}
{% endif %}

    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.originate    {{ bgp.ipv4_default_originate | default('not_defined') }}    {{ bgp.ipv4_default_originate_variable | default('not_defined') }}    msg=bgp.ipv4_default_originate    var_msg=bgp.ipv4_default_originate_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.paths    {{ bgp.ipv4_eibgp_maximum_paths | default('not_defined') }}    {{ bgp.ipv4_eibgp_maximum_paths_variable | default('not_defined') }}    msg=bgp.ipv4_eibgp_maximum_paths    var_msg=bgp.ipv4_eibgp_maximum_paths_variable

    Log    =====IPv4 Neighbors=====
    Should Be Equal Value Json List Length    ${service_bgp_{{ bgp.name }}}    $..data.neighbor    {{ bgp.get('ipv4_neighbors', []) | length }}    msg=bgp.ipv4_neighbors length
{% if bgp.ipv4_neighbors is defined and bgp.get('ipv4_neighbors', [])|length > 0 %}
{% for neighbor in bgp.ipv4_neighbors | default([]) %}
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].address    {{ neighbor.address | default('not_defined') }}     {{ neighbor.address_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.address     var_msg=bgp.ipv4_neighbors.address_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].asNumber    {{ neighbor.allowas_in_number | default('not_defined') }}     {{ neighbor.allowas_in_number_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.allowas_in_number     var_msg=bgp.ipv4_neighbors.allowas_in_number_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].asOverride    {{ neighbor.as_override | default('not_defined') }}     {{ neighbor.as_override_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.as_override     var_msg=bgp.ipv4_neighbors.as_override_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].description    {{ neighbor.description | default('not_defined') }}     {{ neighbor.description_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.description     var_msg=bgp.ipv4_neighbors.description_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].ebgpMultihop    {{ neighbor.ebgp_multihop | default('not_defined') }}     {{ neighbor.ebgp_multihop_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.ebgp_multihop     var_msg=bgp.ipv4_neighbors.ebgp_multihop_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].holdtime    {{ neighbor.hold_time | default('not_defined') }}     {{ neighbor.hold_time_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.hold_time     var_msg=bgp.ipv4_neighbors.hold_time_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].keepalive    {{ neighbor.keepalive_time | default('not_defined') }}     {{ neighbor.keepalive_time_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.keepalive_time     var_msg=bgp.ipv4_neighbors.keepalive_time_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].localAs    {{ neighbor.local_as | default('not_defined') }}     {{ neighbor.local_as_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.local_as     var_msg=bgp.ipv4_neighbors.local_as_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].nextHopSelf    {{ neighbor.next_hop_self | default('not_defined') }}     {{ neighbor.next_hop_self_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.next_hop_self     var_msg=bgp.ipv4_neighbors.next_hop_self_variable
    # Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].password    {{ neighbor.password | default('not_defined') }}     {{ neighbor.password_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.password     var_msg=bgp.ipv4_neighbors.password_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].remoteAs    {{ neighbor.remote_as | default('not_defined') }}     {{ neighbor.remote_as_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.remote_as     var_msg=bgp.ipv4_neighbors.remote_as_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].sendCommunity    {{ neighbor.send_community | default('not_defined') }}     {{ neighbor.send_community_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.send_community     var_msg=bgp.ipv4_neighbors.send_community_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].sendExtCommunity    {{ neighbor.send_extended_community | default('not_defined') }}     {{ neighbor.send_extended_community_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.send_extended_community     var_msg=bgp.ipv4_neighbors.send_extended_community_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].sendLabel    {{ neighbor.send_label | default('not_defined') }}     {{ neighbor.send_label_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.send_label     var_msg=bgp.ipv4_neighbors.send_label_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].shutdown    {{ neighbor.shutdown | default('not_defined') }}     {{ neighbor.shutdown_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.shutdown     var_msg=bgp.ipv4_neighbors.shutdown_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].ifName    {{ neighbor.source_interface | default('not_defined') }}     {{ neighbor.source_interface_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.source_interface     var_msg=bgp.ipv4_neighbors.source_interface_variable

    Should Be Equal Value Json List Length    ${service_bgp_{{ bgp.name }}}    $..data.neighbor[{{ loop.index0 }}].addressFamily    {{ bgp.get('ipv4_neighbors', []) | length }}    msg=bgp.ipv4.neighbors length
{% if neighbor.address_families is defined and neighbor.get('address_families', [])|length > 0 %}
{% for af in neighbor.address_families | default([]) %}
    ${af_raw}=    Get Value From Json    ${service_bgp_{{ bgp.name }}}    $.data.neighbor[{{ loop.index0 }}].addressFamily[?(@.familyType.value=='{{ af.family_type }}')]
    Run Keyword If    ${af_raw} == []    Fail    Address Family {{ af.family_type }} expected to be configured in BGP neighbor
    ${af}=    Set Variable If    ${af_raw} == []    not_defined    ${af_raw[0]}

    Should Be Equal Value Json Yaml    ${af}    $.maxPrefixConfig.policyType    {{ af.maximum_prefixes_reach_policy | default('not_defined') }}     not_defined     msg=bgp.ipv4_neighbors.address_families.maximum_prefixes_reach_policy     var_msg=not_defined
    Should Be Equal Value Json Yaml    ${af}    $.maxPrefixConfig.prefixNum    {{ af.maximum_prefixes_number | default('not_defined') }}     {{ af.maximum_prefixes_number_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.address_families.maximum_prefixes_number     var_msg=bgp.ipv4_neighbors.address_families.maximum_prefixes_number_variable
    Should Be Equal Value Json Yaml    ${af}    $.maxPrefixConfig.restartInterval    {{ af.maximum_prefixes_restart_interval | default('not_defined') }}     {{ af.maximum_prefixes_restart_interval_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.address_families.maximum_prefixes_restart_interval     var_msg=bgp.ipv4_neighbors.address_families.maximum_prefixes_restart_interval_variable
    Should Be Equal Value Json Yaml    ${af}    $.maxPrefixConfig.threshold    {{ af.maximum_prefixes_threshold | default('not_defined') }}     {{ af.maximum_prefixes_threshold_variable | default('not_defined') }}     msg=bgp.ipv4_neighbors.address_families.maximum_prefixes_threshold     var_msg=bgp.ipv4_neighbors.address_families.maximum_prefixes_threshold_variable

    ${refid_rpl_in_raw}=    Get Value From Json    ${af}    $.inRoutePolicy.refId.value
    ${refid_rpl_in}=    Set Variable If    ${refid_rpl_in_raw} == []    not_defined    ${refid_rpl_in_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl_in}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ af.route_policy_in | default('not_defined') }}    msg=bgp.ipv4_neighbors.address_families.route_policy_in

    ${refid_rpl_out_raw}=    Get Value From Json    ${af}    $.outRoutePolicy.refId.value
    ${refid_rpl_out}=    Set Variable If    ${refid_rpl_out_raw} == []    not_defined    ${refid_rpl_out_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl_out}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ af.route_policy_out | default('not_defined') }}    msg=bgp.ipv4_neighbors.address_families.route_policy_out
{% endfor %}
{% endif %}

{% endfor %}
{% endif %}

    Log    =====IPv4 Networks=====
    Should Be Equal Value Json List Length    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.network    {{ bgp.get('ipv4_networks', []) | length }}    msg=bgp.ipv4_networks length
{% if bgp.ipv4_networks is defined and bgp.get('ipv4_networks', [])|length > 0 %}
{% for network in bgp.ipv4_networks | default([]) %}
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.network[{{ loop.index0 }}].prefix.address    {{ network.network_address | default('not_defined') }}     {{ network.network_address_variable | default('not_defined') }}     msg=bgp.ipv4_networks.network_address     var_msg=bgp.ipv4_networks.network_address_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.network[{{ loop.index0 }}].prefix.mask    {{ network.subnet_mask | default('not_defined') }}     {{ network.subnet_mask_variable | default('not_defined') }}     msg=bgp.ipv4_networks.subnet_mask     var_msg=bgp.ipv4_networks.subnet_mask_variable
{% endfor %}
{% endif %}

    Log    =====IPv4 Redistributes=====
    Should Be Equal Value Json List Length    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.redistribute    {{ bgp.get('ipv4_redistributes', []) | length }}    msg=bgp.ipv4_redistributes length
{% if bgp.ipv4_redistributes is defined and bgp.get('ipv4_redistributes', [])|length > 0 %}
{% for redistribute in bgp.ipv4_redistributes | default([]) %}
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.redistribute[{{ loop.index0 }}].protocol    {{ redistribute.protocol | default('not_defined') }}     {{ redistribute.protocol_variable | default('not_defined') }}     msg=bgp.ipv4_redistributes.protocol     var_msg=bgp.ipv4_redistributes.protocol_variable

    ${refid_rpl_raw}=    Get Value From Json    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.redistribute[{{ loop.index0 }}].routePolicy.refId.value
    ${refid_rpl}=    Set Variable If    ${refid_rpl_raw} == []    not_defined    ${refid_rpl_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ redistribute.route_policy | default('not_defined') }}    msg=bgp.ipv4_redistributes.route_policy

    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.redistribute[{{ loop.index0 }}].translateRibMetric    {{ redistribute.translate_rib_metric | default('not_defined') }}     {{ redistribute.translate_rib_metric_variable | default('not_defined') }}     msg=bgp.ipv4_redistributes.translate_rib_metric     var_msg=bgp.ipv4_redistributes.translate_rib_metric_variable
{% endfor %}
{% endif %}

    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.filter    {{ bgp.ipv4_table_map_filter | default('not_defined') }}    {{ bgp.ipv4_table_map_filter_variable | default('not_defined') }}    msg=bgp.ipv4_table_map_filter    var_msg=bgp.ipv4_table_map_filter_variable

    ${refid_rpl_raw}=    Get Value From Json    ${service_bgp_{{ bgp.name }}}    $..data.addressFamily.name.refId.value
    ${refid_rpl}=    Set Variable If    ${refid_rpl_raw} == []    not_defined    ${refid_rpl_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ bgp.ipv4_table_map_route_policy | default('not_defined') }}    msg=bgp.ipv4_table_map_route_policy

    Log    =====IPv6 Aggregate Addresses=====
{% if bgp.ipv6_aggregate_addresses is defined and bgp.get('ipv6_aggregate_addresses', [])|length > 0 %}
{% for aggregate in bgp.ipv6_aggregate_addresses | default([]) %}
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.ipv6AggregateAddress[{{ loop.index0 }}].asSet    {{ aggregate.as_set_path | default('not_defined') }}     {{ aggregate.as_set_path_variable | default('not_defined') }}     msg=bgp.ipv6_aggregate_addresses.as_path_set     var_msg=bgp.ipv6_aggregate_addresses.as_path_set_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.ipv6AggregateAddress[{{ loop.index0 }}].prefix    {{ aggregate.prefix | default('not_defined') }}     {{ aggregate.prefix_variable | default('not_defined') }}     msg=bgp.ipv6_aggregate_addresses.prefix     var_msg=bgp.ipv6_aggregate_addresses.prefix_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.ipv6AggregateAddress[{{ loop.index0 }}].summaryOnly    {{ aggregate.summary_only | default('not_defined') }}     {{ aggregate.summary_only_variable | default('not_defined') }}     msg=bgp.ipv6_aggregate_addresses.summary_only     var_msg=bgp.ipv6_aggregate_addresses.summary_only_variable
{% endfor %}
{% endif %}

    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.originate    {{ bgp.ipv6_default_originate | default('not_defined') }}    {{ bgp.ipv6_default_originate_variable | default('not_defined') }}    msg=bgp.ipv6_default_originate    var_msg=bgp.ipv6_default_originate_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.paths    {{ bgp.ipv6_eibgp_maximum_paths | default('not_defined') }}    {{ bgp.ipv6_eibgp_maximum_paths_variable | default('not_defined') }}    msg=bgp.ipv6_eibgp_maximum_paths    var_msg=bgp.ipv6_eibgp_maximum_paths_variable

    Log    =====IPv6 Neighbors=====
    Should Be Equal Value Json List Length    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor    {{ bgp.get('ipv6_neighbors', []) | length }}    msg=bgp.ipv6_neighbors length
{% if bgp.ipv6_neighbors is defined and bgp.get('ipv6_neighbors', [])|length > 0 %}
{% for neighbor in bgp.ipv6_neighbors | default([]) %}
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].address    {{ neighbor.address | default('not_defined') }}     {{ neighbor.address_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.address     var_msg=bgp.ipv6_neighbors.address_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].asNumber    {{ neighbor.allowas_in_number | default('not_defined') }}     {{ neighbor.allowas_in_number_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.allowas_in_number     var_msg=bgp.ipv6_neighbors.allowas_in_number_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].asOverride    {{ neighbor.as_override | default('not_defined') }}     {{ neighbor.as_override_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.as_override     var_msg=bgp.ipv6_neighbors.as_override_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].description    {{ neighbor.description | default('not_defined') }}     {{ neighbor.description_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.description     var_msg=bgp.ipv6_neighbors.description_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].ebgpMultihop    {{ neighbor.ebgp_multihop | default('not_defined') }}     {{ neighbor.ebgp_multihop_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.ebgp_multihop     var_msg=bgp.ipv6_neighbors.ebgp_multihop_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].holdtime    {{ neighbor.hold_time | default('not_defined') }}     {{ neighbor.hold_time_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.hold_time     var_msg=bgp.ipv6_neighbors.hold_time_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].keepalive    {{ neighbor.keepalive_time | default('not_defined') }}     {{ neighbor.keepalive_time_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.keepalive_time     var_msg=bgp.ipv6_neighbors.keepalive_time_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].localAs    {{ neighbor.local_as | default('not_defined') }}     {{ neighbor.local_as_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.local_as     var_msg=bgp.ipv6_neighbors.local_as_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].nextHopSelf    {{ neighbor.next_hop_self | default('not_defined') }}     {{ neighbor.next_hop_self_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.next_hop_self     var_msg=bgp.ipv6_neighbors.next_hop_self_variable
    # Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].password    {{ neighbor.password | default('not_defined') }}     {{ neighbor.password_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.password     var_msg=bgp.ipv6_neighbors.password_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].remoteAs    {{ neighbor.remote_as | default('not_defined') }}     {{ neighbor.remote_as_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.remote_as     var_msg=bgp.ipv6_neighbors.remote_as_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].sendCommunity    {{ neighbor.send_community | default('not_defined') }}     {{ neighbor.send_community_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.send_community     var_msg=bgp.ipv6_neighbors.send_community_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].sendExtCommunity    {{ neighbor.send_extended_community | default('not_defined') }}     {{ neighbor.send_extended_community_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.send_extended_community     var_msg=bgp.ipv6_neighbors.send_extended_community_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].sendLabel    {{ neighbor.send_label | default('not_defined') }}     {{ neighbor.send_label_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.send_label     var_msg=bgp.ipv6_neighbors.send_label_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].sendLabelExplicit    {{ neighbor.send_label_explicit_null | default('not_defined') }}     {{ neighbor.send_label_explicit_null_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.send_label_explicit_null     var_msg=bgp.ipv6_neighbors.send_label_explicit_null_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].shutdown    {{ neighbor.shutdown | default('not_defined') }}     {{ neighbor.shutdown_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.shutdown     var_msg=bgp.ipv6_neighbors.shutdown_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].ifName    {{ neighbor.source_interface | default('not_defined') }}     {{ neighbor.source_interface_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.source_interface     var_msg=bgp.ipv6_neighbors.source_interface_variable

    Should Be Equal Value Json List Length    ${service_bgp_{{ bgp.name }}}    $..data.ipv6Neighbor[{{ loop.index0 }}].addressFamily    {{ bgp.get('ipv6_neighbors', []) | length }}    msg=bgp.ipv6.neighbors length
{% if neighbor.address_families is defined and neighbor.get('address_families', [])|length > 0 %}
{% for af in neighbor.address_families | default([]) %}
    ${af_raw}=    Get Value From Json    ${service_bgp_{{ bgp.name }}}    $.data.ipv6Neighbor[{{ loop.index0 }}].addressFamily[?(@.familyType.value=='{{ af.family_type }}')]
    Run Keyword If    ${af_raw} == []    Fail    Address Family {{ af.family_type }} expected to be configured in BGP neighbor
    ${af}=    Set Variable If    ${af_raw} == []    not_defined    ${af_raw[0]}

    Should Be Equal Value Json Yaml    ${af}    $.maxPrefixConfig.policyType    {{ af.maximum_prefixes_reach_policy | default('not_defined') }}     not_defined     msg=bgp.ipv6_neighbors.address_families.maximum_prefixes_reach_policy     var_msg=not_defined
    Should Be Equal Value Json Yaml    ${af}    $.maxPrefixConfig.prefixNum    {{ af.maximum_prefixes_number | default('not_defined') }}     {{ af.maximum_prefixes_number_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.address_families.maximum_prefixes_number     var_msg=bgp.ipv6_neighbors.address_families.maximum_prefixes_number_variable
    Should Be Equal Value Json Yaml    ${af}    $.maxPrefixConfig.restartInterval    {{ af.maximum_prefixes_restart_interval | default('not_defined') }}     {{ af.maximum_prefixes_restart_interval_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.address_families.maximum_prefixes_restart_interval     var_msg=bgp.ipv6_neighbors.address_families.maximum_prefixes_restart_interval_variable
    Should Be Equal Value Json Yaml    ${af}    $.maxPrefixConfig.threshold    {{ af.maximum_prefixes_threshold | default('not_defined') }}     {{ af.maximum_prefixes_threshold_variable | default('not_defined') }}     msg=bgp.ipv6_neighbors.address_families.maximum_prefixes_threshold     var_msg=bgp.ipv6_neighbors.address_families.maximum_prefixes_threshold_variable

    ${refid_rpl_in_raw}=    Get Value From Json    ${af}    $.inRoutePolicy.refId.value
    ${refid_rpl_in}=    Set Variable If    ${refid_rpl_in_raw} == []    not_defined    ${refid_rpl_in_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl_in}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ af.route_policy_in | default('not_defined') }}    msg=bgp.ipv6_neighbors.address_families.route_policy_in

    ${refid_rpl_out_raw}=    Get Value From Json    ${af}    $.outRoutePolicy.refId.value
    ${refid_rpl_out}=    Set Variable If    ${refid_rpl_out_raw} == []    not_defined    ${refid_rpl_out_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl_out}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ af.route_policy_out | default('not_defined') }}    msg=bgp.ipv6_neighbors.address_families.route_policy_out
{% endfor %}
{% endif %}

{% endfor %}
{% endif %}

    Log    =====IPv6 Networks=====
    Should Be Equal Value Json List Length    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.ipv6Network    {{ bgp.get('ipv6_networks', []) | length }}    msg=bgp.ipv6_networks length
{% if bgp.ipv6_networks is defined and bgp.get('ipv6_networks', [])|length > 0 %}
{% for network in bgp.ipv6_networks | default([]) %}
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.ipv6Network[{{ loop.index0 }}].prefix    {{ network.prefix | default('not_defined') }}     {{ network.prefix_variable | default('not_defined') }}     msg=bgp.ipv6_networks.prefix     var_msg=bgp.ipv6_networks.prefix_variable
{% endfor %}
{% endif %}

    Log    =====IPv6 Redistributes=====
    Should Be Equal Value Json List Length    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.redistribute    {{ bgp.get('ipv6_redistributes', []) | length }}    msg=bgp.ipv6_redistributes length
{% if bgp.ipv6_redistributes is defined and bgp.get('ipv6_redistributes', [])|length > 0 %}
{% for redistribute in bgp.ipv6_redistributes | default([]) %}
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.redistribute[{{ loop.index0 }}].protocol    {{ redistribute.protocol | default('not_defined') }}     {{ redistribute.protocol_variable | default('not_defined') }}     msg=bgp.ipv6_redistributes.protocol     var_msg=bgp.ipv6_redistributes.protocol_variable

    ${refid_rpl_raw}=    Get Value From Json    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.redistribute[{{ loop.index0 }}].routePolicy.refId.value
    ${refid_rpl}=    Set Variable If    ${refid_rpl_raw} == []    not_defined    ${refid_rpl_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ redistribute.route_policy | default('not_defined') }}    msg=bgp.ipv6_redistributes.route_policy

    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.redistribute[{{ loop.index0 }}].translateRibMetric    {{ redistribute.translate_rib_metric | default('not_defined') }}     {{ redistribute.translate_rib_metric_variable | default('not_defined') }}     msg=bgp.ipv6_redistributes.translate_rib_metric     var_msg=bgp.ipv6_redistributes.translate_rib_metric_variable
{% endfor %}
{% endif %}

    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.filter    {{ bgp.ipv6_table_map_filter | default('not_defined') }}    {{ bgp.ipv6_table_map_filter_variable | default('not_defined') }}    msg=bgp.ipv6_table_map_filter    var_msg=bgp.ipv6_table_map_filter_variable

    ${refid_rpl_raw}=    Get Value From Json    ${service_bgp_{{ bgp.name }}}    $..data.ipv6AddressFamily.name.refId.value
    ${refid_rpl}=    Set Variable If    ${refid_rpl_raw} == []    not_defined    ${refid_rpl_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ bgp.ipv6_table_map_route_policy | default('not_defined') }}    msg=bgp.ipv6_table_map_route_policy

    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.keepalive    {{ bgp.keepalive_time | default('not_defined') }}    {{ bgp.keepalive_time_variable | default('not_defined') }}    msg=bgp.keepalive_time    var_msg=bgp.keepalive_time_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.local    {{ bgp.local_routes_distance | default('not_defined') }}    {{ bgp.local_routes_distance_variable | default('not_defined') }}    msg=bgp.local_routes_distance    var_msg=bgp.local_routes_distance_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.missingAsWorst    {{ bgp.missing_med_as_worst | default('not_defined') }}    {{ bgp.missing_med_as_worst_variable | default('not_defined') }}    msg=bgp.missing_med_as_worst    var_msg=bgp.missing_med_as_worst_variable

    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.multipathRelax    {{ bgp.multipath_relax | default('not_defined') }}    {{ bgp.multipath_relax_variable | default('not_defined') }}    msg=bgp.multipath_relax    var_msg=bgp.multipath_relax_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.propagateAspath    {{ bgp.propagate_as_path | default('not_defined') }}    {{ bgp.propagate_as_path_variable | default('not_defined') }}    msg=bgp.propagate_as_path    var_msg=bgp.propagate_as_path_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.propagateCommunity    {{ bgp.propagate_community | default('not_defined') }}    {{ bgp.propagate_community_variable | default('not_defined') }}    msg=bgp.propagate_community    var_msg=bgp.propagate_community_variable
    Should Be Equal Value Json Yaml    ${service_bgp_{{ bgp.name }}}    $..data.routerId    {{ bgp.router_id | default('not_defined') }}    {{ bgp.router_id_variable | default('not_defined') }}    msg=bgp.router_id    var_msg=bgp.router_id_variable

{% endfor %}

{% endif %}

{% endfor %}

{% endif %}