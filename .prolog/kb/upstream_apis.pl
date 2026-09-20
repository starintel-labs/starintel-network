% Upstream API facts, Brave-verified 2026-09-19 (see .prolog/runs for digests).

% --- WiGLE (api.wigle.net, API v2) ---

wigle_auth(basic, 'API name as user, API token as password').
wigle_endpoint(search, 'GET /api/v2/network/search').
wigle_endpoint(detail, 'GET /api/v2/network/{netid} (fallback GET /api/v2/network/detail?netid=)').
wigle_endpoint(bluetooth_search, 'GET /api/v2/bluetooth/search').

wigle_search_param(latrange1, 'lesser latitude bound').
wigle_search_param(latrange2, 'greater latitude bound').
wigle_search_param(longrange1, 'lesser longitude bound').
wigle_search_param(longrange2, 'greater longitude bound').
wigle_search_param(ssid, 'exact network name').
wigle_search_param(netid, 'BSSID; first three octets minimum').
wigle_search_param(onlymine, 'only points first discovered by the current user').
wigle_search_param(resultsPerPage, 'site auth bounded at 100; COMMAPI 1000').
wigle_search_param(searchafter, 'pass back previous page searchAfter; replaces legacy lastnetid').
wigle_search_param(encryption, "filter: 'None','WEP','WPA','WPA2','WPA3','Unknown'; case-insensitive").

wigle_response_field(netid, 'BSSID').
wigle_response_field(ssid, 'network name').
wigle_response_field(trilat, 'latitude').
wigle_response_field(trilong, 'longitude').
wigle_response_field(qos, 'signal quality 0-7').
wigle_response_field(channel, 'Wi-Fi channel').
wigle_response_field(encryption, "encryption string, e.g. 'WPA2', 'unknown'").
wigle_response_field(wep, 'legacy WEP flag').
wigle_response_field(firsttime, 'first seen ISO timestamp').
wigle_response_field(lasttime, 'last seen ISO timestamp').
wigle_response_field(searchAfter, 'pagination cursor (string); search_after int deprecated').
wigle_response_field(nettype, 'network type; "????" when unknown').

wigle_pagination(primary, searchAfter).
wigle_pagination(fallback, lastnetid).  % legacy; used only when no searchAfter returned

% WiGLE cannot distinguish PSK vs enterprise; plain WPA/WPA2/WPA3 map to -psk.
wigle_security_mapping('None', open).
wigle_security_mapping('WEP', wep).
wigle_security_mapping('WPA', 'wpa-psk').
wigle_security_mapping('WPA2', 'wpa2-psk').
wigle_security_mapping('WPA3', 'wpa3-psk').
wigle_security_mapping('WPA2+WPA3', 'wpa2wpa3-psk').

wigle_unverified([ 'search-result fnoise/signal ranges (detail-level observation fields)',
                   '6ghz channel-number mapping' ]).

wigle_source_url('https://api.wigle.net/swagger').
wigle_source_url('https://pkg.go.dev/github.com/borud/wigle').
wigle_source_url('https://github.com/yawigle/yawigle').
wigle_source_url('https://synapse.docs.vertex.link/projects/rapid-powerups/en/latest/storm-packages/synapse-wigle/stormpackage.html').
wigle_source_url('https://docs.fortinet.com/document/fortisoar/1.0.0/wigle/1/wigle-v1-0-0').

% --- Kismet REST ---

kismet_auth(token_cookie, 'API token in KISMET cookie (or URI param); token-only consumers').
kismet_auth(basic, 'admin username/password via HTTP Basic').
kismet_endpoint(status, 'GET /system/status.readonly.json (no-login variant)').
kismet_endpoint(timestamp, 'GET /system/timestamp.json').
kismet_endpoint(devices_all, 'POST /devices/summary/devices.json {"fields": [...]}').
kismet_endpoint(devices_since, 'POST /devices/last-time/{TS}/devices.json {"fields": [...]}').

kismet_field('kismet.device.base.macaddr').
kismet_field('kismet.device.base.type').          % e.g. 'Wi-Fi AP'
kismet_field('kismet.device.base.manuf').
kismet_field('kismet.device.base.channel').
kismet_field('kismet.device.base.frequency').
kismet_field('kismet.device.base.first_time').
kismet_field('kismet.device.base.last_time').
kismet_field('kismet.device.base.crypt').
kismet_field('kismet.device.base.signal/kismet.common.signal.last_signal_dbm').  % union path
kismet_field('dot11.device/dot11.device.advertised_ssid_map/dot11.advertisedssid.ssid').
kismet_field('dot11.device/dot11.device.advertised_ssid_map/dot11.advertisedssid.cloaked').
kismet_field('dot11.device/dot11.device.probed_ssid_map/dot11.probedssid.ssid').

kismet_unverified([ 'last-time response envelope keys (kismet_device_list accepted + bare vector)',
                    'dot11.device.last_bssid field name',
                    'kismet.device.base.packets/kismet.common.packets.total union path',
                    'legacy kismet.dot11.device.lastssid' ]).

kismet_source_url('https://www.kismetwireless.net/docs/api/command_param/').
kismet_source_url('https://www.kismetwireless.net/docs/api/wifi_dot11/').
kismet_source_url('https://www.kismetwireless.net/docs/api/login/').
kismet_source_url('https://github.com/kismetwireless/python-kismet-rest').
kismet_source_url('https://github.com/kismetwireless/kismet/blob/master/docs/dev/webui_rest.md').
