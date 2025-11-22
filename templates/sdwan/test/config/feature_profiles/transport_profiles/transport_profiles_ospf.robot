*** Settings ***
Documentation   Verify Transport Feature Profile Configuration OSPF Features
Name            Transport Profiles OSPF Features
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles    transport_profiles    ospf
Resource        ../../../sdwan_common.resource


{% set profile_ospf_list = [] %}
{% for profile in sdwan.get('feature_profiles', {}).get('transport_profiles', {}) %}
 {% if profile.ospf_features is defined %}
  {% set _ = profile_ospf_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_ospf_list != [] %}

*** Test Cases ***
Get Transport Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.transport_profiles | default([]) %}
{% if profile.ospf_features is defined %}

Verify Feature Profiles Transport Profiles {{ profile.name }} OSPF Feature
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    Set Suite Variable    ${profile}
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}
    ${transport_ospf_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}/routing/ospf
    Set Suite Variable    ${transport_ospf_res}
    ${transport_ospf}=    Get Value From Json    ${transport_ospf_res.json()}    $..payload
    Run Keyword If    ${transport_ospf} == []    Fail    OSPF feature(s) expected to be configured within the transport profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${transport_ospf}

    # Extract route policies since they might be used in OSPF
    ${route_policies_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id}[0]/route-policy
    Set Suite Variable    ${route_policies_res}

