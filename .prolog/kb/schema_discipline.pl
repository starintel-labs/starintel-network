% Schema-lock discipline (policy + current pending state).

schema_lock_file('schema/starintel-schema.lock.json').
schema_lock_status(pending, '0.10.1').   % as of 2026-09-19; canonical mint in flight
wireless_dtypes([wireless-network, wireless-station]).

pending_lock_policy(
    [ 'envelope validated against bundled v0.9.0 base schema (dtype enum locally extended)',
      'wireless data contracts validated by local supplemental validator in transport.py',
      'starintel-doc is NOT pinned for the wireless dtypes until 0.10.1 is published',
      'tests/test_schema_lock.py and .github/workflows/ci.yml fail closed on any other lock state'
    ]).

% When 0.10.1 lands: pin lock to canonical commit, swap supplemental
% validator for published contracts, restore pin checks. Never hand-edit
% release bumps; use the canonical repo's schema-release tooling.

% Supplemental contracts implemented (0.10.1)
dtype_required(wireless-network, [bssid, security]).
dtype_required(wireless-station, [mac]).
dtype_enum(wireless-network, security,
    [open, wep, wpa-psk, wpa2-psk, wpa2-enterprise, wpa3-psk, wpa3-enterprise, wpa2wpa3-psk, unknown]).
dtype_enum(wireless-network, band, ['2.4ghz', '5ghz', '6ghz', unknown]).
dtype_enum(wireless-station, station_type, [station, ap, bridge, 'bridge-ap', unknown]).
dtype_additional_properties(wireless-network, false).
dtype_additional_properties(wireless-station, false).
