*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration Expanded Community List
Name            Policy Object Profile Expanded Community List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   expanded_community_lists
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles.policy_object_profile.expanded_community_lists is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get Expanded Community Lists
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${expanded_community_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/expanded-community
    Set Suite Variable    ${expanded_community_raw}


{% for expanded_community_list in sdwan.feature_profiles.policy_object_profile.expanded_community_lists | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} Expanded Community List Feature {{ expanded_community_list.name }}

    ${expanded_community_lists}=    Get Value From Json    ${expanded_community_raw.json()}    $..data[?(@..name=='{{ expanded_community_list.name }}')]..payload
    Run Keyword If    ${expanded_community_lists} == []    Fail    Feature '{{ expanded_community_list.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${expanded_community_lists[0]}    $..name    {{ expanded_community_list.name }}    msg=name
    Should Be Equal Value Json Special_String     ${expanded_community_lists[0]}     $.description    {{ expanded_community_list.description | default('not_defined') | normalize_special_string }}    msg=description

    ${expanded_communities_list}=    Create List    {{ expanded_community_list.get('expanded_communities', []) | join('   ') }}
    ${expanded_communities_list}=    Set Variable If    ${expanded_communities_list} == []    not_defined    ${expanded_communities_list}
    Should Be Equal Value Json Yaml     ${expanded_community_lists[0]}    $.data.expandedCommunityList   ${expanded_communities_list}   not_defined   msg=expanded communities  var_msg=none

{% endfor %}

{% endif %}