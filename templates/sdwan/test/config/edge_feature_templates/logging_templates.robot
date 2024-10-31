*** Settings ***
Documentation   Verify Logging Feature Template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.logging_templates is defined %}

*** Test Cases ***
Get Logging Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_logging")]
    Set Suite Variable    ${r}

{% for logging in sdwan.edge_feature_templates.logging_templates | default([]) %}

Verify Edge Feature Template Logging Feature template {{ logging.name }}
    ${logging_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{logging.name }}")]
    Should Be Equal Value Json String    ${logging_id}    $..templateName    {{ logging.name }}    msg=name
    Should Be Equal Value Json String    ${logging_id}    $..templateDescription    {{ logging.description }}    msg=description

{% set test_list = [] %}
{% for item in logging.device_types | default(defaults.sdwan.edge_feature_templates.logging_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${logging_id}    $..deviceType
    ${test_list}=    Create List    {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device types

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{logging.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $..disk.enable.vipValue    {{ logging.disk_logging | default("not_defined") | lower() }}    msg=disk logging
    Should Be Equal Value Json String    ${r_id.json()}    $..disk.enable.vipVariableName    {{ logging.disk_logging_variable | default("not_defined") }}    msg=disk logging variable
    Should Be Equal Value Json String    ${r_id.json()}    $..disk.file.rotate.vipValue    {{ logging.log_rotations | default("not_defined") }}    msg=log rotations
    Should Be Equal Value Json String    ${r_id.json()}    $..disk.file.rotate.vipVariableName    {{ logging.log_rotations_variable | default("not_defined") }}    msg=log rotations variable
    Should Be Equal Value Json String    ${r_id.json()}    $..disk.file.size.vipValue    {{ logging.max_size | default("not_defined") }}    msg=max size
    Should Be Equal Value Json String    ${r_id.json()}    $..disk.file.size.vipVariableName    {{ logging.max_size_variable | default("not_defined") }}    msg=max size variable

    ${ipv4_server_items}=    Get Value From Json    ${r_id.json()}    $.server.vipValue
    ${res_ipv4_servers_length}=    Get Length     ${ipv4_server_items[0]}
    Should Be Equal As Integers    ${res_ipv4_servers_length}    {{ logging.ipv4_servers | length }}    msg=ipv4 servers

{% for ipv4_server in logging.ipv4_servers | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].name.vipValue    {{ ipv4_server.hostname_ip | default("not_defined") }}    msg=ipv4 hostname ip
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].name.vipVariableName    {{ ipv4_server.hostname_ip_variable | default("not_defined") }}    msg=ipv4 hostname ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].tls..["enable-tls"].vipValue    {{ ipv4_server.enable_tls | default("not_defined") | lower() }}    msg=ipv4 enable tls
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].tls..["enable-tls"].vipVariableName    {{ ipv4_server.enable_tls_variable | default("not_defined") }}    msg=ipv4 enable tls variable
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].priority.vipValue    {{ ipv4_server.logging_level | default("not_defined") }}    msg=ipv4 logging level
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].priority.vipVariableName    {{ ipv4_server.logging_level_variable | default("not_defined") }}    msg=ipv4 logging level variable
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}]..["source-interface"].vipValue    {{ ipv4_server.source_interface | default("not_defined") }}    msg=ipv4 source interface
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}]..["source-interface"].vipVariableName    {{ ipv4_server.source_interface_variable | default("not_defined") }}    msg=ipv4 source interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].tls..["tls-properties"].profile.vipValue    {{ ipv4_server.tls_profile | default("not_defined") }}    msg=ipv4 tls profile
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].tls..["tls-properties"].profile.vipVariableName    {{ ipv4_server.tls_profile_variable | default("not_defined") }}    msg=ipv4 tls profile variable
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].vipOptional    {{ ipv4_server.optional | default("not_defined") }}    msg=ipv4 optional
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].vpn.vipValue    {{ ipv4_server.vpn_id | default("not_defined") }}    msg=ipv4 vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $..server.vipValue[{{loop.index0}}].vpn.vipVariableName    {{ ipv4_server.vpn_id_variable | default("not_defined") }}    msg=ipv4 vpn id variable

{% endfor %}

    ${ipv6_server_items}=    Get Value From Json    ${r_id.json()}    $..["ipv6-server"].vipValue
    ${res_ipv6_servers_length}=    Get Length    ${ipv6_server_items[0]}
    Should Be Equal As Integers    ${res_ipv6_servers_length}    {{ logging.ipv6_servers | length }}    msg=ipv6 servers

