#!/bin/sh
# sindan.sh
# version 0.13

# read configurationfile
source sindan.conf

#
# functions
#

#
write_json() {
  if [ $# -lt 5 ]; then
    echo "ERROR: write_json <layer> <group> <type> <result> <detail>. ($2)" 1>&2
    return 1
  fi

  local json="{ \"layer\" : \"$1\",
                \"log_group\" : \"$2\",
                \"log_type\" : \"$3\",
                \"log_campaign_uuid\" : \"${uuid}\",
                \"result\" : \"$4\",
                \"detail\" : \"$5\",
                \"occurred_at\" : \"`date '+%Y-%m-%d %T'`\" }"
  echo ${json} > log/sindan_$1_$3_`date '+%s'`.json
}

## for datalink layer
#
get_os() {
  sw_vers | awk -F: '{sub(/\t/,""); print $2}' | 
   awk -v ORS=' ' '1; END{printf "\n"}'
}

get_devicename() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_devicename <iftype>." 1>&2
    return 1
  fi
  networksetup -listnetworkserviceorder | grep Hardware | grep $1 |
   sed 's/^.*Device: \(.*\))$/\1/'
}

#
get_ifstatus() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ifstatus <devicename>." 1>&2
    return 1
  fi
  ifconfig $1 | grep status | awk '{print $2}'
}

#
get_ifmtu() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ifmtu <devicename>." 1>&2
    return 1
  fi
  ifconfig $1 | grep mtu | awk '{print $4}'
}

#
get_macaddr() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_macaddr <devicename>." 1>&2
    return 1
  fi
  ifconfig $1 | grep ether | awk '{print $2}'
}

#
get_mediatype() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_mediatype <devicename>." 1>&2
    return 1
  fi
  ifconfig $1 | grep media | awk '{print $2}'
}

#
get_wifi_ssid() {
  $AIRPORT -I | grep [^B]SSID | awk '{print $2}'
}

#
get_wifi_channel() {
  $AIRPORT -I | grep channel | awk '{print $2}'
}

#
get_wifi_rssi() {
  $AIRPORT -I | grep agrCtlRSSI | awk '{print $2}'
}

#
get_wifi_noise() {
  $AIRPORT -I | grep agrCtlNoise | awk '{print $2}'
}

#
get_wifi_rate() {
  $AIRPORT -I | grep lastTxRate | awk '{print $2}'
}

## for interface layer
#
get_v4ifconf() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_v4ifconf <iftype>." 1>&2
    return 1
  fi

  if networksetup -getinfo $1 | grep 'DHCP Configuration' > /dev/null
  then
    echo 'dhcp'
  elif networksetup -getinfo $1 | grep 'Manually Using DHCP' > /dev/null
  then
    echo 'manual and dhcp'
  elif networksetup -getinfo $1 | grep 'BOOTP Configuration' > /dev/null
  then
    echo 'bootp'
  elif networksetup -getinfo $1 | grep 'Manual Configuration' > /dev/null
  then
    echo 'manual'
  else
    echo 'unknown'
  fi
}

#
get_v6ifconf() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_v6ifconf <iftype>." 1>&2
    return 1
  fi

  if networksetup -getinfo $1 | grep 'IPv6: Automatic' > /dev/null
  then
    echo 'automatic'
  elif networksetup -getinfo $1 | grep 'IPv6: Manual' > /dev/null
  then
    echo 'manual'
  elif networksetup -getinfo $1 | grep 'IPv6 IP address: none' > /dev/null
  then
    echo 'linklocal'
  else
    echo 'unknown'
  fi
}

#
get_v4addr() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_v4addr <devicename> <v4ifconf>." 1>&2
    return 1
  fi

  if [ $2 = "dhcp" ]; then
    ipconfig getpacket $1 | grep yiaddr | awk '{print $3}'
  else
    ifconfig $1 | grep inet[^6] | awk '{print $2}'
  fi
}

#
get_netmask() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_netmask <devicename> <v4ifconf>." 1>&2
    return 1
  fi

  if [ $2 = "dhcp" ]; then
    ipconfig getpacket $1 | grep subnet_mask | awk '{print $3}'
  else
    var=`ifconfig $1 | grep inet[^6] | awk '{print $4}'`
    oct1=0x`echo ${var} | cut -c 3-4`
    oct2=0x`echo ${var} | cut -c 5-6`
    oct3=0x`echo ${var} | cut -c 7-8`
    oct4=0x`echo ${var} | cut -c 9-10`
    printf "%d.%d.%d.%d" ${oct1} ${oct2} ${oct3} ${oct4}
  fi
}

