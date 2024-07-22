*** Settings ***
Documentation   Verify SNMP Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    snmp_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.snmp_templates is defined%}

*** Test Cases ***
Get SNMP Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_snmp")]
    Set Suite Variable    ${r}

{% for snmp_template in sdwan.edge_feature_templates.snmp_templates | default([]) %}
Verify Edge Feature Template SNMP Feature template {{ snmp_template.name }}

    ${snmp_template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{snmp_template.name }}")]
    Should Be Equal Value Json String    ${snmp_template_id}    $..templateName    {{ snmp_template.name }}    msg=snmp template name
    Should Be Equal Value Json String    ${snmp_template_id}    $..templateDescription    {{ snmp_template.description }}    msg=snmp template description

{% set test_list = [] %}
{% for item in snmp_template.device_types | default(defaults.sdwan.edge_feature_templates.snmp_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${r}    $[?(@..templateName=="{{ snmp_template.name }}")].deviceType
    ${test_list}=    Create List    {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list}[0]    ${test_list}    ignore_order=True    msg= {{ snmp_template.name }} template device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{snmp_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $..["contact"].vipValue   {{ snmp_template.contact | default("not_defined") }}    msg=snmp template contact
    Should Be Equal Value Json String    ${r_id.json()}    $..["contact"].vipVariableName    {{ snmp_template.contact_variable | default("not_defined")  }}    msg=snmp template contact variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["location"].vipValue   {{ snmp_template.location | default("not_defined") }}    msg=snmp template location
    Should Be Equal Value Json String    ${r_id.json()}    $..["location"].vipVariableName    {{ snmp_template.location_variable | default("not_defined") }}    msg=snmp template location variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["shutdown"].vipValue   {{ snmp_template.shutdown | default("not_defined") }}    msg=snmp template shutdown
    Should Be Equal Value Json String    ${r_id.json()}    $..["shutdown"].vipVariableName    {{ snmp_template.shutdown_variable | default("not_defined") }}    msg=snmp template shutdown variable

    ${snmp_community_items}=    Get Value From Json    ${r_id.json()}    $..["community"].vipValue
    ${snmp_community_items_length}=    Get Length    ${snmp_community_items[0]}
    Should Be Equal As Integers    ${snmp_community_items_length}    {{ snmp_template.communities | length }}    msg=snmp communities length

{% for snmp_community in snmp_template.communities | default([]) %}
{% if snmp_community.authorization_read_only | default("not_defined") | lower() == "true" %}
    ${snmp_community_auth}=    Get Value From Json    ${r_id.json()}    $..["community"].vipValue[{{loop.index0}}].authorization.vipValue
    ${r_value}=    Set Variable If    "${snmp_community_auth[0]}" == "read-only"    true
    Should Be Equal As Strings    ${r_value}    {{ snmp_community.authorization_read_only | default("not_defined") | lower() }}    msg=authorization read only
{% elif snmp_community.authorization_read_only | default("not_defined") | lower() == "false" %}
    ${snmp_community_auth}=    Get Value From Json    ${r_id.json()}    $..["community"].vipValue[{{loop.index0}}].authorization.vipValue
    ${r_value}=    Set Variable If    "${snmp_community_auth[0]}" == []    false
    Should Be Equal As Strings    ${r_value}    {{ snmp_community.authorization_read_only | default("not_defined") | lower() }}    msg=authorization read only
{% elif snmp_community.authorization_read_only == "not_defined" %}
    ${snmp_community_auth}=    Get Value From Json    ${r_id.json()}    $..["community"].vipValue[{{loop.index0}}].authorization.vipValue
    Should Be Equal As Strings    ${snmp_community_auth}    {{ snmp_community.authorization_read_only }}    msg=authorization read only
{% endif %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["community"].vipValue[{{loop.index0}}].authorization.vipVariableName    {{ snmp_community.authorization_read_only_variable | default("not_defined") }}    msg=community authorization read only variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["community"].vipValue[{{loop.index0}}].name.vipValue    {{ snmp_community.name }}    msg=community name
    Should Be Equal Value Json String    ${r_id.json()}    $..["community"].vipValue[{{loop.index0}}].view.vipValue    {{ snmp_community.view | default("not_defined") }}    msg=community view
    Should Be Equal Value Json String    ${r_id.json()}    $..["community"].vipValue[{{loop.index0}}].view.vipVariableName    {{ snmp_community.view_variable | default("not_defined") }}    msg=community view variable
{% endfor %}

    ${snmp_groups_items}=    Get Value From Json    ${r_id.json()}    $..["group"].vipValue
    IF   ${snmp_groups_items} == []
        ${snmp_groups_items_length}=    Get Length    ${snmp_groups_items}
    ELSE
        ${snmp_groups_items_length}=    Get Length    ${snmp_groups_items[0]}
    END
    Should Be Equal As Integers    ${snmp_groups_items_length}    {{ snmp_template.groups | length }}    msg=snmp group length

{% for snmp_group in snmp_template.groups | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["group"].vipValue[{{loop.index0}}].name.vipValue    {{ snmp_group.name }}    msg=snmp group name
    Should Be Equal Value Json String    ${r_id.json()}    $..["group"].vipValue[{{loop.index0}}].security-level.vipValue    {{ snmp_group.security_level }}    msg=snmp group security level
    Should Be Equal Value Json String    ${r_id.json()}    $..["group"].vipValue[{{loop.index0}}].view.vipValue    {{ snmp_group.view | default("not_defined") }}    msg=snmp group view
    Should Be Equal Value Json String    ${r_id.json()}    $..["group"].vipValue[{{loop.index0}}].view.vipVariableName    {{ snmp_group.view_variable | default("not_defined") }}    msg=snmp group view variable 
{% endfor %}

{% for snmp_trap_target_server in snmp_template.trap_target_servers | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].community-name.vipValue    {{ snmp_trap_target_server.community_name | default("not_defined") }}    msg=snmp trap target server community name
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].community-name.vipVariableName   {{ snmp_trap_target_server.community_name_variable | default("not_defined") }}    msg=snmp trap target server community name variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].ip.vipValue    {{ snmp_trap_target_server.ip | default("not_defined") }}    msg=trap target server ip
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].ip.vipVariableName   {{ snmp_trap_target_server.ip_variable | default("not_defined") }}    msg=snmp trap target server ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].source-interface.vipValue    {{ snmp_trap_target_server.source_interface | default("not_defined") }}    msg=trap target server source interface
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].source-interface.vipVariableName   {{ snmp_trap_target_server.source_interface_variable | default("not_defined") }}    msg=snmp trap target server source interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].port.vipValue    {{ snmp_trap_target_server.udp_port | default("not_defined")  }}    msg=snmp trap target server udp port
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].port.vipVariableName   {{ snmp_trap_target_server.udp_port_variable | default("not_defined") }}    msg=snmp trap target server udp port variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].user.vipValue    {{ snmp_trap_target_server.user | default("not_defined") }}    msg=snmp trap target server user
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].user.vipVariableName   {{ snmp_trap_target_server.user_variable | default("not_defined") }}    msg=snmp trap target server user variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].vpn-id.vipValue    {{ snmp_trap_target_server.vpn_id | default("not_defined") }}    msg=snmp trap target server vpn id
    Should Be Equal Value Json String    ${r_id.json()}    $..["trap"].target.vipValue[{{loop.index0}}].vpn-id.vipVariableName   {{ snmp_trap_target_server.vpn_id_variable | default("not_defined") }}    msg=snmp trap target server vpn id variable
{% endfor %}

    ${snmp_users_items}=    Get Value From Json    ${r_id.json()}    $..["user"].vipValue
    IF   ${snmp_users_items} == []
        ${snmp_users_items_length}=    Get Length    ${snmp_users_items}
    ELSE
        ${snmp_users_items_length}=    Get Length    ${snmp_users_items[0]}
    END
    Should Be Equal As Integers    ${snmp_users_items_length}    {{ snmp_template.users | length }}    msg=snmp users length

