#!/bin/bash

# Run fink-broker e2e tests

# @author  Fabrice Jammes

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)

. $DIR/token.sh

token="${TOKEN:-}"

event_type="e2e-noscience"

url="https://api.github.com/repos/k8s-school/gha-experiment/dispatches"

payload="{\"build\": $build,\"e2e\": $e2e,\"push\": $push, \"cluster\": \"$cluster\", \"image\": \"$CIUX_IMAGE_URL\"}"
echo "Payload: $payload"

if [ -z "$token" ]; then
  echo "No token provided, skipping GitHub dispatch"
else
  echo "Dispatching event to GitHub"
  curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  $url \
  -d "{\"event_type\":\"$event_type\",\"client_payload\":$payload}" || echo "ERROR Failed to dispatch event" >&2
