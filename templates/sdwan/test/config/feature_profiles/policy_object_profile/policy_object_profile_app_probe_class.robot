*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration App Probe Class
Name            Policy Object Profile App Probe Class
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   app_probe_classes
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles.policy_object_profile.app_probe_classes is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get App Probe Classes
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${app_probe_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/app-probe
    Set Suite Variable    ${app_probe_raw}


{% for app_probe in sdwan.feature_profiles.policy_object_profile.app_probe_classes | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} App Probe Class Feature {{ app_probe.name }}

    ${app_probe_lists}=    Get Value From Json    ${app_probe_raw.json()}    $..data[?(@..name=='{{ app_probe.name }}')]..payload
    Run Keyword If    ${app_probe_lists} == []    Fail    Feature '{{ app_probe.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${app_probe_lists[0]}    $..name    {{ app_probe.name }}    msg=name

    Should Be Equal Value Json Yaml    ${app_probe_lists[0]}    $..data..entries..forwardingClass    {{ app_probe.forwarding_class | default('not_defined') }}    not_defined    msg=forwarding_class    var_msg=not_defined
    Should Be Equal Value Json List Length    ${app_probe_lists[0]}    $..data..entries..map   {{ app_probe.get('mappings', []) | length }}    msg=mappings length
{% if app_probe.get('mappings', []) | length > 0 %}
    Log     === Mappings for {{ app_probe.forwarding_class }} ===
{% for mapping in app_probe.get('mappings', []) %}
    Should Be Equal Value Json Yaml    ${app_probe_lists[0]}    $..data..entries..map[{{ loop.index0 }}].color    {{ mapping.color | default('not_defined') }}    not_defined    msg=color    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${app_probe_lists[0]}    $..data..entries..map[{{ loop.index0 }}].dscp    {{ mapping.dscp | default('not_defined') }}    not_defined    msg=dscp    var_msg=not_defined
{% endfor %}

{% endif %}

{% endfor %}

{% endif %}