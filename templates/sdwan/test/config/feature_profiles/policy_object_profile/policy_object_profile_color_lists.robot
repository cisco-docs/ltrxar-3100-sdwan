*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration Color List
Name            Policy Object Profile Color List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   color_lists
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.policy_object_profile is defined and sdwan.feature_profiles.policy_object_profile.color_lists is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get Color Lists
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}

    ${color_list_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/color
    Set Suite Variable    ${color_list_raw}


{% for color_list in sdwan.feature_profiles.policy_object_profile.color_lists | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} Color List Feature {{ color_list.name }}

    ${color_lists}=    Get Value From Json    ${color_list_raw.json()}    $..data[?(@..name=='{{ color_list.name }}')]..payload
    Run Keyword If    ${color_lists} == []    Fail    Feature '{{ color_list.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${color_lists[0]}    $..name    {{ color_list.name }}    msg=name
    
    ${colors_list}=    Create List    {{ color_list.get('colors', []) | join('   ') }}
    Should Be Equal Value Json List   ${color_lists[0]}   $..color.value   ${colors_list}   msg=colors

{% endfor %}

{% endif %}