FROM briarm/camunda:camundaRum_7.22_v1.0 AS base

COPY ./default.yml      /camunda/configuration
COPY ./production.yml   /camunda/configuration