#
get_v4routers() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_v4routers <devicename> <v4ifconf>." 1>&2
    return 1
  fi

  if [ $2 = "dhcp" ]; then
    ipconfig getpacket $1 | grep router | sed 's/.*{\([0-9.,]*\)}$/\1/'
  else
    netstat -rn | grep default | grep $1 | grep -v % | awk '{print $2}'
  fi
}

#
get_v4nameservers() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_v4nameservers <devicename> <v4ifconf>." 1>&2
    return 1
  fi

  if [ $2 = "dhcp" ]; then
    ipconfig getpacket $1 | grep domain_name_server |
     sed 's/.*{\([0-9., ]*\)}$/\1/'
  else
    echo 'TBD'
  fi
}

#
get_v6lladdr() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_v6lladdr <devicename>." 1>&2
    return 1
  fi

#  ifconfig $1 | grep inet6 | grep fe80 | awk '{print$2}' |
#   awk -F% '{print $1}'
  ifconfig $1 | grep inet6 | grep fe80 | awk '{print$2}'
}

#
get_ra_prefix() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ra_prefix <devicename>." 1>&2
    return 1
  fi

  ndp -pn | grep $1 | grep -v 'fe80:' | awk '{print $1}'
}

#
get_ra_prefixes() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ra_prefixes <devicename>." 1>&2
    return 1
  fi

  ndp -pn | grep $1 | grep -v fe80 | awk '{print $1}' |
   awk -F\n -v ORS=',' '{print}' | sed 's/,$//'
}

#
get_ra_prefix_flags() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ra_prefix_flags <ra_prefix>." 1>&2
    return 1
  fi

  prefix=`echo $1 | awk -F/ '{print $1}'`

  ndp -pn |
  awk 'BEGIN{
    find=0;
    while (getline line) {
      if (find==1) {
        print line;
        find=0;
      } else if (match(line,/'"$prefix"'.*/)) {
        find=1;
      }
    }
  }' |
  awk '{print $1}' |
  awk -F= '{print $2}'
}

#
get_ra_flags() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_ra_flags <devicename>." 1>&2
    return 1
  fi

  ndp -rn | grep $1 | sed 's/,//g' | awk '{print $3}' |
   awk -F= '{print $2}'
}

