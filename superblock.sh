#!/bin/bash

# First arg is the time in minutes.
# Second arg is V for vote time, and S for super block time
_convert_time_units(){
	if (( $# != 2 ));then return 1;fi
	if (( $(echo "$1>2880"|bc -l) ));then
		_TIME=$(echo "scale=2;$1/60/24"|bc)
		_UNITS="days"
	elif (( $(echo "scale=2;$1>300"|bc -l) ));then
		_TIME=$(echo "$1/60"|bc)
		_UNITS="hours"
	else
		# Nothing to convert, just return
		return 0
	fi
	case $2 in
		S)
			S_TIME="$_TIME";S_UNITS="$_UNITS"
			;;
		V)
			V_TIME="$_TIME";V_UNITS="$_UNITS"
			;;
		*)
			return 2
			;;
	esac
}

superblock(){
	# A super block occurs every 16616 blocks
	SUPER_BLOCK_INTERVAL=16616
	# The voting deadline occurs 1662 blocks before the super block.
	VOTING_DEADLINE=1662
	# A Super block from the past.
	SUPER_BLOCK=880648
	# The time taken to create a new block
	BLOCK_TIME=2.625
	S_UNITS="minutes";V_UNITS="minutes"

	CURRENT_BLOCK=$(dash-cli getblockcount)
	if [[ -z "$CURRENT_BLOCK" || "$CURRENT_BLOCK" -lt 1 ]];then
		echo "Cannot determine current block, exiting..."
		return 1;
	fi

	while : ;do
		if ((SUPER_BLOCK-VOTING_DEADLINE-CURRENT_BLOCK < 0));then
			if ((SUPER_BLOCK-CURRENT_BLOCK < 0));then
				((SUPER_BLOCK+=SUPER_BLOCK_INTERVAL))
			else
				S_TIME=$(echo "$((SUPER_BLOCK-CURRENT_BLOCK))* $BLOCK_TIME"|bc)
				_convert_time_units "$S_TIME" S
				echo "Voting deadline has passed, the next super block will be in $S_TIME $S_UNITS."
				break
			fi
		else
			S_TIME=$(echo "$((SUPER_BLOCK-CURRENT_BLOCK))* $BLOCK_TIME"|bc)
			_convert_time_units "$S_TIME" S
			V_TIME=$(echo "$((SUPER_BLOCK-VOTING_DEADLINE-CURRENT_BLOCK))* $BLOCK_TIME"|bc)
			_convert_time_units "$V_TIME" V
			echo "Voting deadline is in $V_TIME $V_UNITS and the next super block will be in $S_TIME $S_UNITS."
			break
		fi
	done
	unset SUPER_BLOCK SUPER_BLOCK_INTERVAL CURRENT_BLOCK S_TIME S_UNITS BLOCK_TIME VOTING_DEADLINE V_TIME V_UNITS _TIME _UNITS
}
superblock
