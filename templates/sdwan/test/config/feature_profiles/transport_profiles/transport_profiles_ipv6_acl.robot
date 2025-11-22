*** Settings ***
Documentation   Verify Transport Feature Profile Configuration IPv6 ACL
Name            Transport Profiles IPv6 ACL
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     transport_profiles   ipv6_acls
Resource        ../../../sdwan_common.resource


{% set profile_ipv6_acl_list = [] %}
{% for profile in sdwan.get('feature_profiles', {}).get('transport_profiles', {}) %}
 {% if profile.ipv6_acls is defined %}
  {% set _ = profile_ipv6_acl_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_ipv6_acl_list != [] %}

*** Test Cases ***
Get Transport Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport
    Set Suite Variable    ${r}

Get Policy Object Profile
    ${r_po}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    ${profile_po}=    Get Value From Json    ${r_po.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name | default(defaults.sdwan.feature_profiles.policy_object_profile.name) }}')]
    Run Keyword If    ${profile_po} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name | default(defaults.sdwan.feature_profiles.policy_object_profile.name) }}' should be present on the Manager
    ${profile_po_id}=    Get Value From Json    ${profile_po}    $..profileId

    ${ipv6_data_prefix_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/data-ipv6-prefix
    Set Suite Variable    ${ipv6_data_prefix_res}

    ${mirror_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/mirror
    Set Suite Variable    ${mirror_res}

    ${policer_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/policer
    Set Suite Variable    ${policer_res}

{% for profile in sdwan.feature_profiles.transport_profiles | default([]) %}
{% if profile.ipv6_acls is defined %}

Verify Feature Profiles Transport Profiles {{ profile.name }} IPv6 ACL Feature
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    Set Suite Variable    ${profile}
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}
    ${transport_ipv6_acl_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}/ipv6-acl
    Set Suite Variable    ${transport_ipv6_acl_res}
    ${transport_acl}=    Get Value From Json    ${transport_ipv6_acl_res.json()}    $..payload
    Run Keyword If    ${transport_acl} == []    Fail    IPv6 ACL feature(s) expected to be configured within the transport profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${transport_acl}

{% for acl in profile.ipv6_acls | default([]) %}
    Log    === IPv6 ACL: {{ acl.name }} ===
    
    # for each acl find the corresponding one in the json and check parameters:
    ${transport_ipv6_acls_{{ acl.name }}_raw}=    Get Value From Json    ${transport_acl}    $[?(@.name=='{{ acl.name }}')]
    ${transport_ipv6_acls_{{ acl.name }}}=    Set Variable If    ${transport_ipv6_acls_{{ acl.name }}_raw} == []    not_defined    ${transport_ipv6_acls_{{ acl.name }}_raw}
    Log    ${transport_ipv6_acls_{{ acl.name }}}

    Should Be Equal Value Json String    ${transport_ipv6_acls_{{ acl.name }}}    $..name    {{ acl.name }}    msg=name
    Should Be Equal Value Json Special_String    ${transport_ipv6_acls_{{ acl.name }}}    $..description    {{ acl.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json String    ${transport_ipv6_acls_{{ acl.name }}}    $..data.defaultAction.value    {{ acl.default_action }}    msg=acl.default_action

    Should Be Equal Value Json List Length    ${transport_ipv6_acls_{{ acl.name }}}    $..sequences    {{ acl.get('sequences', []) | length }}    msg=sequences length
{% if acl.get('sequences', []) | length > 0 %}
    Log    === Sequences List ===
{% for sequence in acl.sequences | default([]) %}
    Log    === Sequence {{ sequence.id }} ===
    ${sequence_raw}=    Get Value From Json    ${transport_ipv6_acls_{{ acl.name }}}    $..data.sequences[?(@.sequenceId.value=={{ sequence.id }})]
    Run Keyword If    ${sequence_raw} == []    Fail    IPv6 ACL sequence ID {{ sequence.id }} expected to be configured on the Manager
    ${sequence}=    Set Variable If    ${sequence_raw} == []    not_defined    ${sequence_raw[0]}

    Should Be Equal Value Json Yaml    ${sequence}    $.sequenceId    {{ sequence.id }}    not_defined    msg=acl.sequence.id    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sequence}    $.sequenceName    {{ sequence.name | default(defaults.sdwan.feature_profiles.transport_profiles.ipv6_acls.sequences.name ) }}    not_defined    msg=acl.sequence.name    var_msg=not_defined
{% if 'actions' not in sequence %}
    Should Be Equal Value Json Yaml    ${sequence}    $.baseAction    {{ sequence.base_action | default('not_defined') }}    not_defined    msg=acl.sequence.base_action    var_msg=not_defined
{% endif %}

    Should Be Equal Value Json Yaml    ${sequence}    $.matchEntries[0].destinationDataPrefix.destinationIpPrefix    {{ sequence.match_entries.destination_data_prefix | default('not_defined') }}    {{ sequence.match_entries.destination_data_prefix_variable | default('not_defined') }}    msg=acl.sequence.match_entries.destination_data_prefix    var_msg=acl.sequence.match_entries.destination_data_prefix_variable

    ${configured_destination_data_prefix_refid_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].destinationDataPrefix.destinationDataPrefixList.refId.value
    ${configured_destination_data_prefix_refid}=    Set Variable If    ${configured_destination_data_prefix_refid_raw} == []    not_defined    ${configured_destination_data_prefix_refid_raw[0]}
    Log    ${ipv6_data_prefix_res.json()}
    ${configured_destination_data_prefix_name}=    Get Value From Json    ${ipv6_data_prefix_res.json()}    $..data[?(@.parcelId=='${configured_destination_data_prefix_refid}')]
    Should Be Equal Value Json String    ${configured_destination_data_prefix_name}    $..name    {{ sequence.match_entries.destination_data_prefix_list | default('not_defined') }}    msg=acl.sequence.match_entries.destination_data_prefix_list

    ${configured_destination_ports_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].destinationPorts[*].destinationPort.value
    ${configured_destination_ports}=    Evaluate    [str(item) for item in $configured_destination_ports_raw]
    ${expected_destination_ports}=    Create List
{% for destination_port in sequence.get('match_entries', {}).get('destination_ports', []) | default([]) %}
    Append To List    ${expected_destination_ports}    {{ destination_port | string }}
{% endfor %}
    Lists Should Be Equal    ${expected_destination_ports}    ${configured_destination_ports}   ignore_order=True    values=False    msg=acl.sequence.match_entries.destination_ports expected: '${expected_destination_ports}' and got: '${configured_destination_ports}'

    ${expected_traffic_classes}=    Set Variable If    {{ sequence.get('match_entries', {}).get('traffic_classes', []) | length == 0 }}    not_defined    {{ sequence.get('match_entries', {}).get('traffic_classes', []) }}
    Should Be Equal Value Json Yaml    ${sequence}    $.matchEntries[0].trafficClass    ${expected_traffic_classes}    not_defined    msg=acl.sequence.match_entries.trafficClass    var_msg=not_defined
    Log    ${sequence}
    Should Be Equal Value Json Yaml    ${sequence}    $.matchEntries[0].icmpMsg    {{ sequence.match_entries.icmpv6_messages | default('not_defined') }}    not_defined    msg=acl.sequence.match_entries.icmpv6_messages    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sequence}    $.matchEntries[0].packetLength    {{ sequence.match_entries.packet_length | default('not_defined') }}    not_defined    msg=acl.sequence.match_entries.packet_length    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${sequence}    $.matchEntries[0].sourceDataPrefix.sourceIpPrefix    {{ sequence.match_entries.source_data_prefix | default('not_defined') }}    {{ sequence.match_entries.source_data_prefix_variable | default('not_defined') }}    msg=acl.sequence.match_entries.source_data_prefix    var_msg=acl.sequence.match_entries.source_data_prefix_variable

    ${configured_source_data_prefix_refid_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].sourceDataPrefix.sourceDataPrefixList.refId.value
    ${configured_source_data_prefix_refid}=    Set Variable If    ${configured_source_data_prefix_refid_raw} == []    not_defined    ${configured_source_data_prefix_refid_raw[0]}
    ${configured_source_data_prefix_name}=    Get Value From Json    ${ipv6_data_prefix_res.json()}    $..data[?(@.parcelId=='${configured_source_data_prefix_refid}')]
    Should Be Equal Value Json String    ${configured_source_data_prefix_name}    $..name    {{ sequence.match_entries.source_data_prefix_list | default('not_defined') }}    msg=acl.sequence.match_entries.source_data_prefix_list

    ${configured_source_ports_raw}=    Get Value From Json    ${sequence}    $.matchEntries[0].sourcePorts[*].sourcePort.value
    ${configured_source_ports}=    Evaluate    [str(item) for item in $configured_source_ports_raw]
    ${expected_source_ports}=    Create List
{% for source_port in sequence.get('match_entries', {}).get('source_ports', []) | default([]) %}
    Append To List    ${expected_source_ports}    {{ source_port | string }}
{% endfor %}
    Lists Should Be Equal    ${expected_source_ports}    ${configured_source_ports}   ignore_order=True    values=False    msg=acl.sequence.match_entries.source_ports expected: '${expected_source_ports}' and got: '${configured_source_ports}'

    Should Be Equal Value Json Yaml    ${sequence}    $.matchEntries[0].tcp    {{ sequence.match_entries.tcp_state | default('not_defined') }}    not_defined    msg=acl.sequence.match_entries.tcp_state    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0]..counterName    {{ sequence.actions.counter_name | default('not_defined') }}    not_defined    msg=acl.sequence.actions.counter_name    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setTrafficClass    {{ sequence.actions.traffic_class | default('not_defined') }}    not_defined    msg=acl.sequence.actions.traffic_class    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0].accept.setNextHop    {{ sequence.actions.ipv6_next_hop | default('not_defined') }}    not_defined    msg=acl.sequence.actions.ipv6_next_hop    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sequence}    $.actions[0]..log    {{ sequence.actions.log | default('not_defined') }}    not_defined    msg=acl.sequence.actions.log    var_msg=not_defined

    ${configured_mirror_refid_raw}=    Get Value From Json    ${sequence}    $.actions[0].accept.mirror.refId.value
    ${configured_mirror_refid}=    Set Variable If    ${configured_mirror_refid_raw} == []    not_defined    ${configured_mirror_refid_raw[0]}
    ${configured_mirror_name}=    Get Value From Json    ${mirror_res.json()}    $..data[?(@.parcelId=='${configured_mirror_refid}')]
    Should Be Equal Value Json String    ${configured_mirror_name}    $..name    {{ sequence.actions.mirror | default('not_defined') }}    msg=acl.sequence.actions.mirror

    ${configured_policer_refid_raw}=    Get Value From Json    ${sequence}    $.actions[0].accept.policer.refId.value
    ${configured_policer_refid}=    Set Variable If    ${configured_policer_refid_raw} == []    not_defined    ${configured_policer_refid_raw[0]}
    ${configured_policer_name}=    Get Value From Json    ${policer_res.json()}    $..data[?(@.parcelId=='${configured_policer_refid}')]
    Should Be Equal Value Json String    ${configured_policer_name}    $..name    {{ sequence.actions.policer | default('not_defined') }}    msg=acl.sequence.actions.policer

{% endfor %}

{% endif %}

{% endfor %}

{% endif %}

{% endfor %}

{% endif %}