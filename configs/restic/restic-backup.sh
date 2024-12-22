#!/bin/bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export RESTIC_REPOSITORY=
export RESTIC_PASSWORD=

restic backup --tag homelab /data/shate/gitea/git
restic backup --tag homelab /data/photos
