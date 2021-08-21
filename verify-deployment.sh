#!/bin/bash

POD_NAME=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{end}}' | grep weather-app)
POD_LOGS=$(kubectl logs "${POD_NAME}")
kubectl logs "${POD_NAME}"

if [[ ${POD_LOGS} == *"Response Code: 200"* ]]; then
  echo 'Verification finished successfully'
  exit 0
else
  echo 'Verification failed'
  exit 1
fi