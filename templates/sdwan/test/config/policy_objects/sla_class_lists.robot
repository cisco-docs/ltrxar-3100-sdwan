*** Settings ***
Documentation   Verify Sla Class Lists
Suite Setup     Login SDWAN Manager
Default Tags    sdwan   config   sla_class_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.sla_classes is defined %}

*** Test Cases ***
Get Sla Class List(s)
    ${r}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/sla
    Set Suite Variable   ${r}

{% for sla in sdwan.policy_objects.sla_classes | default([]) %}
{% if sla.name is defined %}
{% set sla_class_name= sla.name %}

Verify Policy Objects SLA Class List {{ sla_class_name }}
   ${sla_class_id}=   Get Value From Json   ${r.json()}   $..data[?(@..name=="{{sla_class_name }}")].listId
   ${sla}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/sla/${sla_class_id[0]}
   Should Be Equal Value Json String   ${sla.json()}   $..name  {{ sla_class_name }}   msg=SLA class name

{% set sla_class_jitter= sla.jitter_ms | default("not_defined") %}
   Should Be Equal Value Json String   ${sla.json()}   $..jitter   {{ sla_class_jitter }}  msg={{ sla_class_name }}: Jitter

{% set sla_class_latency= sla.latency_ms | default("not_defined") %}
   Should Be Equal Value Json String   ${sla.json()}   $..latency   {{ sla_class_latency }}  msg={{ sla_class_name }}: Latency

{% set sla_class_loss= sla.loss_percentage | default("not_defined") %}
   Should Be Equal Value Json String   ${sla.json()}   $..loss   {{ sla_class_loss }}  msg={{ sla_class_name }}: Loss

{% set app_probe_class= sla.app_probe_class | default("not_defined") %}
   ${app_probe_id}=   Get Value From Json   ${sla.json()}   $..appProbeClass
   ${app_probe_object}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/appprobe/${app_probe_id[0]}
   Should Be Equal Value Json String   ${app_probe_object.json()}   $..name   {{ app_probe_class }}  msg={{ sla_class_name }}: App Probe Class

{% set fallback_best_tunnel_criteria= sla.fallback_best_tunnel_criteria | default("not_defined") %}
   Should Be Equal Value Json String   ${sla.json()}   $..criteria   {{ fallback_best_tunnel_criteria }}  msg={{ sla_class_name }}: Loss Criteria

{% set fallback_best_tunnel_jitter= sla.fallback_best_tunnel_jitter | default("not_defined") %}
   Should Be Equal Value Json String   ${sla.json()}   $..jitterVariance   {{ fallback_best_tunnel_jitter }}  msg={{ sla_class_name }}: Jitter Variance

{% set fallback_best_tunnel_latency= sla.fallback_best_tunnel_latency | default("not_defined") %}
   Should Be Equal Value Json String   ${sla.json()}   $..latencyVariance   {{ fallback_best_tunnel_latency }}  msg={{ sla_class_name }}: Latency Variance

{% set fallback_best_tunnel_loss= sla.fallback_best_tunnel_loss | default("not_defined") %}
   Should Be Equal Value Json String   ${sla.json()}   $..lossVariance   {{ fallback_best_tunnel_loss }}  msg={{ sla_class_name }}: Loss Variance
{% endif %}

{% endfor %}
{% endif %}
