*** Settings ***
Documentation   Verify Secure App Hosting Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.secure_app_hosting_templates is defined %}

*** Test Cases ***
Get Secure App Hosting Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="virtual-application-utd")]
    Set Suite Variable    ${r}

{% for secure_app_hosting_template in sdwan.edge_feature_templates.secure_app_hosting_templates | default([]) %}

Verify Edge Feature Template Secure App Hosting Feature template {{ secure_app_hosting_template.name }}
    ${secure_app_hosting_template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{secure_app_hosting_template.name }}")]
    Should Be Equal Value Json String    ${secure_app_hosting_template_id}    $..templateName    {{ secure_app_hosting_template.name }}    msg=name
    Should Be Equal Value Json String    ${secure_app_hosting_template_id}    $..templateDescription    {{ secure_app_hosting_template.description }}    msg=description

{% set test_list = [] %}
{% for item in secure_app_hosting_template.device_types | default(defaults.sdwan.edge_feature_templates.secure_app_hosting_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${secure_app_hosting_template_id}    $..deviceType
    ${test_list}=   Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device types

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{secure_app_hosting_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}
    log    ${r_id.json()}

    Should Be Equal Value Json String    ${r_id.json()}    $.virtual-application..vipValue[?(@["utd"]["nat"]["vipType"] == "constant")].utd.nat.vipValue    {{ secure_app_hosting_template.nat | default("not_defined") | lower()}}    msg=nat
    Should Be Equal Value Json String    ${r_id.json()}    $.virtual-application..vipValue[?(@["utd"]["nat"]["vipType"] == "variableName")].utd.nat.vipVariableName    {{ secure_app_hosting_template.nat_variable | default("not_defined") | lower() }}    msg=nat_variable
    Should Be Equal Value Json String    ${r_id.json()}    $.virtual-application..vipValue[?(@["utd"]["database-url"]["vipType"] == "constant")].utd.database-url.vipValue    {{ secure_app_hosting_template.download_url_database_on_device | default("not_defined") | lower() }}    msg=download_url_database_on_device
    Should Be Equal Value Json String    ${r_id.json()}    $.virtual-application..vipValue[?(@["utd"]["database-url"]["vipType"] == "variableName")].utd.database-url.vipVariableName    {{ secure_app_hosting_template.download_url_database_on_device_variable | default("not_defined") | lower() }}    msg=download_url_database_on_device_variable
    Should Be Equal Value Json String    ${r_id.json()}    $.virtual-application..vipValue[?(@["utd"]["resource-profile"]["vipType"] == "constant")].utd.resource-profile.vipValue    {{ secure_app_hosting_template.resource_profile | default("not_defined")}}    msg=resource_profile
    Should Be Equal Value Json String    ${r_id.json()}    $.virtual-application..vipValue[?(@["utd"]["resource-profile"]["vipType"] == "variableName")].utd.resource-profile.vipVariableName    {{ secure_app_hosting_template.resource_profile_variable | default("not_defined")}}    msg=resource_profile_variable

{% endfor %}

{% endif %}
