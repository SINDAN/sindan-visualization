#!/bin/bash
# sindan.sh
# version 1.1

# read configurationfile
. ./sindan.conf

#
# functions
#

## for initial
#
cleate_uuid() {
  uuidgen
}

#
write_json_campaign() {
#  if [ $# -lt 4 ]; then
#    echo "ERROR: write_json_campaign <uuid> <mac_addr> <os> <ssid>." 1>&2
#    return 1
#  fi
  local json="{ \"log_campaign_uuid\" : \"$1\",
                \"mac_addr\" : \"$2\",
                \"os\" : \"$3\",
                \"ssid\" : \"$4\",
                \"occurred_at\" : \"`date -u '+%Y-%m-%d %T'`\" }"
  echo ${json} > log/campaign_`date -u '+%s'`.json
}

#
write_json() {
  if [ $# -lt 5 ]; then
    echo "$1, $2, $3, $4, #5"
    echo "ERROR: write_json <layer> <group> <type> <result> <detail>. ($3)" 1>&2
    return 1
  fi
  local json="{ \"layer\" : \"$1\",
                \"log_group\" : \"$2\",
                \"log_type\" : \"$3\",
                \"log_campaign_uuid\" : \"${uuid}\",
                \"result\" : \"$4\",
                \"detail\" : \"$5\",
                \"occurred_at\" : \"`date -u '+%Y-%m-%d %T'`\" }"
  echo ${json} > log/sindan_$1_$3_`date -u '+%s'`.json
}

## for datalink layer
#
get_devicename() {
    echo ${DEVNAME}
}

#
do_ifdown() {
  if [ $# -lt 1 ]; then
    echo "ERROR: do_ifdown <devicename>." 1>&2
    return 1
  fi
  ifdown $1
  rm /var/lib/dhcp/dhclient.$1.leases
}

#
do_ifup() {
  if [ $# -lt 1 ]; then
    echo "ERROR: do_ifup <devicename>." 1>&2
    return 1
  fi
  ifup $1
}

#
get_os() {
  if type lsb_release > /dev/null 2>&1; then
    lsb_release -ds
  else
    grep PRETTY_NAME /etc/*-release | awk -F\" '{print $2}'
  fi
}

#
get_ifstatus() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ifstatus <devicename>." 1>&2
    return 1
  fi
#  local status=`ip link show $1 | grep state | awk '{print $9}'`
  local status=`cat /sys/class/net/$1/operstate`
  if [ "${status}" = "UP" ]; then
    echo ${status}; return 0
  else
    echo ${status}; return 1
  fi
}

#
get_ifmtu() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ifmtu <devicename>." 1>&2
    return 1
  fi
#  ip link show $1 | grep mtu | awk '{print $5}'
  cat /sys/class/net/$1/mtu
}

#
get_macaddr() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_macaddr <devicename>." 1>&2
    return 1
  fi
  cat /sys/class/net/$1/address
}

#
get_mediatype() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_mediatype <devicename>." 1>&2
    return 1
  fi
  local speed=`cat /sys/class/net/$1/speed`
  local duplex=`cat /sys/class/net/$1/duplex`
  echo ${speed} ${duplex}
}

#
get_wifi_ssid() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_wifi_ssid <devicename>." 1>&2
    return 1
  fi
#  wpa_cli -i $1 status | grep [^b]ssid | awk -F: '{print $2}
  iwgetid $1 --raw
}

#
get_wifi_bssid() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_wifi_bssid <devicename>." 1>&2
    return 1
  fi
#  wpa_cli -i $1 status | grep bssid | awk -F: '{print $2}
  iwgetid $1 --raw --ap
}

#
get_wifi_channel() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_wifi_channel <devicename>." 1>&2
    return 1
  fi
  iwgetid $1 --raw --channel
}

#
get_wifi_rssi() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_wifi_rssi <devicename>." 1>&2
    return 1
  fi
  grep $1 /proc/net/wireless | awk '{print $4}'
}

#
get_wifi_noise() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_wifi_noise <devicename>." 1>&2
    return 1
  fi
  grep $1 /proc/net/wireless | awk '{print $5}'
}

#
get_wifi_rate() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_wifi_rate <devicename>." 1>&2
    return 1
  fi
  iwconfig $1 | sed -n 's@^.*Bit\ Rate=\([0-9.]*\) Mb/s.*$@\1@p'
}

## for interface layer
#
get_v4ifconf() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_v4ifconf <devicename>." 1>&2
    return 1
  fi
  grep "$1 inet" /etc/network/interfaces | awk '{print $4}'
#  echo "TBD"
}

#
check_v4autoconf() {
  if [ $# -lt 2 ]; then
    echo "ERROR: check_v4autoconf <devicename> <v4ifconf>." 1>&2
    return 1
  fi
  if [ $2 = "dhcp" ]; then
    cat /var/lib/dhcp/dhclient.$1.leases | sed 's/"//g'
    return 0
  fi
  echo "v4conf is $2"
  return 9
}

#
get_v4addr() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_v4addr <devicename> <v4ifconf>." 1>&2
    return 1
  fi
#  if [ $2 = "dhcp" ]; then
#    echo "TBD"
#  else
    ip -4 address show $1 | sed -n 's@^.*inet \([0-9.]*\)/.*$@\1@p'
#  fi
}

#
get_netmask() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_netmask <devicename> <v4ifconf>." 1>&2
    return 1
  fi
#  if [ $2 = "dhcp" ]; then
#    echo "TBD"
#  else
    local preflen=`ip -4 address show $1 | sed -n 's@^.*inet [0-9.]*/\([0-9]*\) .*$@\1@p'`
    case "${preflen}" in
      16) echo "255.255.0.0" ;;
      17) echo "255.255.128.0" ;;
      18) echo "255.255.192.0" ;;
      19) echo "255.255.224.0" ;;
      20) echo "255.255.240.0" ;;
      21) echo "255.255.248.0" ;;
      22) echo "255.255.252.0" ;;
      23) echo "255.255.254.0" ;;
      24) echo "255.255.255.0" ;;
      25) echo "255.255.255.128" ;;
      26) echo "255.255.255.192" ;;
      27) echo "255.255.255.224" ;;
      28) echo "255.255.255.240" ;;
      29) echo "255.255.255.248" ;;
      30) echo "255.255.255.252" ;;
      31) echo "255.255.255.254" ;;
      *) ;;
    esac
