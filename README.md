# Open Street Maps Museum Data

[`data/all-museums.csv`](data/all-museums.csv) contains data points from all museums on earth (36,694 in total). It is extracted from [planet.osm](https://wiki.openstreetmap.org/wiki/Planet.osm) as of June 5th, 2017.

The code in this repository uses [Osmosis](https://wiki.openstreetmap.org/wiki/Osmosis) to search for OSM nodes where `tourism=museum` (without a lat/long bounding box). It would be trivial to adapt `query.sh` to use different search criteria to meet your needs. See [here](https://wiki.openstreetmap.org/wiki/Osmosis/Detailed_Usage_0.45) for more info. I've written code that parses the resulting [`data/all-museums.osm`](data/all-museums.osm) query into a CSV that includes only a subset of desirable fields. I've found the country/city data provided by OSM to be quite sparse, so I've ignored OSM's city and country fields and chosen to instead include results from a reverse geolookup by lat/long using the [reverse-geocode](https://bitbucket.org/richardpenman/reverse_geocode) python package.

If you wish to repeat this process, or run similar queries or convert OSM XML to CSV, see below.

## Download

Open Street Maps planet data is ~54GB compressed, and ~751GB once uncompressed. [Full planet files](https://wiki.openstreetmap.org/wiki/Planet.osm) are made available weekly.

```bash
# clone this repo
git clone https://github.com/brannondorsey/osm-museums

# navigate to the data folder
cd osm-museums/data

# download the planet osm file
wget https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/planet/2017/planet-170102.osm.bz2

# you will likely need to install pbzip2 before running this command
# uncompress using 2GB of RAM (the max)
pbzip2 -d -m2000 planet-170102.osm.bz2
```

Osmosis can operate on `.bz2` compressed OSM files, however this is not encouraged and unless disk space is a limited resource should be avoided. 

## Query

The official OSM query tool is a Java application called [Osmosis](https://wiki.openstreetmap.org/wiki/Osmosis). You must [download and install](https://wiki.openstreetmap.org/wiki/Osmosis#How_to_install) it for your platform. Next we search for all museums in the world and output the results to an XML file called `all-museums.osm` inside `data/`.

```bash
osmosis \
 --read-xml data/planet-170102.osm \
 --tf accept-nodes tourism=museum \
 --tf reject-ways \
 --tf reject-relations \
 --write-xml data/all-museums.osm
```

The above command is also the contents of `query.sh`. So you can instead run `./query.sh` for convenience. See here for [full Osmosis usage documentation](https://wiki.openstreetmap.org/wiki/Osmosis/Detailed_Usage_0.45).

## Convert to CSV (and augment location using geolookup)

`osm2csv.py` is a python program to convert osm file (that are the result of `query.sh`) to csv. Before running this program you must install the necessary dependencies.

```
pip install numpy scipy reverse_geocode unicodecsv
``` 

To convert and augment geo location data, run:
```
python osm2csv.py --input data/all-museums.osm --output data/all-museums.csv
```