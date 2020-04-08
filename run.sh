# 사용자 정보, 주석 지우고 사용할 것
# readonly MAIL="gicho@student.42seoul.kr"
readonly MAIL="gicho@student.42seoul.kr"
# readonly USER="gicho"
readonly USER="gicho"
readonly MAX_LEN_FILE=41
readonly MAX_LEN_USER=9
readonly MAX_LEN_MAIL=25
HEADER=(
  "/* ************************************************************************** */"
  "/*                                                                            */"
  "/*                                                        :::      ::::::::   */"
  "/*                                                      :+:      :+:    :+:   */"
  "/*                                                    +:+ +:+         +:+     */"
  "/*   By:                                            +#+  +:+       +#+        */"
  "/*                                                +#+#+#+#+#+   +#+           */"
  "/*   Created:                     by                   #+#    #+#             */"
  "/*   Updated:                     by                  ###   ########.fr       */"
  "/*                                                                            */"
  "/* ************************************************************************** */"
)
readonly HEADER_FILE_NAME_PART="${HEADER[3]}"
readonly REGEX="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

# 미리 정한 최대 길이를 넘은 경우 문자열을 잘라서 반환
resize() {
  local _str=$1
  local _len=$2
  if [ ${#_str} -gt "$_len" ]; then
    _str=${_str:0:$_len}
  fi
  echo "$_str"
}

# 파일에 42헤더 삽입
prepend() {
  local _file=$(basename "$1")
  _file=$(resize "$_file" $MAX_LEN_FILE)
  HEADER[3]=${HEADER_FILE_NAME_PART:0:5}$_file${HEADER_FILE_NAME_PART:((5 + ${#_file}))}

  local _result=""
  for line in "${HEADER[@]}"; do
    _result+="$line
"
  done
  _result+="
"
  echo "${_result}$(cat "$1")" >"$1"
}

# 디렉토리 순회하여 *.c 와 *.h 파일 탐색
traverse() {
  for path in "$1"/*; do
    if [ -d "$path" ]; then
      traverse "$path"
    elif [ -e "$path" ]; then
      case "$path" in
      *.c | *.h)
        prepend "$path"
        echo modified: "$path"
        ;;
      esac
    fi
  done
}

setCommonInfo(){
  # 메일 주소 형식 검사, 25자를 넘길 경우 주의
  local _mail=$(resize $MAIL $MAX_LEN_MAIL)
  if ! [[ $MAIL =~ $REGEX ]]; then
    echo "mail error"
    exit 1
  fi

  local _user=$(resize $USER $MAX_LEN_USER)
  local _user_info="$_user <$_mail>"
  local _time_info="$(date +"%Y/%m/%d %T") by $_user"

  HEADER[5]=${HEADER[5]:0:9}$_user_info${HEADER[5]:((9 + ${#_user_info}))}
  HEADER[7]=${HEADER[7]:0:14}$_time_info${HEADER[7]:((14 + ${#_time_info}))}
  HEADER[8]=${HEADER[8]:0:14}$_time_info${HEADER[8]:((14 + ${#_time_info}))}
}

main() {
  setCommonInfo
  traverse "."
}

main
