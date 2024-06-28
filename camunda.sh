#!/bin/bash
set -Eeu

trap 'Error on line $LINENO' ERR

source $(dirname "$0")/camunda-lib.sh

# Set Password as Docker Secrets for Swarm-Mode
if [[ -z "${DB_PASSWORD:-}" && -n "${DB_PASSWORD_FILE:-}" && -f "${DB_PASSWORD_FILE:-}" ]]; then
  export DB_PASSWORD="$(< "${DB_PASSWORD_FILE}")"
fi

# For compatibility: when DB_ variables are set, translate them to SPRING_ variables.
# Otherwise [defaults](https://github.com/camunda/camunda-bpm-platform/blob/master/distro/run/assembly/resources/default.yml)
# will be used.

if [[ -z "${SPRING_DATASOURCE_DRIVER_CLASS_NAME:-}" && -n "${DB_DRIVER:-}" ]]; then
  export SPRING_DATASOURCE_DRIVER_CLASS_NAME="${DB_DRIVER}"
fi

if [[ -z "${SPRING_DATASOURCE_PASSWORD:-}" && -n "${DB_PASSWORD:-}" ]]; then
  export SPRING_DATASOURCE_PASSWORD="${DB_PASSWORD}"
fi

if [[ -z "${SPRING_DATASOURCE_USERNAME:-}" && -n "${DB_USERNAME:-}" ]]; then
  export SPRING_DATASOURCE_USERNAME="${DB_USERNAME}"
fi

if [[ -z "${SPRING_DATASOURCE_URL:-}" && -n "${DB_URL:-}" ]]; then
  export SPRING_DATASOURCE_URL="${DB_URL}"
fi

echo "Set secret variables"
if [ -e /run/secrets/SECRET_ML_DB_DRIVER ] 
then
    export SECRET_ML_DB_DRIVER=`cat /run/secrets/SECRET_ML_DB_DRIVER`
else
    export SECRET_ML_DB_DRIVER=""
fi

if [ -e /run/secrets/SECRET_ML_DB_URL ] 
then
    export SECRET_ML_DB_URL=`cat /run/secrets/SECRET_ML_DB_URL`
else
    export SECRET_ML_DB_URL=""
fi

if [ -e /run/secrets/SECRET_ML_DB_USERNAME ] 
then
    export SECRET_ML_DB_USERNAME=`cat /run/secrets/SECRET_ML_DB_USERNAME`
else
    export SECRET_ML_DB_USERNAME=""
fi

if [ -e /run/secrets/SECRET_ML_DB_PASSWORD ] 
then
    export SECRET_ML_DB_PASSWORD=`cat /run/secrets/SECRET_ML_DB_PASSWORD`
else
    export SECRET_ML_DB_PASSWORD=""
fi

CMD="/camunda/internal/run.sh start"

wait_for_it

# shellcheck disable=SC2086
exec ${CMD} "$@"