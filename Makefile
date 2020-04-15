all:

install:
	install -d /etc/cron.d
	install -d /etc/cron.daily
	install -d /etc/cron.hourly
	install -d /etc/cron.weekly
	install -d /etc/cron.monthly
	install -m 0644 etc/zfs-auto-snapshot.cron.frequent /etc/cron.d/zfs-auto-snapshot
	install etc/zfs-auto-snapshot.cron.hourly   /etc/cron.hourly/zfs-auto-snapshot
	install etc/zfs-auto-snapshot.cron.daily    /etc/cron.daily/zfs-auto-snapshot
	install etc/zfs-auto-snapshot.cron.weekly   /etc/cron.weekly/zfs-auto-snapshot
	install etc/zfs-auto-snapshot.cron.monthly  /etc/cron.monthly/zfs-auto-snapshot
	install -d /usr/local/sbin
	install src/zfs-auto-snapshot.sh /usr/local/sbin/zfs-auto-snapshot

uninstall:
	rm /etc/cron.d/zfs-auto-snapshot
	rm /etc/cron.hourly/zfs-auto-snapshot
	rm /etc/cron.daily/zfs-auto-snapshot
	rm /etc/cron.weekly/zfs-auto-snapshot
	rm /etc/cron.monthly/zfs-auto-snapshot
	rm /usr/local/sbin/zfs-auto-snapshot



