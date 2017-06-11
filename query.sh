#!/bin/bash
osmosis \
 --read-xml data/planet-170102.osm \
 --tf accept-nodes tourism=museum \
 --tf reject-ways \
 --tf reject-relations \
 --write-xml data/all-museums.osm