#  fi
}

#
get_v4routers() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_v4routers <devicename> <v4ifconf>." 1>&2
    return 1
  fi
#  if [ $2 = "dhcp" ]; then
#    echo "TBD"
#  else
    ip -4 route | grep default | grep $1 | awk '{print $3}'
#  fi
}

#
get_v4nameservers() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_v4nameservers <devicename> <v4ifconf>." 1>&2
    return 1
  fi
#  if [ $2 = "dhcp" ]; then
#    echo "TBD"
#  else
    grep nameserver /etc/resolv.conf | awk '{print $2}' | grep -v : |
     awk -v ORS=' ' '1; END{printf "\n"}'
#  fi
}

#
get_v6ifconf() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_v6ifconf <devicename>." 1>&2
    return 1
  fi
  local v6ifconf=`grep "$1 inet6" /etc/network/interfaces | awk '{print $4}'`
  if [ "X${v6ifconf}" != "X" ]; then
    cat ${v6ifconf}
  else
    echo "automatic"
  fi
#  echo "TBD"
}

#
get_v6lladdr() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_v6lladdr <devicename>." 1>&2
    return 1
  fi
  ip -6 address show $1 | sed -n 's@^.*inet6 \(fe80[0-9a-f:]*\)/.*$@\1@p'
}

#
get_ra_prefixes() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ra_prefixes <devicename>." 1>&2
    return 1
  fi
  rdisc6 -1 $1 | grep Prefix | awk '{print $3}' |
   awk -F\n -v ORS=',' '{print}' | sed 's/,$//'
}

# require ndisc6 ver 1.0.3
get_ra_prefix_flags() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_ra_prefix_flags <devicename> <ra_prefix>." 1>&2
    return 1
  fi
  local prefix=`echo $1 | awk -F/ '{print $2}'`
  rdisc6 -1 $1 |
   awk 'BEGIN{
     find=0;
     while (getline line) {
       if (find==1) {
         if (match(line,/'"On-link"'.*/) && match(line,/'"Yes"'.*/)) {
           print "O";
         } else if (match(line,/'"Autonomous"'.*/) && match(line,/'"Yes"'.*/)) {
           print "A";
           find=0;
         }
       } else if (match(line,/'"$prefix"'.*/)) {
         find=1;
       }
     }
   }' |
   awk -F\n -v ORS='' '{print}'
}

#
get_ra_flags() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ra_flags <devicename>." 1>&2
    return 1
  fi
  rdisc6 -1 $1 |
   awk 'BEGIN{
     while (getline line) {
       if (match(line,/'"Stateful address"'.*/) && match(line,/'"No"'.*/)) {
         print "M";
       } else if (match(line,/'"Stateful other"'.*/) && match(line,/'"No"'.*/)) {
         print "O";
       }
     }
   }' |
   awk -F\n -v ORS='' '{print}'
}

#
check_v6autoconf() {
  if [ $# -lt 5 ]; then
    echo "ERROR: check_v6autoconf <devicename> <v6ifconf> <ra_flags> <ra_prefix> <ra_prefix_flags>." 1>&2
    return 1
  fi
  local prefix=`echo $3 | sed -n 's@\([0-9a-f:]*\)::/.*$@\1@p'`
  local v6addrs=""
  local a_flag=`echo $3 | grep A`
  local m_flag=`echo $5 | grep M`
  if [ $2 = "automatic" ]; then
#    if [ "X${a_flag}" != "X" ]; then
#     #TBD
#    fi
#    if [ "X${m_flag}" != "X" ]; then
#     #TBD
#    fi
    echo ${v6addrs} | sed 's/,$//'
    return 0
  else
    ip -6 address show $1 | sed -n '/${prefix}/s@^.*inet6 \([0-9a-f:]*\)/.*$@\1@p'
    return 9
  fi
}

#
get_v6addrs() {
  if [ $# -lt 4 ]; then
    echo "ERROR: get_v6addrs <devicename> <v6ifconf> <ra_prefix> <ra_prefix_flags>." 1>&2
    return 1
  fi
  local prefix=`echo $3 | sed -n 's@\([0-9a-f:]*\)::/.*$@\1@p'`
  local m_flag=`echo $4 | grep M`
  if [ $2 = "automatic" -a "${m_flag}" ]; then
    echo "TBD"
  else
    ip -6 address show $1 | grep inet6 | grep ${prefix} | awk '{print $2}' |
     awk -F\n -v ORS=',' '{print}' | sed 's/,$//'
#    ip -6 address show $1 | sed -n '/${prefix}/s@^.*inet6 \([0-9a-f:]*\)/.*$@\1@p' |
#     awk -F\n -v ORS=',' '{print}' | sed 's/,$//'
  fi
}

#
get_prefixlen() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_prefixlen <ra_prefix>." 1>&2
    return 1
  fi
  echo $1 | awk -F/ '{print $2}'
}

#
get_v6routers() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_v6routers <devicename>." 1>&2
    return 1
  fi
  local v6router=`ip -6 route | grep default | grep $1 | awk '{print $3}'`
  echo ${v6router}%$1
}

#
get_v6nameservers() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_v6nameservers <devicename> <v6ifconf> <ra_flags>." 1>&2
    return 1
  fi
