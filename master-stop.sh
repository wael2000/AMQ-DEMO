echo
echo "#################################################"
echo "##                                             ##"
echo "##           ###    ##     ##  #######         ##"
echo "##          ## ##   ###   ### ##     ##        ##"
echo "##         ##   ##  #### #### ##     ##        ##"
echo "##        ######### ##     ## ##  ## ##        ##"
echo "##        ##     ## ##     ##  ##### ##        ##"
echo "##                                    ##       ##"
echo "##                MASTER - STOP                ##"
echo "#################################################"
echo

echo "  - Stop all existing AMQ brokers ..."
echo
#jps -lm | grep artemis | awk '{print $1}' | if [[ $OSTYPE = "linux-gnu" ]]; then xargs -r kill -SIGTERM; else xargs kill -SIGTERM; fi

BORKER_HOME=/Users/redhat/Documents/MW/AMQ/ha-demo/target/amq-broker-7.8.2
MASTER_BROKER_NAME=master
SLAVE_BROKER_NAME=slave
index=${1:-1}
echo 'Stop Master'$index
$BORKER_HOME/instances/$MASTER_BROKER_NAME$index/bin/artemis-service stop
