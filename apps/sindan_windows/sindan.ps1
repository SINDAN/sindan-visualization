$body = @{
#    layer = "Layer2";
#    log_type = "Wireless";
    result = 1;
#    detail = "HTTP/1.1 200 OK";
#    occurred_at = "" 
}

$body["log_unit_uuid"]=[guid]::NewGuid().ToString();

function GetInterfaces() {
    $body["layer"] = "Layer2";
    $body["occurred_at"] = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $body["log_group"] = "Wired"
    $body["log_type"] = "Media"
    $interfaces = (Get-NetAdapter).interfaceGUID

    for($i=0; $i -lt $interfaces.Length ; $i++) {
        $body["detail"] = $interfaces[$i]

        Invoke-RestMethod -Method Post  -Uri http://fluentd.c.u-tokyo.ac.jp:8888/sindan.log -Body (ConvertTo-Json $body)  -ContentType "application/json" 
    }
}


GetInterfaces
Get-NetAdapter
