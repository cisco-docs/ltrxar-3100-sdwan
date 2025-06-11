*** Settings ***
Documentation   Verify System Feature Profile Configuration Security
Name            System Profiles Security
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_profiles   security
Resource        ../../../sdwan_common.resource


{% set profile_security_list = [] %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.security is defined %}
  {% set _ = profile_security_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_security_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.security is defined %}

Verify Feature Profiles System Profiles {{ profile.name }} Security Feature {{ profile.security.name | default(defaults.sdwan.feature_profiles.system_profiles.security.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${system_security_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id[0]}/security
    ${system_security}=    Get Value From Json    ${system_security_res.json()}    $..payload
    Run Keyword If    ${system_security} == []    Fail    Feature '{{profile.security.name}}' expected to be configured within the system profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${system_security}

    Should Be Equal Value Json String    ${system_security[0]}    $..name    {{ profile.security.name | default(defaults.sdwan.feature_profiles.system_profiles.security.name) }}    msg=name
    Should Be Equal Value Json Special_String     ${system_security[0]}     $..description    {{ profile.security.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.replayWindow   {{ profile.security.anti_replay_window| default('not_defined') }}     {{ profile.security.anti_replay_window_variable| default('not_defined') }}     msg=anti_replay_window    var_msg=anti_replay_window variable
    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.extendedArWindow   {{ profile.security.extended_anti_replay_window| default('not_defined') }}     {{ profile.security.extended_anti_replay_window_variable| default('not_defined') }}     msg=extended_anti_replay_window    var_msg=extended_anti_replay_window variable
    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.pairwiseKeying   {{ profile.security.ipsec_pairwise_keying| default('not_defined') }}     {{ profile.security.ipsec_pairwise_keying_variable| default('not_defined') }}     msg=ipsec_pairwise_keying    var_msg=ipsec_pairwise_keying variable
    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.rekey   {{ profile.security.rekey_time| default('not_defined') }}     {{ profile.security.rekey_time_variable| default('not_defined') }}     msg=rekey_time    var_msg=rekey_time variable

    # Re-interpret string as list
    ${integrity_types_list}=    Create List    {{ profile.security.integrity_types | join('   ') }}
    ${integrity_types_list}=    Set Variable If    ${integrity_types_list} == []    not_defined    ${integrity_types_list}
    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.integrityType   ${integrity_types_list}    {{ profile.security.integrity_types_variable| default('not_defined') }}     msg=integrity_types_list    var_msg=integrity_types_list variable

    Should Be Equal Value Json List Length    ${system_security[0]}    $.data.keychain    {{ profile.security.key_chains | length }}    msg=keychains_count
    
# Loop over keychains list
{% if profile.security.key_chains is defined and profile.security.key_chains|length > 0 %}
    Log    === Keychains List ===
{% for keychain_entry in profile.security.key_chains | default([]) %}

    Should Be Equal Value Json String    ${system_security[0]}    $.data.keychain[{{ loop.index0 }}].name.value    {{ keychain_entry.name | default('not_defined') }}    msg=keychain name
    Should Be Equal Value Json String    ${system_security[0]}    $.data.keychain[{{ loop.index0 }}].id.value   {{ keychain_entry.key_id | default('not_defined') }}    msg=keychain id

{% endfor %}
{% endif %}


# Loop over keys list
{% set key_list = profile.security.get('keys', []) %}
    Should Be Equal Value Json List Length    ${system_security[0]}    $.data.key    {{ key_list | length }}    msg=keys_count
{% if key_list is defined and key_list|length > 0 %}
    Log    === Keys List ===
{% for key_entry in key_list | default([]) %}

    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].id.value   {{ key_entry.id | default('not_defined') }}    msg=keychain id
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].name.value    {{ key_entry.key_chain_name | default('not_defined') }}    msg=key_chain_name
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].tcp.value    {{ key_entry.crypto_algorithm | default('not_defined') }}    msg=crypto_algorithm

    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.key[{{ loop.index0 }}].acceptAoMismatch   {{ key_entry.accept_ao_mismatch| default('not_defined') }}     {{ key_entry.accept_ao_mismatch_variable| default('not_defined') }}     msg=accept_ao_mismatch    var_msg=accept_ao_mismatch variable
    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.key[{{ loop.index0 }}].includeTcpOptions   {{ key_entry.include_tcp_options| default('not_defined') }}     {{ key_entry.include_tcp_options_variable| default('not_defined') }}     msg=include_tcp_options    var_msg=include_tcp_options variable

    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.key[{{ loop.index0 }}].sendId   {{ key_entry.send_id| default('not_defined') }}     {{ key_entry.send_id_variable| default('not_defined') }}     msg=send_id    var_msg=send_id variable
    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.key[{{ loop.index0 }}].recvId   {{ key_entry.receiver_id| default('not_defined') }}     {{ key_entry.receiver_id_variable| default('not_defined') }}     msg=receiver_id    var_msg=receiver_id variable

    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.key[{{ loop.index0 }}].acceptLifetime.local   {{ key_entry.accept_life_time_local| default('not_defined') }}     {{ key_entry.accept_life_time_local_variable| default('not_defined') }}     msg=accept_life_time_local    var_msg=accept_life_time_local variable
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].acceptLifetime.startEpoch.value    {{ key_entry.accept_life_time_start_epoch | default('not_defined') }}    msg=accept_life_time_start_epoch
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].acceptLifetime.oneOfendChoice.infinite.value    {{ key_entry.accept_life_time_infinite | default('not_defined') }}    msg=accept_life_time_infinite
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].acceptLifetime.oneOfendChoice.exact.value    {{ key_entry.accept_life_time_exact | default('not_defined') }}    msg=accept_life_time_exact
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].acceptLifetime.oneOfendChoice.duration.value    {{ key_entry.accept_life_time_duration | default('not_defined') }}    msg=accept_life_time_duration

    Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.key[{{ loop.index0 }}].sendLifetime.local   {{ key_entry.send_life_time_local| default('not_defined') }}     {{ key_entry.send_life_time_local_variable| default('not_defined') }}     msg=send_life_time_local    var_msg=send_life_time_local variable
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].sendLifetime.startEpoch.value    {{ key_entry.send_life_time_start_epoch | default('not_defined') }}    msg=send_life_time_start_epoch
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].sendLifetime.oneOfendChoice.infinite.value    {{ key_entry.send_life_time_infinite | default('not_defined') }}    msg=send_life_time_infinite
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].sendLifetime.oneOfendChoice.exact.value    {{ key_entry.send_life_time_exact | default('not_defined') }}    msg=send_life_time_exact
    Should Be Equal Value Json String    ${system_security[0]}    $.data.key[{{ loop.index0 }}].sendLifetime.oneOfendChoice.duration.value    {{ key_entry.send_life_time_duration | default('not_defined') }}    msg=send_life_time_duration

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! TODO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Should Be Equal Value Json Yaml    ${system_security[0]}    $.data.key[{{ loop.index0 }}].keyString   {{ key_entry.key_string| default('not_defined') }}     {{ key_entry.key_string_variable| default('not_defined') }}     msg=key_string    var_msg=key_string variable

{% endfor %}
{% endif %}

{% endif %}
{% endfor %}

{% endif %}
