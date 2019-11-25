#!/bin/sh

# 使い方
# $ ./publish.sh [引数]
# -> 引数には"flutter pub pub publish"実行時に生成されたcredentials.jsonを指定します。

if [ $# -ne 1 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行出来る引数は1個です。" 1>&2
  echo "シェルファイル内のコメントも確認ください" 1>&2
  exit 1
fi

INPUT_CREDENTIAL=$1
PUB_CACHE_DIR="${FLUTTER_HOME}/.pub-cache"

echo $PATH

mkdir -p ${PUB_CACHE_DIR}

# cat <<EOF > ${PUB_CACHE_DIR}/credentials.json
# {
#   "accessToken":"$GOOGLE_API_ACCESS_TOKEN",
#   "refreshToken":"$GOOGLE_API_REFRESH_TOKEN",
#   "tokenEndpoint":"$GOOGLE_API_TOKEN_ENDPOINT",
#   "scopes":["https://www.googleapis.com/auth/plus.me","https://www.googleapis.com/auth/userinfo.email"],
#   "expiration":$EXPIRATION
# }
# EOF

cat <<EOF > ${PUB_CACHE_DIR}/credentials.json
$INPUT_CREDENTIAL
EOF

echo "Let's publish this!"
flutter pub pub publish -f
