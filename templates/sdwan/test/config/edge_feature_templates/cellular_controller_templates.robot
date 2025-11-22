*** Settings ***
Documentation   Verify Cellular Controller Feature Templates
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates is defined and sdwan.edge_feature_templates.cellular_controller_templates is defined %}

*** Test Cases ***
Get Cellular Controller Feature Templates
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cellular-cedge-controller")]
    Set Suite Variable    ${r}

{% for ft_yaml in sdwan.edge_feature_templates.cellular_controller_templates | default([]) %}

Verify Edge Feature Template Cellular Controller Feature Template {{ ft_yaml.name }}
    ${ft_summary_json}=    Get Value From Json    ${r}    $[?(@.templateName="{{ ft_yaml.name }}")]
    Should Not be Empty   ${ft_summary_json}   msg=Feature Template '{{ft_yaml.name}}' should be present on the Manager
    Should Be Equal Value Json String    ${ft_summary_json}    $..templateName    {{ ft_yaml.name }}    msg=name
    Should Be Equal Value Json Special_String    ${ft_summary_json}    $..templateDescription    {{ ft_yaml.description | normalize_special_string }}    msg=description

    # Device types validation
    {% set device_types_yaml = [] %}
    {% for item in ft_yaml.device_types | default(defaults.sdwan.edge_feature_templates.cellular_controller_templates.device_types) %}
    {% set device_type = "vedge-" ~ item %}
    {% set _ = device_types_yaml.append(device_type) %}
    {% endfor %}
    ${device_types_json}=    Get Value From Json    ${ft_summary_json}    $..deviceType
    ${device_types_yaml}=    Create List           {{ device_types_yaml | join('   ') }}
    Lists Should Be Equal    ${device_types_json}[0]    ${device_types_yaml}    ignore_order=True    msg=device_types

    # Get template definition
    ${ft_id}=    Get Value From Json    ${r}    $[?(@.templateName="{{ ft_yaml.name }}")].templateId
    ${ft}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${ft_id[0]}

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..id
    ...    {{ ft_yaml.cellular_interface_id | default("not_defined") }}
    ...    {{ ft_yaml.cellular_interface_id_variable | default("not_defined") }}
    ...    msg=cellular_interface_id

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..primary.slot
    ...    {{ ft_yaml.primary_sim_slot | default("not_defined") }}
    ...    {{ ft_yaml.primary_sim_slot_variable | default("not_defined") }}
    ...    msg=primary_sim_slot

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..["max-retry"]
    ...    {{ ft_yaml.sim_failover_retries | default("not_defined") }}
    ...    {{ ft_yaml.sim_failover_retries_variable | default("not_defined") }}
    ...    msg=sim_failover_retries

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..failovertimer
    ...    {{ ft_yaml.sim_failover_timeout | default("not_defined") }}
    ...    {{ ft_yaml.sim_failover_timeout_variable | default("not_defined") }}
    ...    msg=sim_failover_timeout

{% endfor %}

{% endif %}