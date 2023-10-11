#!/bin/env bash
: "${COMPUTE_DEVICE:=cuda}"
: "${DEFAULT_MODEL:=lama}"

function has_device_parameter() {
  local plugin
  for feature in gfpgan interactive-seg restoreformer; do
    if [ "${feature}" = "$1" ]; then
      return 0
    fi
  done
  return 1
}

function is_valid_feature() {
  local feature
  for feature in anime-seg gfpgan gif interactive-seg realesrgan remove-bg restoreformer xformers; do
    if [ "${feature}" = "$1" ]; then
      return 0
    fi
  done
  return 1
}

EXTRA_ARGS=""

for feature in ${ENABLED_FEATURES}; do
  if is_valid_feature ${feature}; then
    EXTRA_ARGS="${EXTRA_ARGS} --enable-${feature}"
    if has_device_parameter ${feature}; then
      EXTRA_ARGS="${EXTRA_ARGS} --${feature}-device=${COMPUTE_DEVICE}"
    fi
  else
    echo "Ignoring unknown feature: ${feature}"
  fi
done

echo Running lama-cleaner with the following features: ${EXTRA_ARGS}
lama-cleaner --device=${COMPUTE_DEVICE} --host=${HOST:-"0.0.0.0"} --model=${DEFAULT_MODEL} ${EXTRA_ARGS} $@
