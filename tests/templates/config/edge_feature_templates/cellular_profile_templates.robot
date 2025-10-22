*** Settings ***
Documentation   Verify Cellular Profile Feature Template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.cellular_profile_templates is defined %}

*** Test Cases ***
Get Cellular Profile Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cellular-cedge-profile")]
    Set Suite Variable    ${r}

{% for cellular_profile_template in sdwan.edge_feature_templates.cellular_profile_templates | default([]) %}

Verify Cellular Profile Feature template {{ cellular_profile_template.name }}
    ${cell_prof_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{cellular_profile_template.name}}")]
    Should Be Equal Value Json String    ${cell_prof_id}    $..templateName    {{ cellular_profile_template.name }}    msg=name
    Should Be Equal Value Json Special_String    ${cell_prof_id}    $..templateDescription    {{ cellular_profile_template.description | normalize_special_string }}    msg=description

    {% set dt_list_local = [] %}
    {% for item in cellular_profile_template.device_types | default(defaults.sdwan.edge_feature_templates.cellular_profile_templates.device_types) %}
    {% set test = "vedge-" ~ item %}
    {% set _ = dt_list_local.append(test) %}
    {% endfor %}

    ${dt_list_remote}=    Get Value From Json    ${cell_prof_id}    $..deviceType
    ${dt_list_local}=    Create List    {{ dt_list_local | join('   ') }}
    Lists Should Be Equal    ${dt_list_remote[0]}    ${dt_list_local}    ignore_order=True    msg=device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ cellular_profile_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}
    
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["id"]    {{ cellular_profile_template.profile_id_variable | default(cellular_profile_template.profile_id | default("not_defined")) }}    msg=profile id
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["apn"]    {{ cellular_profile_template.access_point_name_variable | default(cellular_profile_template.access_point_name | default("not_defined")) }}    msg=access point name
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["pdn-type"]    {{ cellular_profile_template.packet_data_network_type_variable | default(cellular_profile_template.packet_data_network_type | default("not_defined")) }}    msg=packet data network type
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["authentication"]    {{ cellular_profile_template.authentication_type_variable | default(cellular_profile_template.authentication_type | default("not_defined")) }}    msg=authentication type
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["username"]    {{ cellular_profile_template.profile_username_variable | default(cellular_profile_template.profile_username | default("not_defined")) }}    msg=profile username
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["password"]    {{ cellular_profile_template.profile_password_variable | default(cellular_profile_template.profile_password | default("not_defined")) }}    msg=profile password
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["no-overwrite"]    {{ cellular_profile_template.no_overwrite_variable | default(cellular_profile_template.no_overwrite | default("not_defined")) }}    msg=no overwrite

{% endfor %}

{% endif %}