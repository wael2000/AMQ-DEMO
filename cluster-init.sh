echo
echo "#################################################"
echo "##                                             ##"
echo "##           ###    ##     ##  #######         ##"
echo "##         ##   ##  #### #### ##     ##        ##"
echo "##        ##     ## ## ### ## ##     ##        ##"
echo "##        ######### ##     ## ##  ## ##        ##"
echo "##        ##     ## ##     ##  ##### ##        ##"
echo "##                                    ##       ##"
echo "##               CLUSTER - INIT                ##"
echo "#################################################"
echo

echo "  - Stop all existing AMQ processes..."
echo
jps -lm | grep artemis | awk '{print $1}' | if [[ $OSTYPE = "linux-gnu" ]]; then xargs -r kill -SIGTERM; else xargs kill -SIGTERM; fi


BORKER_HOME=/Users/redhat/Documents/MW/AMQ/ha-demo/target/amq-broker-7.8.2
MASTER_BROKER_NAME=master
SLAVE_BROKER_NAME=slave
PAIR_NO=${1:-2}
PORT_OFFSET=0
for (( index=1; index<=$PAIR_NO; index++ ))
do
$BORKER_HOME/bin/artemis create --allow-anonymous --user admin --password password --cluster-user admin --cluster-password --clustered --replicated --host localhost --port-offset $PORT_OFFSET $BORKER_HOME/instances/$MASTER_BROKER_NAME$index
# master changes: add heck-for-live-server and group-name
sed  -i'' -e 's/<master>/<master>\n               <check-for-live-server>true<\/check-for-live-server>\n               <group-name>node-'$index'<\/group-name>/' $BORKER_HOME/instances/$MASTER_BROKER_NAME$index/etc/broker.xml
sed  -i'' -e 's/<addresses>/<addresses>\n <address name="haQueue">\n		<anycast>\n			 <queue name="haQueue"\/>\n		<\/anycast>\n <\/address>/' $BORKER_HOME/instances/$MASTER_BROKER_NAME$index/etc/broker.xml
sed  -i'' -e 's/<address-setting match="#">/<address-setting match="#">\n    <redistribution-delay>0<\/redistribution-delay>/' $BORKER_HOME/instances/$MASTER_BROKER_NAME$index/etc/broker.xml
sed  -i'' -e 's/<max-hops>0<\/max-hops>/<max-hops>1<\/max-hops>/' $BORKER_HOME/instances/$MASTER_BROKER_NAME$index/etc/broker.xml

let PORT_OFFSET=PORT_OFFSET+2
$BORKER_HOME/bin/artemis create --allow-anonymous --user admin --password password --cluster-user admin --cluster-password --clustered --replicated --host localhost --port-offset $PORT_OFFSET --slave $BORKER_HOME/instances/$SLAVE_BROKER_NAME$index
# master changes: add allow-failback and group-name
sed  -i'' -e 's/<slave\/>/<slave>\n               <allow-failback>true<\/allow-failback>\n               <group-name>node-'$index'<\/group-name>\n           <\/slave>/' $BORKER_HOME/instances/$SLAVE_BROKER_NAME$index/etc/broker.xml
sed  -i'' -e 's/<addresses>/<addresses>\n <address name="haQueue">\n		<anycast>\n			 <queue name="haQueue"\/>\n		<\/anycast>\n <\/address>/' $BORKER_HOME/instances/$SLAVE_BROKER_NAME$index/etc/broker.xml
sed  -i'' -e 's/<address-setting match="#">/<address-setting match="#">\n    <redistribution-delay>0<\/redistribution-delay>/' $BORKER_HOME/instances/$SLAVE_BROKER_NAME$index/etc/broker.xml
sed  -i'' -e 's/<max-hops>0<\/max-hops>/<max-hops>1<\/max-hops>/' $BORKER_HOME/instances/$SLAVE_BROKER_NAME$index/etc/broker.xml

let PORT_OFFSET=PORT_OFFSET+2

$BORKER_HOME/instances/$MASTER_BROKER_NAME$index/bin/artemis-service start
$BORKER_HOME/instances/$SLAVE_BROKER_NAME$index/bin/artemis-service start

# end of for
done

echo
echo "Open the admin conolse http://localhost:8161/console/auth/login"
echo
