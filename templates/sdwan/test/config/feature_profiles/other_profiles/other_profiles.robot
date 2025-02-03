*** Settings ***
Documentation   Verify Other Feature Profile Configuration
Name            Other Profiles Summary
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles    other_feature_profiles
Resource        ../../../sdwan_common.resource

{% if sdwan.feature_profiles.other_profiles is defined %}

*** Test Cases ***
Get Other Profiles
    ${r}=    Get On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/other
    Set Suite Variable   ${r}

{% for profile in sdwan.feature_profiles.other_profiles | default([]) %}

Verify Feature Profiles Other Profiles {{ profile.name }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    Should Be Equal Value Json String    ${profile}    $..profileName    {{ profile.name }}    msg=name
    ${profile_description_raw}=    Get Value From Json    ${profile}    $..description
    ${profile_description}=    Set Variable If    ${profile_description_raw} == [""]    not_defined    ${profile_description_raw[0]}
    Should Be Equal As Strings    ${profile_description}    {{ profile.description | default("not_defined") }}    msg=description
    
 {% if 'strict_config_check' not in robot_exclude_tags | default() %}
    ${profile_features_res}=   GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/other/${profile_id}[0]
    ${profile_features}=   Get Value From Json    ${profile_features_res.json()}    $..associatedProfileParcels
    # Extract feature list in profile from the data model
    ${profile_features_data_model}=    Create List
    Append To List    ${profile_features_data_model}    {{ profile.ucse.name }}
    Append To List    ${profile_features_data_model}    {{ profile.thousandeyes.name }}
    Log    ${profile_features_data_model}
    # Add multiple instances of the features of same type, where applicable
    # {% for tracker in profile.ipv4_trackers %}
    # Append To List    ${profile_features_data_model}    {{ tracker.name }}
    # {% endfor %}
    
     # Extract features from the JSON
    ${profile_features_js}=    Evaluate    [p['payload']['name'] for p in ${profile_features}[0]] 
    ${data_match}=    Evaluate    set(${profile_features_js}) ^ set(${profile_features_data_model})    
    IF     ${data_match} != set()
        FOR    ${feature}    IN    @{profile_features_js}   
            Run Keyword And Continue On Failure    Run Keyword If    '${feature}' not in ${profile_features_data_model}    Fail    Feature Profile '{{profile.name}}' has the feature ${feature} that is not present in the data model
        END 
    ELSE
        Log    Feature Profile '{{profile.name}}' contains all features defined in the configuration data model
    END
{% endif %}

{% endfor %}
{% endif %}