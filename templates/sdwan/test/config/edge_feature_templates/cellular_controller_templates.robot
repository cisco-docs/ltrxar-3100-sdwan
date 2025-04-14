*** Settings ***
Documentation   Verify Cellular Controller Feature Template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.cellular_controller_templates is defined %}

*** Test Cases ***
Get Cellular Controller Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cellular-cedge-controller")]
    Set Suite Variable    ${r}

{% for cellular_controller_template in sdwan.edge_feature_templates.cellular_controller_templates | default([]) %}

Verify Cellular Controller Feature template {{ cellular_controller_template.name }}
    ${cell_cont_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{cellular_controller_template.name}}")]
    Should Be Equal Value Json String    ${cell_cont_id}    $..templateName    {{ cellular_controller_template.name }}    msg=name
    Should Be Equal Value Json Special_String    ${cell_cont_id}    $..templateDescription    {{ cellular_controller_template.description | normalize_special_string }}    msg=description

    {% set dt_list_local = [] %}
    {% for item in cellular_controller_template.device_types | default(defaults.sdwan.edge_feature_templates.cellular_controller_templates.device_types) %}
    {% set test = "vedge-" ~ item %}
    {% set _ = dt_list_local.append(test) %}
    {% endfor %}
    ${dt_list_remote}=    Get Value From Json    ${cell_cont_id}    $..deviceType
    ${dt_list_local}=    Create List    {{ dt_list_local | join('   ') }}
    Lists Should Be Equal    ${dt_list_remote[0]}    ${dt_list_local}    ignore_order=True    msg=device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ cellular_controller_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["id"]    {{ cellular_controller_template.cellular_interface_id_variable | default(cellular_controller_template.cellular_interface_id | default("not_defined")) }}    msg=cellular interface id 
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["primary"].slot    {{ cellular_controller_template.primary_sim_slot_variable | default(cellular_controller_template.primary_sim_slot | default("not_defined")) }}    msg=primary sim slot
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["max-retry"]    {{ cellular_controller_template.sim_failover_retries_variable | default(cellular_controller_template.sim_failover_retries | default("not_defined")) }}    msg=sim failover retries
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["failovertimer"]    {{ cellular_controller_template.sim_failover_timeout_variable | default(cellular_controller_template.sim_failover_timeout | default("not_defined")) }}    msg=sim failover timeout

{% endfor %}

{% endif %}