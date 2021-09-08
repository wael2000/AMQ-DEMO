echo
echo "#################################################"
echo "##                                             ##"
echo "##           ###    ##     ##  #######         ##"
echo "##         ##   ##  #### #### ##     ##        ##"
echo "##        ##     ## ## ### ## ##     ##        ##"
echo "##        ######### ##     ## ##  ## ##        ##"
echo "##        ##     ## ##     ##  ##### ##        ##"
echo "##                                    ##       ##"
echo "##             CLUSTER - START                 ##"
echo "#################################################"
echo

echo "  - Stop all existing AMQ processes..."
echo
jps -lm | grep artemis | awk '{print $1}' | if [[ $OSTYPE = "linux-gnu" ]]; then xargs -r kill -SIGTERM; else xargs kill -SIGTERM; fi

echo "  - Start AMQ brokers..."

BORKER_HOME=/Users/redhat/Documents/MW/AMQ/ha-demo/target/amq-broker-7.8.2
MASTER_BROKER_NAME=master
SLAVE_BROKER_NAME=slave
PAIR_NO=${1:-2}
for (( index=1; index<=$PAIR_NO; index++ ))
do
$BORKER_HOME/instances/$MASTER_BROKER_NAME$index/bin/artemis-service start
$BORKER_HOME/instances/$SLAVE_BROKER_NAME$index/bin/artemis-service start
# end of for
done
