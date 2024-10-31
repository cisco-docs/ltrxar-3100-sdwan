*** Settings ***
Documentation   Verify NTP Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.ntp_templates is defined%}

*** Test Cases ***
Get NTP Feature template
    ${r}=    GET On Session   sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_ntp")]
    Set Suite Variable    ${r}

{% for ntp_template in sdwan.edge_feature_templates.ntp_templates | default([]) %}

Verify Edge Feature Template NTP Feature template {{ ntp_template.name }}

    ${ntp_template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ntp_template.name }}")]
    Should Be Equal Value Json String    ${ntp_template_id}    $..templateName    {{ ntp_template.name }}    msg=ntp template name
    Should Be Equal Value Json String    ${ntp_template_id}    $..templateDescription    {{ ntp_template.description }}    msg=ntp template description

{% set test_list = [] %}
{% for item in ntp_template.device_types | default(defaults.sdwan.edge_feature_templates.ntp_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${r}    $[?(@..templateName=="{{ ntp_template.name }}")].deviceType
    ${test_list}=    Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list}[0]    ${test_list}    ignore_order=True    msg= {{ ntp_template.name }} template device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ntp_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $..["master"].enable.vipValue    {{ ntp_template.master | default("not_defined") }}    msg=ntp master
    Should Be Equal Value Json String    ${r_id.json()}    $..["master"].enable.vipVariableName    {{ ntp_template.master_variable | default("not_defined") }}    msg=ntp master variable 
    Should Be Equal Value Json String    ${r_id.json()}    $..["master"].stratum.vipValue    {{ ntp_template.master_stratum | default("not_defined") }}    msg=ntp master stratum
    Should Be Equal Value Json String    ${r_id.json()}    $..["master"].stratum.vipVariableName    {{ ntp_template.master_stratum_variable | default("not_defined") }}    msg=ntp master stratum variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["master"].source.vipValue    {{  ntp_template.master_source_interface | default("not_defined") }}    msg=ntp master source interface
    Should Be Equal Value Json String    ${r_id.json()}    $..["master"].source.vipVariableName    {{  ntp_template.master_source_interface_variable | default("not_defined") }}    msg=ntp master source interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["keys"].trusted.vipValue    {{ ntp_template.trusted_keys | default("not_defined") }}    msg=ntp trusted keys
    Should Be Equal Value Json String    ${r_id.json()}    $..["keys"].trusted.vipVariableName    {{ ntp_template.trusted_keys_variable | default("not_defined") }}    msg=ntp trusted keys variable

    Should Be Equal Value Json List Length   ${r_id.json()}  $..["keys"].authentication.vipValue  {{ ntp_template.authentication_keys | length }}    msg=authentication keys length
{% for ntp_auth_keys in ntp_template.authentication_keys | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["keys"].authentication.vipValue[{{loop.index0}}].number.vipValue    {{ ntp_auth_keys.id | default("not_defined") }}    msg=ntp authentication key id
    Should Be Equal Value Json String    ${r_id.json()}    $..["keys"].authentication.vipValue[{{loop.index0}}].number.vipVariableName    {{ ntp_auth_keys.id_variable | default("not_defined") }}    msg=ntp authentication key id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["keys"].authentication.vipValue[{{loop.index0}}].md5.vipValue    {{ ntp_auth_keys.value | default("not_defined") }}    msg=ntp authentication key value
    Should Be Equal Value Json String    ${r_id.json()}    $..["keys"].authentication.vipValue[{{loop.index0}}].md5.vipVariableName    {{ ntp_auth_keys.value_variable | default("not_defined") }}    msg=ntp authentication key value variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["keys"].authentication.vipValue[{{loop.index0}}].vipOptional   {{ ntp_auth_keys.optional | default("not_defined") }}    msg=ntp authentication key optional
{% endfor %}

    Should Be Equal Value Json List Length   ${r_id.json()}  $..["server"].vipValue  {{ ntp_template.servers | length }}    msg=server length

{% for ntp_server_template in ntp_template.servers | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].name.vipValue    {{ ntp_server_template.hostname_ip | default("not_defined") }}    msg=ntp server hostname ip
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].name.vipVariableName    {{ ntp_server_template.hostname_ip_variable | default("not_defined") }}    msg=ntp server hostname ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].key.vipValue    {{ ntp_server_template.authentication_key_id | default("not_defined") }}    msg=ntp server authentication key id
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].key.vipVariableName    {{ ntp_server_template.authentication_key_id_variable | default("not_defined") }}    msg=ntp server authentication key id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].vpn.vipValue    {{ ntp_server_template.vpn_id | default("not_defined") }}    msg=ntp server vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].vpn.vipVariableName    {{ ntp_server_template.vpn_id_variable | default("not_defined") }}    msg=ntp server vpn id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].version.vipValue    {{ ntp_server_template.version | default("not_defined") }}    msg=ntp server version
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].version.vipVariableName    {{ ntp_server_template.version_variable | default("not_defined") }}    msg=ntp server version variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].source-interface.vipValue    {{ ntp_server_template.source_interface | default("not_defined") }}    msg=ntp server source interface
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].source-interface.vipVariableName    {{ ntp_server_template.source_interface_variable | default("not_defined") }}    msg=ntp server source interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].prefer.vipValue    {{ ntp_server_template.prefer | default("not_defined") | lower }}    msg=ntp server prefer
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].prefer.vipVariableName    {{ ntp_server_template.prefer_variable | default("not_defined") }}    msg=ntp server prefer variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["server"].vipValue[{{loop.index0}}].vipOptional   {{ ntp_server_template.optional | default("not_defined") }}    msg=ntp server optional
{% endfor %}

{% endfor %}

{% endif %}
