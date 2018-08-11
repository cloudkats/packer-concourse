#/bin/bash
concourse quickstart \
  --postgres-password '__PSQL_PASSWORD__' \
  --postgres-user ${CONCOURSE_POSTGRES_USER} \
  --basic-auth-username ${CONCOURSE_BASIC_AUTH_USERNAME} \
  --basic-auth-password ${CONCOURSE_BASIC_AUTH_PASSWORD} \
  --worker-work-dir /opt/concourse/worker \
  --postgres-host ${CONCOURSE_POSTGRES_HOST} \
  --postgres-database ${CONCOURSE_POSTGRES_DATABASE} \
  --bind-port 80
