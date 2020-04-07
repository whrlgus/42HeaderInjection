mail="gicho@student.42seoul.kr"
user="gicho"
MAX_LEN_FILE=41
MAX_LEN_USER=9
MAX_LEN_MAIL=25
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
HEADER_FILE_NAME_PART="${HEADER[3]}"

resize() {
  local _str=$1
  local _len=$2
  if [ ${#_str} -gt $_len ]; then
    _str=${_str:0:$_len}
  fi
  echo $_str
}

prepend() {
  for pathname in "$1"/*; do
    if [ -d "$pathname" ]; then
      prepend "$pathname"
    elif [ -e "$pathname" ]; then
      case "$pathname" in
      *.c | *.h)
        file=$(basename $pathname)
        file=$(resize $file $MAX_LEN_FILE)
        HEADER[3]=${HEADER_FILE_NAME_PART:0:5}$file${HEADER_FILE_NAME_PART:((5 + ${#file}))}
        result=""
        for line in "${HEADER[@]}"; do
          result+="$line
"
        done
        result+="
"
        echo "${result}$(cat $pathname)" >$pathname
        ;;
      esac
    fi
  done
}

mail=$(resize $mail $MAX_LEN_MAIL)
regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
if ! [[ $mail =~ $regex ]]; then
  echo "mail error"
  exit 1
fi

user=$(resize $user $MAX_LEN_USER)
user_info="$user <$mail>"
time_info="$(date +"%Y/%m/%d %T") by $user"

HEADER[5]=${HEADER[5]:0:9}$user_info${HEADER[5]:((9 + ${#user_info}))}
HEADER[7]=${HEADER[7]:0:14}$time_info${HEADER[7]:((14 + ${#time_info}))}
HEADER[8]=${HEADER[8]:0:14}$time_info${HEADER[8]:((14 + ${#time_info}))}

prepend "."
