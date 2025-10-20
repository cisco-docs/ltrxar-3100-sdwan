*** Settings ***
Documentation   Verify Secure App Hosting Feature Templates
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.secure_app_hosting_templates is defined %}

*** Test Cases ***
Get Secure App Hosting Feature Templates
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="virtual-application-utd")]
    Set Suite Variable    ${r}

{% for ft_yaml in sdwan.edge_feature_templates.secure_app_hosting_templates | default([]) %}

Verify Edge Feature Template Secure App Hosting Feature Template {{ ft_yaml.name }}
    ${ft_summary_json}=    Get Value From Json    ${r}    $[?(@.templateName="{{ ft_yaml.name }}")]
    Should Not be Empty   ${ft_summary_json}   msg=Feature Template '{{ft_yaml.name}}' should be present on the Manager
    Should Be Equal Value Json String    ${ft_summary_json}    $..templateName    {{ ft_yaml.name }}    msg=name
    Should Be Equal Value Json Special_String    ${ft_summary_json}    $..templateDescription    {{ ft_yaml.description | normalize_special_string }}    msg=description

    # Device types validation
    {% set device_types_yaml = [] %}
    {% for item in ft_yaml.device_types | default(defaults.sdwan.edge_feature_templates.secure_app_hosting_templates.device_types) %}
    {% set device_type = "vedge-" ~ item %}
    {% set _ = device_types_yaml.append(device_type) %}
    {% endfor %}
    ${device_types_json}=    Get Value From Json    ${ft_summary_json}    $..deviceType
    ${device_types_yaml}=    Create List           {{ device_types_yaml | join('   ') }}
    Lists Should Be Equal    ${device_types_json}[0]    ${device_types_yaml}    ignore_order=True    msg=device_types

    # Get template definition
    ${ft_id}=    Get Value From Json    ${r}    $[?(@.templateName="{{ ft_yaml.name }}")].templateId
    ${ft}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${ft_id[0]}

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $.virtual-application..vipValue..utd.nat
    ...    {{ ft_yaml.nat | default("not_defined") }}
    ...    {{ ft_yaml.nat_variable | default("not_defined") }}
    ...    msg=nat

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $.virtual-application..vipValue..utd..["database-url"]
    ...    {{ ft_yaml.download_url_database_on_device | default("not_defined") }}
    ...    {{ ft_yaml.download_url_database_on_device_variable | default("not_defined") }}
    ...    msg=download_url_database_on_device

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $.virtual-application..vipValue..utd..["resource-profile"]
    ...    {{ ft_yaml.resource_profile | default("not_defined") }}
    ...    {{ ft_yaml.resource_profile_variable | default("not_defined") }}
    ...    msg=resource_profile

{% endfor %}

{% endif %}