{% for user in snmp_template.users | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].auth-password.vipValue    {{ user.authentication_password | default("not_defined") }}    msg=snmp users authentication password
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].auth-password.vipVariableName    {{ user.authentication_password_variable | default("not_defined") }}    msg=snmp users authentication password variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].auth.vipValue    {{ user.authentication_protocol | default("not_defined") }}    msg=snmp users authentication protocol
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].auth.vipVariableName    {{ user.authentication_protocol_variable | default("not_defined") }}    msg=snmp users authentication protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].name.vipValue    {{ user.name }}    msg=snmp users name
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].group.vipValue    {{ user.group | default("not_defined") }}    msg=snmp users group
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].group.vipVariableName    {{ user.group_variable | default("not_defined") }}    msg=snmp users group variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].priv-password.vipValue    {{ user.privacy_password | default("not_defined") }}    msg=snmp users privacy password
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].priv-password.vipVariableName    {{ user.privacy_password_variable | default("not_defined") }}    msg=snmp users privacy password variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].priv.vipValue    {{ user.privacy_protocol | default("not_defined") }}    msg=snmp users privacy protocol
    Should Be Equal Value Json String    ${r_id.json()}    $..["user"].vipValue[{{loop.index0}}].priv.vipVariableName    {{ user.privacy_protocol_variable | default("not_defined") }}    msg=snmp users privacy protocol variable
{% endfor %}

    ${snmp_views_items}=    Get Value From Json    ${r_id.json()}    $..["view"].vipValue
    ${snmp_views_items_length}=    Get Length    ${snmp_views_items[0]}
    Should Be Equal As Integers    ${snmp_views_items_length}    {{ snmp_template.views | length }}    msg=snmp views length

{% for snmp_view in snmp_template.views | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["view"].vipValue[{{loop.index0}}].name.vipValue    {{ snmp_view.name }}    msg=snmp view name
{% for snmp_view_oid in snmp_view.oids %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["view"].vipValue[{{loop.index0}}].oid.vipValue[{{loop.index0}}].id.vipValue    {{ snmp_view_oid.id }}    msg=snmp view oid id
    Should Be Equal Value Json String    ${r_id.json()}    $..["view"].vipValue[{{loop.index0}}].oid.vipValue[{{loop.index0}}].id.vipVariableName    {{ snmp_view_oid.id_variable | default("not_defined") }}    msg=snmp view oid id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["view"].vipValue[{{loop.index0}}].oid.vipValue[{{loop.index0}}].exclude.vipValue    {{ snmp_view_oid.exclude | default("not_defined") | lower }}    msg=snmp view oid exclude
    Should Be Equal Value Json String    ${r_id.json()}    $..["view"].vipValue[{{loop.index0}}].oid.vipValue[{{loop.index0}}].exclude.vipVariableName    {{ snmp_view_oid.exclude_variable | default("not_defined") }}    msg=snmp view oid exclude variable
{% endfor %}
{% endfor %}

{% endfor %}

{% endif %}
