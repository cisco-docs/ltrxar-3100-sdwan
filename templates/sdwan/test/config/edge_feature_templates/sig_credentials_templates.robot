*** Settings ***
Documentation   Verify SIG Credential Feature Template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    sig_credentials_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.sig_credentials_templates is defined %}

*** Test Cases ***
Get SIG Credential Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_sig_credentials")]
    Set Suite Variable    ${r}

{% for sigc in sdwan.edge_feature_templates.sig_credentials_templates | default([]) %}

{% if sigc.name == "umbrella" %}
{% set sigc_value = "Cisco-Umbrella-Global-Credentials" %}
{% elif sigc.name == "zscaler" %}
{% set sigc_value = "Cisco-Zscaler-Global-Credentials" %}
{% endif %}

Verify Edge Feature Template SIG Credential Feature template {{ sigc_value }}
    ${sigc_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{sigc_value }}")]
    Should Be Equal Value Json String    ${sigc_id}    $..templateName    {{ sigc_value }}    msg=name

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{sigc_value }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $.umbrella["api-key"].vipValue    {{ sigc.umbrella_api_key | default("not_defined") }}    msg=umbrella api key
    Should Be Equal Value Json String    ${r_id.json()}    $.umbrella["api-key"].vipVariableName    {{ sigc.umbrella_api_key_variable | default("not_defined") }}    msg=umbrella api key variable
    Should Be Equal Value Json String    ${r_id.json()}    $.umbrella["api-secret"].vipValue    {{ sigc.umbrella_api_secret | default("not_defined") }}    msg=umbrella api secret
    Should Be Equal Value Json String    ${r_id.json()}    $.umbrella["api-secret"].vipVariableName    {{ sigc.umbrella_api_secret_variable | default("not_defined") }}    msg=umbrella api secret variable
    Should Be Equal Value Json String    ${r_id.json()}    $.umbrella["org-id"].vipValue    {{ sigc.umbrella_organization_id | default("not_defined") }}    msg=umbrella organization id
    Should Be Equal Value Json String    ${r_id.json()}    $.umbrella["org-id"].vipVariableName    {{ sigc.umbrella_organization_id_variable | default("not_defined") }}    msg=umbrella organization id variable

    ${zscaler_org}=    Get Value From Json    ${r_id.json()}    $.zscaler.organization.vipType
    IF    ${zscaler_org} == ['constant']
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler.organization.vipValue    {{ sigc.zscaler_organization | default("not_defined") }}    msg=zscaler organization
    ELSE
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler.organization.vipVariableName    {{ sigc.zscaler_organization_variable | default("not_defined") }}    msg=zscaler organization variable
    END

    ${zscaler_partner_base}=    Get Value From Json    ${r_id.json()}    $.zscaler["partner-base-uri"].vipType
    IF    ${zscaler_partner_base} == ['constant']
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler["partner-base-uri"].vipValue    {{ sigc.zscaler_partner_base_uri | default("not_defined") }}    msg=zscaler partner base uri
    ELSE
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler["partner-base-uri"].vipVariableName    {{ sigc.zscaler_partner_base_uri_variable | default("not_defined") }}    msg=zscaler partner base uri variable
    END

    ${zscaler_uname}=    Get Value From Json    ${r_id.json()}    $.zscaler.username.vipType
    IF    ${zscaler_uname} == ['constant']
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler.username.vipValue    {{ sigc.zscaler_username | default("not_defined") }}    msg=zscaler username
    ELSE
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler.username.vipVariableName    {{ sigc.zscaler_username_variable | default("not_defined") }}    msg=zscaler username variable
    END

    ${zscaler_pwd}=    Get Value From Json    ${r_id.json()}    $.zscaler.password.vipType
    IF    ${zscaler_pwd} == ['constant']
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler.password.vipValue    {{ sigc.zscaler_password | default("not_defined") }}    msg=zscaler password
    ELSE
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler.password.vipVariableName    {{ sigc.zscaler_password_variable | default("not_defined") }}    msg=zscaler password variable
    END

    ${zscaler_partner_api}=    Get Value From Json    ${r_id.json()}    $.zscaler["partner-key"].vipType
    IF    ${zscaler_partner_api} == ['constant']
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler["partner-key"].vipValue    {{ sigc.zscaler_partner_api_key | default("not_defined") }}    msg=zscaler partner api key
    ELSE
        Should Be Equal Value Json String    ${r_id.json()}    $.zscaler["partner-key"].vipVariableName    {{ sigc.zscaler_partner_api_key_variable | default("not_defined") }}    msg=zscaler partner api key variable
    END

{% endfor %}

{% endif %}
