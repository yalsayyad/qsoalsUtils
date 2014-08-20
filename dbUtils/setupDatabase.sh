#!/bin/bash
# Script to setup new spatially enable database on nazgul.uchicago.edu
#
# Run like: setupDatabase.sh <databaseName> <userName>

#enable language for posgis spatial functions
createlang plpgsql $1 -h localhost -U $2
psql -d $1 -h localhost -U $2 -f /usr/share/pgsql/contrib/postgis-64.sql
psql -d $1 -h localhost -U $2 -f /usr/share/pgsql/contrib/postgis-1.5/spatial_ref_sys.sql
psql -d $1 -h localhost -U $2 -f schema.sql
echo "ingesting data. This may take a couple minutes"
psql -d $1 -h localhost -U $2 -f ingest.sql