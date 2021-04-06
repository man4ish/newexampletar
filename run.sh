if [ $1 == 'docker' ]
then
   java -jar cromwell-58.jar run myWorkflow_withdocker.wdl --inputs testinput.json
else
   java -jar cromwell-58.jar run myWorkflow.wdl --inputs testinput.json
fi
