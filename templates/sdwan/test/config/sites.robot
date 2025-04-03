*** Settings ***
Documentation   Verify Device Template Configuration Apply
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan   config   sites
Resource        ../sdwan_common.resource

{% if sdwan.sites is defined%}

*** Test Cases ***
Get Device Template Configuration Apply
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/device 
    Set Suite Variable    ${r}

{% for site in sdwan.sites | default([]) %}

{% for router in site.routers | default([]) %}

{% if router.device_template is defined%}

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

{% endfor %}

{% endfor %}

{% endif %}
