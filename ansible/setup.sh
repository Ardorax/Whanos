#!/bin/bash
for i in $(cat production | grep -Eo "192\.168\.122\.[0-9]+"); do
    ssh-copy-id "ardorax@$i"
done
