#!/bin/sh

opt_prefix='zfs-auto-snap'

do_snapshots ()
{
	local KEEP=''

	for ii in $TARGETS
	do
		zfs snapshot "$ii@$SNAPNAME"

		KEEP="$opt_keep"

		# ASSERT: The old snapshot list is sorted by increasing age.
		for jj in $SNAPSHOTS_OLD
		do
			# Check whether this is an old snapshot of the filesystem.
			if [ -z "${jj#$ii@$SNAPGLOB}" ]
			then
				KEEP=$(( $KEEP - 1 ))
				if [ "$KEEP" -le '0' ]
				then
					zfs destroy -d "$jj"

				fi
			fi
		done
	done
}


# main ()
# {

while [ "$#" -gt '0' ]
do
	case "$1" in 
		--keep)
			if   [ ! "$2" -gt '0' ];
			then
				exit 1
			fi
			opt_keep="$2"
			shift 2
			;;
		--label)
			opt_label="$2"
			shift 2
			;;
	esac
done

ZPOOL_STATUS=$(env LC_ALL=C zpool status 2>&1 )
ZFS_LIST=$(env LC_ALL=C zfs list -t volume,filesystem -H)
CANDIDATES=$(echo "$ZFS_LIST" | awk -F '\t' '{print $1}')
SNAPSHOTS_OLD=$(env LC_ALL=C zfs list -H -t snapshot -S creation -o name) 

# Get a list of pools that are being scrubbed.
ZPOOLS_SCRUBBING=$(echo "$ZPOOL_STATUS" | awk -F ': ' \
  '$1 ~ /^ *pool$/ { pool = $2 } ; \
   $1 ~ /^ *scan$/ && $2 ~ /scrub in progress/ { print pool }' \
  | sort ) 

# Get a list of pools that cannot do a snapshot.
ZPOOLS_NOTREADY=$(echo "$ZPOOL_STATUS" | awk -F ': ' \
  '$1 ~ /^ *pool$/ { pool = $2 } ; \
   $1 ~ /^ *state$/ && $2 !~ /ONLINE|DEGRADED/ { print pool } ' \
  | sort)

# Initialize the list of datasets that will get snapshots.
TARGETS=''

for ii in $CANDIDATES
do
	# Exclude datasets in pools that cannot do a snapshot.

	for jj in $ZPOOLS_NOTREADY
	do
		if [ "$(echo "$ii" | awk -F/ '{print $1}')" = "$jj" ]
		then
			continue 2
		fi
	done
	for jj in $ZPOOLS_SCRUBBING
	do
		if [ "$(echo "$ii" | awk -F/ '{print $1}')" = "$jj" ]
		then
			continue 2
		fi
	done

	TARGETS="$TARGETS $ii"
done


DATE=$(date --utc +%F-%H-%M)
SNAPNAME="${opt_prefix}_${opt_label}_$DATE"

# The expression for matching old snapshots.
SNAPGLOB="${opt_prefix}_${opt_label}_????-??-??-??-??"

do_snapshots "$SNAPNAME" "$SNAPGLOB" "$TARGETS"

exit 0
# }
