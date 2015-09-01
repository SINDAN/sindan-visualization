$body = @{
#    layer = "Layer2";
#    log_type = "Wireless";
    result = 1;
#    detail = "HTTP/1.1 200 OK";
#    occurred_at = "" 
}

$destructive=1

#################
##  Phase 0

# Set lock file


# Create and regist UUID
$body["log_unit_uuid"]=[guid]::NewGuid().ToString();

echo "log_unit_uuid:" $body["log_unit_uuid"]


function GetInterfaces() {
    $body["layer"] = "Layer2";
    $body["occurred_at"] = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $body["log_group"] = "Wired"
    $body["log_type"] = "Media"

    # Get devicename
    $interfaces = (Get-NetAdapter -Name 'Wi-Fi').interfaceGUID

    $body["detail"] = $interfaces

    # Get MAC address
    
    # Get OS version    
    
    # Register log_unit_id
    Invoke-RestMethod -Method Post  -Uri http://fluentd.c.u-tokyo.ac.jp:8888/sindan.log -Body (ConvertTo-Json $body)  -ContentType "application/json"     

#    for($i=0; $i -lt $interfaces.Length ; $i++) {
#        $body["detail"] = $interfaces[$i]
#        Invoke-RestMethod -Method Post  -Uri http://fluentd.c.u-tokyo.ac.jp:8888/sindan.log -Body (ConvertTo-Json $body)  -ContentType "application/json" 
#    }
}

##################
### Phase 1 
echo "Phase 1: Datalink Layer checking..."



if ($destructive) {
    # Record current ssid
    $ssid_profile=netsh wlan show interfaces | Select-String -NotMatch "接続モード" | Select-String "プロファイル" 
    echo $ssid_profile
    # If up/down
#    netsh interface set interface name="Wi-Fi" admin=DISABLED
    #Get-NetAdapterHardwareInfo
    echo "Interface Up/Down..."
    sleep 2
#    netsh interface set interface name="Wi-Fi" admin=ENABLED

    # Change to recorded ssid
}

sleep 2

# Check I/F status

# Get iftype

# Get ifmtu

# Wi-Fi
# if wifi
    # Get media type
    # Get Wi-Fi SSID
    # Get Wi-Fi RSSI
    # Get Wi-Fi noise
    # Get Wi-Fi rate
# fi

# Report phase 1 results

GetInterfaces
#Get-NetAdapter

##################
### Phase 2 

echo "Phase 2: Interface Layer checking..."

# Get if configuration
# Get IPv4 address
# Get IPv4 netmask
# Get IPv4 routers
# Get IPv4 name servers
# Get IPv4 NTP servers

# Get IPv6 linklocal address
# Get IPv6 RA prefix

# if RA prefix present
    # Get IPv6 RA prefix flags
    # Get IPv6 RA flags
    # Get Ipv6 address
    # Get IPv6 routers
    # Get IPv6 name servers
    # Get IPv6 NTP servers
# fi

# Report phase 2 results

sleep 2

##################
### Phase 3

echo "Phase 3: Localnet Layer checking..."

# Do ping to IPv4 routers

# Do ping to IPv4 nameservers

# Do ping to IPv6 routers

# Do ping to IPv6 nameservers

sleep 2

##################
### Phase 4
echo "Phase 4: Globalnet Layer checking..."

# Check PING_SRVS parameter

# Do ping to external IPv4 servers

# Do traceroute to external IPv4 servers

# Check path MTU to external IPv4 servers

# Check PING6_SRVS parameter

# Do ping to external IPv6 servers

# Do traceroute to external IPv6 servers

# Check path MTU to external IPv6 servers

sleep 2

##################
### Phase  5
echo "Phase 5: DNS Layer checking..."

# Clear dns local cache
echo "flushing DNS caches..."

# Check FQDNS parameter

# Do dns lookup for A record by IPv4

# Do dns lookup for AAAA record by IPv4

# Do dns lookup for A record by IPv6

# Do dns lookup for AAAA record by IPv6

# Check GPDNS[4|6] parameter

# Do dns lookup for A record by GPDNS4

# Do dns lookup for AAAA record by GPDNS4

# Do dns lookup for A record by GPDNS6

# Do dns lookup for AAAA record by GPDNS6

sleep 2

##################
### Phase 6
echo "Phase 6: Web Layer checking..."

sleep 2

##################
### Phase 7

# write log file

# remove lock file

exit 0



