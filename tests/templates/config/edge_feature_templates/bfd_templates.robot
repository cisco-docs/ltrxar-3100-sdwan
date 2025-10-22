*** Settings ***
Documentation   Verify BFD Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.bfd_templates is defined %}

*** Test Cases ***
Get BFD Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_bfd")]
    Set Suite Variable    ${r}

{% for bfd_template in sdwan.edge_feature_templates.bfd_templates | default([]) %}

Verify Edge Feature Template BFD Feature template {{ bfd_template.name }}
    ${bfd_template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{bfd_template.name }}")]
    Should Be Equal Value Json String    ${bfd_template_id}    $..templateName    {{ bfd_template.name }}    msg=name    
    Should Be Equal Value Json Special_String    ${bfd_template_id}    $..templateDescription    {{ bfd_template.description | normalize_special_string }}    msg=description

{% set test_list = [] %}
{% for item in bfd_template.device_types | default(defaults.sdwan.edge_feature_templates.bfd_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${bfd_template_id}    $..deviceType
    ${test_list}=   Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device types

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{bfd_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    ${color_items}=    Get Value From Json    ${r_id.json()}    $.color.vipValue
    ${res_colors_length}=    Get Length     ${color_items[0]}
    Should Be Equal As Integers    ${res_colors_length}    {{ bfd_template.colors | length }}    msg=colors

{% for color in bfd_template.colors | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["default-dscp"].vipValue    {{ bfd_template.default_dscp | default("not_defined") }}    msg=default dscp
    Should Be Equal Value Json String    ${r_id.json()}    $..["default-dscp"].vipVariableName    {{ bfd_template.default_dscp_variable | default("not_defined") }}    msg=default dscp variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["app-route"]..multiplier.vipValue    {{ bfd_template.multiplier | default("not_defined") }}    msg=multiplier
    Should Be Equal Value Json String    ${r_id.json()}    $..["app-route"]..multiplier.vipVariableName    {{ bfd_template.multiplier_variable | default("not_defined") }}    msg=multiplier variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["app-route"]..["poll-interval"].vipValue    {{ bfd_template.poll_interval | default("not_defined") }}    msg=poll interval
    Should Be Equal Value Json String    ${r_id.json()}    $..["app-route"]..["poll-interval"].vipVariableName    {{ bfd_template.poll_interval_variable | default("not_defined") }}    msg=poll interval variable

    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}].color.vipValue    {{ color.color | default("not_defined") }}    msg=color
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}].color.vipVariableName    {{ color.color_variable | default("not_defined") }}    msg=color variable
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}].dscp.vipValue    {{ color.default_dscp | default("not_defined") }}    msg=color default dscp
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}].dscp.vipVariableName    {{ color.default_dscp_variable | default("not_defined") }}    msg=color default dscp variable
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}]..["hello-interval"].vipValue    {{ color.hello_interval | default("not_defined") }}    msg=color hello interval
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}]..["hello-interval"].vipVariableName    {{ color.hello_interval_variable | default("not_defined") }}    msg=color hello interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}].multiplier.vipValue    {{ color.multiplier | default("not_defined") }}    msg=color multiplier
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}].multiplier.vipVariableName    {{ color.multiplier_variable | default("not_defined") }}    msg=color multiplier variable
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}].vipOptional    {{ color.optional | default("not_defined") }}    msg=color optional
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}]..["pmtu-discovery"].vipValue    {{ color.path_mtu_discovery | default("not_defined") | lower() }}    msg=color path mtu discovery
    Should Be Equal Value Json String    ${r_id.json()}    $..color.vipValue[{{loop.index0}}]..["pmtu-discovery"].vipVariableName    {{ color.path_mtu_discovery_variable | default("not_defined") }}    msg=color path mtu discovery variable

{% endfor %}

{% endfor %}

{% endif %}
