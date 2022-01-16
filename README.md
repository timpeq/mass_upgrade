# mass_upgrade.sh
Bash script to *manually* mass-upgrade an Ubuntu host along with all running LXD containers.

This is a rather blunt tool to upgrade this host and running LXD containers.  The tool assumes Ubuntu (but should work on any Debian host/container using `apt`).  You should keep focus while upgrade proceeds because some updates may require user interaction.  No attempt has been made to make updates unattended.
