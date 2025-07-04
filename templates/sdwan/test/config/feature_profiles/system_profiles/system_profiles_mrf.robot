*** Settings ***
Documentation   Verify System Feature Profile Configuration MRF
Name            System Profiles MRF
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_profiles   mrf
Resource        ../../../sdwan_common.resource


{% set profile_mrf_list = [] %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.mrf is defined %}
  {% set _ = profile_mrf_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_mrf_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.mrf is defined %}

Verify Feature Profiles System Profiles {{ profile.name }} MRF Feature {{ profile.mrf.name | default(defaults.sdwan.feature_profiles.system_profiles.mrf.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${system_mrf_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id[0]}/mrf
    ${system_mrf}=    Get Value From Json    ${system_mrf_res.json()}    $..payload
    Run Keyword If    ${system_mrf} == []    Fail    Feature '{{ profile.mrf.name | default(defaults.sdwan.feature_profiles.system_profiles.mrf.name) }}' expected to be configured within the system profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${system_mrf}

    Should Be Equal Value Json String    ${system_mrf[0]}    $..name    {{ profile.mrf.name | default(defaults.sdwan.feature_profiles.system_profiles.mrf.name) }}    msg=name
    Should Be Equal Value Json Special_String    ${system_mrf[0]}    $..description     {{ profile.mrf.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json String    ${system_mrf[0]}    $..enableMrfMigration.value    {{ profile.mrf.migration_to_mrf | default('not_defined') }}    msg=migration_to_mrf
    Should Be Equal Value Json String    ${system_mrf[0]}    $..migrationBgpCommunity.value    {{ profile.mrf.migration_bgp_community | default('not_defined') }}    msg=migration_bgp_community
    Should Be Equal Value Json String    ${system_mrf[0]}    $..regionId.value    {{ profile.mrf.region_id | default('not_defined') }}    msg=region_id

    Should Be Equal Value Json Yaml    ${system_mrf[0]}    $..role   {{ profile.mrf.role| default('not_defined') }}     {{ profile.mrf.role_variable| default('not_defined') }}     msg=role    var_msg=role variable
    Should Be Equal Value Json Yaml    ${system_mrf[0]}    $..secondaryRegion   {{ profile.mrf.secondary_region_id| default('not_defined') }}     {{ profile.mrf.secondary_region_id_variable| default('not_defined') }}     msg=secondary_region_id    var_msg=secondary_region_id variable

{% endif %}
{% endfor %}

{% endif %}
