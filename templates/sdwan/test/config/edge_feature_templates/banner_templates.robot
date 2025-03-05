*** Settings ***
Documentation   Verify Banner feature template configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates    banner_templates
Resource        ../../sdwan_common.resource
Library         ../../myutils.py

{% if sdwan.edge_feature_templates.banner_templates is defined %}

*** Test Cases ***
Get Banner Template (s)
    ${r}=   GET On Session   sdwan_manager   /dataservice/template/feature
    Set Suite Variable   ${r}

{% for banner in sdwan.edge_feature_templates.banner_templates | default([]) %}

Verify Banner {{ banner.name }}
    ${banner_id}=  Get Value From Json   ${r.json()}   $..data[?(@..templateName=="{{ banner.name }}")].templateId
    Should Not be Empty   ${banner_id}   msg= {{ banner.name }} not present
    Should Be Equal Value Json String   ${r.json()}   $..data[?(@..templateName=="{{ banner.name }}")].templateDescription   {{ banner.description }}  msg=description
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/feature/definition/${banner_id[0]}
    Set Suite Variable   ${r_id}

    {% set dt_list_local = [] %}
    {% for item in banner.device_types | default(defaults.sdwan.edge_feature_templates.banner_templates.device_types) %}
    {% set test = "vedge-" ~ item %}
    {% set _ = dt_list_local.append(test) %}
    {% endfor %}

    ${dt_list}=  Get Value From Json   ${r.json()}   $..data[?(@..templateName=="{{ banner.name }}")].deviceType
    ${dt_list_local}=   Create List   {{ dt_list_local | join('   ') }}
    Lists Should Be Equal    ${dt_list_local}    ${dt_list}[0]   ignore_order=True   msg={{ banner.name }}: device type

    ${login_banner_1}=   Create List    {{ banner.login_variable | default(banner.login | default("not_defined")) }}
    ${login_banner}=    replace escape characters    text=${login_banner_1}
    ${motd_banner_1}=   Create List    {{ banner.motd_variable | default(banner.motd | default("not_defined")) }}
    ${motd_banner}=    replace escape characters    text=${motd_banner_1}
    
    ${banner_remote_str_1_vt}=  Get Value From Json   ${r_id.json()}   $..login.vipType
    IF    "${banner_remote_str_1_vt}[0]" == "constant"
        ${banner_remote_str_1}=  Get Value From Json   ${r_id.json()}   $..login.vipValue
    ELSE IF    "${banner_remote_str_1_vt}[0]" == "variableName"
        ${banner_remote_str_1}=  Get Value From Json   ${r_id.json()}   $..login.vipVariableName
    ELSE
        ${banner_remote_str_1}=  Set Variable    []
    END
    ${banner_remote_str}=   replace escape characters   ${banner_remote_str_1}

    ${motd_remote_str_1_vt}=  Get Value From Json   ${r_id.json()}   $..motd.vipType
    IF    "${motd_remote_str_1_vt}[0]" == "constant"
        ${motd_remote_str_1}=  Get Value From Json   ${r_id.json()}   $..motd.vipValue
    ELSE IF    "${motd_remote_str_1_vt}[0]" == "variableName"
        ${motd_remote_str_1}=  Get Value From Json   ${r_id.json()}   $..motd.vipVariableName
    ELSE
        ${motd_remote_str_1}=  Set Variable    []
    END
    ${motd_remote_str}=    replace escape characters    text=${motd_remote_str_1}
    
    Lists Should Be Equal    ${banner_remote_str}   ${login_banner}    msg=banner login
    Lists Should Be Equal    ${motd_remote_str}    ${motd_banner}    msg=banner motd

{% endfor %}
{% endif %}