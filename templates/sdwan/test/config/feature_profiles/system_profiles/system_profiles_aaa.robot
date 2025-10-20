*** Settings ***
Documentation   Verify System Feature Profile Configuration AAA
Name            System Profiles AAA
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_profiles   aaa
Resource        ../../../sdwan_common.resource


{% set profile_aaa_list = [] %}
{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.system_profiles is defined %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.aaa is defined %}
  {% set _ = profile_aaa_list.append(profile.name) %}
 {% endif %}
{% endfor %}
{% endif %}

{% if profile_aaa_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.aaa is defined %}

Verify Feature Profiles System Profile {{ profile.name }} AAA Feature {{ profile.aaa.name | default(defaults.sdwan.feature_profiles.system_profiles.aaa.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${system_aaa_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id}[0]/aaa
    ${system_aaa}=    Get Value From Json    ${system_aaa_res.json()}    $..payload
    Run Keyword If    ${system_aaa} == []    Fail    Feature '{{profile.aaa.name  | default(defaults.sdwan.feature_profiles.system_profiles.aaa.name)}}' expected to be configured within the system profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${system_aaa}

    Log   ${system_aaa}

    Should Be Equal Value Json String    ${system_aaa[0]}    $..name    {{ profile.aaa.name | default(defaults.sdwan.feature_profiles.system_profiles.aaa.name) }}    msg=name
    Should Be Equal Value Json Special_String    ${system_aaa[0]}    $..description    {{ profile.aaa.description | default('not_defined') | normalize_special_string }}    msg=description  

    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.authenticationGroup   {{ profile.aaa.dot1x_authentication| default('not_defined') }}     {{ profile.aaa.dot1x_authentication_variable| default('not_defined') }}     msg=aaa dot1x_authentication    var_msg=aaa dot1x_authentication_variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.accountingGroup   {{ profile.aaa.dot1x_accounting| default('not_defined') }}     {{ profile.aaa.dot1x_accounting_variable| default('not_defined') }}     msg=aaa dot1x_accounting    var_msg=aaa dot1x_accounting_variable

    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.authorizationConsole   {{ profile.aaa.authorization_console| default('not_defined') }}     {{ profile.aaa.authorization_console_variable| default('not_defined') }}     msg=aaa authorization_console    var_msg=aaa authorization_console_variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.authorizationConfigCommands   {{ profile.aaa.authorization_config_commands| default('not_defined') }}     {{ profile.aaa.authorization_config_commands_variable| default('not_defined') }}     msg=aaa authorization_config_commands    var_msg=aaa authorization_config_commands_variable

    ${auth_order_list}=    Create List    {{ profile.aaa.get('auth_order' , []) | join('   ') }}
    ${auth_order_list}=    Set Variable If    ${auth_order_list} == []    {{ defaults.sdwan.feature_profiles.system_profiles.aaa.auth_order }}    ${auth_order_list}
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $..data.serverAuthOrder   ${auth_order_list}    {{ profile.aaa.auth_order_variable| default('not_defined') }}     msg=aaa auth_order    var_msg=aaa auth_order_variable

    Should Be Equal Value Json List Length    ${system_aaa[0]}    $.data.user  {{ profile.aaa.get('users' , []) | length }}    msg=aaa users length
    ${aaa_user}=  Get Value From Json    ${system_aaa[0]}    $.data.user
    log   ${aaa_user}

{% if profile.aaa.users is defined and profile.aaa.get('users' , [])|length > 0 %}

    Log     === AAA local user accounts === 

{% for user_entry in profile.aaa.users | default([]) %}

    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.user[{{ loop.index0 }}].name   {{ user_entry.name | default("not_defined") }}    {{ user_entry.name_variable| default('not_defined') }}     msg=aaa user name    var_msg=aaa user name_variable
	#Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.user[{{ loop.index0 }}].password   {{ user_entry.password | default("not_defined") }}    {{ user_entry.password_variable| default('not_defined') }}     msg=aaa user password    var_msg=aaa user password_variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.user[{{ loop.index0 }}].privilege   {{ user_entry.privilege | default("not_defined") }}    {{ user_entry.privilege_variable| default('not_defined') }}     msg=aaa user privilege    var_msg=aaa user privilege_variable

    Should Be Equal Value Json List Length    ${system_aaa[0]}    $.data.user[{{ loop.index0 }}].pubkeyChain   {{ user_entry.get('public_key_chains' , []) | length }}    msg=aaa user public_key_chains length

{% if user_entry.public_key_chains is defined and user_entry.get('public_key_chains' , [])|length > 0 %}
    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}
    ${public_key_chains_list}=    Create List    {{ user_entry.get('public_key_chains' , []) | join('   ') }}
    ${public_key_chains_list}=    Set Variable If    ${public_key_chains_list} == []    ${default_public_key_chains_list}    ${public_key_chains_list}
    @{r_public_key_chains_list}=    Create List

{% for public_keychain_entry in user_entry.public_key_chains | default([]) %}

    ${json_public_keychain}=   Get Value From Json   ${system_aaa[0]}   $.data.user[${outer_loop_index}].pubkeyChain[{{ loop.index0 }}].keyString.value
    Append To List  ${r_public_key_chains_list}     ${json_public_keychain[0]}

{% endfor %}

    Lists Should Be Equal   ${public_key_chains_list}   ${r_public_key_chains_list}     msg: aaa user public_key_chains_list

{% endif %}

{% endfor %}

{% endif %}

    Should Be Equal Value Json List Length    ${system_aaa[0]}    $.data.radius  {{ profile.aaa.get('radius_groups' , []) | length }}    msg=aaa radius_groups length
    Should Be Equal Value Json List Length    ${system_aaa[0]}    $.data.radius.server  {{ profile.aaa.get('radius_groups.servers' , [])| length }}    msg=aaa radius server length

{% if profile.aaa.radius_groups is defined and profile.aaa.get('radius_groups' , [])|length > 0 %}

    Log     === Radius Configurations ===

{% for rule_entry in profile.aaa.radius_groups | default([]) %}

    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.radius[{{ loop.index0 }}].vpn.value    {{ rule_entry.vpn| default('not_defined') }}    msg=aaa radius_group vpn
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.radius[{{ loop.index0 }}].sourceInterface   {{ rule_entry.source_interface| default('not_defined') }}    {{ rule_entry.source_interface_variable| default('not_defined') }}     msg=aaa radius_group source_interface    var_msg=aaa radius_group source_interface_variable

    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

{% for server_entry in rule_entry.servers | default([]) %}

    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.radius[${outer_loop_index}].server[{{ loop.index0 }}].address.value   {{ server_entry.address | default("not_defined") }}    msg=aaa radius server address
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.radius[${outer_loop_index}].server[{{ loop.index0 }}].authPort   {{ server_entry.authentication_port | default("not_defined") }}    {{ server_entry.authentication_port_variable| default('not_defined') }}     msg=aaa radius server authentication_port    var_msg=aaa radius server authentication_port variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.radius[${outer_loop_index}].server[{{ loop.index0 }}].acctPort   {{ server_entry.accounting_port | default("not_defined") }}    {{ server_entry.accounting_port_variable| default('not_defined') }}     msg=aaa radius server accounting_port    var_msg=aaa radius server accounting_port variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.radius[${outer_loop_index}].server[{{ loop.index0 }}].timeout   {{ server_entry.timeout | default("not_defined") }}    {{ server_entry.timeout_variable| default('not_defined') }}     msg=aaa radius server timeout    var_msg=aaa radius server timeout variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.radius[${outer_loop_index}].server[{{ loop.index0 }}].retransmit   {{ server_entry.retransmit | default("not_defined") }}    {{ server_entry.retransmit_variable| default('not_defined') }}     msg=aaa radius server retransmit    var_msg=aaa radius server retransmit variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.radius[${outer_loop_index}].server[{{ loop.index0 }}].keyType   {{ server_entry.key_type | default("not_defined") }}    {{ server_entry.key_type_variable| default('not_defined') }}     msg=aaa radius server key_type    var_msg=aaa radius server key_type variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.radius[${outer_loop_index}].server[{{ loop.index0 }}].secretKey   {{ server_entry.secret_key | default("not_defined") }}    {{ server_entry.secret_key_variable| default('not_defined') }}     msg=aaa radius server secret_key    var_msg=aaa radius server secret_key variable

{% endfor %}

{% endfor %}

{% endif %}

    Should Be Equal Value Json List Length    ${system_aaa[0]}    $.data.tacacs  {{ profile.aaa.get('tacacs_groups' , []) | length }}    msg=aaa tacacs_groups length
    Should Be Equal Value Json List Length    ${system_aaa[0]}    $.data.tacacs.server  {{ profile.aaa.get('tacacs_groups.servers' , [])| length }}    msg=aaa tacacs server length

{% if profile.aaa.tacacs_groups is defined and profile.aaa.get('tacacs_groups' , [])|length > 0 %}

	Log     === Tacacs Configurations ===

{% for rule_entry in profile.aaa.tacacs_groups | default([]) %}

    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.tacacs[{{ loop.index0 }}].vpn.value    {{ rule_entry.vpn| default('not_defined') }}    msg=aaa tacacs_group vpn
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.tacacs[{{ loop.index0 }}].sourceInterface   {{ rule_entry.source_interface| default('not_defined') }}    {{ rule_entry.source_interface_variable| default('not_defined') }}     msg=aaa tacacs_group source_interface    var_msg=aaa tacacs_group source_interface_variable

    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

{% for server_entry in rule_entry.servers | default([]) %}

    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.tacacs[${outer_loop_index}].server[{{ loop.index0 }}].address.value   {{ server_entry.address | default("not_defined") }}    msg=aaa tacacs server address
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.tacacs[${outer_loop_index}].server[{{ loop.index0 }}].port   {{ server_entry.port | default("not_defined") }}    {{ server_entry.port_variable| default('not_defined') }}     msg=aaa tacacs server port    var_msg=aaa tacacs server port variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.tacacs[${outer_loop_index}].server[{{ loop.index0 }}].timeout   {{ server_entry.timeout | default("not_defined") }}    {{ server_entry.timeout_variable| default('not_defined') }}     msg=aaa tacacs server timeout    var_msg=aaa tacacs server timeout variable
    Should Be Equal Value Json Yaml    ${system_aaa[0]}    $.data.tacacs[${outer_loop_index}].server[{{ loop.index0 }}].secretKey   {{ server_entry.secret_key | default("not_defined") }}    {{ server_entry.secret_key_variable| default('not_defined') }}     msg=aaa tacacs server secret_key    var_msg=aaa tacacs server secret_key variable

{% endfor %}

{% endfor %}

{% endif %}

    Should Be Equal Value Json List Length    ${system_aaa[0]}    $.data.authorizationRule  {{ profile.aaa.get('authorization_rules' , []) | length }}    msg=aaa authorization_rules length

{% if profile.aaa.authorization_rules is defined and profile.aaa.get('authorization_rules' , [])|length > 0 %}

	Log     === Authorization rules ===

{% for rule_entry in profile.aaa.authorization_rules | default([]) %}

    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.authorizationRule[{{ loop.index0 }}].ifAuthenticated.value    {{ rule_entry.authenticated| default('not_defined') }}    msg=aaa authorization_rules authenticated
    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.authorizationRule[{{ loop.index0 }}].ruleId.value    {{ rule_entry.id| default('not_defined') }}    msg=aaa authorization_rules id
    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.authorizationRule[{{ loop.index0 }}].level.value    {{ rule_entry.level| default('not_defined') }}    msg=aaa authorization_rules level
    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.authorizationRule[{{ loop.index0 }}].method.value    {{ rule_entry.method| default('not_defined') }}    msg=aaa authorization_rules method

    ${group_list}=    Create List    {{ rule_entry.get('groups' , []) | join('   ') }}
    ${r_group_list}=   Get Value From Json   ${system_aaa[0]}   $.data.authorizationRule[{{ loop.index0 }}].group.value
    Lists Should Be Equal   ${group_list}   ${r_group_list[0]}     msg: aaa auth rules methods     ignore_order=True

{% endfor %}

{% endif %}

    Should Be Equal Value Json List Length   ${system_aaa[0]}    $.data.accountingRule  {{ profile.aaa.get('accounting_rules' , []) | length }}    msg=aaa accounting_rules length

{% if profile.aaa.accounting_rules is defined and profile.aaa.get('accounting_rules' , [])|length > 0 %}

	Log     === Accounting rules ===

{% for rule_entry in profile.aaa.accounting_rules | default([]) %}

    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.accountingRule[{{ loop.index0 }}].ruleId.value    {{ rule_entry.id| default('not_defined') }}    msg=aaa accounting_rules id
    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.accountingRule[{{ loop.index0 }}].method.value    {{ rule_entry.method| default('not_defined') }}    msg=aaa accounting_rules method
    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.accountingRule[{{ loop.index0 }}].level.value    {{ rule_entry.level| default('not_defined') }}    msg=aaa accounting_rules level
    Should Be Equal Value Json String    ${system_aaa[0]}    $.data.accountingRule[{{ loop.index0 }}].startStop.value    {{ rule_entry.start_stop| default('not_defined') }}    msg=aaa accounting_rules start_stop

    ${group_list}=    Create List    {{ rule_entry.get('groups' , []) | join('   ') }}
    ${r_group_list}=   Get Value From Json   ${system_aaa[0]}   $.data.accountingRule[{{ loop.index0 }}].group.value
    Lists Should Be Equal   ${group_list}   ${r_group_list[0]}     msg: aaa auth rules methods      ignore_order=True

{% endfor %}

{% endif %}

{% endif %}

{% endfor %}

{% endif %}