#  local dhcpv6=`echo $3 | grep M`
#  if [ $2 = "automatic" -a "${dhcpv6}" ]; then
#    echo "TBD"
#  else
    # need for IPv6
    grep nameserver /etc/resolv.conf | awk '{print $2}' | grep : |
     awk -v ORS=' ' '1; END{printf "\n"}'
#  fi
}

## for localnet layer
#
do_ping() {
  if [ $# -lt 2 ]; then
    echo "ERROR: do_ping <version> <target_addr>." 1>&2
    return 1
  fi
  local command=""
  case $1 in
    "4" ) command=ping ;;
    "6" ) command=ping6 ;;
    * ) echo "ERROR: <version> must be 4 or 6." 1>&2; return 9 ;;
  esac
  ${command} -c 5 $2
  return $?
}

#
get_rtt() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_rtt <ping_result>." 1>&2
    return 1
  fi
  echo "$1" | grep rtt | awk '{print $4}' | awk -F"/" '{print $2}'
}

## for globalnet layer
#
do_traceroute() {
  if [ $# -lt 2 ]; then
    echo "ERROR: do_traceroute <version> <target_addr>." 1>&2
    return 1
  fi
  local command=""
  case $1 in
    "4" ) command=traceroute ;;
    "6" ) command=traceroute6 ;;
    * ) echo "ERROR: <version> must be 4 or 6." 1>&2; return 9 ;;
  esac
  ${command} -n -w 1 -q 1 -m 50 $2 2>/dev/null | grep -v traceroute |
   awk '{print $2}' | awk -F\n -v ORS=',' '{print}' | sed 's/,$//'
}

#
do_pmtud() {
  if [ $# -lt 4 ]; then
    echo "ERROR: do_pmtud <version> <target_addr> <min_mtu> <max_mtu>." 1>&2
    return 1
  fi
  local command=""
  local dfopt=""
  case $1 in
    "4" ) command=ping; dfopt="-M do" ;;
    "6" ) command=ping6 ;;
    * ) echo "ERROR: <version> must be 4 or 6." 1>&2; return 9 ;;
  esac
  ${command} -c 1 $2 > /dev/null
  if [ $? -ne 0 ]; then
    echo 0
    return 1
  fi

  local version=$1
  local target=$2
  local min=$3
  local max=$4
  local mid=`expr \( ${min} + ${max} \) / 2`
  local result=0
  if [ ${min} -eq ${mid} ] || [ ${max} -eq ${mid} ]; then
    echo ${min}
    return
  fi
  ${command} -c 3 -s ${mid} ${dfopt} ${target} >/dev/null 2>/dev/null
  if [ $? -eq 0 ]; then
    result=$(do_pmtud ${version} ${target} ${mid} ${max})
  else
    result=$(do_pmtud ${version} ${target} ${min} ${mid})
  fi
  echo ${result}
}