#
get_v6addrs() {
  if [ $# -lt 4 ]; then
    echo "ERROR: get_v6addrs <devicename> <v6ifconf> <ra_prefix> <ra_flags>." 1>&2
    echo "ERROR: $1,$2,$3,$4"
    return 1
  fi

  prefix=`echo $3 | awk -F':/' '{print $1}' | sed 's/:0:/::/g'`
  dhcpv6=`echo $4 | grep M`
  if [ $2 = "automatic" -a "${dhcpv6}" ]; then
    ipconfig getv6packet $1 | grep yiaddr | awk '{print $3}'
  else
    ifconfig $1 | grep inet6 | grep -v fe80 | grep ${prefix} | awk '{print $2}' |
     awk -F\n -v ORS=',' '{print}' | sed 's/,$//'
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
  if [ $# -lt 3 ]; then
    echo "ERROR: get_v6routers <devicename> <v6ifconf> <ra_flags>." 1>&2
    return 1
  fi

  dhcpv6=`echo $3 | grep M`
  if [ $2 = "automatic" -a "${dhcpv6}" ]; then
    ipconfig getv6packet $1 | grep router |
     sed 's/.*{\([0-9A-Fa-f:]*\)}$/\1/'
  else
#    netstat -rn | grep default | grep "%$1" | awk '{print $2}' |
#     awk -F% '{print $1}'
    netstat -rn | grep default | grep "%$1" | awk '{print $2}'
  fi
}

#
get_v6nameservers() {
  if [ $# -lt 2 ]; then
    echo "ERROR: get_v6nameservers <devicename> <v6ifconf> <ra_flags>." 1>&2
    return 1
  fi

  local dhcpv6=`echo $3 | grep M`
  if [ $2 = "automatic" -a "${dhcpv6}" ]; then
    ipconfig getv6packet $1 | grep domain_name_server |
     sed 's/.*{\([0-9A-Fa-f:, ]*\)}$/\1/'
  else
    :
#    echo 'TBD'
  fi
}

## for localnet layer
#
do_ping() {
  if [ $# -lt 2 ]; then
    echo "ERROR: do_ping <version> <target_addr>." 1>&2
    return 1
  fi
  if [ $1 = 4 ]; then
    command=ping
  elif [ $1 = 6 ]; then
    command=ping6
  else
    echo "ERROR: <version> must be 4 or 6." 1>&2
    return 9
  fi

  ${command} -c 5 $2
  return $?
}

get_rtt() {
  if [ $# -lt 1 ]; then
    echo "ERROR: get_rtt <ping_result>." 1>&2
    return 1
  fi

  echo "$1" | grep round-trip | awk '{print $4}' | awk -F"/" '{print $2}'
}

## for globalnet layer
#
do_traceroute() {
  if [ $# -lt 2 ]; then
    echo "ERROR: do_traceroute <version> <target_addr>." 1>&2
    return 1
  fi
  if [ $1 = 4 ]; then
    command=traceroute
  elif [ $1 = 6 ]; then
    command=traceroute6
  else
    echo "ERROR: <version> must be 4 or 6." 1>&2
    return 9
  fi

  ${command} -n -w 1 -q 1 -m 50 $2 2>/dev/null | awk '{print $2}' |
   awk -F\n -v ORS=',' '{print}' | sed 's/,$//'
}

#
do_pmtud() {
  if [ $# -lt 4 ]; then
    echo "ERROR: do_pmtud <version> <target_addr> <min_mtu> <max_mtu>." 1>&2
    return 1
  fi
  if [ $1 = 4 ]; then
    command=ping
  elif [ $1 = 6 ]; then
    command=ping6
  else
    echo "ERROR: <version> must be 4 or 6." 1>&2
    return 9
  fi

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

  ${command} -c 3 -s ${mid} -D ${target} >/dev/null 2>/dev/null
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
## Phase 0

# Set lock file
# Check LOCKFILE parameter
if [ "X${LOCKFILE}" = "X" ]; then
  echo "ERROR: LOCKFILE is null at configration file." 1>&2
  return 1
fi
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

# Cleate UUID
uuid=`uuidgen`

# Get devicename
# Check {IFTYPE} parameter
if [ "X${IFTYPE}" = "X" ]; then
  echo "ERROR: IFTYPE is null at configration file." 1>&2
  return 1
fi
devicename=$(get_devicename ${IFTYPE})

# Get MAC address
mac_addr=$(get_macaddr ${devicename})

# Get OS version
os=$(get_os)

# Make JSON
json0="{ \"log_campaign_uuid\" : \"${uuid}\",
        \"mac_addr\" : \"${mac_addr}\",
        \"os\" : \"${os}\",
        \"occurred_at\" : \"`date '+%Y-%m-%d %T'`\" }"

# write log file
echo ${json0} > log/campaign_`date '+%s'`.json

# remove lock file

####################
## Phase 1
echo "Phase 1: Datalink Layer checking..."
layer="datalink"

if [ ${RECONNECT} = "yes" ]; then
  # Down Wi-Fi interface
  echo " interface:${devicename} down"
  networksetup -setairportpower ${devicename} off
  sleep 2

  # Start Wi-Fi interface
  echo " interface:${devicename} up"
  networksetup -setairportpower ${devicename} on
  sleep 2
fi

if [ "X${SSID}" != "X" -a "X${SSID_KEY}" != "X" ]; then
  echo " set SSID:${SSID}"
  networksetup -setairportnetwork ${devicename} ${SSID} ${SSID_KEY}
  sleep 5
fi

# Check I/F status
ifup=0
ifstatus=$(get_ifstatus ${devicename})
result=${FAIL}
if [ ${ifstatus} = "active" ]; then
  result=${SUCCESS}
fi
write_json ${layer} "" ifstatus ${result} ${ifstatus}

# Get iftype
write_json ${layer} "" iftype ${INFO} ${IFTYPE}

# Get ifmtu
ifmtu=$(get_ifmtu ${devicename})
write_json ${layer} "" ifmtu ${INFO} ${ifmtu}

#
if [ ${IFTYPE} != "Wi-Fi" ]; then
  # Get media type
  media=$(get_mediatype ${devicename})
  write_json ${layer} ${IFTYPE} media ${INFO} ${media}
else
  # Get Wi-Fi SSID
  ssid=$(get_wifi_ssid)
  write_json ${layer} ${IFTYPE} ssid ${INFO} ${ssid}
  # Get Wi-Fi channel
  channel=$(get_wifi_channel)
  write_json ${layer} ${IFTYPE} channel ${INFO} ${channel}
  # Get Wi-Fi RSSI
  rssi=$(get_wifi_rssi)
  write_json ${layer} ${IFTYPE} rssi ${INFO} ${rssi}
  # Get Wi-Fi noise
  noise=$(get_wifi_noise)
  write_json ${layer} ${IFTYPE} noise ${INFO} ${noise}
  # Get Wi-Fi rate
  rate=$(get_wifi_rate)
  write_json ${layer} ${IFTYPE} rate ${INFO} ${rate}
fi

# Report phase 1 results
echo " datalink information:"
echo "  type:${IFTYPE}, dev:${devicename}"
echo "  status:${ifstatus}, mtu:${ifmtu} MB"
if [ ${IFTYPE} != "Wi-Fi" ]; then
  echo "  media:${media}"
else
  echo "  ssid:${ssid}, ch:${channel}, rate:${rate} Mbps"
  echo "  rssi:${rssi} dB, noise:${noise} dB"
fi

sleep 5

####################
## Phase 2
echo "Phase 2: Interface Layer checking..."
layer="interface"

# Get if configurations
v4ifconf=$(get_v4ifconf ${IFTYPE})
write_json ${layer} IPv4 v4ifconf ${INFO} ${v4ifconf}
v6ifconf=$(get_v6ifconf ${IFTYPE})
write_json ${layer} IPv6 v6ifconf ${INFO} ${v6ifconf}

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
echo " interface information:"
echo "  IPv4 conf:${v4ifconf}"
echo "  IPv4 addr:${v4addr}/${netmask}"
echo "  IPv4 router:${v4routers}"
echo "  IPv4 namesrv:${v4nameservers}"

# Get IPv6 linklocal address
v6lladdr=$(get_v6lladdr ${devicename})
write_json ${layer} IPv6 v6lladdr ${INFO} ${v6lladdr}

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
echo "  IPv6 conf:${v6ifconf}"
echo "  IPv6 lladdr:${v6lladdr}"

if [ "X${ra_flags}" != "X" ]; then
  echo "  IPv6 RA flags:${ra_flags}"
  for pref in `echo ${ra_prefixes} | sed 's/,/ /g'`; do
    # Get IPv6 RA prefix flags
    ra_prefix_flags=$(get_ra_prefix_flags ${pref})
    write_json ${layer} RA ra_prefix_flags ${INFO} "(${pref}) ${ra_prefix_flags}"
    echo "  IPv6 RA prefix(flags):${pref}(${ra_prefix_flags})"

    # Get IPv6 prefix length
    prefixlen=$(get_prefixlen ${pref})
    write_json ${layer} RA prefixlen ${INFO} "(${pref}) ${prefixlen}"

    # Get IPv6 address
    v6addrs=$(get_v6addrs ${devicename} ${v6ifconf} ${pref} ${ra_flags})
    write_json ${layer} IPv6 v6addrs ${INFO} "(${pref}) ${v6addrs}"
    for addr in `echo ${v6addrs} | sed 's/,/ /g'`; do
      echo "   IPv6 addr:${addr}/${prefixlen}"
    done
  done

  # Get IPv6 routers
  v6routers=$(get_v6routers ${devicename} ${v6ifconf} ${ra_flags})
  write_json ${layer} IPv6 v6routers ${INFO} "${v6routers}"
  echo "  IPv6 routers:${v6routers}"

  # Get IPv6 name servers
  v6nameservers=$(get_v6nameservers ${devicename} ${v6ifconf} ${ra_flags})
  write_json ${layer} IPv6 v6nameservers ${INFO} "${v6nameservers}"
  echo "  IPv6 nameservers:${v6nameservers}"

  # Get IPv6 NTP servers
  #TBD
else
  echo "   RA does not exist."
fi

sleep 2

####################
## Phase 3
echo "Phase 3: Localnet Layer checking..."
layer="localnet"

# Do ping to IPv4 routers
for var in `echo ${v4routers} | sed 's/,/ /g'`; do
  result=${FAIL}
  echo " ping to IPv4 router:${var}"
  v4alive_router=$(do_ping 4 ${var})
  if [ $? -eq 0 ]; then
    result=${SUCCESS}
  fi
  write_json ${layer} IPv4 v4alive_router ${result} "(${var}) ${v4alive_router}"
  v4rtt_router=$(get_rtt "${v4alive_router}")
  write_json ${layer} IPv4 v4rtt_router ${INFO} "(${var}) ${v4rtt_router}"
  if [ ${result} = ${SUCCESS} ]; then
    echo "  status:ok, rtt:${v4rtt_router} msec"
  else
    echo "  status:ng"
  fi
done

# Do ping to IPv4 nameservers
for var in `echo ${v4nameservers} | sed 's/,/ /g'`; do
  result=${FAIL}
  echo " ping to IPv4 nameserver:${var}"
  v4alive_namesrv=$(do_ping 4 ${var})
  if [ $? -eq 0 ]; then
    result=${SUCCESS}
  fi
  write_json ${layer} IPv4 v4alive_namesrv ${result} "(${var}) ${v4alive_namesrv}"
  v4rtt_namesrv=$(get_rtt "${v4alive_namesrv}")
  write_json ${layer} IPv4 v4rtt_namesrv ${INFO} "(${var}) ${v4rtt_namesrv}"
  if [ ${result} = ${SUCCESS} ]; then
    echo "  status:ok, rtt:${v4rtt_namesrv} msec"
  else
    echo "  status:ng"
  fi
done

# Do ping to IPv6 routers
for var in `echo ${v6routers} | sed 's/,/ /g'`; do
  result=${FAIL}
  echo " ping to IPv6 router:${var}"
  v6alive_router=$(do_ping 6 ${var})
  if [ $? -eq 0 ]; then
    result=${SUCCESS}
  fi
  write_json ${layer} IPv6 v6alive_router ${result} "(${var}) ${v6alive_router}"
  v6rtt_router=$(get_rtt "${v6alive_router}")
  write_json ${layer} IPv6 v6rtt_router ${INFO} "(${var}) ${v6rtt_router}"
  if [ ${result} = ${SUCCESS} ]; then
    echo "  status:ok, rtt:${v6rtt_router} msec"
  else
    echo "  status:ng"
  fi
done

# Do ping to IPv6 nameservers
for var in `echo ${v6nameservers} | sed 's/,/ /g'`; do
  result=${FAIL}
  echo " ping to IPv6 nameserver:${var}"
  v4alive_namesrv=$(do_ping 6 ${var})
  if [ $? -eq 0 ]; then
    result=${SUCCESS}
  fi
  write_json ${layer} IPv6 v6alive_namesrv ${result} "(${var}) ${v6alive_namesrv}"
  v6rtt_namesrv=$(get_rtt "${v6alive_namesrv}")
  write_json ${layer} IPv6 v6rtt_namesrv ${INFO} "(${var}) ${v6rtt_namesrv}"
  if [ ${result} = ${SUCCESS} ]; then
    echo "  status:ok, rtt:${v6rtt_namesrv} msec"
  else
    echo "  status:ng"
  fi
done

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
    echo " ping to extarnal IPv4 server:${var}"
    v4alive_srv=$(do_ping 4 ${var})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    fi
    write_json ${layer} IPv4 v4alive_srv ${result} "(${var}) ${v4alive_srv}"
    v4rtt_srv=$(get_rtt "${v4alive_srv}")
    write_json ${layer} IPv4 v4rtt_srv ${INFO} "(${var}) ${v4rtt_srv}"
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status:ok, rtt:${v4rtt_srv} msec"
    else
      echo "  status:ng"
    fi
  done
  
  # Do traceroute to extarnal IPv4 servers
  for var in `echo ${PING_SRVS} | sed 's/,/ /g'`; do
    echo " traceroute to extarnal IPv4 server:${var}"
    v4path_srv=$(do_traceroute 4 ${var})
    write_json ${layer} IPv4 v4path_srv ${INFO} "(${var}) ${v4path_srv}"
    echo "  path:${v4path_srv}"
  done
  
  # Check path MTU to extarnal IPv4 servers
  for var in `echo ${PING_SRVS} | sed 's/,/ /g'`; do
    echo " do pmtud to extarnal IPv4 server:${var}"
    data=$(do_pmtud 4 ${var} 1450 1473)
    if [ ${data} -eq 0 ]; then
      write_json ${layer} IPv4 v4pmtu_srv ${INFO} "(${var}) unmeasurable"
      echo "  pmtud:unmeasurable"
    else
      v4pmtu_srv=`expr ${data} + 28`
      write_json ${layer} IPv4 v4pmtu_srv ${INFO} "(${var}) ${v4pmtu_srv}"
      echo "  pmtu:${v4pmtu_srv} MB"
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
    echo " ping to extarnal IPv6 server:${var}"
    v6alive_srv=$(do_ping 6 ${var})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    fi
    write_json ${layer} IPv6 v6alive_srv ${result} "(${var}) ${v6alive_srv}"
    v6rtt_srv=$(get_rtt "${v6alive_srv}")
    write_json ${layer} IPv6 v6rtt_srv ${INFO} "(${var}) ${v6rtt_srv}"
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status:ok, rtt:${v6rtt_srv} msec"
    else
      echo "  status:ng"
    fi
  done
  
  # Do traceroute to extarnal IPv6 servers
  for var in `echo ${PING6_SRVS} | sed 's/,/ /g'`; do
    echo " traceroute to extarnal IPv6 server:${var}"
    v6path_srv=$(do_traceroute 6 ${var})
    write_json ${layer} IPv6 v6path_srv ${INFO} "(${var}) ${v6path_srv}"
    echo "  path:${v6path_srv}"
  done
  
  # Check path MTU to extarnal IPv6 servers
  for var in `echo ${PING6_SRVS} | sed 's/,/ /g'`; do
    echo " do pmtud to extarnal IPv6 server:${var}"
    data=$(do_pmtud 6 ${var} 1450 1473)
    if [ ${data} -eq 0 ]; then
      write_json ${layer} IPv6 v6pmtu_srv ${INFO} "(${var}) unmeasurable"
      echo "  pmtud:unmeasurable"
    else
      v6pmtu_srv=`expr ${data} + 28`
      write_json ${layer} IPv6 v6pmtu_srv ${INFO} "(${var}) ${v6pmtu_srv}"
      echo "  pmtu:${v6pmtu_srv} MB"
    fi
  done
fi

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
    echo " do dns lookup for A record by IPv4 nameserver:${var}"
    for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
      result=${FAIL}
      echo " do resolve server:${fqdn}"
      v4trans_a_namesrv=$(do_dnslookup ${var} a ${fqdn})
      if [ $? -eq 0 ]; then
        result=${SUCCESS}
      else
        stat=$?
      fi
      write_json ${layer} IPv4 v4trans_a_namesrv ${result} "(@${var}, resolv ${fqdn}) ${v4trans_a_namesrv}"
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status:ok, result:${v4trans_a_namesrv}"
      else
        echo "  status:ng ($stat)"
      fi
    done
  done

  # Do dns lookup for AAAA record by IPv4
  for var in `echo ${v4nameservers} | sed 's/,/ /g'`; do
    echo " do dns lookup for AAAA record by IPv4 nameserver:${var}"
    for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
      result=${FAIL}
      echo " do resolve server:${fqdn}"
      v4trans_aaaa_namesrv=$(do_dnslookup ${var} aaaa ${fqdn})
      if [ $? -eq 0 ]; then
        result=${SUCCESS}
      else
        stat=$?
      fi
      write_json ${layer} IPv4 v4trans_aaaa_namesrv ${result} "(@${var}, resolv ${fqdn}) ${v4trans_aaaa_namesrv}"
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status:ok, result:${v4trans_aaaa_namesrv}"
      else
        echo "  status:ng ($stat)"
      fi
    done
  done
fi

if [ "X${v6addrs}" != "X" ]; then
  # Do dns lookup for A record by IPv6
  for var in `echo ${v6nameservers} | sed 's/,/ /g'`; do
    echo " do dns lookup for A record by IPv6 nameserver:${var}"
    for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
      result=${FAIL}
      echo " do resolve server:${fqdn}"
      v6trans_a_namesrv=$(do_dnslookup ${var} a ${fqdn})
      if [ $? -eq 0 ]; then
        result=${SUCCESS}
      else
        stat=$?
      fi
      write_json ${layer} IPv6 v6trans_a_namesrv ${result} "(@${var}, resolv ${fqdn}) ${v6trans_a_namesrv}"
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status:ok, result:${v6trans_a_namesrv}"
      else
        echo "  status:ng ($stat)"
      fi
    done
  done

  # Do dns lookup for AAAA record by IPv6
  for var in `echo ${v6nameservers} | sed 's/,/ /g'`; do
    echo " do dns lookup for AAAA record by IPv6 nameserver:${var}"
    for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
      result=${FAIL}
      echo " do resolve server:${fqdn}"
      v6trans_aaaa_namesrv=$(do_dnslookup ${var} aaaa ${fqdn})
      if [ $? -eq 0 ]; then
        result=${SUCCESS}
      else
        stat=$?
      fi
      write_json ${layer} IPv6 v6trans_aaaa_namesrv ${result} "(@${var}, resolv ${fqdn}) ${v6trans_aaaa_namesrv}"
      if [ ${result} = ${SUCCESS} ]; then
        echo "  status:ok, result:${v6trans_aaaa_namesrv}"
      else
        echo "  status:ng ($stat)"
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
  echo " do dns lookup for A record by IPv4 nameserver:${GPDNS4}"
  for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
    result=${FAIL}
    echo " do resolve server:${fqdn}"
    v4trans_a_namesrv=$(do_dnslookup ${GPDNS4} a ${fqdn})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv4 v4trans_a_namesrv ${result} "(@${GPDNS4}, resolv ${fqdn}) ${v4trans_a_namesrv}"
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status:ok"
    else
      echo "  status:ng ($stat)"
    fi
  done

  # Do dns lookup for AAAA record by GPDNS4
  echo " do dns lookup for AAAA record by IPv4 nameserver:${GPDNS4}"
  for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
    result=${FAIL}
    echo " do resolve server:${fqdn}"
    v4trans_aaaa_namesrv=$(do_dnslookup ${GPDNS4} aaaa ${fqdn})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv4 v4trans_aaaa_namesrv ${result} "(@${GPDNS4}, resolv ${fqdn}) ${v4trans_aaaa_namesrv}"
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status:ok"
    else
      echo "  status:ng ($stat)"
    fi
  done
fi

if [ "X${v6addrs}" != "X" ]; then
  # Do dns lookup for A record by GPDNS6
  echo " do dns lookup for A record by IPv6 nameserver:${GPDNS6}"
  for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
    result=${FAIL}
    echo " do resolve server:${fqdn}"
    v6trans_a_namesrv=$(do_dnslookup ${GPDNS6} a ${fqdn})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv6 v6trans_a_namesrv ${result} "(@${GPDNS6}, resolv ${fqdn}) ${v6trans_a_namesrv}"
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status:ok"
    else
      echo "  status:ng ($stat)"
    fi
  done

  # Do dns lookup for AAAA record by GPDNS6
  echo " do dns lookup for AAAA record by IPv6 nameserver:${GPDNS6}"
  for fqdn in `echo ${FQDNS} | sed 's/,/ /g'`; do
    result=${FAIL}
    echo " do resolve server:${fqdn}"
    v6trans_aaaa_namesrv=$(do_dnslookup ${GPDNS6} aaaa ${fqdn})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv6 v6trans_aaaa_namesrv ${result} "(@${GPDNS6}, resolv ${fqdn}) ${v6trans_aaaa_namesrv}"
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status:ok"
    else
      echo "  status:ng ($stat)"
    fi
  done
fi

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
    echo " curl to extarnal server:${var} by IPv4"
    v6http_srv=$(do_curl 4 ${var})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv4 v4http_srv ${result} "(${var}) ${v4http_srv}"
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status:ok, http status code:${v4http_srv}"
    else
      echo "  status:ng ($stat)"
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
    echo " curl to extarnal server:${var} by IPv6"
    v6http_srv=$(do_curl 6 ${var})
    if [ $? -eq 0 ]; then
      result=${SUCCESS}
    else
      stat=$?
    fi
    write_json ${layer} IPv6 v6http_srv ${result} "(${var}) ${v6http_srv}"
    if [ ${result} = ${SUCCESS} ]; then
      echo "  status:ok, http status code:${v6http_srv}"
    else
      echo "  status:ng ($stat)"
    fi
  done

  # Do measure http throuput by IPv6
  #TBD
  # v6http_throughput_srv
fi

sleep 2

####################
## Phase 7

# remove lock file
rm -f ${LOCKFILE}

exit 0
