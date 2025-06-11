*** Settings ***
Documentation   Verify System Feature Profile Configuration SNMP
Name            System Profiles SNMP
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_profiles   snmp
Resource        ../../../sdwan_common.resource


{% set profile_snmp_list = [] %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.snmp is defined %}
  {% set _ = profile_snmp_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_snmp_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.snmp is defined %}

Verify Feature Profiles System Profiles {{ profile.name }} SNMP Feature {{ profile.snmp.name | default(defaults.sdwan.feature_profiles.system_profiles.snmp.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${system_snmp_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id[0]}/snmp
    ${system_snmp}=    Get Value From Json    ${system_snmp_res.json()}    $..payload
    Run Keyword If    ${system_snmp} == []    Fail    Feature '{{profile.snmp.name}}' expected to be configured within the system profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${system_snmp}

    Should Be Equal Value Json String    ${system_snmp[0]}    $..name    {{ profile.snmp.name | default(defaults.sdwan.feature_profiles.system_profiles.snmp.name) }}    msg=name
    Should Be Equal Value Json Special_String     ${system_snmp[0]}     $.description    {{ profile.snmp.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json List Length    ${system_snmp[0]}    $.data.community    {{ profile.snmp.communities | length }}    msg=communities length
{% if profile.snmp.communities is defined and profile.snmp.communities | length > 0 %}
    Log     === Communities List ===
{% for snmp_community in profile.snmp.communities | default([]) %}

    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.community[{{ loop.index0 }}].authorization    {{ snmp_community.authorization | default('not_defined') }}    {{ snmp_community.authorization_variable | default('not_defined') }}    msg=authorization    var_msg=authorization variable
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.community[{{ loop.index0 }}].userLabel    {{ snmp_community.user_label | default('not_defined') }}    not_defined    msg=user label    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.community[{{ loop.index0 }}].view    {{ snmp_community.view | default('not_defined') }}    {{ snmp_community.view_variable | default('not_defined') }}    msg=view    var_msg=view variable

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! TODO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.community[{{ loop.index0 }}].name    {{ snmp_community.name | default('not_defined') }}    not_defined    msg=name    var_msg=not_defined
    
{% endfor %}
{% endif %}

    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.contact    {{ profile.snmp.contact_person | default('not_defined') }}    {{ profile.snmp.contact_person_variable | default('not_defined') }}    msg=contact person    var_msg=contact person variable
    
    Should Be Equal Value Json List Length    ${system_snmp[0]}    $.data.group    {{ profile.snmp.groups | length }}    msg=groups length
{% if profile.snmp.groups is defined and profile.snmp.groups | length > 0 %}
    Log     === Groups List ===
{% for snmp_group in profile.snmp.groups | default([]) %}

    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.group[{{ loop.index0 }}].name    {{ snmp_group.name | default('not_defined') }}    not_defined    msg=name    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.group[{{ loop.index0 }}].securityLevel    {{ snmp_group.security_level | default('not_defined') }}    not_defined    msg=security level    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.group[{{ loop.index0 }}].view    {{ snmp_group.view | default('not_defined') }}    {{ snmp_group.view_variable | default('not_defined') }}    msg=view    var_msg=view variable
    
{% endfor %}
{% endif %}

    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.location    {{ profile.snmp.location | default('not_defined') }}    {{ profile.snmp.location_variable | default('not_defined') }}    msg=location    var_msg=location variable
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.shutdown    {{ profile.snmp.shutdown | default('not_defined') }}    {{ profile.snmp.shutdown_variable | default('not_defined') }}    msg=shutdown    var_msg=shutdown variable

    Should Be Equal Value Json List Length    ${system_snmp[0]}    $.data.target    {{ profile.snmp.trap_target_servers | length }}    msg=trap target servers length
{% if profile.snmp.trap_target_servers is defined and profile.snmp.trap_target_servers | length > 0 %}
    Log     === Trap Target Servers List ===
{% for snmp_target in profile.snmp.trap_target_servers | default([]) %}

    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.target[{{ loop.index0 }}].ip    {{ snmp_target.ip | default('not_defined') }}    {{ snmp_target.ip_variable	 | default('not_defined') }}    msg=ip    var_msg=ip variable
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.target[{{ loop.index0 }}].port    {{ snmp_target.port | default('not_defined') }}    {{ snmp_target.port_variable | default('not_defined') }}    msg=port    var_msg=port variable
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.target[{{ loop.index0 }}].sourceInterface    {{ snmp_target.source_interface | default('not_defined') }}    {{ snmp_target.source_interface_variable | default('not_defined') }}    msg=source interface    var_msg=source interface variable
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.target[{{ loop.index0 }}].user    {{ snmp_target.user | default('not_defined') }}    {{ snmp_target.user_variable | default('not_defined') }}    msg=user    var_msg=user variable
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.target[{{ loop.index0 }}].userLabel    {{ snmp_target.user_label | default('not_defined') }}    not_defined    msg=user label    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.target[{{ loop.index0 }}].vpnId    {{ snmp_target.vpn_id | default('not_defined') }}    {{ snmp_target.vpn_id_variable | default('not_defined') }}    msg=vpn id    var_msg=vpn id variable
    
{% endfor %}
{% endif %}

    Should Be Equal Value Json List Length    ${system_snmp[0]}    $.data.user    {{ profile.snmp.users | length }}    msg=users length
{% if profile.snmp.users is defined and profile.snmp.users | length > 0 %}
    Log     === Users List ===
{% for snmp_user in profile.snmp.users | default([]) %}

    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.user[{{ loop.index0 }}].auth    {{ snmp_user.authentication_protocol | default('not_defined') }}    {{ snmp_user.authentication_protocol_variable | default('not_defined') }}    msg=authentication protocol    var_msg=authentication protocol variable
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.user[{{ loop.index0 }}].group    {{ snmp_user.group | default('not_defined') }}    {{ snmp_user.group_variable | default('not_defined') }}    msg=group    var_msg=group variable
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.user[{{ loop.index0 }}].name    {{ snmp_user.name | default('not_defined') }}    not_defined    msg=name    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.user[{{ loop.index0 }}].priv    {{ snmp_user.privacy_protocol | default('not_defined') }}    {{ snmp_user.privacy_protocol_variable | default('not_defined') }}    msg=privacy protocol    var_msg=privacy protocol variable

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! TODO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.user[{{ loop.index0 }}].authPassword    {{ snmp_user.authentication_password | default('not_defined') }}    {{ snmp_user.authentication_password_variable | default('not_defined') }}    msg=authentication password    var_msg=authentication password variable
    # Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.user[{{ loop.index0 }}].privPassword    {{ snmp_user.privacy_password | default('not_defined') }}    {{ snmp_user.privacy_password_variable | default('not_defined') }}    msg=privacy password    var_msg=privacy password variable
    
{% endfor %}
{% endif %}

    Should Be Equal Value Json List Length    ${system_snmp[0]}    $.data.view    {{ profile.snmp.views | length }}    msg=views length
{% if profile.snmp.views is defined and profile.snmp.views | length > 0 %}
    Log     === Views List ===
{% for snmp_view in profile.snmp.views | default([]) %}

    Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.view[{{ loop.index0 }}].name    {{ snmp_view.name | default('not_defined') }}    not_defined    msg=name    var_msg=not_defined

    Should Be Equal Value Json List Length    ${system_snmp[0]}    $.data.view[{{ loop.index0 }}].oid    {{ snmp_view.oids | length }}    msg=oids length
    {% for snmp_view_oid in snmp_view.oids | default([]) %}

        Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.view[{{ loop.index0 }}].oid[{{ loop.index0 }}].exclude    {{ snmp_view_oid.exclude | default('not_defined') }}    {{ snmp_view_oid.exclude_variable	 | default('not_defined') }}    msg=exclude    var_msg=exclude variable
        Should Be Equal Value Json Yaml    ${system_snmp[0]}    $.data.view[{{ loop.index0 }}].oid[{{ loop.index0 }}].id    {{ snmp_view_oid.id | default('not_defined') }}    {{ snmp_view_oid.id_variable	 | default('not_defined') }}    msg=id    var_msg=id variable

    {% endfor %}
    
{% endfor %}
{% endif %}


{% endif %}
{% endfor %}

{% endif %}