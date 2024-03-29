#!/bin/bash

echo "Starting build to gh-pages"

REMOTE_REPO="https://${GITHUB_ACTOR}:$1@github.com/${GITHUB_REPOSITORY}.git"
echo "远程仓库: ${REMOTE_REPO}"

BUILD_DIR="${GITHUB_WORKSPACE}/out"
echo "构建目录文件夹: ${BUILD_DIR}"

remote_branch="gh-pages"
echo "部署分支：${remote_branch}"

LOCAL_BRANCH=$remote_branch
echo "本地分支是：${LOCAL_BRANCH}"


if npm run build ; then
  echo "构建完成"
else
  echo "构建失败"
  exit 1
fi

touch $BUILD_DIR/.nojekyll

cd $BUILD_DIR

rm -rf .git
rm .gitignore

git init -b $LOCAL_BRANCH

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git add .
git commit -m "build from Action ${GITHUB_SHA}"
git push -f $REMOTE_REPO $LOCAL_BRANCH:$remote_branch

