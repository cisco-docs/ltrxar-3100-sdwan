*** Settings ***
Documentation   Verify System Feature Profile Configuration IPv6 Device Access Policy
Name            System Profiles IPv6 Device Access Policy
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_profiles   ipv6_device_access_policy
Resource        ../../../sdwan_common.resource


{% set profile_ipv6_device_access_policy_list = [] %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.ipv6_device_access_policy is defined %}
  {% set _ = profile_ipv6_device_access_policy_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_ipv6_device_access_policy_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}


Get Policy Object Profile
    ${r_po}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    ${profile_po}=    Get Value From Json    ${r_po.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name | default(defaults.sdwan.feature_profiles.policy_object_profile.name) }}')]
    Run Keyword If    ${profile_po} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name | default(defaults.sdwan.feature_profiles.policy_object_profile.name) }}' should be present on the Manager
    ${profile_po_id}=    Get Value From Json    ${profile_po}    $..profileId

    ${ipv6_data_prefix_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_po_id[0]}/data-ipv6-prefix
    Set Suite Variable    ${ipv6_data_prefix_res}


{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.ipv6_device_access_policy is defined %}

Verify Feature Profiles System Profiles {{ profile.name }} IPv6 Device Access Policy Feature {{ profile.ipv6_device_access_policy.name | default(defaults.sdwan.feature_profiles.system_profiles.ipv6_device_access_policy.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${system_ipv6_device_access_policy_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id[0]}/ipv6-device-access-policy
    ${system_ipv6_device_access_policy}=    Get Value From Json    ${system_ipv6_device_access_policy_res.json()}    $..payload
    Run Keyword If    ${system_ipv6_device_access_policy} == []    Fail    Feature '{{profile.ipv6_device_access_policy.name}}' expected to be configured within the system profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${system_ipv6_device_access_policy}

    Should Be Equal Value Json String    ${system_ipv6_device_access_policy[0]}    $..name    {{ profile.ipv6_device_access_policy.name | default(defaults.sdwan.feature_profiles.system_profiles.ipv6_device_access_policy.name) }}    msg=name
    Should Be Equal Value Json Special_String     ${system_ipv6_device_access_policy[0]}     $.description    {{ profile.ipv6_device_access_policy.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${system_ipv6_device_access_policy[0]}    $.data.defaultAction    {{ profile.ipv6_device_access_policy.default_action | default('not_defined') }}    not_defined    msg=default action    var_msg=not_defined

    Should Be Equal Value Json List Length    ${system_ipv6_device_access_policy[0]}    $.data.sequences    {{ profile.ipv6_device_access_policy.get('sequences', []) | length }}    msg=sequences length
{% if profile.ipv6_device_access_policy.get('sequences', []) | length > 0 %}
    Log     === Sequences List ===
{% for sequence in profile.ipv6_device_access_policy.sequences | default([]) %}
    Log     === {{ sequence.name }} ===

    Should Be Equal Value Json Yaml    ${system_ipv6_device_access_policy[0]}    $.data.sequences[{{ loop.index0 }}].baseAction    {{ sequence.base_action | default('not_defined') }}    not_defined    msg=base action    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${system_ipv6_device_access_policy[0]}    $.data.sequences[{{ loop.index0 }}].sequenceName    {{ sequence.name | default('not_defined') }}    not_defined    msg=name    var_msg=not_defined

    ${destination_data_prefixes_list}=    Create List    {{ sequence.match_entries.get('destination_data_prefixes', []) | join('   ') }}
    ${destination_data_prefixes_list}=    Set Variable If    ${destination_data_prefixes_list} == []    not_defined    ${destination_data_prefixes_list}
    Should Be Equal Value Json Yaml    ${system_ipv6_device_access_policy[0]}    $.data.sequences[{{ loop.index0 }}].matchEntries.destinationDataPrefix.destinationIpPrefixList    ${destination_data_prefixes_list}    not_defined    msg=destination data prefixes    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${system_ipv6_device_access_policy[0]}    $.data.sequences[{{ loop.index0 }}].matchEntries.destinationPort    {{ sequence.match_entries.destination_port | default('not_defined') }}    not_defined    msg=destination port    var_msg=not_defined

    ${source_data_prefixes_list}=    Create List    {{ sequence.match_entries.get('source_data_prefixes', []) | join('   ') }}
    ${source_data_prefixes_list}=    Set Variable If    ${source_data_prefixes_list} == []    not_defined    ${source_data_prefixes_list}
    Should Be Equal Value Json Yaml    ${system_ipv6_device_access_policy[0]}    $.data.sequences[{{ loop.index0 }}].matchEntries.sourceDataPrefix.sourceIpPrefixList    ${source_data_prefixes_list}    not_defined    msg=source data prefixes    var_msg=not_defined

    ${source_ports_list}=    Create List    {{ sequence.match_entries.get('source_ports', []) | join('   ') }}
    ${source_ports_list}=    Set Variable If    ${source_ports_list} == []    not_defined    ${source_ports_list}
    Should Be Equal Value Json Yaml    ${system_ipv6_device_access_policy[0]}    $.data.sequences[{{ loop.index0 }}].matchEntries.sourcePorts    ${source_ports_list}    not_defined    msg=source ports    var_msg=not_defined

    # Extract refID of the destination data prefix list
    ${refid_destination_data_prefix_list_raw}=    Get Value From Json    ${system_ipv6_device_access_policy[0]}    $.data.sequences[{{ loop.index0 }}].matchEntries.destinationDataPrefix.destinationDataPrefixList.refId.value
    ${refid_destination_data_prefix_list}=    Set Variable If    ${refid_destination_data_prefix_list_raw} == []    not_defined    ${refid_destination_data_prefix_list_raw[0]}

    # Extract the data prefix list from the policy object profile using the refID
    ${profile_ipv6_data_prefix}=    Get Value From Json    ${ipv6_data_prefix_res.json()}    $..data[?(@.parcelId=='${refid_destination_data_prefix_list}')]
    
    # should be equal to the name of the data prefix list
    Should Be Equal Value Json String    ${profile_ipv6_data_prefix}    $..name    {{ sequence.match_entries.destination_data_prefix_list | default('not_defined') }}    msg=destination data prefix list

    # Extract refID of the source data prefix list
    ${refid_source_data_prefix_list_raw}=    Get Value From Json    ${system_ipv6_device_access_policy[0]}    $.data.sequences[{{ loop.index0 }}].matchEntries.sourceDataPrefix.sourceDataPrefixList.refId.value
    ${refid_source_data_prefix_list}=    Set Variable If    ${refid_source_data_prefix_list_raw} == []    not_defined    ${refid_source_data_prefix_list_raw[0]}

    # Extract the data prefix list from the policy object profile using the refID
    ${profile_ipv6_data_prefix}=    Get Value From Json    ${ipv6_data_prefix_res.json()}    $..data[?(@.parcelId=='${refid_source_data_prefix_list}')]
    
    # should be equal to the name of the data prefix list
    Should Be Equal Value Json String    ${profile_ipv6_data_prefix}    $..name    {{ sequence.match_entries.source_data_prefix_list | default('not_defined') }}    msg=source data prefix list

{% endfor %}
{% endif %}


{% endif %}
{% endfor %}

{% endif %}