{% for ospf in profile.ospf_features | default([]) %}
    Log    === OSPF: {{ ospf.name }} ===

    # for each ospf find the corresponding one in the json and check parameters:
    ${transport_ospf_{{ ospf.name }}_raw}=    Get Value From Json    ${transport_ospf}    $[?(@.name=='{{ ospf.name }}')]
    ${transport_ospf_{{ ospf.name }}}=    Set Variable If    ${transport_ospf_{{ ospf.name }}_raw} == []    not_defined    ${transport_ospf_{{ ospf.name }}_raw[0]}

    Should Be Equal Value Json String    ${transport_ospf_{{ ospf.name }}}    $..name    {{ ospf.name }}    msg=name
    Should Be Equal Value Json Special_String    ${transport_ospf_{{ ospf.name }}}    $..description    {{ ospf.description | default('not_defined') | normalize_special_string }}    msg=description

    # Basic OSPF parameters
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.routerId    {{ ospf.router_id | default('not_defined') }}    {{ ospf.router_id_variable | default('not_defined') }}    msg=ospf.router_id    var_msg=ospf.router_id_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.referenceBandwidth    {{ ospf.reference_bandwidth | default('not_defined') }}    {{ ospf.reference_bandwidth_variable | default('not_defined') }}    msg=ospf.reference_bandwidth    var_msg=ospf.reference_bandwidth_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.rfc1583    {{ ospf.rfc1583_compatibility | default('not_defined') }}    {{ ospf.rfc1583_compatibility_variable | default('not_defined') }}    msg=ospf.rfc1583_compatibility    var_msg=ospf.rfc1583_compatibility_variable

    # Default route origination
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.originate    {{ ospf.default_originate | default('not_defined') }}    not_defined    msg=ospf.default_originate    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.always    {{ ospf.default_originate_always | default('not_defined') }}    {{ ospf.default_originate_always_variable | default('not_defined') }}    msg=ospf.default_originate_always    var_msg=ospf.default_originate_always_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.metric    {{ ospf.default_originate_metric | default('not_defined') }}    {{ ospf.default_originate_metric_variable | default('not_defined') }}    msg=ospf.default_originate_metric    var_msg=ospf.default_originate_metric_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.metricType    {{ ospf.default_originate_metric_type | default('not_defined') }}    {{ ospf.default_originate_metric_type_variable | default('not_defined') }}    msg=ospf.default_originate_metric_type    var_msg=ospf.default_originate_metric_type_variable

    # Distance parameters
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.external    {{ ospf.distance_external | default('not_defined') }}    {{ ospf.distance_external_variable | default('not_defined') }}    msg=ospf.distance_external    var_msg=ospf.distance_external_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.interArea    {{ ospf.distance_inter_area | default('not_defined') }}    {{ ospf.distance_inter_area_variable | default('not_defined') }}    msg=ospf.distance_inter_area    var_msg=ospf.distance_inter_area_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.intraArea    {{ ospf.distance_intra_area | default('not_defined') }}    {{ ospf.distance_intra_area_variable | default('not_defined') }}    msg=ospf.distance_intra_area    var_msg=ospf.distance_intra_area_variable

    # SPF timers
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.delay    {{ ospf.spf_calculation_delay | default('not_defined') }}    {{ ospf.spf_calculation_delay_variable | default('not_defined') }}    msg=ospf.spf_calculation_delay    var_msg=ospf.spf_calculation_delay_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.initialHold    {{ ospf.spf_initial_hold_time | default('not_defined') }}    {{ ospf.spf_initial_hold_time_variable | default('not_defined') }}    msg=ospf.spf_initial_hold_time    var_msg=ospf.spf_initial_hold_time_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.maxHold    {{ ospf.spf_maximum_hold_time | default('not_defined') }}    {{ ospf.spf_maximum_hold_time_variable | default('not_defined') }}    msg=ospf.spf_maximum_hold_time    var_msg=ospf.spf_maximum_hold_time_variable

    # Route policy
    ${refid_rpl_raw}=    Get Value From Json    ${transport_ospf_{{ ospf.name }}}    $..data.routePolicy.refId.value
    ${refid_rpl}=    Set Variable If    ${refid_rpl_raw} == []    not_defined    ${refid_rpl_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ ospf.route_policy | default('not_defined') }}    msg=ospf.route_policy

    Log    =====Redistributes=====
    Should Be Equal Value Json List Length    ${transport_ospf_{{ ospf.name }}}    $..data.redistribute    {{ ospf.get('redistributes', []) | length }}    msg=ospf.redistributes length
{% if ospf.redistributes is defined and ospf.get('redistributes', [])|length > 0 %}
{% for redistribute in ospf.redistributes | default([]) %}
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.redistribute[{{ loop.index0 }}].protocol    {{ redistribute.protocol | default('not_defined') }}    {{ redistribute.protocol_variable | default('not_defined') }}    msg=ospf.redistributes.protocol    var_msg=ospf.redistributes.protocol_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.redistribute[{{ loop.index0 }}].dia    {{ 'not_defined' if redistribute.get('dia', 'not_defined') == true else (redistribute.dia | default('not_defined')) }}    {{ redistribute.dia_variable | default('not_defined') }}    msg=ospf.redistributes.dia    var_msg=ospf.redistributes.dia_variable

    ${refid_rpl_raw}=    Get Value From Json    ${transport_ospf_{{ ospf.name }}}    $..data.redistribute[{{ loop.index0 }}].routePolicy.refId.value
    ${refid_rpl}=    Set Variable If    ${refid_rpl_raw} == []    not_defined    ${refid_rpl_raw[0]}
    ${profile_rpl}=    Get Value From Json    ${route_policies_res.json()}    $.data[?(@.parcelId=='${refid_rpl}')]
    Should Be Equal Value Json String    ${profile_rpl}    $..name    {{ redistribute.route_policy | default('not_defined') }}    msg=ospf.redistributes.route_policy
{% endfor %}
{% endif %}

    Log    =====Router LSA=====
    Should Be Equal Value Json List Length    ${transport_ospf_{{ ospf.name }}}    $..data.routerLsa    {{ 1 if ospf.router_lsa_advertisement_type is defined else 0 }}    msg=ospf.router_lsa length
{% if ospf.router_lsa_advertisement_type is defined %}
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.routerLsa[0].adType    {{ ospf.router_lsa_advertisement_type | default('not_defined') }}    not_defined    msg=ospf.router_lsa_advertisement_type    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.routerLsa[0].time    {{ ospf.router_lsa_advertisement_time | default('not_defined') }}    not_defined    msg=ospf.router_lsa_advertisement_time    var_msg=not_defined
{% endif %}

    Log    =====Areas=====
    Should Be Equal Value Json List Length    ${transport_ospf_{{ ospf.name }}}    $..data.area    {{ ospf.get('areas', []) | length }}    msg=ospf.areas length
{% if ospf.areas is defined and ospf.get('areas', [])|length > 0 %}
{% for area in ospf.areas | default([]) %}
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].aNum    {{ area.number | default('not_defined') }}    {{ area.number_variable | default('not_defined') }}    msg=ospf.areas.number    var_msg=ospf.areas.number_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].aType    {{ area.type | default('not_defined') }}    not_defined    msg=ospf.areas.type    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].noSummary    {{ area.no_summary | default('not_defined') }}    {{ area.no_summary_variable | default('not_defined') }}    msg=ospf.areas.no_summary    var_msg=ospf.areas.no_summary_variable

    Log    =====Area {{ loop.index0 }} Interfaces=====
    Should Be Equal Value Json List Length    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface    {{ area.get('interfaces', []) | length }}    msg=ospf.areas.interfaces length
{% if area.interfaces is defined and area.get('interfaces', [])|length > 0 %}
{% for interface in area.interfaces | default([]) %}
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].name    {{ interface.name | default('not_defined') }}    {{ interface.name_variable | default('not_defined') }}    msg=ospf.areas.interfaces.name    var_msg=ospf.areas.interfaces.name_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].helloInterval    {{ interface.hello_interval | default('not_defined') }}    {{ interface.hello_interval_variable | default('not_defined') }}    msg=ospf.areas.interfaces.hello_interval    var_msg=ospf.areas.interfaces.hello_interval_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].deadInterval    {{ interface.dead_interval | default('not_defined') }}    {{ interface.dead_interval_variable | default('not_defined') }}    msg=ospf.areas.interfaces.dead_interval    var_msg=ospf.areas.interfaces.dead_interval_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].retransmitInterval    {{ interface.lsa_retransmit_interval | default('not_defined') }}    {{ interface.lsa_retransmit_interval_variable | default('not_defined') }}    msg=ospf.areas.interfaces.lsa_retransmit_interval    var_msg=ospf.areas.interfaces.lsa_retransmit_interval_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].cost    {{ interface.cost | default('not_defined') }}    {{ interface.cost_variable | default('not_defined') }}    msg=ospf.areas.interfaces.cost    var_msg=ospf.areas.interfaces.cost_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].priority    {{ interface.designated_router_priority | default('not_defined') }}    {{ interface.designated_router_priority_variable | default('not_defined') }}    msg=ospf.areas.interfaces.designated_router_priority    var_msg=ospf.areas.interfaces.designated_router_priority_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].network    {{ interface.network_type | default('not_defined') }}    {{ interface.network_type_variable | default('not_defined') }}    msg=ospf.areas.interfaces.network_type    var_msg=ospf.areas.interfaces.network_type_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].passiveInterface    {{ interface.passive | default('not_defined') }}    {{ interface.passive_variable | default('not_defined') }}    msg=ospf.areas.interfaces.passive    var_msg=ospf.areas.interfaces.passive_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].type    {{ interface.authentication_type | default('not_defined') }}    {{ interface.authentication_type_variable | default('not_defined') }}    msg=ospf.areas.interfaces.authentication_type    var_msg=ospf.areas.interfaces.authentication_type_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].interface[{{ loop.index0 }}].messageDigestKey    {{ interface.authentication_message_digest_key_id | default('not_defined') }}    {{ interface.authentication_message_digest_key_id_variable | default('not_defined') }}    msg=ospf.areas.interfaces.authentication_message_digest_key_id    var_msg=ospf.areas.interfaces.authentication_message_digest_key_id_variable
    # Skip authentication_message_digest_key as it's write-only
{% endfor %}
{% endif %}

    Log    =====Area {{ loop.index0 }} Ranges=====
    Should Be Equal Value Json List Length    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].range    {{ area.get('ranges', []) | length }}    msg=ospf.areas.ranges length
{% if area.ranges is defined and area.get('ranges', [])|length > 0 %}
{% for range in area.ranges | default([]) %}
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].range[{{ loop.index0 }}].address.ipAddress    {{ range.network_address | default('not_defined') }}    {{ range.network_address_variable | default('not_defined') }}    msg=ospf.areas.ranges.network_address    var_msg=ospf.areas.ranges.network_address_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].range[{{ loop.index0 }}].address.subnetMask    {{ range.subnet_mask | default('not_defined') }}    {{ range.subnet_mask_variable | default('not_defined') }}    msg=ospf.areas.ranges.subnet_mask    var_msg=ospf.areas.ranges.subnet_mask_variable
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].range[{{ loop.index0 }}].cost    {{ range.cost | default('not_defined') }}    not_defined    msg=ospf.areas.ranges.cost    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${transport_ospf_{{ ospf.name }}}    $..data.area[{{ loop.index0 }}].range[{{ loop.index0 }}].noAdvertise    {{ range.no_advertise | default('not_defined') }}    {{ range.no_advertise_variable | default('not_defined') }}    msg=ospf.areas.ranges.no_advertise    var_msg=ospf.areas.ranges.no_advertise_variable
{% endfor %}
{% endif %}

{% endfor %}
{% endif %}

{% endfor %}

{% endif %}

{% endfor %}

{% endif %}