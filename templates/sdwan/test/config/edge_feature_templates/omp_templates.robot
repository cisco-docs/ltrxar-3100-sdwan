*** Settings ***
Documentation   Verify OMP Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.omp_templates is defined %}

*** Test Cases ***
Get OMP Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_omp")]
    Set Suite Variable    ${r}

{% for omp_template in sdwan.edge_feature_templates.omp_templates | default([]) %}

Verify Edge Feature Template OMP Feature template {{ omp_template.name }}
    ${omp_template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{omp_template.name }}")]
    Should Be Equal Value Json String    ${omp_template_id}    $..templateName    {{ omp_template.name }}    msg=omp template name
    Should Be Equal Value Json String    ${omp_template_id}    $..templateDescription    {{ omp_template.description }}    msg=omp template description

{% set test_list = [] %}
{% for item in omp_template.device_types | default(defaults.sdwan.edge_feature_templates.omp_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${omp_template_id}    $..deviceType
    ${test_lists}=   Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_lists}    ignore_order=True    msg=omp template device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{omp_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $..["timers"]..advertisement-interval.vipValue    {{ omp_template.advertisement_interval | default("not_defined") }}    msg=omp advertisement interval
    Should Be Equal Value Json String    ${r_id.json()}    $..["timers"]..advertisement-interval.vipVariableName    {{ omp_template.advertisement_interval_variable | default("not_defined") }}    msg=omp advertisement interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ecmp-limit"].vipValue    {{ omp_template.ecmp_limit | default("not_defined") }}    msg=omp ecmp limit
    Should Be Equal Value Json String    ${r_id.json()}    $..["ecmp-limit"].vipVariableName    {{ omp_template.ecmp_limit_variable | default("not_defined") }}    msg=omp ecmp limit variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["timers"]..eor-timer.vipValue    {{ omp_template.eor_timer | default("not_defined") }}    msg=omp eor timer
    Should Be Equal Value Json String    ${r_id.json()}    $..["timers"]..eor-timer.vipVariableName    {{ omp_template.eor_timer_variable | default("not_defined") }}    msg=omp eor timer variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["graceful-restart"].vipValue    {{ omp_template.graceful_restart | default("not_defined") | lower }}    msg=omp graceful restart
    Should Be Equal Value Json String    ${r_id.json()}    $..["graceful-restart"].vipVariableName    {{ omp_template.graceful_restart_variable | default("not_defined") }}    msg=omp graceful restart variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["timers"]..graceful-restart-timer.vipValue    {{ omp_template.graceful_restart_timer | default("not_defined") }}    msg=omp graceful restart timer
    Should Be Equal Value Json String    ${r_id.json()}    $..["timers"]..graceful-restart-timer.vipVariableName    {{ omp_template.graceful_restart_timer_variable | default("not_defined") }}    msg=omp graceful restart timer variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["timers"]..holdtime.vipValue    {{ omp_template.holdtime | default("not_defined") }}    msg=omp holdtime
    Should Be Equal Value Json String    ${r_id.json()}    $..["timers"]..holdtime.vipVariableName    {{ omp_template.holdtime_variable | default("not_defined") }}    msg=omp holdtime variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["ignore-region-path-length"].vipValue    {{ omp_template.ignore_region_path_length | default("not_defined") }}    msg=ignore region path length
    Should Be Equal Value Json String    ${r_id.json()}    $..["ignore-region-path-length"].vipVariableName    {{ omp_template.ignore_region_path_length_variable | default("not_defined") }}    msg=ignore region path length variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["omp-admin-distance-ipv4"].vipValue    {{ omp_template.omp_admin_distance_ipv4 | default("not_defined") }}    msg=omp admin distance ipv4
    Should Be Equal Value Json String    ${r_id.json()}    $..["omp-admin-distance-ipv4"].vipVariableName    {{ omp_template.omp_admin_distance_ipv4_variable | default("not_defined") }}    msg=omp admin distance ipv4 variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["omp-admin-distance-ipv6"].vipValue    {{ omp_template.omp_admin_distance_ipv6 | default("not_defined") }}    msg=omp admin distance ipv6
    Should Be Equal Value Json String    ${r_id.json()}    $..["omp-admin-distance-ipv6"].vipVariableName    {{ omp_template.omp_admin_distance_ipv6_variable | default("not_defined") }}    msg=omp admin distance ipv6 variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["overlay-as"].vipValue    {{ omp_template.overlay_as | default("not_defined") }}    msg=omp overlay as
    Should Be Equal Value Json String    ${r_id.json()}    $..["overlay-as"].vipVariableName    {{ omp_template.overlay_as_variable | default("not_defined") }}    msg=omp overlay as variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["send-path-limit"].vipValue    {{ omp_template.send_path_limit | default("not_defined") }}    msg=omp send path limit
    Should Be Equal Value Json String    ${r_id.json()}    $..["send-path-limit"].vipVariableName    {{ omp_template.send_path_limit_variable | default("not_defined") }}    msg=omp send path limit variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["shutdown"].vipValue    {{ omp_template.shutdown | default("not_defined") | lower }}    msg=omp shutdown
    Should Be Equal Value Json String    ${r_id.json()}    $..["shutdown"].vipVariableName    {{ omp_template.shutdown_variable | default("not_defined") }}    msg=omp shutdown variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["transport-gateway"].vipValue    {{ omp_template.transport_gateway | default("not_defined") }}    msg=transport gateway
    Should Be Equal Value Json String    ${r_id.json()}    $..["transport-gateway"].vipVariableName    {{ omp_template.transport_gateway_variable | default("not_defined") }}    msg=transport gateway variable

    ${omp_ipv4_advertise_protocols_list}=    Create List    {{ omp_template.ipv4_advertise_protocols | join('   ') | default([]) }}
    Should Be Equal Value Json List    ${r_id.json()}    $.advertise.vipValue..protocol.vipValue    ${omp_ipv4_advertise_protocols_list}    msg=omp ipv4 advertise protocols

    ${omp_ipv6_advertise_protocols_list}=    Create List    {{ omp_template.ipv6_advertise_protocols | join('   ') | default([]) }}
    Should Be Equal Value Json List    ${r_id.json()}    $["ipv6-advertise"].vipValue..protocol.vipValue    ${omp_ipv6_advertise_protocols_list}    msg=omp ipv6 advertise protocols

{% endfor %}
{% endif %}
