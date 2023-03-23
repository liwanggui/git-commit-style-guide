#!/bin/bash
#
#***************************************************************************
# Author: liwanggui
# Email: liwanggui@163.com
# Date: 2023-03-23
# FileName: install.sh
# Description: Git commit 提交规范工具安装及配置
# Copyright (C): 2023 All rights reserved
#***************************************************************************
# 
# curl -SsL https://github.com/liwanggui/git-commit-style-guide/raw/master/install.sh | bash
# 

latest_url="https://github.com/liwanggui/git-commit-style-guide/releases/latest"
latest_version=$(curl -si $latest_url | grep ^location | awk -F/ '{print $NF}' | tr -d '[:space:]')
download_url="https://github.com/liwanggui/git-commit-style-guide/archive/refs/tags/${latest_version}.tar.gz"
temp_dir=$(mktemp -d)

install_commit_style () {
    curl -SsL $download_url | tar xzf - --strip-components=1 -C $temp_dir

    /bin/cp -f ${temp_dir}/.cz-config.js .
    /bin/cp -f ${temp_dir}/.vcmrc .
    /bin/cp -f ${temp_dir}/package.json .
    /bin/rm -rf $temp_dir

    npm install -g commitizen conventional-changelog-cli
    npm install
}

if ! command -v npm &>/dev/null; then
    echo "error: npm not found, please install nodejs first"
    exit 1
fi

if [ $UID -ne 0 ]; then
    echo "error: run as root or use sudo"
    echo "example:"
    echo "  $ curl -SsL https://github.com/liwanggui/git-commit-style-guide/raw/master/install.sh | sudo bash"
    exit 1
fi

install_commit_style