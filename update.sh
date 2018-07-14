#!/usr/bin/env bash
set -e
BE="https://api.github.com/repos/unicef/sir-poc/releases/latest"

if [ -z "${GITHUB_TOKEN}" ];then
    echo "Error: GITHUB_TOKEN not found in environment"
    exit 1
fi

latest=`curl -s -H "Authorization: token ${GITHUB_TOKEN}" ${BE} | jq -r '.tag_name'`
if [ $latest ==  null ];then
    echo "Unable to find release"
    exit 1
fi

sed -i "" -e "s/^ENV BACKEND_VERSION .*/ENV BACKEND_VERSION '$latest'/g" backend/Dockerfile
if [ "$latest" == "null" ];then
    echo "${GITHUB_TOKEN}"
    echo "unable to fetch last release from ${BE}"
else
    echo $latest
    BACKEND_VERSION=$latest
fi
