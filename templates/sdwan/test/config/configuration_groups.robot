*** Settings ***
Documentation   Verify Configuration Group Configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan   config   configuration_groups
Resource        ../sdwan_common.resource

{% if sdwan.configuration_groups is defined %}

*** Test Cases ***
Get Configuration Groups
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/config-group
    Set Suite Variable    ${r}

{% for configuration_group in sdwan.configuration_groups | default([]) %}

Verify Configuration Group {{ configuration_group.name }}
    ${cfg}=    Get Value From Json    ${r.json()}    $[?(@.name=='{{ configuration_group.name }}')]
    Run Keyword If    ${cfg} == []    Fail    Configuration Group '{{configuration_group.name}}' should be present on the Manager
    ${cfg_id}=    Get Value From Json    ${cfg}    $..id

    Should Be Equal Value Json String    ${cfg[0]}    $.name    {{ configuration_group.name }}    msg=name
    Should Be Equal Value Json Special_String    ${cfg[0]}    $.description    {{ configuration_group.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json String    ${cfg[0]}    $.profiles[?(@.type=='cli')].name    {{ configuration_group.cli_profile | default('not_defined') }}    msg=cli_profile
    Should Be Equal Value Json String    ${cfg[0]}    $.profiles[?(@.type=='other')].name    {{ configuration_group.other_profile | default('not_defined') }}    msg=other_profile
    Should Be Equal Value Json String    ${cfg[0]}    $.profiles[?(@.type=='policy-object')].name    {{ configuration_group.policy_object_profile | default('not_defined') }}    msg=policy_object_profile
    Should Be Equal Value Json String    ${cfg[0]}    $.profiles[?(@.type=='service')].name    {{ configuration_group.service_profile | default('not_defined') }}    msg=service_profile
    Should Be Equal Value Json String    ${cfg[0]}    $.profiles[?(@.type=='system')].name    {{ configuration_group.system_profile | default('not_defined') }}    msg=system_profile
    Should Be Equal Value Json String    ${cfg[0]}    $.profiles[?(@.type=='transport')].name    {{ configuration_group.transport_profile | default('not_defined') }}    msg=transport_profile

    Should Be Equal Value Json List Length    ${cfg[0]}    $.topology.devices    {{ configuration_group.get('device_tags', []) | length }}    msg=device_tags count   
{% if configuration_group.get('device_tags', []) | length == 2 %}
    Log   === Dual Device Site ===
    
    # extract transport profile ID and service profile ID
    ${transport_id}=    Get Value From Json    ${cfg[0]}    $.profiles[?(@.type=='transport')].id
    ${service_id}=      Get Value From Json    ${cfg[0]}    $.profiles[?(@.type=='service')].id

    # get transport profile details
    ${transport_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${transport_id[0]}
    Run Keyword If    ${transport_res.json()} == []    Fail    The transport profile '{{ configuration_group.transport_profile | default('not_defined') }}' should be present on the Manager
    ${transport_associated_profiles}=    Get Value From Json    ${transport_res.json()}    $.associatedProfileParcels
    
    # get service profile details
    ${service_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${service_id[0]}
    Run Keyword If    ${service_res.json()} == []    Fail    The service profile '{{ configuration_group.service_profile | default('not_defined') }}' should be present on the Manager
    ${service_associated_profiles}=    Get Value From Json    ${service_res.json()}    $.associatedProfileParcels

    ${unsupported_features_ids_device1}=    Get Value From Json    ${cfg[0]}    $.topology.devices[0].unsupportedFeatures..parcelId
    ${unsupported_features_ids_device2}=    Get Value From Json    ${cfg[0]}    $.topology.devices[1].unsupportedFeatures..parcelId

    # two dimensional list of devices features
    @{feature_list_devices} =    Create List
{% for device_tag in configuration_group.get('device_tags', []) %}
    Log   Device Tag: {{ device_tag.name }}
    Should Be Equal Value Json String     ${cfg[0]}    $.topology.devices[{{ loop.index0 }}].criteria.value    {{ device_tag.name | default('not_defined') }}    msg=device_tag_name
    
    @{feature_list} =    Create List
{% for feature in device_tag.get('features', []) %}
    Log   Feature: {{ feature }}

    ${feature_id}=    Get Value From Json    ${transport_associated_profiles[0]}    $..subparcels[?(@.payload.name=='{{ feature }}')].parcelId
    IF    ${feature_id} == []
        ${feature_id}=    Get Value From Json    ${service_associated_profiles[0]}      $..subparcels[?(@.payload.name=='{{ feature }}')].parcelId
        Run Keyword If    ${feature_id} == []    Fail    Feature '{{ feature }}' should be present on the Manager
    END
    Append To List    ${feature_list}    ${feature_id[0]}

{% endfor %}

    Append To List    ${feature_list_devices}    ${feature_list}
{% endfor %}

    Log    Feature List Devices: ${feature_list_devices}
    # features defined in 1st device should be the same as the unsupported features list on 2nd device, vice versa
    Lists Should Be Equal    ${feature_list_devices[0]}    ${unsupported_features_ids_device2}    ignore_order=True
    Lists Should Be Equal    ${feature_list_devices[1]}    ${unsupported_features_ids_device1}    ignore_order=True

{% endif %}

{% endfor %}

{% endif %}
