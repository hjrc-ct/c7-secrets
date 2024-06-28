FROM briarm/camunda:camundaRum_7.22_v1.0 AS base

RUN rm -f /camunda/configuration/default.yml
RUN rm -f /camunda/configuration/production.yml
RUN rm -f /camunda/camunda.sh

COPY ./default.yml                    /camunda/configuration
COPY ./production.yml                 /camunda/configuration

COPY --chmod=0755  ./camunda.sh       /camunda/camunda.sh


ENTRYPOINT [ "./camunda.sh", "--production" ]