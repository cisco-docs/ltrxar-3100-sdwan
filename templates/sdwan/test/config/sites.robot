*** Settings ***
Documentation   Verify Device Template Configuration Apply
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan   config   sites
Resource        ../sdwan_common.resource

{% if sdwan.sites is defined %}

*** Test Cases ***
Get Device Template Configuration Apply
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/device 
    Set Suite Variable    ${r}

Get Configuration Group Apply
    ${r_config_groups}=    GET On Session    sdwan_manager    /dataservice/v1/config-group
    Set Suite Variable    ${r_config_groups}

Get Policy Group Apply
    ${r_policy_groups}=    GET On Session    sdwan_manager    /dataservice/v1/policy-group
    Set Suite Variable    ${r_policy_groups}

{% for site in sdwan.sites | default([]) %}

{% for router in site.routers | default([]) %}

{% if router.device_template is defined %}

Verify Device Template Configuration Apply {{ router.device_template }} With Chassis Id {{ router.chassis_id }}

    ${dt_id}=    Get Value From Json    ${r.json()}    $..data[?(@.templateName=="{{ router.device_template }}")].templateId
    ${post_headers}=    Set Variable    {"templateId":"${dt_id[0]}","deviceIds":["{{ router.chassis_id }}"],"isEdited":false,"isMasterEdited":false} 
    ${response}=    Wait Until Keyword Succeeds    6x    10s    POST On Session    sdwan_manager    /dataservice/template/device/config/input    data=${post_headers}

    Should Be Equal Value Json String    ${r.json()}    $..data[?(@.templateName=="{{ router.device_template }}")].deviceType    vedge-{{ router.model }}     msg=model

{% for key, value in router.device_variables.items() | default({}) %}

    ${val}=    Get Value From Json    ${response.json()}    $..columns[?(@.title =~ '.*\({{ key }}\)')].property
    ${r_value}=   Get Value From Json   ${response.json()}   $..data..["${val[0]}"]
    Should Be Equal As Strings    ${r_value[0]}    {{ router.device_variables[key] }}    ignore_case=${True}    msg={{ key }}

{% endfor %}

{% endif %}

{% if router.configuration_group is defined %}

Verify Configuration Group Apply {{ router.configuration_group }} With Chassis Id {{ router.chassis_id }}
    ${cg_id}=    Get Value From Json    ${r_config_groups.json()}    $[?(@.name == "{{ router.configuration_group }}")].id
    Should Not Be Empty    ${cg_id}    msg=Check if configuration group "{{ router.configuration_group }}" is found
    ${response}=    GET On Session    sdwan_manager    /dataservice/v1/config-group/${cg_id[0]}/device/variables    params=device-id={{ router.chassis_id }}
{% for key, value in router.device_variables.items() | default({}) %}
    ${var_value}=    Get Value From Json    ${response.json()}    $..devices..variables[?(@.name == '{{ key }}')].value
    Should Be Equal As Strings    ${var_value[0]}    {{ value }}    ignore_case=${True}    msg={{ key }}
{% endfor %}

{% endif %}

{% if router.policy_group is defined %}

Verify Policy Group Apply {{ router.policy_group }} With Chassis Id {{ router.chassis_id }}
    ${pg_id}=    Get Value From Json    ${r_policy_groups.json()}    $[?(@.name == "{{ router.policy_group }}")].id
    Should Not Be Empty    ${pg_id}    msg=Check if policy group "{{ router.policy_group }}" is found
    ${response}=    GET On Session    sdwan_manager    /dataservice/v1/policy-group/${pg_id[0]}/device/variables    params=device-id={{ router.chassis_id }}
{% for key, value in router.policy_variables.items() | default({}) %}
    ${var_value}=    Get Value From Json    ${response.json()}    $..devices..variables[?(@.name == '{{ key }}')].value
    Should Be Equal As Strings    ${var_value[0]}    {{ value }}    ignore_case=${True}    msg={{ key }}
{% endfor %}

{% endif %}

{% endfor %}

{% endfor %}

{% endif %}
