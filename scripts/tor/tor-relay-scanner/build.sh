#!/bin/bash
python3 -m pip install . --target torparse
find torparse -path '*/__pycache__*' -delete
python3 -m zipapp -m "tor_relay_scanner.scanner:main" -c torparse
