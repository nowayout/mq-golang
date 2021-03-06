#!/bin/sh

# This is used to start the IBM MQ monitoring service for Prometheus

# The queue manager name comes in from the service definition as the
# only command line parameter
qMgr=$1

# Set the environment to ensure we pick up libmqm.so etc
. /opt/mqm/bin/setmqenv -m $qMgr -k

# A list of queues to be monitored is given here.
# It is a set of names or patterns ('*' only at the end, to match how MQ works),
# separated by commas. When no queues match a pattern, it is reported but
# is not fatal.
queues="APP.*,MYQ.*"

# An alternative is to have a file containing the patterns, and named
# via the ibmmq.monitoredQueuesFile option.

# See config.go for all recognised flags

# Start via "exec" so the pid remains the same. The queue manager can
# then check the existence of the service and use the MQ_SERVER_PID value
# to kill it on shutdown.
exec /usr/local/bin/mqgo/mq_prometheus -ibmmq.queueManager=$qMgr -ibmmq.monitoredQueues="$queues" -log.level=error
