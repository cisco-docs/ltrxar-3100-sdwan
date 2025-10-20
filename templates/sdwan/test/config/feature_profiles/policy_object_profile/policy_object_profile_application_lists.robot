*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration Application List
Name            Policy Object Profile Application List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   application_lists
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.policy_object_profile is defined and sdwan.feature_profiles.policy_object_profile.application_lists is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get Application Lists
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${application_list_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/app-list
    Set Suite Variable    ${application_list_raw}


{% for application_list in sdwan.feature_profiles.policy_object_profile.application_lists | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} Application List Feature {{ application_list.name }}

    ${application_lists}=    Get Value From Json    ${application_list_raw.json()}    $..data[?(@..name=='{{ application_list.name }}')]..payload
    Run Keyword If    ${application_lists} == []    Fail    Feature '{{ application_list.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${application_lists[0]}    $..name    {{ application_list.name }}    msg=name

    ${app_list}=    Create List    {{ application_list.get('applications', []) | join('   ') }}
    Should Be Equal Value Json List    ${application_lists[0]}    $.data.entries..app.value    ${app_list}    msg=applications

    ${app_family_list}=    Create List    {{ application_list.get('application_families', []) | join('   ') }}
    Should Be Equal Value Json List    ${application_lists[0]}    $.data.entries..appFamily.value    ${app_family_list}    msg=application families

{% endfor %}

{% endif %}