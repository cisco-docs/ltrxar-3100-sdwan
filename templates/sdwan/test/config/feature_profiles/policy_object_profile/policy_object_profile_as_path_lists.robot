*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration AS Path List
Name            Policy Object Profile AS Path List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   as_path_lists
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.policy_object_profile is defined and sdwan.feature_profiles.policy_object_profile.as_path_lists is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get AS Path Lists
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${as_path_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/as-path
    Set Suite Variable    ${as_path_raw}


{% for as_path_list in sdwan.feature_profiles.policy_object_profile.as_path_lists | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} AS Path List Feature {{ as_path_list.name }}

    ${as_path_lists}=    Get Value From Json    ${as_path_raw.json()}    $..data[?(@..name=='{{ as_path_list.name }}')]..payload
    Run Keyword If    ${as_path_lists} == []    Fail    Feature '{{ as_path_list.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${as_path_lists[0]}    $..name    {{ as_path_list.name }}    msg=name
    Should Be Equal Value Json Special_String     ${as_path_lists[0]}     $.description    {{ as_path_list.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${as_path_lists[0]}    $.data.asPathListNum   {{ as_path_list.id | default('not_defined') }}    not_defined     msg=as path list num    var_msg=not_defined

    ${as_paths_list}=    Create List    {{ as_path_list.get('as_paths', []) | join('   ') }}
    # Extract features from the JSON
    ${as_paths_list_json}=    Evaluate    [ item['asPath']['value'] for item in ${as_path_lists[0]['data']['entries']} if 'asPath' in item and 'value' in item['asPath'] ]
    Lists Should Be Equal    ${as_paths_list}    ${as_paths_list_json}    ignore_order=True    msg=as paths

{% endfor %}

{% endif %}