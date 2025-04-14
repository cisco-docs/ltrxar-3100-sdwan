*** Settings ***
Documentation   Verify CLI Feature Template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.cli_templates is defined %}

*** Test Cases ***
Get CLI Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cli-template")]
    Set Suite Variable    ${r}

{% for cli in sdwan.edge_feature_templates.cli_templates | default([]) %}

Verify Edge Feature Template CLI Add-on template {{ cli.name }}
    ${cli_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{cli.name }}")]
    Should Be Equal Value Json String    ${cli_id}    $..templateName    {{ cli.name }}    msg=name
    Should Be Equal Value Json Special_String    ${cli_id}    $..templateDescription    {{ cli.description | normalize_special_string }}    msg=description

{% set test_list = [] %}
{% for item in cli.device_types | default(defaults.sdwan.edge_feature_templates.cli_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${cli_id}    $..deviceType
    ${test_list}=    Create List    {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device types

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{cli.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    ${config_dt}=    Get Value From Json    ${r_id.json()}    $.config.vipValue
    ${config_split}=    Split string    ${config_dt[0]}    separator=\n
    ${res_config_list}=    Evaluate    [s.strip() for s in ${config_split} if s.strip()]

    ${exp_config_list}=    Create list
{% for line in cli.cli_config.split('\n') %}
    Append To List    ${exp_config_list}    {{ line }}
{% endfor %}

    Lists Should Be Equal    ${res_config_list}    ${exp_config_list}    ignore_order=False    msg=cli config

{% endfor %}

{% endif %}
