*** Settings ***
Documentation   Verify System Feature Profile Configuration Banner
Name            System Profiles Banner
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_profiles   banner
Resource        ../../../sdwan_common.resource

{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.system_profiles is defined %}
{% set profile_banner_list = [] %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.banner is defined %}
  {% set _ = profile_banner_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_banner_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.banner is defined %}

Verify Feature Profiles System Profiles {{ profile.name }} Banner Feature {{ profile.banner.name | default(defaults.sdwan.feature_profiles.system_profiles.banner.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${system_banner_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id[0]}/banner
    ${system_banner}=    Get Value From Json    ${system_banner_res.json()}    $..payload
    Run Keyword If    ${system_banner} == []    Fail    Feature '{{ profile.banner.name | default(defaults.sdwan.feature_profiles.system_profiles.banner.name) }}' expected to be configured within the system profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${system_banner}

    Should Be Equal Value Json String    ${system_banner[0]}    $..name    {{ profile.banner.name | default(defaults.sdwan.feature_profiles.system_profiles.banner.name) }}    msg=name
    Should Be Equal Value Json Special_String     ${system_banner[0]}     $.description    {{ profile.banner.description | default('not_defined') | normalize_special_string }}    msg=description

    {% if profile.banner.login is defined %}
        Should Be Equal Value Json Special_String   ${system_banner[0]}    $.data.login.value    {{ profile.banner.login | default("not_defined") | normalize_special_string }}    msg=login
    {% else %}
        Should Be Equal Value Json Yaml    ${system_banner[0]}    $.data.login    {{ profile.banner.login | default('not_defined') }}    {{ profile.banner.login_variable | default('not_defined') }}    msg=login    var_msg=login variable
    {% endif %}

    
    {% if profile.banner.motd is defined %}
        Should Be Equal Value Json Special_String   ${system_banner[0]}    $.data.motd.value    {{ profile.banner.motd | default("not_defined") | normalize_special_string }}    msg=motd
    {% else %}
        Should Be Equal Value Json Yaml    ${system_banner[0]}    $.data.motd    {{ profile.banner.motd | default('not_defined') }}    {{ profile.banner.motd_variable | default('not_defined') }}    msg=motd    var_msg=motd variable
    {% endif %}


{% endif %}
{% endfor %}

{% endif %}

{% endif %}