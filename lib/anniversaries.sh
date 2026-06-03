
anniversaries() {
  local today year mmdd easter holiday_date

  today="${1:-$(command date +%F)}" || return
  year="${today%%-*}"
  mmdd="${today#*-}"

  fi_holiday_add() {
    printf 'Today in Finland: %s\n' "$1"
  }

  fi_date_add() {
    command date -d "$1 $2 days" +%F
  }

  fi_nth_weekday() {
    local y="$1" m="$2" weekday="$3" nth="$4" first first_weekday offset day

    first="$(printf '%04d-%02d-01' "$y" "$m")"
    first_weekday="$(command date -d "$first" +%u)"
    offset=$(( (weekday - first_weekday + 7) % 7 ))
    day=$(( 1 + offset + ((nth - 1) * 7) ))
    printf '%04d-%02d-%02d\n' "$y" "$m" "$day"
  }

  fi_last_weekday() {
    local y="$1" m="$2" weekday="$3" last last_weekday offset

    last="$(command date -d "$(printf '%04d-%02d-01 +1 month -1 day' "$y" "$m")" +%F)"
    last_weekday="$(command date -d "$last" +%u)"
    offset=$(( (last_weekday - weekday + 7) % 7 ))
    fi_date_add "$last" "-$offset"
  }

  fi_weekday_after() {
    local from="$1" weekday="$2" from_weekday offset

    from_weekday="$(command date -d "$from" +%u)"
    offset=$(( (weekday - from_weekday + 7) % 7 ))
    [[ $offset -eq 0 ]] && offset=7
    fi_date_add "$from" "$offset"
  }

  fi_weekday_on_or_after() {
    local from="$1" weekday="$2" from_weekday offset

    from_weekday="$(command date -d "$from" +%u)"
    offset=$(( (weekday - from_weekday + 7) % 7 ))
    fi_date_add "$from" "$offset"
  }

  fi_sunday_before() {
    local from="$1" from_weekday offset

    from_weekday="$(command date -d "$from" +%u)"
    offset="$from_weekday"
    fi_date_add "$from" "-$offset"
  }

  fi_easter() {
    local y="$1" a b c d e f g h i k l m month day

    a=$(( y % 19 ))
    b=$(( y / 100 ))
    c=$(( y % 100 ))
    d=$(( b / 4 ))
    e=$(( b % 4 ))
    f=$(( (b + 8) / 25 ))
    g=$(( (b - f + 1) / 3 ))
    h=$(( (19 * a + b - d - g + 15) % 30 ))
    i=$(( c / 4 ))
    k=$(( c % 4 ))
    l=$(( (32 + 2 * e + 2 * i - h - k) % 7 ))
    m=$(( (a + 11 * h + 22 * l) / 451 ))
    month=$(( (h + l - 7 * m + 114) / 31 ))
    day=$(( ((h + l - 7 * m + 114) % 31) + 1 ))

    printf '%04d-%02d-%02d\n' "$y" "$month" "$day"
  }

  easter="$(fi_easter "$year")"

  case "$mmdd" in
    01-01) fi_holiday_add "Uudenvuodenpäivä" ;;
    01-06) fi_holiday_add "Loppiainen" ;;
    01-27) fi_holiday_add "Vainojen uhrien muistopäivä" ;;
    02-05) fi_holiday_add "Runebergin päivä" ;;
    02-06) fi_holiday_add "Saamelaisten kansallispäivä" ;;
    02-14) fi_holiday_add "Ystävänpäivä" ;;
    02-28) fi_holiday_add "Kalevalan päivä, suomalaisen kulttuurin päivä" ;;
    02-29) fi_holiday_add "Karkauspäivä" ;;
    03-08) fi_holiday_add "Naistenpäivä" ;;
    03-19) fi_holiday_add "Minna Canthin päivä, tasa-arvon päivä" ;;
    04-08) fi_holiday_add "Romanien kansallispäivä" ;;
    04-09) fi_holiday_add "Mikael Agricolan päivä, suomen kielen päivä" ;;
    04-27) fi_holiday_add "Kansallinen veteraanipäivä" ;;
    05-01) fi_holiday_add "Vappu, suomalaisen työn päivä" ;;
    05-09) fi_holiday_add "Eurooppa-päivä" ;;
    05-12) fi_holiday_add "J. V. Snellmanin päivä, suomalaisuuden päivä" ;;
    06-04) fi_holiday_add "Puolustusvoimien lippujuhlan päivä" ;;
    07-06) fi_holiday_add "Eino Leinon päivä, runon ja suven päivä" ;;
    07-27) fi_holiday_add "Unikeonpäivä" ;;
    09-05) fi_holiday_add "Yrittäjän päivä" ;;
    10-10) fi_holiday_add "Aleksis Kiven päivä, suomalaisen kirjallisuuden päivä" ;;
    10-24) fi_holiday_add "YK:n päivä" ;;
    11-06) fi_holiday_add "Svenska dagen" ;;
    11-20) fi_holiday_add "Lasten oikeuksien päivä" ;;
    12-06) fi_holiday_add "Itsenäisyyspäivä" ;;
    12-08) fi_holiday_add "Jean Sibeliuksen päivä, suomalaisen musiikin päivä" ;;
    12-24) fi_holiday_add "Jouluaatto" ;;
    12-25) fi_holiday_add "Joulupäivä" ;;
    12-26) fi_holiday_add "Tapaninpäivä" ;;
    12-28) fi_holiday_add "Viattomien lasten päivä" ;;
  esac

  [[ $today == "$(fi_date_add "$easter" "-49")" ]] && fi_holiday_add "Laskiaissunnuntai"
  [[ $today == "$(fi_date_add "$easter" "-47")" ]] && fi_holiday_add "Laskiaistiistai"
  [[ $today == "$(fi_date_add "$easter" "-7")" ]] && fi_holiday_add "Palmusunnuntai"
  [[ $today == "$(fi_date_add "$easter" "-2")" ]] && fi_holiday_add "Pitkäperjantai"
  [[ $today == "$easter" ]] && fi_holiday_add "Pääsiäispäivä"
  [[ $today == "$(fi_date_add "$easter" "1")" ]] && fi_holiday_add "2. pääsiäispäivä"
  [[ $today == "$(fi_date_add "$easter" "39")" ]] && fi_holiday_add "Helatorstai"
  [[ $today == "$(fi_date_add "$easter" "49")" ]] && fi_holiday_add "Helluntaipäivä"

  holiday_date="$(fi_sunday_before "$year-03-29")"
  if [[ $holiday_date == "$easter" || $holiday_date == "$(fi_date_add "$easter" "-7")" ]]; then
    holiday_date="$(fi_date_add "$easter" "-14")"
  fi
  [[ $today == "$holiday_date" ]] && fi_holiday_add "Marian ilmestyspäivä"

  [[ $today == "$(fi_nth_weekday "$year" 5 7 2)" ]] && fi_holiday_add "Äitienpäivä"
  [[ $today == "$(fi_nth_weekday "$year" 5 7 3)" ]] && fi_holiday_add "Kaatuneitten muistopäivä"
  [[ $today == "$(fi_weekday_on_or_after "$year-06-19" 5)" ]] && fi_holiday_add "Juhannusaatto"
  [[ $today == "$(fi_weekday_on_or_after "$year-06-20" 6)" ]] && fi_holiday_add "Juhannuspäivä"
  [[ $today == "$(fi_weekday_after "$year-10-30" 6)" ]] && fi_holiday_add "Pyhäinpäivä"
  [[ $today == "$(fi_nth_weekday "$year" 11 7 2)" ]] && fi_holiday_add "Isänpäivä"
  [[ $today == "$(fi_last_weekday "$year" 3 7)" ]] && fi_holiday_add "Kesäaika alkaa (tunti eteenpäin)"
  [[ $today == "$(fi_last_weekday "$year" 10 7)" ]] && fi_holiday_add "Kesäaika päättyy (tunti taaksepäin)"

  holiday_date="$(fi_sunday_before "$year-12-24")"
  [[ $today == "$(fi_date_add "$holiday_date" "-21")" ]] && fi_holiday_add "1. adventtisunnuntai"
  [[ $today == "$(fi_date_add "$holiday_date" "-14")" ]] && fi_holiday_add "2. adventtisunnuntai"
  [[ $today == "$(fi_date_add "$holiday_date" "-7")" ]] && fi_holiday_add "3. adventtisunnuntai"
  [[ $today == "$holiday_date" ]] && fi_holiday_add "4. adventtisunnuntai"

  return 0
}
