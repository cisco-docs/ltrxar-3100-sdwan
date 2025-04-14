*** Settings ***
Documentation   Verify Thousandeye feature template configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan  config  feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.thousandeyes_templates is defined %}

*** Test Cases ***
Get Thousandeyes Template(s)
   ${r}=   GET On Session   sdwan_manager   /dataservice/template/feature
   Set Suite Variable   ${r}

{% for thousandeye in sdwan.edge_feature_templates.thousandeyes_templates | default([]) %}
Verify Thousandeye {{ thousandeye.name }}
   ${eye_id}=  Get Value From Json   ${r.json()}   $..data[?(@..templateName=="{{ thousandeye.name }}")].templateId
   Should Not be Empty   ${eye_id}   msg= {{ thousandeye.name }} not present
   Should Be Equal Value Json Special_String   ${r.json()}   $..data[?(@..templateName=="{{ thousandeye.name }}")].templateDescription   {{ thousandeye.description | normalize_special_string }}  msg={{ thousandeye.name }}: Description
   ${r_template}=   GET On Session   sdwan_manager   /dataservice/template/feature/definition/${eye_id[0]}
   Set Suite Variable   ${r_template}

{% set test_list = [] %}
{% for item in thousandeye.device_types | default(defaults.sdwan.edge_feature_templates.thousandeyes_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

   ${dt_list}=  Get Value From Json   ${r.json()}   $..data[?(@..templateName=="{{ thousandeye.name }}")].deviceType
   ${test_list}=   Create List   {{ test_list | join('   ') }}
   Lists Should Be Equal    ${test_list}    ${dt_list}[0]   ignore_order=True   msg= {{ thousandeye.name }} template device type

   Should Be Equal Value Json String    ${r_template.json()}    $..hostname.vipValue    {{ thousandeye.hostname | default("not_defined") }}    msg={{ thousandeye.name }}: hostname
   Should Be Equal Value Json String    ${r_template.json()}    $..hostname.vipVariableName    {{ thousandeye.hostname_variable | default("not_defined") }}    msg={{ thousandeye.name }}: hostname_variable

   Should Be Equal Value Json String    ${r_template.json()}    $..name-server.vipValue    {{ thousandeye.name_server | default("not_defined") }}    msg={{ thousandeye.name }}: name-server
   Should Be Equal Value Json String    ${r_template.json()}    $..name-server.vipVariableName    {{ thousandeye.name_server_variable | default("not_defined") }}    msg={{ thousandeye.name }}: name-server variable

   Should Be Equal Value Json String    ${r_template.json()}    $..proxy_host.vipValue    {{ thousandeye.proxy_host | default("not_defined") }}    msg={{ thousandeye.name }}: proxy_host
   Should Be Equal Value Json String    ${r_template.json()}    $..proxy_host.vipVariableName    {{ thousandeye.proxy_host_variable | default("not_defined") }}    msg={{ thousandeye.name }}: proxy_host_variable

   Should Be Equal Value Json String    ${r_template.json()}    $..proxy_port.vipValue    {{ thousandeye.proxy_port | default("not_defined") }}    msg={{ thousandeye.name }}: proxy_port
   Should Be Equal Value Json String    ${r_template.json()}    $..proxy_port.vipVariableName    {{ thousandeye.proxy_port_variable | default("not_defined") }}    msg={{ thousandeye.name }}: proxy_port_variable

   Should Be Equal Value Json String    ${r_template.json()}    $..proxy_type.vipValue    {{ thousandeye.proxy_type | default("not_defined") }}    msg={{ thousandeye.name }}: proxy_type
   Should Be Equal Value Json String    ${r_template.json()}    $..proxy_type.vipVariableName    {{ thousandeye.proxy_type_variable | default("not_defined") }}    msg={{ thousandeye.name }}: proxy_type_variable

   Should Be Equal Value Json String    ${r_template.json()}    $..proxy_pac.pac_url.vipValue    {{ thousandeye.proxy_pac_url | default("not_defined") }}    msg={{ thousandeye.name }}: proxy_pac_url
   Should Be Equal Value Json String    ${r_template.json()}    $..proxy_pac.pac_url.vipVariableName    {{ thousandeye.proxy_pac_url_variable | default("not_defined") }}    msg={{ thousandeye.name }}: proxy_pac_url_variable

   Should Be Equal Value Json String    ${r_template.json()}    $..te-mgmt-ip.vipValue    {{ thousandeye.ip | default("not_defined") }}    msg={{ thousandeye.name }}: ip
   Should Be Equal Value Json String    ${r_template.json()}    $..te-mgmt-ip.vipVariableName    {{ thousandeye.ip_variable | default("not_defined") }}    msg={{ thousandeye.name }}: ip_variable

   Should Be Equal Value Json String    ${r_template.json()}    $..te-vpg-ip.vipValue    {{ thousandeye.default_gateway | default("not_defined") }}    msg={{ thousandeye.name }}: default_gateway
   Should Be Equal Value Json String    ${r_template.json()}    $..te-vpg-ip.vipVariableName    {{ thousandeye.default_gateway_variable | default("not_defined") }}    msg={{ thousandeye.name }}: default_gateway_variable

   Should Be Equal Value Json String    ${r_template.json()}    $..te.token.vipValue    {{ thousandeye.account_group_token | default("not_defined") }}    msg={{ thousandeye.name }}: account_group_token
   Should Be Equal Value Json String    ${r_template.json()}    $..te.token.vipVariableName    {{ thousandeye.account_group_token_variable | default("not_defined") }}    msg={{ thousandeye.name }}: account_group_token_variable

   Should Be Equal Value Json String    ${r_template.json()}    $..vpn.vipValue    {{ thousandeye.vpn_id | default("not_defined") }}    msg={{ thousandeye.name }}: vpn_id
   Should Be Equal Value Json String    ${r_template.json()}    $..vpn.vipVariableName    {{ thousandeye.vpn_id_variable | default("not_defined") }}    msg={{ thousandeye.name }}: vpn_id_variable

{% endfor %}
{% endif %}
