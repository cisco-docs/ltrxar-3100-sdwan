*** Settings ***
Documentation   Verify ThousandEyes Feature Templates
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.thousandeyes_templates is defined %}

*** Test Cases ***
Get ThousandEyes Feature Templates
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_thousandeyes")]
    Set Suite Variable    ${r}

{% for ft_yaml in sdwan.edge_feature_templates.thousandeyes_templates | default([]) %}

Verify Edge Feature Template ThousandEyes Feature Template {{ ft_yaml.name }}
    ${ft_summary_json}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ft_yaml.name }}")]
    Should Not be Empty   ${ft_summary_json}   msg=Feature Template '{{ft_yaml.name}}' should be present on the Manager
    Should Be Equal Value Json String    ${ft_summary_json}    $..templateName    {{ ft_yaml.name }}    msg=name
    Should Be Equal Value Json Special_String    ${ft_summary_json}    $..templateDescription    {{ ft_yaml.description | normalize_special_string }}    msg=description

    # Device types validation
    {% set device_types_yaml = [] %}
    {% for item in ft_yaml.device_types | default(defaults.sdwan.edge_feature_templates.thousandeyes_templates.device_types) %}
    {% set device_type = "vedge-" ~ item %}
    {% set _ = device_types_yaml.append(device_type) %}
    {% endfor %}
    ${device_types_json}=    Get Value From Json    ${ft_summary_json}    $..deviceType
    ${device_types_yaml}=    Create List           {{ device_types_yaml | join('   ') }}
    Lists Should Be Equal    ${device_types_json}[0]    ${device_types_yaml}    ignore_order=True    msg=device_types

    # Get template definition
    ${ft_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ft_yaml.name }}")].templateId
    ${ft}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${ft_id[0]}

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..hostname
    ...    {{ ft_yaml.hostname | default("not_defined") }}
    ...    {{ ft_yaml.hostname_variable | default("not_defined") }}
    ...    msg=hostname

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..["name-server"]
    ...    {{ ft_yaml.name_server | default("not_defined") }}
    ...    {{ ft_yaml.name_server_variable | default("not_defined") }}
    ...    msg=name_server

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..proxy_host
    ...    {{ ft_yaml.proxy_host | default("not_defined") }}
    ...    {{ ft_yaml.proxy_host_variable | default("not_defined") }}
    ...    msg=proxy_host

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..proxy_port
    ...    {{ ft_yaml.proxy_port | default("not_defined") }}
    ...    {{ ft_yaml.proxy_port_variable | default("not_defined") }}
    ...    msg=proxy_port

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..proxy_type
    ...    {{ ft_yaml.proxy_type | default("not_defined") }}
    ...    {{ ft_yaml.proxy_type_variable | default("not_defined") }}
    ...    msg=proxy_type

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..proxy_pac.pac_url
    ...    {{ ft_yaml.proxy_pac_url | default("not_defined") }}
    ...    {{ ft_yaml.proxy_pac_url_variable | default("not_defined") }}
    ...    msg=proxy_pac_url

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..["te-mgmt-ip"]
    ...    {{ ft_yaml.ip | default("not_defined") }}
    ...    {{ ft_yaml.ip_variable | default("not_defined") }}
    ...    msg=ip

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..["te-vpg-ip"]
    ...    {{ ft_yaml.default_gateway | default("not_defined") }}
    ...    {{ ft_yaml.default_gateway_variable | default("not_defined") }}
    ...    msg=default_gateway

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..te.token
    ...    {{ ft_yaml.account_group_token | default("not_defined") }}
    ...    {{ ft_yaml.account_group_token_variable | default("not_defined") }}
    ...    msg=account_group_token

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..vpn
    ...    {{ ft_yaml.vpn_id | default("not_defined") }}
    ...    {{ ft_yaml.vpn_id_variable | default("not_defined") }}
    ...    msg=vpn_id

{% endfor %}
{% endif %}
