*** Settings ***
Documentation   Verify CLI Feature Template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.cli_templates is defined %}

*** Test Cases ***
Get CLI Feature Templates
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cli-template")]
    Set Suite Variable    ${r}

{% for ft_yaml in sdwan.edge_feature_templates.cli_templates | default([]) %}

Verify Edge Feature Template CLI Feature Template {{ ft_yaml.name }}
    ${ft_summary_json}=    Get Value From Json    ${r}    $[?(@.templateName="{{ ft_yaml.name }}")]\
    Should Not be Empty   ${ft_summary_json}   msg=Feature Template '{{ft_yaml.name}}' should be present on the Manager
    Should Be Equal Value Json String    ${ft_summary_json}    $..templateName    {{ ft_yaml.name }}    msg=name
    Should Be Equal Value Json Special_String    ${ft_summary_json}    $..templateDescription    {{ ft_yaml.description | normalize_special_string }}    msg=description

    # Device types validation
    {% set device_types_yaml = [] %}
    {% for item in ft_yaml.device_types | default(defaults.sdwan.edge_feature_templates.cli_templates.device_types) %}
    {% set device_type = "vedge-" ~ item %}
    {% set _ = device_types_yaml.append(device_type) %}
    {% endfor %}
    ${device_types_json}=    Get Value From Json    ${ft_summary_json}    $..deviceType
    ${device_types_yaml}=    Create List           {{ device_types_yaml | join('   ') }}
    Lists Should Be Equal    ${device_types_json}[0]    ${device_types_yaml}    ignore_order=True    msg=device_types

    # Get template definition
    ${ft_id}=    Get Value From Json    ${r}    $[?(@.templateName="{{ ft_yaml.name }}")].templateId
    ${ft}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${ft_id[0]}

    # CLI configuration validation
    ${config_dt}=    Get Value From Json    ${ft.json()}    $.config.vipValue
    ${config_split}=    Split string    ${config_dt[0]}    separator=\n
    ${res_config_list}=    Evaluate    [s.strip() for s in ${config_split} if s.strip()]

    ${exp_config_list}=    Create list
{% for line in ft_yaml.cli_config.split('\n') %}
    Append To List    ${exp_config_list}    {{ line }}
{% endfor %}

    Lists Should Be Equal    ${res_config_list}    ${exp_config_list}    ignore_order=False    msg=cli_config

{% endfor %}

{% endif %}
