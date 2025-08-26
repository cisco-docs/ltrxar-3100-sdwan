*** Settings ***
Documentation   Verify IGMP Feature Template Configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.igmp_templates is defined %}

*** Test Cases ***
Get IGMP Feature Template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cedge_igmp")]
    Set Suite Variable    ${r}

{% for igmp_template in sdwan.edge_feature_templates.igmp_templates | default([]) %}

Verify Edge Feature IGMP Configuration Template {{ igmp_template.name }}
    ${igmp_template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{igmp_template.name }}")]
    Should Be Equal Value Json String    ${igmp_template_id}    $..templateName    {{ igmp_template.name }}    msg=name    
    Should Be Equal Value Json Special_String    ${igmp_template_id}    $..templateDescription    {{ igmp_template.description | normalize_special_string }}    msg=description

{% set test_list = [] %}
{% for item in igmp_template.device_types | default(defaults.sdwan.edge_feature_templates.igmp_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${igmp_template_id}    $..deviceType
    ${test_list}=   Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device types

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{igmp_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json List Length    ${r_id.json()}   $..interface.vipValue    {{ igmp_template.interfaces | length }}    msg=interfaces length
{% for interface in igmp_template.interfaces | default([]) %}

    Should Be Equal Value Json String      ${r_id.json()}     $..interface.vipValue[{{ loop.index0 }}].name.vipValue          {{ interface.name | default('not_defined') }}               msg=name
    Should Be Equal Value Json String      ${r_id.json()}     $..interface.vipValue[{{ loop.index0 }}].name.vipVariableName   {{ interface.name_variable| default('not_defined') }}       msg=name_variable
    Should Be Equal Value Json String      ${r_id.json()}     $..interface.vipValue[{{ loop.index0 }}].vipOptional            {{ interface.optional | default("not_defined")}}            msg=optional

    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}
    Should Be Equal Value Json List Length    ${r_id.json()}   $..interface.vipValue..join-group.vipValue    {{ interface.join_groups | length }}    msg=join_groups length
{% for group in interface.join_groups | default([]) %}

    Should Be Equal Value Json String       ${r_id.json()}     $..interface.vipValue[${outer_loop_index}].join-group.vipValue[{{ loop.index0 }}].group-address.vipValue          {{ group.group_address | default("not_defined") }}             msg=group_address
    Should Be Equal Value Json String       ${r_id.json()}     $..interface.vipValue[${outer_loop_index}].join-group.vipValue[{{ loop.index0 }}].group-address.vipVariableName   {{ group.group_address_variable | default("not_defined") }}    msg=group_address_variable

    Should Be Equal Value Json String       ${r_id.json()}     $..interface.vipValue[${outer_loop_index}].join-group.vipValue[{{ loop.index0 }}].source.vipValue                 {{ group.source | default("not_defined") }}               msg=source
    Should Be Equal Value Json String       ${r_id.json()}     $..interface.vipValue[${outer_loop_index}].join-group.vipValue[{{ loop.index0 }}].source.vipVariableName          {{ group.source_variable | default("not_defined") }}      msg=source_variable

{% endfor %}

{% endfor %}

{% endfor %}

{% endif %}
