DEMO="JBoss AMQ 7 Replicated HA Demo"
PRODUCT_HOME=./target/amq-broker-7.8.2
AMQ_INSTANCES=$PRODUCT_HOME/instances
AMQ_MASTER=replicatedMaster
AMQ_SLAVE=replicatedSlave
AMQ_MASTER_HOME=$AMQ_INSTANCES/$AMQ_MASTER
AMQ_SLAVE_HOME=$AMQ_INSTANCES/$AMQ_SLAVE

# wipe screen.
clear

echo "  - Produce 10 messages"
echo
sh $AMQ_MASTER_HOME/bin/artemis consumer --destination=queue://haQueue --verbose
