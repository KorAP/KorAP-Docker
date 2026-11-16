#!/usr/bin/env python3
"""Verify the isolated frontend's host filter and rendered maintenance notice."""
import json
import os
import sys
import time
from urllib.error import URLError
from urllib.request import urlopen

host = sys.argv[1]
port = os.environ.get('DOWNTIME_TEST_PORT', '64543')
base = f'http://127.0.0.1:{port}'
for attempt in range(30):
    try:
        with urlopen(base + '/maintenance-test.json', timeout=3) as response:
            data = json.load(response)
        if data['status']['last_success'] and not data['status']['refreshing']:
            break
    except (URLError, ConnectionError):
        pass
    time.sleep(0.5)
else:
    raise SystemExit('Calendar cache did not warm successfully')
assert 'hosts' not in data
for event in data['events']:
    assert set(event) == {'start', 'end', 'start_epoch', 'end_epoch', 'all_day', 'ongoing'}
assert not data['status']['error'], data['status']
expected = host == 'worker-05'
assert bool(data['events']) == expected, data
with urlopen(base + '/', timeout=10) as response:
    html = response.read().decode('utf-8')
assert ('id="maintenance-title"' in html) == expected
assert ('System maintenance' in html or 'Systemwartung' in html) == expected
for private in ('worker-05', 'korap-head-02', 'OS Upgrade to Rocky 9'):
    assert private not in html and private not in json.dumps(data)
if expected:
    assert '16.11.2026' in html and '17.11.2026' in html
print(f'{host}: JSON and landing page OK; notices={len(data["events"])}')
