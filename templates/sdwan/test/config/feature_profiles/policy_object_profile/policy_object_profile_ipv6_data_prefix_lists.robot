*** Settings ***
Documentation   Verify Policy Object Feature Profile Configuration IPv6 Data Prefix List
Name            Policy Object Profile IPv6 Data Prefix List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     policy_object_profile   ipv6_data_prefix_lists
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.policy_object_profile is defined and sdwan.feature_profiles.policy_object_profile.ipv6_data_prefix_lists is defined %}

*** Test Cases ***
Get Policy Object Profile
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object
    Set Suite Variable    ${r}


Get IPv6 Data Prefix Lists
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ sdwan.feature_profiles.policy_object_profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${ipv6_data_prefix_raw}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/policy-object/${profile_id[0]}/data-ipv6-prefix
    Set Suite Variable    ${ipv6_data_prefix_raw}


{% for ipv6_data_prefix_list in sdwan.feature_profiles.policy_object_profile.ipv6_data_prefix_lists | default([]) %}

Verify Feature Profiles Policy Object Profile {{ sdwan.feature_profiles.policy_object_profile.name }} IPv6 Data Prefix List Feature {{ ipv6_data_prefix_list.name }}

    ${ipv6_data_prefix_lists}=    Get Value From Json    ${ipv6_data_prefix_raw.json()}    $..data[?(@..name=='{{ ipv6_data_prefix_list.name }}')]..payload
    Run Keyword If    ${ipv6_data_prefix_lists} == []    Fail    Feature '{{ ipv6_data_prefix_list.name }}' expected to be configured within the policy object profile '{{ sdwan.feature_profiles.policy_object_profile.name }}' on the Manager

    Should Be Equal Value Json String    ${ipv6_data_prefix_lists[0]}    $..name    {{ ipv6_data_prefix_list.name }}    msg=name
    Should Be Equal Value Json Special_String     ${ipv6_data_prefix_lists[0]}     $.description    {{ ipv6_data_prefix_list.description | default('not_defined') | normalize_special_string }}    msg=description

    ${prefixes_list}=    Create List    {{ ipv6_data_prefix_list.get('prefixes', []) | join('   ') }}
    # Extract features from the JSON
    ${prefixes_list_json}=    Evaluate    [f"{item['ipv6Address']['value']}/{item['ipv6PrefixLength']['value']}" for item in ${ipv6_data_prefix_lists[0]['data']['entries']} if 'ipv6Address' in item and 'ipv6PrefixLength' in item]
    Lists Should Be Equal    ${prefixes_list}    ${prefixes_list_json}    ignore_order=True    msg=ip prefix

{% endfor %}

{% endif %}