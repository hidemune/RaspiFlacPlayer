#!/bin/bash

amixer sset 'Digital' $(echo "(50 + 0$1) /180*255" | bc -l) 2>&1 > /dev/null