{% for ipv6_server in logging.ipv6_servers | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].name.vipValue    {{ ipv6_server.hostname_ip | default("not_defined") }}    msg=ipv6 hostname ip
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].name.vipVariableName    {{ ipv6_server.hostname_ip_variable | default("not_defined") }}    msg=ipv6 hostname ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].tls..["enable-tls"].vipValue    {{ ipv6_server.enable_tls | default("not_defined") | lower() }}    msg=ipv6 enable tls
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].tls..["enable-tls"].vipVariableName    {{ ipv6_server.enable_tls_variable | default("not_defined") }}    msg=ipv6 enable tls variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].priority.vipValue    {{ ipv6_server.logging_level | default("not_defined") }}    msg=ipv6 logging level
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].priority.vipVariableName    {{ ipv6_server.logging_level_variable | default("not_defined") }}    msg=ipv6 logging level variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}]..["source-interface"].vipValue    {{ ipv6_server.source_interface | default("not_defined") }}    msg=ipv6 source interface
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}]..["source-interface"].vipVariableName    {{ ipv6_server.source_interface_variable | default("not_defined") }}    msg=ipv6 source interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].tls..["tls-properties"].profile.vipValue    {{ ipv6_server.tls_profile | default("not_defined") }}    msg=ipv6 tls profile
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].tls..["tls-properties"].profile.vipVariableName    {{ ipv6_server.tls_profile_variable | default("not_defined") }}    msg=ipv6 tls profile variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].vipOptional    {{ ipv6_server.optional | default("not_defined") }}    msg=ipv6 optional
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].vpn.vipValue    {{ ipv6_server.vpn_id | default("not_defined") }}    msg=ipv6 vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipv6-server"].vipValue[{{loop.index0}}].vpn.vipVariableName    {{ ipv6_server.vpn_id_variable | default("not_defined") }}    msg=ipv6 vpn id variable

{% endfor %}

    ${tls_profile_items}=    Get Value From Json    ${r_id.json()}    $..["tls-profile"].vipValue
    ${res_tls_profiles_length}=    Get Length    ${tls_profile_items[0]}
    Should Be Equal As Integers    ${res_tls_profiles_length}    {{ logging.tls_profiles | length }}    msg=tls profiles

{% for tls_profile in logging.tls_profiles | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["tls-profile"].vipValue[{{loop.index0}}]..["auth-type"].vipValue    {{ tls_profile.authentication_type | default("not_defined") | title() }}    msg=authentication type
    Should Be Equal Value Json String    ${r_id.json()}    $..["tls-profile"].vipValue[{{loop.index0}}]..["auth-type"].vipVariableName    {{ tls_profile.authentication_type_variable | default("not_defined") }}    msg=authentication type variable

    ${rec_ciphersuite_list}=    Get Value From Json    ${r_id.json()}    $..["tls-profile"].vipValue[{{loop.index0}}].ciphersuite..["ciphersuite-list"].vipValue
    ${exp_ciphersuites_list}=    Create List    {{ tls_profile.ciphersuites | default("not_defined") | join('   ') }}
    Lists Should Be Equal    ${rec_ciphersuite_list[0]}    ${exp_ciphersuites_list}    ignore_order=True    msg=${rec_ciphersuite_list}

    Should Be Equal Value Json String    ${r_id.json()}    $..["tls-profile"].vipValue[{{loop.index0}}].ciphersuite..["ciphersuite-list"].vipVariableName    {{ tls_profile.ciphersuites_variable | default("not_defined") }}    msg=ciphersuites variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tls-profile"].vipValue[{{loop.index0}}].profile.vipValue    {{ tls_profile.name | default("not_defined") }}    msg=tls profile name
    Should Be Equal Value Json String    ${r_id.json()}    $..["tls-profile"].vipValue[{{loop.index0}}].profile.vipVariableName    {{ tls_profile.name_variable | default("not_defined") }}    msg=tls profile name variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tls-profile"].vipValue[{{loop.index0}}]..["tls-version"]..["version"].vipValue    {{ tls_profile.version | default("not_defined") }}    msg=version
    Should Be Equal Value Json String    ${r_id.json()}    $..["tls-profile"].vipValue[{{loop.index0}}]..["tls-version"]..["version"].vipVariableName    {{ tls_profile.version_variable | default("not_defined") }}    msg=version variable

{% endfor %}

{% endfor %}

{% endif %}
