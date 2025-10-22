*** Settings ***
Documentation   Verify Banner feature template configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates    banner_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.banner_templates is defined %}

*** Test Cases ***
Get Banner Template (s)
    ${r}=   GET On Session   sdwan_manager   /dataservice/template/feature
    Set Suite Variable   ${r}

{% for banner in sdwan.edge_feature_templates.banner_templates | default([]) %}

Verify Banner {{ banner.name }}
    ${banner_id}=  Get Value From Json   ${r.json()}   $..data[?(@..templateName=="{{ banner.name }}")].templateId
    Should Not be Empty   ${banner_id}   msg= {{ banner.name }} not present
    Should Be Equal Value Json Special_String   ${r.json()}   $..data[?(@..templateName=="{{ banner.name }}")].templateDescription   {{ banner.description | normalize_special_string }}  msg=description
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
    
    Should Be Equal Value Json Special_String FT   ${r_id.json()}   $..login    {{ banner.login_variable | default(banner.login | default("not_defined")) | normalize_special_string }}    msg=login banner
    Should Be Equal Value Json Special_String FT   ${r_id.json()}   $..motd    {{ banner.motd_variable | default(banner.motd | default("not_defined")) | normalize_special_string }}    msg=motd banner

{% endfor %}
{% endif %}