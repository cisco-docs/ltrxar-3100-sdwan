*** Settings ***
Documentation   Verify Security Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    security_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.security_templates is defined%}

*** Test Cases ***
Get Security Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_security")]
    Set Suite Variable    ${r}

{% for security_template in sdwan.edge_feature_templates.security_templates | default([]) %}

Verify Edge Feature Template Security Feature template {{ security_template.name }}
    ${security_template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{security_template.name }}")]
    Should Be Equal Value Json String    ${security_template_id}    $..templateName    {{ security_template.name }}    msg=security template name
    Should Be Equal Value Json String    ${security_template_id}    $..templateDescription    {{ security_template.description }}    msg=security template description

{% set test_list = [] %}
{% for item in security_template.device_types | default(defaults.sdwan.edge_feature_templates.security_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${security_template_id}    $..deviceType
    FOR    ${item}    IN    @{dt_list}[0]
        ${test_lists}=   Create List   {{ test_list | join('   ') }}
        List Should Contain Value    ${test_lists}    ${item}    msg=security template device type mismatch
    END

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{security_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}
    Set Suite Variable    ${r_id}

{% for item_auth in security_template.authentication_types %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].authentication-type.vipValue[{{loop.index0}}]    {{ item_auth }}    msg=security authentication types
{% endfor %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].authentication-type.vipVariableName    {{ security_template.authentication_types_variable | default("not_defined") }}    msg=security authentication types variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].extended-ar-window.vipValue    {{ security_template.extended_anti_replay_window | default("not_defined") }}    msg=security extended anti replay window
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].extended-ar-window.vipVariableName    {{ security_template.extended_anti_replay_window_variable | default("not_defined") }}    msg=security extended anti replay window variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].pairwise-keying.vipValue    {{ security_template.pairwise_keying | default("not_defined") | lower }}    msg=security pairwise keying
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].pairwise-keying.vipVariableName    {{ security_template.pairwise_keying_variable | default("not_defined") }}    msg=security pairwise keying variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].rekey.vipValue    {{ security_template.rekey_interval | default("not_defined") }}    msg=security rekey interval
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].rekey.vipVariableName    {{ security_template.rekey_interval_variable | default("not_defined") }}    msg=security rekey interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].replay-window.vipValue    {{ security_template.replay_window | default("not_defined") }}    msg=security replay window
    Should Be Equal Value Json String    ${r_id.json()}    $..["ipsec"].replay-window.vipVariableName    {{ security_template.replay_window_variable | default("not_defined") }}    msg=security replay window variable

{% for security_key_chain in security_template.key_chains | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["trustsec"].keychain.vipValue[{{loop.index0}}].name.vipValue    {{ security_key_chain.name }}    msg=security key chain name
    Should Be Equal Value Json String    ${r_id.json()}    $..["trustsec"].keychain.vipValue[{{loop.index0}}].keyid.vipValue    {{ security_key_chain.key_id }}    msg=security key chain id
{% endfor %}

{% for security_key in security_template.key | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].accept-ao-mismatch.vipValue    {{ security_key.accept_ao_mismatch | default("not_defined") | lower }}    msg=security key accept ao mismatch
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].accept-lifetime.lifetime-group-v1.local.vipValue    {{ security_key.accept_lifetime | default("not_defined") | lower }}    msg=security key accept lifetime
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].accept-lifetime.lifetime-group-v1.local.vipVariableName    {{ security_key.accept_lifetime_variable | default("not_defined") }}    msg=security key accept lifetime variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].accept-lifetime.lifetime-group-v1.duration.vipValue    {{ security_key.accept_lifetime_duration_seconds | default("not_defined") }}    msg=security key accept lifetime duration seconds
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].accept-lifetime.lifetime-group-v1.duration.vipVariableName    {{ security_key.accept_lifetime_duration_variable | default("not_defined") }}    msg=security key accept lifetime duration variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].accept-lifetime.lifetime-group-v1.end-epoch.vipValue    {{ security_key.accept_lifetime_end_time_epoch | default("not_defined") }}    msg=security key accept lifetime end time epoch
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].accept-lifetime.lifetime-group-v1.end-choice.vipValue    {{ security_key.accept_lifetime_end_time_format | default("not_defined") }}    msg=security key accept lifetime end time format
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].accept-lifetime.lifetime-group-v1.start-epoch.vipValue    {{ security_key.accept_lifetime_start_time_epoch | default("not_defined") }}    msg=security key accept lifetime start time epoch
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].cryptographic-algorithm-choice.tcp.vipValue    {{ security_key.crypto_algorithm }}    msg=security key crypto algorithm
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].id.vipValue    {{ security_key.id }}    msg=security key id
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].include-tcp-options.vipValue    {{ security_key.include_tcp_options | default("not_defined") | lower }}    msg=include tcp options
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].include-tcp-options.vipVariableName    {{ security_key.include_tcp_options_variable | default("not_defined") }}    msg=include tcp options variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].chain-name.vipValue    {{ security_key.key_chain_name }}    msg=security key chain names
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].key-string.vipValue    {{ security_key.key_string }}    msg=security key string
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].send-id.vipValue    {{ security_key.send_id | default("not_defined") }}    msg=send id
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].send-id.vipVariableName    {{ security_key.send_id_variable | default("not_defined") }}    msg=send id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].send-lifetime.lifetime-group-v1.local.vipValue    {{ security_key.send_lifetime | default("not_defined") | lower }}    msg=security key send lifetime
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].send-lifetime.lifetime-group-v1.local.vipVariableName    {{ security_key.send_lifetime_variable | default("not_defined") }}    msg=security key send lifetime variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].send-lifetime.lifetime-group-v1.duration.vipValue    {{ security_key.send_lifetime_duration_seconds | default("not_defined") }}    msg=send lifetime duration seconds
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].send-lifetime.lifetime-group-v1.duration.vipVariableName    {{ security_key.send_lifetime_duration_variable | default("not_defined") }}    msg=send lifetime duration variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].send-lifetime.lifetime-group-v1.end-epoch.vipValue    {{ security_key.send_lifetime_end_time_epoch | default("not_defined") }}    msg=send lifetime end time epoch
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].send-lifetime.lifetime-group-v1.end-choice.vipValue    {{ security_key.send_lifetime_end_time_format | default("not_defined") }}    msg=send lifetime end time format
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].send-lifetime.lifetime-group-v1.start-epoch.vipValue    {{ security_key.send_lifetime_start_time_epoch | default("not_defined") }}    msg=send lifetime start time epoch
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].recv-id.vipValue    {{ security_key.receive_id | default("not_defined") }}    msg=receive id
    Should Be Equal Value Json String    ${r_id.json()}    $..["key"].vipValue[{{loop.index0}}].recv-id.vipVariableName    {{ security_key.receive_id_variable | default("not_defined") }}    msg=receive id variable
{% endfor %}

{% endfor %}

{% endif %}
