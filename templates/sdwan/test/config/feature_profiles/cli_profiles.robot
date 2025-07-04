*** Settings ***
Documentation   Verify CLI Feature Profile Configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles    cli_profiles
Resource        ../../sdwan_common.resource

{% if sdwan.feature_profiles.cli_profiles is defined %}

*** Test Cases ***
Get CLI Profiles
    ${r}=    Get On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/cli
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.cli_profiles | default([]) %}

Verify Feature Profiles CLI Profiles {{ profile.name }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    Should Be Equal Value Json String    ${profile}    $..profileName    {{ profile.name }}    msg=name
    Should Be Equal Value Json Special_String   ${profile}    $..description    {{ profile.description | default('not_defined') | normalize_special_string }}    msg=description

    ${cli_config_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/cli/${profile_id}[0]/config
    ${cli_config}=    Get Value From Json    ${cli_config_res.json()}    $..payload
    Set Suite Variable    ${cli_config}

{% if profile.config is defined %}

Verify Feature Profiles CLI Profiles {{ profile.name }} Config Feature {{ profile.config.name | default(defaults.sdwan.feature_profiles.cli_profiles.config.name) }}
    Run Keyword If    ${cli_config} == []    Fail    Feature '{{ profile.config.name | default(defaults.sdwan.feature_profiles.cli_profiles.config.name) }}' expected to be configured within the cli profile '{{profile.name}}' on the Manager
    Should Be Equal Value Json String    ${cli_config[0]}    $.name    {{ profile.config.name | default(defaults.sdwan.feature_profiles.cli_profiles.config.name) }}    msg=name

    Should Be Equal Value Json Special_String     ${cli_config[0]}    $..description    {{ profile.config.description | default('not_defined') | normalize_special_string }}    msg=description

    ${config}=    Get Value From Json    ${cli_config[0]}    $..config
    ${config_split}=    Split string    ${config[0]}    separator=\n
    ${res_config_list}=    Evaluate    [s.strip() for s in ${config_split} if s.strip()]

    ${exp_config_list}=    Create list

{% for line in profile.config.get('cli_configuration', '').split('\n') %}
    Append To List    ${exp_config_list}    {{ line }}
{% endfor %}

    Lists Should Be Equal    ${res_config_list}    ${exp_config_list}    ignore_order=False    msg=cli_configuration

{% elif 'strict_config_check' not in robot_exclude_tags | default() %}

    Run Keyword If    ${cli_config}    Fail    Feature Profile {{profile.name}} has the config feature ${cli_config[0]['name']} that is not present in the data model

{% endif %}

{% endfor %}

{% endif %}
