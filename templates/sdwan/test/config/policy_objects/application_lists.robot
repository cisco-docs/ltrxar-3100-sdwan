*** Settings ***
Documentation   Application Lists
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    application_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.application_lists is defined %}


*** Test Cases ***
Get Application List(s)
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/app
    Set Suite Variable    ${r}

{% for application in sdwan.policy_objects.application_lists | default([]) %}
{% set application_name = application.name %}

Verify Policy Objects Application List {{ application_name }}
    ${application_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{application_name }}")].listId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/app/${application_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ application_name }}    msg=application name

{% set app_applications = application.applications | default([]) %}
    ${app_list}=   Create List   {{ app_applications | join('   ') }}
    Should Be Equal Value Json List    ${r_id.json()}    $..entries..app    ${app_list}    msg=applications

{% set app_application_families = application.application_families | default([]) %}
    ${app_family_list}=   Create List   {{ app_application_families | join('   ') }}
    Should Be Equal Value Json List    ${r_id.json()}    $..entries..appFamily    ${app_family_list}    msg=application families

{% endfor %}

{% endif %}