## for dns layer
#
do_dnslookup() {
  if [ $# -lt 3 ]; then
    echo "ERROR: do_dnslookup <nameserver> <query_type> <target_fqdn>." 1>&2
    return 1
  fi
  dig @$1 $3 $2 +short +time=1
  return $?
}

## for web layer
#
do_curl() {
  if [ $# -lt 2 ]; then
    echo "ERROR: do_curl <version> <target_url>." 1>&2
    return 1
  fi
  if [ $1 != 4 -a $1 != 6 ]; then
    echo "ERROR: <version> must be 4 or 6." 1>&2
    return 9
  fi
  curl -$1 --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null $2
}

#
# main
#

####################
## Preparation

# Check parameters
if [ "X${LOCKFILE}" = "X" ]; then
  echo "ERROR: LOCKFILE is null at configration file." 1>&2
  return 1
fi
if [ "X${IFTYPE}" = "X" ]; then
  echo "ERROR: IFTYPE is null at configration file." 1>&2
  return 1
fi
if [ "X${DEVNAME}" = "X" ]; then
  echo "ERROR: DEVNAME is null at configration file." 1>&2
  return 1
fi

####################
## Phase 0

# Set lock file
trap 'rm -f ${LOCKFILE}; exit 0' INT

if [ ! -e ${LOCKFILE} ]; then
  echo $$ >"${LOCKFILE}"
else
  pid=`cat "${LOCKFILE}"`
  kill -0 "${pid}" > /dev/null 2>&1
  if [ $? = 0 ]; then
    exit 0
  else
    echo $$ >"${LOCKFILE}"
    echo "Warning: previous check appears to have not finished correctly"
  fi
fi

# Make log directory
mkdir -p log

# Cleate UUID
uuid=$(cleate_uuid)

# Get devicename
# Check {IFTYPE} parameter
if [ "X${IFTYPE}" = "X" ]; then
  echo "ERROR: IFTYPE is null at configration file." 1>&2
  return 1
fi
devicename=$(get_devicename "${IFTYPE}")

# Get MAC address
mac_addr=$(get_macaddr ${devicename})

# Get OS version
os=$(get_os)

# Write campaign log file
#write_json_campaign ${uuid} ${mac_addr} "${os}" ${ssid}

####################
## Phase 1
echo "Phase 1: Datalink Layer checking..."
layer="datalink"

# Get current SSID
pre_ssid=$(get_wifi_ssid ${devicename})

# XXXX
# set specific ssid
#if [ "X${SSID}" != "X" -a "X${SSID_KEY}" != "X" ]; then
#  echo " set SSID:${SSID}"
#  networksetup -setairportnetwork ${devicename} ${SSID} ${SSID_KEY}
#  sleep 5
##elif [ "X${pre_ssid}" != "X" ]; then
##  networksetup -setairportnetwork ${devicename} ${pre_ssid}
##  sleep 5
#fi

# Select band
if [ "X${BAND}" != "X" ]; then
  set_band ${devicename}
fi

# Down, Up interface
if [ ${RECONNECT} = "yes" ]; then
  # Down target interface
  if [ "${VERBOSE}" = "yes" ]; then
    echo " interface:${devicename} down"
  fi
  do_ifdown ${devicename}
  sleep 2

  # Start target interface
  if [ "${VERBOSE}" = "yes" ]; then
    echo " interface:${devicename} up"
  fi
  do_ifup ${devicename}
  sleep 20 
fi

# Check I/F status
ifstatus=$(get_ifstatus ${devicename})
result=${FAIL}
if [ $? = 0 ]; then
  result=${SUCCESS}
fi
if [ "X${ifstatus}" != "X" ]; then
  write_json ${layer} "common" ifstatus ${result} ${ifstatus}
fi

# Get iftype
write_json ${layer} "common" iftype ${INFO} ${IFTYPE}

# Get ifmtu
ifmtu=$(get_ifmtu ${devicename})
if [ "X${ifmtu}" != "X" ]; then
  write_json ${layer} "common" ifmtu ${INFO} ${ifmtu}
fi

#
if [ ${IFTYPE} != "Wi-Fi" ]; then
  # Get media type
  media=$(get_mediatype ${devicename})
  if [ "X${media}" != "X" ]; then
    write_json ${layer} "${IFTYPE}" media ${INFO} ${media}
  fi
else
  # Get Wi-Fi SSID
  ssid=$(get_wifi_ssid ${devicename})
  if [ "X${ssid}" != "X" ]; then
    write_json ${layer} "${IFTYPE}" ssid ${INFO} ${ssid}
  fi
  # Get Wi-Fi BSSID
  bssid=$(get_wifi_bssid ${devicename})
  if [ "X${bssid}" != "X" ]; then
    write_json ${layer} "${IFTYPE}" bssid ${INFO} ${bssid}
  fi
  # Get Wi-Fi channel
  channel=$(get_wifi_channel ${devicename})
  if [ "X${channel}" != "X" ]; then
    write_json ${layer} "${IFTYPE}" channel ${INFO} ${channel}
  fi
  # Get Wi-Fi RSSI
  rssi=$(get_wifi_rssi ${devicename})
  if [ "X${rssi}" != "X" ]; then
    write_json ${layer} "${IFTYPE}" rssi ${INFO} ${rssi}
  fi
  # Get Wi-Fi noise
  noise=$(get_wifi_noise ${devicename})
  if [ "X${noise}" != "X" ]; then
    write_json ${layer} "${IFTYPE}" noise ${INFO} ${noise}
  fi
  # Get Wi-Fi rate
  rate=$(get_wifi_rate ${devicename})
  if [ "X${rate}" != "X" ]; then
    write_json ${layer} "${IFTYPE}" rate ${INFO} ${rate}
  fi
fi

# Report phase 1 results
if [ "${VERBOSE}" = "yes" ]; then
  echo " datalink information:"
  echo "  type: ${IFTYPE}, dev: ${devicename}"
  echo "  status: ${ifstatus}, mtu: ${ifmtu} MB"
  if [ "${IFTYPE}" != "Wi-Fi" ]; then
    echo "  media: ${media}"
  else
    echo "  ssid: ${ssid}, ch: ${channel}, rate: ${rate} Mbps"
    echo "  bssid: ${bssid}"
    echo "  rssi: ${rssi} dB, noise: ${noise} dB"
  fi
fi

echo " done."
sleep 5

####################
## Phase 2
echo "Phase 2: Interface Layer checking..."
layer="interface"

## IPv4
# Get IPv4 I/F configurations
v4ifconf=$(get_v4ifconf "${devicename}")
if [ "X${v4ifconf}" != "X" ]; then
  write_json ${layer} IPv4 v4ifconf ${INFO} ${v4ifconf}
fi

# Check IPv4 autoconf
v4autoconf=$(check_v4autoconf ${devicename} ${v4ifconf})
result=${FAIL}
if [ $? = 0 -a "X${v4autoconf}" != "X" ]; then
  result=${SUCCESS}
fi
write_json ${layer} IPv4 v4autoconf ${result} "${v4autoconf}"

# Get IPv4 address
v4addr=$(get_v4addr ${devicename} ${v4ifconf})
if [ "X${v4addr}" != "X" ]; then
  write_json ${layer} IPv4 v4addr ${INFO} ${v4addr}
fi

# Get IPv4 netmask
netmask=$(get_netmask ${devicename} ${v4ifconf})
if [ "X${netmask}" != "X" ]; then
  write_json ${layer} IPv4 netmask ${INFO} ${netmask}
fi

# Get IPv4 routers
v4routers=$(get_v4routers ${devicename} ${v4ifconf})
if [ "X${v4routers}" != "X" ]; then
  write_json ${layer} IPv4 v4routers ${INFO} ${v4routers}
fi

# Get IPv4 name servers
v4nameservers=$(get_v4nameservers ${devicename} ${v4ifconf})
if [ "X${v4nameservers}" != "X" ]; then
  write_json ${layer} IPv4 v4nameservers ${INFO} ${v4nameservers}
fi

# Get IPv4 NTP servers
#TBD

# Report phase 2 results (IPv4)
if [ "${VERBOSE}" = "yes" ]; then
  echo " interface information:"
  echo "  IPv4 conf: ${v4ifconf}"
  echo "  IPv4 addr: ${v4addr}/${netmask}"
  echo "  IPv4 router: ${v4routers}"
  echo "  IPv4 namesrv: ${v4nameservers}"
fi

## IPv6
# Get IPv6 I/F configurations
v6ifconf=$(get_v6ifconf "${devicename}")
if [ "X${v6ifconf}" != "X" ]; then
  write_json ${layer} IPv6 v6ifconf ${INFO} ${v6ifconf}
fi

# Get IPv6 linklocal address
v6lladdr=$(get_v6lladdr ${devicename})
if [ "X${v6lladdr}" != "X" ]; then
  write_json ${layer} IPv6 v6lladdr ${INFO} ${v6lladdr}
fi

# Get IPv6 RA flags
ra_flags=$(get_ra_flags ${devicename})
if [ "X${ra_flags}" != "X" ]; then
  write_json ${layer} RA ra_flags ${INFO} ${ra_flags}
fi

# Get IPv6 RA prefix
ra_prefixes=$(get_ra_prefixes ${devicename})
if [ "X${ra_prefixes}" != "X" ]; then
  write_json ${layer} RA ra_prefixes ${INFO} ${ra_prefixes}
fi

# Report phase 2 results (IPv6)
if [ "${VERBOSE}" = "yes" ]; then
  echo "  IPv6 conf: ${v6ifconf}"
  echo "  IPv6 lladdr: ${v6lladdr}"
fi

if [ "X${ra_flags}" != "X" ]; then
  if [ "${VERBOSE}" = "yes" ]; then
    echo "  IPv6 RA flags: ${ra_flags}"
  fi
  for pref in `echo ${ra_prefixes} | sed 's/,/ /g'`; do
    # Get IPv6 RA prefix flags
    ra_prefix_flags=$(get_ra_prefix_flags ${devicename} ${pref})
    write_json ${layer} RA ra_prefix_flags ${INFO} "(${pref}) ${ra_prefix_flags}"
    if [ "${VERBOSE}" = "yes" ]; then
      echo "  IPv6 RA prefix(flags): ${pref}(${ra_prefix_flags})"
    fi

    # Get IPv6 prefix length
    prefixlen=$(get_prefixlen ${pref})
    write_json ${layer} RA prefixlen ${INFO} "(${pref}) ${prefixlen}"

    # Get IPv6 address
    v6addrs=$(get_v6addrs ${devicename} ${v6ifconf} ${pref} ${ra_prefix_flags})
    write_json ${layer} IPv6 v6addrs ${INFO} "(${pref}) ${v6addrs}"
    if [ "${VERBOSE}" = "yes" ]; then
      for addr in `echo ${v6addrs} | sed 's/,/ /g'`; do
#        echo "   IPv6 addr: ${addr}/${prefixlen}"
        echo "   IPv6 addr: ${addr}"
      done
    fi
  done

  # Check IPv6 autoconf #TBD
  result=${FAIL}
  if [ ${v6ifconf} = "automatic" -a "X${v6addrs}" != "X" ]; then
    result=${SUCCESS}
  fi
  write_json ${layer} IPv6 v6autoconf ${result} ${v6addrs}

  # Get IPv6 routers
  v6routers=$(get_v6routers ${devicename})
  if [ "X${v6routers}" != "X" ]; then
    write_json ${layer} IPv6 v6routers ${INFO} "${v6routers}"
  fi
  if [ "${VERBOSE}" = "yes" ]; then
    echo "  IPv6 routers: ${v6routers}"
  fi

  # Get IPv6 name servers
  v6nameservers=$(get_v6nameservers ${devicename} ${v6ifconf} ${ra_flags})
  if [ "X${v6nameservers}" != "X" ]; then
    write_json ${layer} IPv6 v6nameservers ${INFO} "${v6nameservers}"
  fi
  if [ "${VERBOSE}" = "yes" ]; then
    echo "  IPv6 nameservers: ${v6nameservers}"
  fi

  # Get IPv6 NTP servers
  #TBD
else
  if [ "${VERBOSE}" = "yes" ]; then
    echo "   RA does not exist."
  fi
fi

echo " done."
sleep 2

####################
## Phase 3
echo "Phase 3: Localnet Layer checking..."
layer="localnet"

# Do ping to IPv4 routers
for var in `echo ${v4routers} | sed 's/,/ /g'`; do
  result=${FAIL}
  if [ "${VERBOSE}" = "yes" ]; then
    echo " ping to IPv4 router: ${var}"
  fi
  v4alive_router=$(do_ping 4 ${var})
  if [ $? -eq 0 ]; then
    result=${SUCCESS}
  fi
  write_json ${layer} IPv4 v4alive_router ${result} "(${var}) ${v4alive_router}"
  v4rtt_router=$(get_rtt "${v4alive_router}")
  write_json ${layer} IPv4 v4rtt_router ${INFO} "(${var}) ${v4rtt_router}"
  if [ "${VERBOSE}" = "yes" ]; then
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status: ok, rtt: ${v4rtt_router} msec"
    else
      echo "  status: ng"
    fi
  fi
done

# Do ping to IPv4 nameservers
for var in `echo ${v4nameservers} | sed 's/,/ /g'`; do
  result=${FAIL}
  if [ "${VERBOSE}" = "yes" ]; then
    echo " ping to IPv4 nameserver: ${var}"
  fi
  v4alive_namesrv=$(do_ping 4 ${var})
  if [ $? -eq 0 ]; then
    result=${SUCCESS}
  fi
  write_json ${layer} IPv4 v4alive_namesrv ${result} "(${var}) ${v4alive_namesrv}"
  v4rtt_namesrv=$(get_rtt "${v4alive_namesrv}")
  write_json ${layer} IPv4 v4rtt_namesrv ${INFO} "(${var}) ${v4rtt_namesrv}"
  if [ "${VERBOSE}" = "yes" ]; then
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status: ok, rtt: ${v4rtt_namesrv} msec"
    else
      echo "  status: ng"
    fi
  fi
done

# Do ping to IPv6 routers
for var in `echo ${v6routers} | sed 's/,/ /g'`; do
  result=${FAIL}
  if [ "${VERBOSE}" = "yes" ]; then
    echo " ping to IPv6 router: ${var}"
  fi
  v6alive_router=$(do_ping 6 ${var})
  if [ $? -eq 0 ]; then
    result=${SUCCESS}
  fi
  write_json ${layer} IPv6 v6alive_router ${result} "(${var}) ${v6alive_router}"
  v6rtt_router=$(get_rtt "${v6alive_router}")
  write_json ${layer} IPv6 v6rtt_router ${INFO} "(${var}) ${v6rtt_router}"
  if [ "${VERBOSE}" = "yes" ]; then
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status: ok, rtt: ${v6rtt_router} msec"
    else
      echo "  status: ng"
    fi
  fi
done

# Do ping to IPv6 nameservers
for var in `echo ${v6nameservers} | sed 's/,/ /g'`; do
  result=${FAIL}
  if [ "${VERBOSE}" = "yes" ]; then
    echo " ping to IPv6 nameserver: ${var}"
  fi
  v6alive_namesrv=$(do_ping 6 ${var})
  if [ $? -eq 0 ]; then
    result=${SUCCESS}
  fi
  write_json ${layer} IPv6 v6alive_namesrv ${result} "(${var}) ${v6alive_namesrv}"
  v6rtt_namesrv=$(get_rtt "${v6alive_namesrv}")
  write_json ${layer} IPv6 v6rtt_namesrv ${INFO} "(${var}) ${v6rtt_namesrv}"
  if [ "${VERBOSE}" = "yes" ]; then
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status: ok, rtt: ${v6rtt_namesrv} msec"
    else
      echo "  status: ng"
    fi
  fi
done

echo " done."
sleep 2

####################
## Phase 4
echo "Phase 4: Globalnet Layer checking..."
layer="globalnet"

# Check PING_SRVS parameter
if [ "X${PING_SRVS}" = "X" ]; then
  echo "ERROR: PING_SRVS is null at configration file." 1>&2
  return 1
fi

if [ "X${v4addr}" != "X" ]; then
  # Do ping to extarnal IPv4 servers
  for var in `echo ${PING_SRVS} | sed 's/,/ /g'`; do
    result=${FAIL}
    if [ "${VERBOSE}" = "yes" ]; then
      echo " ping to extarnal IPv4 server: ${var}"
    fi
    v4alive_srv=$(do_ping 4 ${var})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    fi
    write_json ${layer} IPv4 v4alive_srv ${result} "(${var}) ${v4alive_srv}"
    v4rtt_srv=$(get_rtt "${v4alive_srv}")
    write_json ${layer} IPv4 v4rtt_srv ${INFO} "(${var}) ${v4rtt_srv}"
    if [ "${VERBOSE}" = "yes" ]; then
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status: ok, rtt: ${v4rtt_srv} msec"
      else
        echo "  status: ng"
      fi
    fi
  done
  
  # Do traceroute to extarnal IPv4 servers
  for var in `echo ${PING_SRVS} | sed 's/,/ /g'`; do
    if [ "${VERBOSE}" = "yes" ]; then
      echo " traceroute to extarnal IPv4 server: ${var}"
    fi
    v4path_srv=$(do_traceroute 4 ${var})
    write_json ${layer} IPv4 v4path_srv ${INFO} "(${var}) ${v4path_srv}"
    if [ "${VERBOSE}" = "yes" ]; then
      echo "  path: ${v4path_srv}"
    fi
  done
  
  # Check path MTU to extarnal IPv4 servers
  for var in `echo ${PING_SRVS} | sed 's/,/ /g'`; do
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do pmtud to extarnal IPv4 server: ${var}"
    fi
    data=$(do_pmtud 4 ${var} 1470 1500)
    if [ ${data} -eq 0 ]; then
      write_json ${layer} IPv4 v4pmtu_srv ${INFO} "(${var}) unmeasurable"
      if [ "${VERBOSE}" = "yes" ]; then
        echo "  pmtud: unmeasurable"
      fi
    else
      v4pmtu_srv=`expr ${data} + 28`
      write_json ${layer} IPv4 v4pmtu_srv ${INFO} "(${var}) ${v4pmtu_srv}"
      if [ "${VERBOSE}" = "yes" ]; then
        echo "  pmtu: ${v4pmtu_srv} MB"
      fi
    fi
  done
fi

# Check PING6_SRVS parameter
if [ "X${PING6_SRVS}" = "X" ]; then
  echo "ERROR: PING6_SRVS is null at configration file." 1>&2
  return 1
fi

if [ "X${v6addrs}" != "X" ]; then
  # Do ping to extarnal IPv6 servers
  for var in `echo ${PING6_SRVS} | sed 's/,/ /g'`; do
    result=${FAIL}
    if [ "${VERBOSE}" = "yes" ]; then
      echo " ping to extarnal IPv6 server: ${var}"
    fi
    v6alive_srv=$(do_ping 6 ${var})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    fi
    write_json ${layer} IPv6 v6alive_srv ${result} "(${var}) ${v6alive_srv}"
    v6rtt_srv=$(get_rtt "${v6alive_srv}")
    write_json ${layer} IPv6 v6rtt_srv ${INFO} "(${var}) ${v6rtt_srv}"
    if [ "${VERBOSE}" = "yes" ]; then
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status: ok, rtt: ${v6rtt_srv} msec"
      else
        echo "  status: ng"
      fi
    fi
  done
  
  # Do traceroute to extarnal IPv6 servers
  for var in `echo ${PING6_SRVS} | sed 's/,/ /g'`; do
    if [ "${VERBOSE}" = "yes" ]; then
      echo " traceroute to extarnal IPv6 server: ${var}"
    fi
    v6path_srv=$(do_traceroute 6 ${var})
    write_json ${layer} IPv6 v6path_srv ${INFO} "(${var}) ${v6path_srv}"
    if [ "${VERBOSE}" = "yes" ]; then
      echo "  path: ${v6path_srv}"
    fi
  done
  
  # Check path MTU to extarnal IPv6 servers
  for var in `echo ${PING6_SRVS} | sed 's/,/ /g'`; do
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do pmtud to extarnal IPv6 server: ${var}"
    fi
    data=$(do_pmtud 6 ${var} 1232 1453)
    if [ ${data} -eq 0 ]; then
      write_json ${layer} IPv6 v6pmtu_srv ${INFO} "(${var}) unmeasurable"
      if [ "${VERBOSE}" = "yes" ]; then
        echo "  pmtud: unmeasurable"
      fi
    else
      v6pmtu_srv=`expr ${data} + 48`
      write_json ${layer} IPv6 v6pmtu_srv ${INFO} "(${var}) ${v6pmtu_srv}"
      if [ "${VERBOSE}" = "yes" ]; then
        echo "  pmtu: ${v6pmtu_srv} MB"
      fi
    fi
  done
fi

echo " done."
sleep 2

####################
## Phase 5
echo "Phase 5: DNS Layer checking..."
layer="dns"

# Clear dns local cache
#TBD

# Check FQDNS parameter
if [ "X${FQDNS}" = "X" ]; then
  echo "ERROR: FQDNS is null at configration file." 1>&2
  return 1
fi

if [ "X${v4addr}" != "X" ]; then
  # Do dns lookup for A record by IPv4
  for var in `echo ${v4nameservers} | sed 's/,/ /g'`; do
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do dns lookup for A record by IPv4 nameserver: ${var}"
    fi
    for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
      result=${FAIL}
      if [ "${VERBOSE}" = "yes" ]; then
        echo " do resolve server: ${fqdn}"
      fi
      v4trans_a_namesrv=$(do_dnslookup ${var} a ${fqdn})
      if [ $? -eq 0 ]; then
        result=${SUCCESS}
      else
        stat=$?
      fi
      write_json ${layer} IPv4 v4trans_a_namesrv ${result} "(@${var}, resolv ${fqdn}) ${v4trans_a_namesrv}"
      if [ "${VERBOSE}" = "yes" ]; then
        if [ ${result} = ${SUCCESS} ]; then
          echo "  status: ok, result: ${v4trans_a_namesrv}"
        else
          echo "  status: ng ($stat)"
        fi
      fi
    done
  done

  # Do dns lookup for AAAA record by IPv4
  for var in `echo ${v4nameservers} | sed 's/,/ /g'`; do
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do dns lookup for AAAA record by IPv4 nameserver: ${var}"
    fi
    for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
      result=${FAIL}
      if [ "${VERBOSE}" = "yes" ]; then
        echo " do resolve server: ${fqdn}"
      fi
      v4trans_aaaa_namesrv=$(do_dnslookup ${var} aaaa ${fqdn})
      if [ $? -eq 0 ]; then
        result=${SUCCESS}
      else
        stat=$?
      fi
      write_json ${layer} IPv4 v4trans_aaaa_namesrv ${result} "(@${var}, resolv ${fqdn}) ${v4trans_aaaa_namesrv}"
      if [ "${VERBOSE}" = "yes" ]; then
        if [ ${result} = ${SUCCESS} ]; then
          echo "  status: ok, result: ${v4trans_aaaa_namesrv}"
        else
          echo "  status: ng ($stat)"
        fi
      fi
    done
  done
fi

if [ "X${v6addrs}" != "X" ]; then
  # Do dns lookup for A record by IPv6
  for var in `echo ${v6nameservers} | sed 's/,/ /g'`; do
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do dns lookup for A record by IPv6 nameserver: ${var}"
    fi
    for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
      result=${FAIL}
      if [ "${VERBOSE}" = "yes" ]; then
        echo " do resolve server: ${fqdn}"
      fi
      v6trans_a_namesrv=$(do_dnslookup ${var} a ${fqdn})
      if [ $? -eq 0 ]; then
        result=${SUCCESS}
      else
        stat=$?
      fi
      write_json ${layer} IPv6 v6trans_a_namesrv ${result} "(@${var}, resolv ${fqdn}) ${v6trans_a_namesrv}"
      if [ "${VERBOSE}" = "yes" ]; then
        if [ ${result} = ${SUCCESS} ]; then
          echo "  status: ok, result: ${v6trans_a_namesrv}"
        else
          echo "  status: ng ($stat)"
        fi
      fi
    done
  done

  # Do dns lookup for AAAA record by IPv6
  for var in `echo ${v6nameservers} | sed 's/,/ /g'`; do
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do dns lookup for AAAA record by IPv6 nameserver: ${var}"
    fi
    for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
      result=${FAIL}
      if [ "${VERBOSE}" = "yes" ]; then
        echo " do resolve server: ${fqdn}"
      fi
      v6trans_aaaa_namesrv=$(do_dnslookup ${var} aaaa ${fqdn})
      if [ $? -eq 0 ]; then
        result=${SUCCESS}
      else
        stat=$?
      fi
      write_json ${layer} IPv6 v6trans_aaaa_namesrv ${result} "(@${var}, resolv ${fqdn}) ${v6trans_aaaa_namesrv}"
      if [ "${VERBOSE}" = "yes" ]; then
        if [ ${result} = ${SUCCESS} ]; then
          echo "  status: ok, result: ${v6trans_aaaa_namesrv}"
        else
          echo "  status: ng ($stat)"
        fi
      fi
    done
  done
fi

# Check GPDNS[4|6] parameter
if [ "X${GPDNS4}" = "X" ]; then
  echo "ERROR: GPDNS4 is null at configration file." 1>&2
  return 1
fi
if [ "X${GPDNS6}" = "X" ]; then
  echo "ERROR: GPDNS6 is null at configration file." 1>&2
  return 1
fi

if [ "X${v4addr}" != "X" ]; then
  # Do dns lookup for A record by GPDNS4
  if [ "${VERBOSE}" = "yes" ]; then
    echo " do dns lookup for A record by IPv4 nameserver: ${GPDNS4}"
  fi
  for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
    result=${FAIL}
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do resolve server: ${fqdn}"
    fi
    v4trans_a_namesrv=$(do_dnslookup ${GPDNS4} a ${fqdn})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv4 v4trans_a_namesrv ${result} "(@${GPDNS4}, resolv ${fqdn}) ${v4trans_a_namesrv}"
    if [ "${VERBOSE}" = "yes" ]; then
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status: ok, result: ${v4trans_a_namesrv}"
      else
        echo "  status: ng ($stat)"
      fi
    fi
  done

  # Do dns lookup for AAAA record by GPDNS4
  if [ "${VERBOSE}" = "yes" ]; then
    echo " do dns lookup for AAAA record by IPv4 nameserver: ${GPDNS4}"
  fi
  for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
    result=${FAIL}
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do resolve server: ${fqdn}"
    fi
    v4trans_aaaa_namesrv=$(do_dnslookup ${GPDNS4} aaaa ${fqdn})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv4 v4trans_aaaa_namesrv ${result} "(@${GPDNS4}, resolv ${fqdn}) ${v4trans_aaaa_namesrv}"
    if [ "${VERBOSE}" = "yes" ]; then
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status: ok, result: ${v4trans_aaaa_namesrv}"
      else
        echo "  status: ng ($stat)"
      fi
    fi
  done
fi

if [ "X${v6addrs}" != "X" ]; then
  # Do dns lookup for A record by GPDNS6
  if [ "${VERBOSE}" = "yes" ]; then
    echo " do dns lookup for A record by IPv6 nameserver: ${GPDNS6}"
  fi
  for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
    result=${FAIL}
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do resolve server: ${fqdn}"
    fi
    v6trans_a_namesrv=$(do_dnslookup ${GPDNS6} a ${fqdn})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv6 v6trans_a_namesrv ${result} "(@${GPDNS6}, resolv ${fqdn}) ${v6trans_a_namesrv}"
    if [ "${VERBOSE}" = "yes" ]; then
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status: ok, result: ${v6trans_a_namesrv}"
      else
        echo "  status: ng ($stat)"
      fi
    fi
  done

  # Do dns lookup for AAAA record by GPDNS6
  if [ "${VERBOSE}" = "yes" ]; then
    echo " do dns lookup for AAAA record by IPv6 nameserver: ${GPDNS6}"
  fi
  for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
    result=${FAIL}
    if [ "${VERBOSE}" = "yes" ]; then
      echo " do resolve server: ${fqdn}"
    fi
    v6trans_aaaa_namesrv=$(do_dnslookup ${GPDNS6} aaaa ${fqdn})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv6 v6trans_aaaa_namesrv ${result} "(@${GPDNS6}, resolv ${fqdn}) ${v6trans_aaaa_namesrv}"
    if [ "${VERBOSE}" = "yes" ]; then
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status: ok, result: ${v6trans_aaaa_namesrv}"
      else
        echo "  status: ng ($stat)"
      fi
    fi
  done
fi

echo " done."
sleep 2

####################
## Phase 6
echo "Phase 6: Web Layer checking..."
layer="web"

# Check V4WEB_SRVS parameter
if [ "X${V4WEB_SRVS}" = "X" ]; then
  echo "ERROR: V4WEB_SRVS is null at configration file." 1>&2
  return 1
fi

if [ "X${v4addr}" != "X" ]; then
  # Do curl to extarnal web servers by IPv4
  for var in `echo ${V4WEB_SRVS} | sed 's/,/ /g'`; do
    result=${FAIL}
    if [ "${VERBOSE}" = "yes" ]; then
      echo " curl to extarnal server: ${var} by IPv4"
    fi
    v4http_srv=$(do_curl 4 ${var})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv4 v4http_srv ${result} "(${var}) ${v4http_srv}"
    if [ "${VERBOSE}" = "yes" ]; then
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status: ok, http status code: ${v4http_srv}"
      else
        echo "  status: ng ($stat)"
      fi
    fi
  done

  # Do measure http throuput by IPv4
  #TBD
  # v4http_throughput_srv
fi

# Check V6WEB_SRVS parameter
if [ "X${V6WEB_SRVS}" = "X" ]; then
  echo "ERROR: V6WEB_SRVS is null at configration file." 1>&2
  return 1
fi

if [ "X${v6addrs}" != "X" ]; then
  # Do curl to extarnal web servers by IPv6
  for var in `echo ${V6WEB_SRVS} | sed 's/,/ /g'`; do
    result=${FAIL}
    if [ "${VERBOSE}" = "yes" ]; then
      echo " curl to extarnal server: ${var} by IPv6"
    fi
    v6http_srv=$(do_curl 6 ${var})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv6 v6http_srv ${result} "(${var}) ${v6http_srv}"
    if [ "${VERBOSE}" = "yes" ]; then
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status: ok, http status code: ${v6http_srv}"
      else
        echo "  status: ng ($stat)"
      fi
    fi
  done

  # Do measure http throuput by IPv6
  #TBD
  # v6http_throughput_srv
fi

echo " done."
sleep 2

####################
## Phase 7
echo "Phase 7: Create campaign log..."

# Write campaign log file
ssid=$(get_wifi_ssid ${devicename})
write_json_campaign ${uuid} ${mac_addr} "${os}" ${ssid}

# remove lock file
rm -f ${LOCKFILE}

echo " done."

exit 0
