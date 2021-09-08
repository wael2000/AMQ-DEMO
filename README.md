# Red Hat AMQ 7 High Availability Replicated Demo (Share Nothing)

## create cluster brokers
1 - Build a highly available cluster with [N] live-backup (Master/Slave) pairs and share no storage.

---------------------------        	    ------------------------
|  Live       Broker 1     | __    __  |  Live      Broker 2   |
---------------------------	    \ /     ------------------------
---------------------------      x 	    ------------------------
|  Backup  Broker 2        | __ / \ __  |  Backup Broker 1     |
---------------------------	    	      ------------------------

For example, create We 4 pairs of master/slave brokers

$ ./cluster-init.sh 4

## Test failover
2 - Stop a live broker, watch the backup slave taking over

For example, stop master1 and check how salve1 is taking over
$ ./master-stop.sh 1

## Test failback
3 - Start the original live broker again, watch it taking over

For example, start master1 and check how salve1 is demoted to slave again
$ ./master-start.sh 1

## Test message replication
4 - produce message to one of the master, switch it off, connect to corresponding salve and make sure messages are replicated

Produce 40 messages to haQueue in master1
$ AMQ_MASTER1_HOME/bin/artemis producer --message-count=40 --destination=queue://haQueue --verbose
Stop master1
$ ./master-stop.sh 1
open slave1 web console, browse haQueue and see the messages, delete some messages
Start master1
$ ./master-start.sh 1
open master1 web console, browse haQueue and see the messages and make sure delete messages are gone

## Test  broker message load balancing - message redistribution   
5 - produce messages to one broker while consumers are connected to other broker, test how messages are being load balanced across all active brokers

start consumer per broker
$ AMQ_MASTER1_HOME/bin/artemis consumer --destination=queue://haQueue --verbose
$ AMQ_MASTER2_HOME/bin/artemis consumer --destination=queue://haQueue --verbose
$ AMQ_MASTER3_HOME/bin/artemis consumer --destination=queue://haQueue --verbose
$ AMQ_MASTER4_HOME/bin/artemis consumer --destination=queue://haQueue --verbose

Produce 40 messages to haQueue in master1
$ AMQ_MASTER1_HOME/bin/artemis producer --message-count=40 --destination=queue://haQueue --verbose

Check, how every broker received 10 messages and being consumed by the connected consumers

## Test  clinet side load balancing
5 - Configure your client to load balance message across all available brokers
use the client-side-load-balancing example to test client load balancing 
