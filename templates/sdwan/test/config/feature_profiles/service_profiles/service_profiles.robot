*** Settings ***
Documentation   Verify Service Feature Profile Configuration
Name            Service Profiles Summary
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     service_profiles
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.service_profiles is defined %}

*** Test Cases ***
Get Service Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.service_profiles | default([]) %}

Verify Feature Profiles Service Profile {{ profile.name }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    Should Be Equal Value Json String    ${profile}    $..profileName    {{ profile.name }}    msg=name
    Should Be Equal Value Json Special_String    ${profile}    $..description    {{ profile.description | default('not_defined') | normalize_special_string }}    msg=description

 {% if 'strict_config_check' not in robot_exclude_tags | default() %}
    ${profile_features_res}=   GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id}[0]
    ${profile_features}=   Get Value From Json    ${profile_features_res.json()}    $..associatedProfileParcels

    # Extract feature list in profile from the data model
    ${profile_features_data_model} =    Create List
    {% for key,value in profile.items() if key != 'name' and key != 'description' %}
      {% if value is mapping %}
        {% if 'name' in value %}
            Append To List    ${profile_features_data_model}    {{ value.name }}
        {% else %}
            Append To List    ${profile_features_data_model}    {{ key }}
        {% endif %}
     {% elif value is iterable and value is not string %}
        {% for item in value %}
                Append To List    ${profile_features_data_model}    {{ item.name }}
        {% endfor %}
      {% endif %}
    {% endfor %}
    Log    ${profile_features_data_model}

     # Extract features from the JSON
    ${profile_features_js}=    Evaluate    [p['payload']['name'] for p in ${profile_features}[0]] 
    ${data_match}=    Evaluate    set(${profile_features_js}) ^ set(${profile_features_data_model})
    IF  ${data_match} != set()
        ${extra_on_manager}=      Evaluate    set(${profile_features_js}) - set(${profile_features_data_model})
        ${missing_on_manager}=    Evaluate    set(${profile_features_data_model}) - set(${profile_features_js})
        Run Keyword And Continue On Failure    Run Keyword If    ${extra_on_manager}      Fail    Feature Profile '{{profile.name}}' has the feature(s) ${extra_on_manager} that is not present in the data model
        Run Keyword And Continue On Failure    Run Keyword If    ${missing_on_manager}    Fail    Feature Profile '{{profile.name}}' has the feature(s) ${missing_on_manager} that is in data model, but not present on the Manager        
    ELSE
        Log    Feature Profile '{{profile.name}}' has exactly same feature list on Manager as defined in configuration data model
    END
 {% endif %}

{% endfor %}
{% endif %}