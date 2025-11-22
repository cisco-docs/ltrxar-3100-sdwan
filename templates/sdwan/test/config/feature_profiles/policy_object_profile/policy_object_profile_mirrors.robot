*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration Mirror List
Name            Policy Object Profile Mirror List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   mirrors
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.policy_object_profile is defined and sdwan.feature_profiles.policy_object_profile.mirrors is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get Mirror Lists
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${mirror_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/mirror
    Set Suite Variable    ${mirror_raw}


{% for mirror in sdwan.feature_profiles.policy_object_profile.mirrors | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} Mirror List Feature {{ mirror.name }}

    ${mirrors}=    Get Value From Json    ${mirror_raw.json()}    $..data[?(@..name=='{{ mirror.name }}')]..payload
    Run Keyword If    ${mirrors} == []    Fail    Feature '{{ mirror.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${mirrors[0]}    $..name    {{ mirror.name }}    msg=name
    Should Be Equal Value Json Special_String     ${mirrors[0]}     $.description    {{ mirror.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${mirrors[0]}    $.data.entries[0].remoteDestIp   {{ mirror.remote_destination_ip | default('not_defined') }}    not_defined     msg=remote destination ip    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${mirrors[0]}    $.data.entries[0].sourceIp   {{ mirror.source_ip | default('not_defined') }}    not_defined     msg=source ip    var_msg=not_defined

{% endfor %}

{% endif %}