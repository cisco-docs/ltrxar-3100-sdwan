*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration SLA Class
Name            Policy Object Profile SLA Class
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   sla_classes
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.policy_object_profile is defined and sdwan.feature_profiles.policy_object_profile.sla_classes is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get SLA Classes
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}

    ${sla_class_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/sla-class
    Set Suite Variable    ${sla_class_raw}


{% for sla_class in sdwan.feature_profiles.policy_object_profile.sla_classes | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} SLA Class Feature {{ sla_class.name }}

    ${sla_classes}=    Get Value From Json    ${sla_class_raw.json()}    $..data[?(@..name=='{{ sla_class.name }}')]..payload
    Run Keyword If    ${sla_classes} == []    Fail    Feature '{{ sla_class.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${sla_classes[0]}    $..name    {{ sla_class.name }}    msg=name
    Should Be Equal Value Json Special_String     ${sla_classes[0]}     $.description    {{ sla_class.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${sla_classes[0]}    $.data.entries[0].jitter   {{ sla_class.jitter_ms | default('not_defined') }}    not_defined     msg=jitter    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sla_classes[0]}    $.data.entries[0].latency   {{ sla_class.latency_ms | default('not_defined') }}    not_defined     msg=latency    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sla_classes[0]}    $.data.entries[0].loss   {{ sla_class.loss_percentage | default('not_defined') }}    not_defined     msg=loss    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sla_classes[0]}    $.data.entries[0].fallbackBestTunnel.criteria   {{ sla_class.fallback_best_tunnel_criteria | default('not_defined') }}    not_defined     msg=fallback_best_tunnel_criteria    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sla_classes[0]}    $.data.entries[0].fallbackBestTunnel.jitterVariance   {{ sla_class.fallback_best_tunnel_jitter_variance | default('not_defined') }}    not_defined     msg=fallback_best_tunnel_jitter_variance    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sla_classes[0]}    $.data.entries[0].fallbackBestTunnel.latencyVariance   {{ sla_class.fallback_best_tunnel_latency_variance | default('not_defined') }}    not_defined     msg=fallback_best_tunnel_latency_variance    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${sla_classes[0]}    $.data.entries[0].fallbackBestTunnel.lossVariance   {{ sla_class.fallback_best_tunnel_loss_variance | default('not_defined') }}    not_defined     msg=fallback_best_tunnel_loss_variance    var_msg=not_defined

    ${app_probe_id}=   Get Value From Json   ${sla_classes[0]}    $..appProbeClass.refId.value
{% if sla_class.app_probe_class | default("not_defined") == "not_defined" %}
   Should Be Empty   ${app_probe_id}  msg={{ sla_class.name }}: App Probe Class
{% else %}
   ${app_probe_object}=   GET On Session   sdwan_manager   /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/app-probe/${app_probe_id[0]}
   Should Be Equal Value Json String   ${app_probe_object.json()}   $..name   {{ sla_class.app_probe_class }}  msg={{ sla_class.name }}: App Probe Class
{% endif %}


{% endfor %}

{% endif %}