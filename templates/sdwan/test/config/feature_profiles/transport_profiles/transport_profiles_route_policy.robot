*** Settings ***
Documentation   Verify Transport Feature Profile Configuration Route Policies
Name            Transport Profiles Route Policies
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     transport_profiles    route_policies
Resource        ../../../sdwan_common.resource


{% set profile_route_policy_list = [] %}
{% for profile in sdwan.get('feature_profiles', {}).get('transport_profiles', {}) %}
 {% if profile.route_policies is defined %}
  {% set _ = profile_route_policy_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_route_policy_list != [] %}

*** Test Cases ***
Get Transport Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport
    Set Suite Variable    ${r}

Get Policy Object Profile
    ${r_po}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    ${profile_po}=    Get Value From Json    ${r_po.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name | default(defaults.sdwan.feature_profiles.policy_object_profile.name) }}')]
    Run Keyword If    ${profile_po} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name | default(defaults.sdwan.feature_profiles.policy_object_profile.name) }}' should be present on the Manager
    ${profile_po_id}=    Get Value From Json    ${profile_po}    $..profileId

    ${as_path_list_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/as-path
    Set Suite Variable    ${as_path_list_res}
    ${expanded_community_list_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/expanded-community
    Set Suite Variable    ${expanded_community_list_res}
    ${extended_community_list_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/ext-community
    Set Suite Variable    ${extended_community_list_res}
    ${ipv4_prefix_list_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/prefix
    Set Suite Variable    ${ipv4_prefix_list_res}
    ${ipv6_prefix_list_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/ipv6-prefix
    Set Suite Variable    ${ipv6_prefix_list_res}
    ${standard_community_list_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/standard-community
    Set Suite Variable    ${standard_community_list_res}

{% for profile in sdwan.feature_profiles.transport_profiles | default([]) %}
{% if profile.route_policies is defined %}

Verify Feature Profiles Transport Profiles {{ profile.name }} Route Policy Feature
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    Set Suite Variable    ${profile}
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}
    ${transport_route_policy_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}/route-policy
    Set Suite Variable    ${transport_route_policy_res}
    ${transport_route_policy}=    Get Value From Json    ${transport_route_policy_res.json()}    $..payload
    Run Keyword If    ${transport_route_policy} == []    Fail    Route Policy feature(s) expected to be configured within the transport profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${transport_route_policy}

{% for route_policy in profile.route_policies | default([]) %}
    Log    === Route Policy: {{ route_policy.name }} ===
    
    # for each route policy find the corresponding one in the json and check parameters:
    ${transport_route_policies_{{ route_policy.name }}_raw}=    Get Value From Json    ${transport_route_policy}    $[?(@.name=='{{ route_policy.name }}')]
    ${transport_route_policies_{{ route_policy.name }}}=    Set Variable If    ${transport_route_policies_{{ route_policy.name }}_raw} == []    not_defined    ${transport_route_policies_{{ route_policy.name }}_raw[0]}

    Should Be Equal Value Json String    ${transport_route_policies_{{ route_policy.name }}}    $..name    {{ route_policy.name }}    msg=name
    Should Be Equal Value Json Special_String    ${transport_route_policies_{{ route_policy.name }}}    $..description    {{ route_policy.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${transport_route_policies_{{ route_policy.name }}}    $..data.defaultAction    {{ route_policy.default_action }}    not_defined    msg=route_policy.default_action    var_msg=not_defined

    Should Be Equal Value Json List Length    ${transport_route_policies_{{ route_policy.name }}}    $..sequences    {{ route_policy.get('sequences', []) | length }}    msg=sequences length
{% if route_policy.get('sequences', []) | length > 0 %}
    Log    === Sequences List ===
{% for sequence in route_policy.sequences | default([]) %}
    Log    === Sequence {{ sequence.id }} ===
    ${sequence_raw}=    Get Value From Json    ${transport_route_policies_{{ route_policy.name }}}    $.data.sequences[?(@.sequenceId.value=={{ sequence.id }})]
    Run Keyword If    ${sequence_raw} == []    Fail    Route Policy sequence ID {{ sequence.id }} expected to be configured on the Manager
    ${sequence}=    Set Variable If    ${sequence_raw} == []    not_defined    ${sequence_raw[0]}

    Should Be Equal Value Json Yaml    ${sequence}    $.sequenceId    {{ sequence.id }}    not_defined    msg=route_policy.sequence.id    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sequence}    $.sequenceName    {{ sequence.name | default(defaults.sdwan.feature_profiles.transport_profiles.route_policies.sequences.name ) }}    not_defined    msg=route_policy.sequence.name    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sequence}    $.baseAction    {{ sequence.base_action | default('not_defined') }}    not_defined    msg=route_policy.sequence.base_action    var_msg=not_defined
    
    {% set protocol = sequence.get('protocol', defaults.sdwan.feature_profiles.transport_profiles.route_policies.sequences.protocol) %}
    Should Be Equal Value Json Yaml    ${sequence}    $.protocol    {{ protocol.upper() }}    not_defined    msg=route_policy.sequence.protocol    var_msg=not_defined

    ${refid_as_path_list_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].asPathList.refId.value
    ${refid_as_path_list}=    Set Variable If    ${refid_as_path_list_raw} == []    not_defined    ${refid_as_path_list_raw[0]}
    ${profile_as_path_list}=    Get Value From Json    ${as_path_list_res.json()}    $..data[?(@.parcelId=='${refid_as_path_list}')]
    Should Be Equal Value Json String    ${profile_as_path_list}    $..name    {{ sequence.match_entries.as_path_list | default('not_defined') }}    msg=route_policy.sequence.match_entries.as_path_list

    Should Be Equal Value Json Yaml    ${sequence}    $.matchEntries[0].bgpLocalPreference    {{ sequence.match_entries.bgp_local_preference | default('not_defined') }}    not_defined    msg=route_policy.sequence.match_entries.bgp_local_preference    var_msg=not_defined

    ${refid_expanded_community_list_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].communityList.expandedCommunityList.refId.value
    ${refid_expanded_community_list}=    Set Variable If    ${refid_expanded_community_list_raw} == []    not_defined    ${refid_expanded_community_list_raw[0]}
    ${profile_expanded_community_list}=    Get Value From Json    ${expanded_community_list_res.json()}    $..data[?(@.parcelId=='${refid_expanded_community_list}')]
    Should Be Equal Value Json String    ${profile_expanded_community_list}    $..name    {{ sequence.match_entries.expanded_community_list | default('not_defined') }}    msg=route_policy.sequence.match_entries.expanded_community_list

    ${refid_extended_community_list_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].extCommunityList.refId.value
    ${refid_extended_community_list}=    Set Variable If    ${refid_extended_community_list_raw} == []    not_defined    ${refid_extended_community_list_raw[0]}
    ${profile_extended_community_list}=    Get Value From Json    ${extended_community_list_res.json()}    $..data[?(@.parcelId=='${refid_extended_community_list}')]
    Should Be Equal Value Json String    ${profile_extended_community_list}    $..name    {{ sequence.match_entries.extended_community_list | default('not_defined') }}    msg=route_policy.sequence.match_entries.extended_community_list

    ${refid_ipv4_address_prefix_list_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].ipv4Address.refId.value
    ${refid_ipv4_address_prefix_list}=    Set Variable If    ${refid_ipv4_address_prefix_list_raw} == []    not_defined    ${refid_ipv4_address_prefix_list_raw[0]}
    ${profile_ipv4_address_prefix_list}=    Get Value From Json    ${ipv4_prefix_list_res.json()}    $..data[?(@.parcelId=='${refid_ipv4_address_prefix_list}')]
    Should Be Equal Value Json String    ${profile_ipv4_address_prefix_list}    $..name    {{ sequence.match_entries.ipv4_address_prefix_list | default('not_defined') }}    msg=route_policy.sequence.match_entries.ipv4_address_prefix_list

    ${refid_ipv4_next_hop_prefix_list_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].ipv4NextHop.refId.value
    ${refid_ipv4_next_hop_prefix_list}=    Set Variable If    ${refid_ipv4_next_hop_prefix_list_raw} == []    not_defined    ${refid_ipv4_next_hop_prefix_list_raw[0]}
    ${profile_ipv4_next_hop_prefix_list}=    Get Value From Json    ${ipv4_prefix_list_res.json()}    $..data[?(@.parcelId=='${refid_ipv4_next_hop_prefix_list}')]
    Should Be Equal Value Json String    ${profile_ipv4_next_hop_prefix_list}    $..name    {{ sequence.match_entries.ipv4_next_hop_prefix_list | default('not_defined') }}    msg=route_policy.sequence.match_entries.ipv4_next_hop_prefix_list

    ${refid_ipv6_address_prefix_list_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].ipv6Address.refId.value
    ${refid_ipv6_address_prefix_list}=    Set Variable If    ${refid_ipv6_address_prefix_list_raw} == []    not_defined    ${refid_ipv6_address_prefix_list_raw[0]}
    ${profile_ipv6_address_prefix_list}=    Get Value From Json    ${ipv6_prefix_list_res.json()}    $..data[?(@.parcelId=='${refid_ipv6_address_prefix_list}')]
    Should Be Equal Value Json String    ${profile_ipv6_address_prefix_list}    $..name    {{ sequence.match_entries.ipv6_address_prefix_list | default('not_defined') }}    msg=route_policy.sequence.match_entries.ipv6_address_prefix_list

    ${refid_ipv6_next_hop_prefix_list_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].ipv6NextHop.refId.value
    ${refid_ipv6_next_hop_prefix_list}=    Set Variable If    ${refid_ipv6_next_hop_prefix_list_raw} == []    not_defined    ${refid_ipv6_next_hop_prefix_list_raw[0]}
    ${profile_ipv6_next_hop_prefix_list}=    Get Value From Json    ${ipv6_prefix_list_res.json()}    $..data[?(@.parcelId=='${refid_ipv6_next_hop_prefix_list}')]
    Should Be Equal Value Json String    ${profile_ipv6_next_hop_prefix_list}    $..name    {{ sequence.match_entries.ipv6_next_hop_prefix_list | default('not_defined') }}    msg=route_policy.sequence.match_entries.ipv6_next_hop_prefix_list

    ${configured_standard_community_list_refids}=    Get Value From Json    ${sequence}    $.matchEntries[0].communityList.standardCommunityList[*].refId.value
    ${configured_standard_community_list_names}=    Create List
    FOR    ${refid}    IN    @{configured_standard_community_list_refids}
        ${profile_standard_community_list}=    Get Value From Json    ${standard_community_list_res.json()}    $..data[?(@.parcelId=='${refid}')].payload.name
        Append To List    ${configured_standard_community_list_names}    ${profile_standard_community_list}[0]
    END
    ${expected_standard_community_list_names}=    Create List
{% for expected_community_list in sequence.get('match_entries', {}).get('standard_community_lists', []) | default([]) %}
    Append To List    ${expected_standard_community_list_names}    {{ expected_community_list }}
{% endfor %}
    Lists Should Be Equal    ${expected_standard_community_list_names}    ${configured_standard_community_list_names}   ignore_order=True    values=False    msg=route_policy.sequence.match_entries.standard_community_lists expected: '${expected_standard_community_list_names}' and got: '${configured_standard_community_list_names}'

    {% set criteria = sequence.get('match_entries', {}).get('standard_community_lists_criteria', 'not_defined') %}
    Should Be Equal Value Json Yaml    ${sequence}    $.matchEntries[0].communityList.criteria    {{ criteria.upper() if criteria != 'not_defined' else 'not_defined' }}    not_defined    msg=route_policy.sequence.match_entries.standard_community_lists_criteria    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setLocalPreference    {{ sequence.actions.bgp_local_preference | default('not_defined') }}    not_defined    msg=route_policy.sequence.actions.bgp_local_preference    var_msg=not_defined

    ${community_list}=    Create List    {{ sequence.get('actions', {}).get('communities', []) | join('    ') }}
    # Replace "local-as" with "local-AS" in the community_list
    ${community_list}=    Evaluate    [item if item != "local-as" else "local-AS" for item in ${community_list}]
    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setCommunity.community    ${community_list}    {{ sequence.actions.communities_variable | default('not_defined') }}    msg=route_policy.sequence.actions.communities    var_msg=route_policy.sequence.actions.communities_variable

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setCommunity.additive    {{ sequence.actions.communities_additive | default(False) }}    not_defined    msg=route_policy.sequence.actions.communities_additive    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setIpv4NextHop    {{ sequence.actions.ipv4_next_hop | default('not_defined') }}    not_defined    msg=route_policy.sequence.actions.ipv4_next_hop    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setIpv6NextHop    {{ sequence.actions.ipv6_next_hop | default('not_defined') }}    not_defined    msg=route_policy.sequence.actions.ipv6_next_hop    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setMetric    {{ sequence.actions.metric | default('not_defined') }}    not_defined    msg=route_policy.sequence.actions.metric    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setMetricType    {{ sequence.actions.metric_type | default('not_defined') }}    not_defined    msg=route_policy.sequence.actions.metric_type    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setOmpTag    {{ sequence.actions.omp_tag | default('not_defined') }}    not_defined    msg=route_policy.sequence.actions.omp_tag    var_msg=not_defined

    {% set origin = sequence.get('actions', {}).get('origin', 'not_defined') %}
    {% if origin == 'incomplete' %}
    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setOrigin    Incomplete    not_defined    msg=route_policy.sequence.actions.origin    var_msg=not_defined
    {% else %}
    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setOrigin    {{ origin.upper() if origin != 'not_defined' else 'not_defined' }}    not_defined    msg=route_policy.sequence.actions.origin    var_msg=not_defined
    {% endif %}

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setOspfTag    {{ sequence.actions.ospf_tag | default('not_defined') }}    not_defined    msg=route_policy.sequence.actions.ospf_tag    var_msg=not_defined

    ${prepend_aspaths_list}=    Create List    {{ sequence.get('actions', {}).get('prepend_as_paths', []) | join('    ') }}
    ${prepend_aspaths_list}=    Set Variable If    ${prepend_aspaths_list} == []    not_defined    ${prepend_aspaths_list}
    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setAsPath.prepend    ${prepend_aspaths_list}    not_defined    msg=route_policy.sequence.actions.prepend_as_paths    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setWeight    {{ sequence.actions.weight | default('not_defined') }}    not_defined    msg=route_policy.sequence.actions.weight    var_msg=not_defined

{% endfor %}

{% endif %}

{% endfor %}

{% endif %}

{% endfor %}

{% endif %}