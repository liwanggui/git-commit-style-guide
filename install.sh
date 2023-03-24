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
# 在线快速安装: 
#   curl -sfL https://github.com/liwanggui/git-commit-style-guide/raw/master/install.sh | bash
# 
# 如果国内无法访问 GitHUB 很慢，请使用以下命令安装:
#   curl -sfL https://gh.wglee.org/github.com/liwanggui/git-commit-style-guide/raw/master/install.sh | bash -s proxy
# 

BASE_URL="https://github.com"
RELEASE_URL="https://api.github.com/repos/liwanggui/git-commit-style-guide/releases/latest"

install_commit_style () {
    local version=$(curl -s $RELEASE_URL | grep tag_name | cut -f4 -d "\"")
    local download_url="${BASE_URL}/liwanggui/git-commit-style-guide/archive/refs/tags/${version}.tar.gz"
    local temp_dir=$(mktemp -d)

    curl -SsL $download_url | tar xzf - --strip-components=1 -C $temp_dir

    /bin/cp -f ${temp_dir}/.cz-config.js .
    /bin/cp -f ${temp_dir}/.vcmrc .
    /bin/cp -f ${temp_dir}/package.json .
    /bin/rm -rf $temp_dir

    npm list -g | grep -q commitizen || npm install -g commitizen 
    npm list -g | grep -q conventional-changelog-cli || npm install -g conventional-changelog-cli
    
    npm install
}

if ! command -v npm &>/dev/null; then
    echo "error: npm not found, please install nodejs first"
    exit 1
fi

if [ $UID -ne 0 ]; then
    echo "error: run as root or use sudo"
    echo "example:"
    echo "  $ curl -SsL ${url}/liwanggui/git-commit-style-guide/raw/master/install.sh | sudo bash"
    exit 1
fi

if [[ $1 = "proxy" ]]; then
    BASE_URL="https://gh.wglee.org/github.com"
fi

install_commit_style