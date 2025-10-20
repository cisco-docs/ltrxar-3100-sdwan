*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration Forwarding Classes
Name            Policy Object Profile Forwarding Classes
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   forwarding_classes
Resource        ../../../sdwan_common.resource

{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.policy_object_profile is defined and sdwan.feature_profiles.policy_object_profile.forwarding_classes is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get Forwarding Classes
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${forwarding_class_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/class
    Set Suite Variable    ${forwarding_class_raw}


{% for forwarding_class in sdwan.feature_profiles.policy_object_profile.forwarding_classes | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} Forwarding Class Feature {{ forwarding_class.name }}

    ${forwarding_classes}=    Get Value From Json    ${forwarding_class_raw.json()}    $..data[?(@..name=='{{ forwarding_class.name }}')]..payload
    Run Keyword If    ${forwarding_classes} == []    Fail    Feature '{{ forwarding_class.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${forwarding_classes[0]}    $..name    {{ forwarding_class.name }}    msg=name
    Should Be Equal Value Json Special_String     ${forwarding_classes[0]}     $.description    {{ forwarding_class.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${forwarding_classes[0]}    $.data.entries[0].queue   {{ forwarding_class.queue | default('not_defined') }}    not_defined     msg=queue    var_msg=not_defined

{% endfor %}

{% endif %}