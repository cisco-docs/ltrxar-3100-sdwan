*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration Policer List
Name            Policy Object Profile Policer List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   policers
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles.policy_object_profile.policers is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get Policer Lists
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${policer_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/policer
    Set Suite Variable    ${policer_raw}


{% for policer in sdwan.feature_profiles.policy_object_profile.policers | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} Policer List Feature {{ policer.name }}

    ${policers}=    Get Value From Json    ${policer_raw.json()}    $..data[?(@..name=='{{ policer.name }}')]..payload
    Run Keyword If    ${policers} == []    Fail    Feature '{{ policer.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${policers[0]}    $..name    {{ policer.name }}    msg=name
    Should Be Equal Value Json Special_String     ${policers[0]}     $.description    {{ policer.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${policers[0]}    $.data.entries[0].burst   {{ policer.burst_bytes | default('not_defined') }}    not_defined     msg=burst bytes    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${policers[0]}    $.data.entries[0].exceed   {{ policer.exceed_action | default('not_defined') }}    not_defined     msg=exceed action    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${policers[0]}    $.data.entries[0].rate   {{ policer.rate_bps | default('not_defined') }}    not_defined     msg=rate bps    var_msg=not_defined

{% endfor %}

{% endif %}