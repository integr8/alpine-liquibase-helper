#!/bin/bash
set -e

if [[ ! -z ${GIT_URL} || ! -z ${GIT_URL}  || ! -z ${GIT_PASS} ]]; then
  git config --global user.name ${GIT_USER}
  git config --global user.email "${GIT_USER}@${GIT_DOMAIN}"
  git config --global credential.username ${GIT_USER}
  git config --global credential.helper '!f() { echo "password='${GIT_PASS}'"; }; f'
  git config --global push.default simple
  git config --global http.sslVerify "false"



else
  echo 'É necessário informar um repositório, usuário e senha para clone'
fi