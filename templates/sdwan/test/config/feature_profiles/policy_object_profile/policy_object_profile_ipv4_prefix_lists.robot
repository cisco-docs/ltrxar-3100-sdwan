*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration IPv4 Prefix List
Name            Policy Object Profile IPv4 Prefix List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   ipv4_prefix_lists
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.policy_object_profile is defined and sdwan.feature_profiles.policy_object_profile.ipv4_prefix_lists is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get IPv4 Prefix Lists
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${ipv4_prefix_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/prefix
    Set Suite Variable    ${ipv4_prefix_raw}


{% for ipv4_prefix_list in sdwan.feature_profiles.policy_object_profile.ipv4_prefix_lists | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} IPv4 Prefix List Feature {{ ipv4_prefix_list.name }}

    ${ipv4_prefix_lists}=    Get Value From Json    ${ipv4_prefix_raw.json()}    $..data[?(@..name=='{{ ipv4_prefix_list.name }}')]..payload
    Run Keyword If    ${ipv4_prefix_lists} == []    Fail    Feature '{{ ipv4_prefix_list.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${ipv4_prefix_lists[0]}    $..name    {{ ipv4_prefix_list.name }}    msg=name
    Should Be Equal Value Json Special_String     ${ipv4_prefix_lists[0]}     $.description    {{ ipv4_prefix_list.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json List Length    ${ipv4_prefix_lists[0]}    $.data.entries    {{ ipv4_prefix_list.get('entries', []) | length }}    msg=entries length
{% if ipv4_prefix_list.get('entries', []) | length > 0 %}
    Log     === Entries List ===
{% for entry in ipv4_prefix_list.entries | default([]) %}

    {% set ip_list = entry.prefix.split('/') %}
    Should Be Equal Value Json Yaml    ${ipv4_prefix_lists[0]}    $.data.entries[{{ loop.index0 }}].ipv4Address    {{ ip_list[0] | default('not_defined') }}    not_defined    msg=ipv4 address    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${ipv4_prefix_lists[0]}    $.data.entries[{{ loop.index0 }}].ipv4PrefixLength    {{ ip_list[1] | default('not_defined') }}    not_defined    msg=ipv4 prefix length    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${ipv4_prefix_lists[0]}    $.data.entries[{{ loop.index0 }}].geRangePrefixLength    {{ entry.ge | default('not_defined') }}    not_defined    msg=ge range prefix length    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${ipv4_prefix_lists[0]}    $.data.entries[{{ loop.index0 }}].leRangePrefixLength    {{ entry.le | default('not_defined') }}    not_defined    msg=le range prefix length    var_msg=not_defined

{% endfor %}
{% endif %}


{% endfor %}

{% endif %}