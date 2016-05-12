
#!/bin/bash
#
# This script prints a header message for debug purposes.
# It receives one argument, the message to be printed.
#

if [[ $# != 1 ]]; then
        echo "Usage: `basename "$0"` <message>"
        exit 1
fi

msg=$1
msg_len=${#msg}
box_width=50

printf "┌"
for i in `seq 1 $(( msg_len + box_width ))`;
do
	printf "─"
done
printf "┐\n│"
for i in `seq 1 $(( box_width / 2 ))`;
do
        printf " "
done
printf %s "$msg"
for i in `seq 1 $(( box_width / 2 ))`;
do
        printf " "
done
printf "│\n└"
for i in `seq 1 $(( msg_len + box_width ))`;
do
        printf "─"
done
printf "┘\n"

