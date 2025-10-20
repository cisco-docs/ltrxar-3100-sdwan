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

{% for ft_yaml in sdwan.edge_feature_templates.igmp_templates | default([]) %}

Verify Edge Feature Template IGMP Feature Template {{ ft_yaml.name }}
    ${ft_summary_json}=    Get Value From Json    ${r}    $[?(@.templateName="{{ ft_yaml.name }}")]
    Should Not be Empty   ${ft_summary_json}   msg=Feature Template '{{ft_yaml.name}}' should be present on the Manager
    Should Be Equal Value Json String    ${ft_summary_json}    $..templateName    {{ ft_yaml.name }}    msg=name
    Should Be Equal Value Json Special_String    ${ft_summary_json}    $..templateDescription    {{ ft_yaml.description | normalize_special_string }}    msg=description

    # Device types validation
    {% set device_types_yaml = [] %}
    {% for item in ft_yaml.device_types | default(defaults.sdwan.edge_feature_templates.igmp_templates.device_types) %}
    {% set device_type = "vedge-" ~ item %}
    {% set _ = device_types_yaml.append(device_type) %}
    {% endfor %}
    ${device_types_json}=    Get Value From Json    ${ft_summary_json}    $..deviceType
    ${device_types_yaml}=    Create List           {{ device_types_yaml | join('   ') }}
    Lists Should Be Equal    ${device_types_json}[0]    ${device_types_yaml}    ignore_order=True    msg=device_types

    # Get template definition
    ${ft_id}=    Get Value From Json    ${r}    $[?(@.templateName="{{ ft_yaml.name }}")].templateId
    ${ft}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${ft_id[0]}

    Should Be Equal Value Json List Length    ${ft.json()}    $..interface.vipValue    {{ ft_yaml.interfaces | default([]) | length }}    msg=interfaces length

{% for interface in ft_yaml.interfaces | default([]) %}

    Log    === Interface {{loop.index0}} ===
    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..interface.vipValue[{{loop.index0}}].name
    ...    {{ interface.name | default("not_defined") }}
    ...    {{ interface.name_variable | default("not_defined") }}
    ...    msg=interfaces.name

    Should Be Equal Value Json String    ${ft.json()}    $..interface.vipValue[{{loop.index0}}].vipOptional
    ...    {{ interface.optional | default("not_defined") }}
    ...    msg=interfaces.optional

    Should Be Equal Value Json List Length    ${ft.json()}    $..interface.vipValue[{{loop.index0}}].join-group.vipValue    {{ interface.join_groups | default([]) | length }}    msg=interface.join_groups length

{% for group_index in range(interface.join_groups | default([]) | length) %}

    Log    === Join Group {{group_index}} ===
    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..interface.vipValue[{{loop.index0}}].join-group.vipValue[{{group_index}}].group-address
    ...    {{ interface.join_groups[group_index].group_address | default("not_defined") }}
    ...    {{ interface.join_groups[group_index].group_address_variable | default("not_defined") }}
    ...    msg=join_groups.group_address

    Should Be Equal Value Json Yaml UX1    ${ft.json()}    $..interface.vipValue[{{loop.index0}}].join-group.vipValue[{{group_index}}].source
    ...    {{ interface.join_groups[group_index].source | default("not_defined") }}
    ...    {{ interface.join_groups[group_index].source_variable | default("not_defined") }}
    ...    msg=join_groups.source

{% endfor %}

{% endfor %}

{% endfor %}

{% endif %}
