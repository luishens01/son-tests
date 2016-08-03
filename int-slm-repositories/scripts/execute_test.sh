#!/usr/bin/env bash

echo "##### Deploying Network Service ####"
python3.4 scripts/gk_ia_simulator.py
echo "#### Checking repositories and monitoring manager ####"
python3.4 scripts/check_repositories.py
echo "#### Test finished ####"