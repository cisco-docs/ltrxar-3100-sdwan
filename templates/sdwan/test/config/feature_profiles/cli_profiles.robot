*** Settings ***
Documentation   Verify CLI Feature Profile Configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles    cli_feature_profiles
Resource        ../../sdwan_common.resource

{% if sdwan.feature_profiles.cli_profiles is defined %}

*** Test Cases ***
Get CLI Profiles
    ${r}=    Get On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/cli
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.cli_profiles | default([]) %}

Verify Feature Profiles CLI Profiles {{ profile.name }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    Should Be Equal Value Json String    ${profile}    $..profileName    {{ profile.name }}    msg=name
    ${profile_description_raw}=    Get Value From Json    ${profile}    $..description
    ${profile_description}=    Set Variable If    ${profile_description_raw} == [""]    not_defined    ${profile_description_raw[0]}
    Should Be Equal As Strings    ${profile_description}    {{ profile.description | default("not_defined") }}    msg=description

    ${cli_config_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/cli/${profile_id}[0]/config
    ${cli_config}=    Get Value From Json    ${cli_config_res.json()}    $..payload
    Set Suite Variable    ${cli_config}

{% if profile.config is defined %}

Verify Feature Profiles CLI Profiles {{ profile.name }} Config Feature {{ profile.config.name | default(defaults.sdwan.feature_profiles.cli_profiles.config.name) }}

    Should Be Equal Value Json String    ${cli_config[0]}    $.name    {{ profile.config.name | default(defaults.sdwan.feature_profiles.cli_profiles.config.name) }}    msg=name

    ${cli_config_description_raw}=    Get Value From Json    ${cli_config[0]}    $..description
    ${cli_config_description}=    Set Variable If    ${cli_config_description_raw} == [""]    not_defined    ${cli_config_description_raw[0]}
    Should Be Equal As Strings    ${cli_config_description}    {{ profile.config.description | default("not_defined") }}    msg=description

    ${config}=    Get Value From Json    ${cli_config[0]}    $..config
    ${config_split}=    Split string    ${config[0]}    separator=\n
    ${res_config_list}=    Evaluate    [s.strip() for s in ${config_split} if s.strip()]

    ${exp_config_list}=    Create list

{% for line in profile.config.cli_configuration.split('\n') %}
    Append To List    ${exp_config_list}    {{ line }}
{% endfor %}

    Lists Should Be Equal    ${res_config_list}    ${exp_config_list}    ignore_order=False    msg=cli_configuration

{% elif 'strict_config_check' not in robot_exclude_tags | default() %}

    Run Keyword If    ${cli_config}    Fail    Feature Profile {{profile.name}} has the config feature ${cli_config[0]['name']} that is not present in the data model

{% endif %}

{% endfor %}

{% endif %}
