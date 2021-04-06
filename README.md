# tarfile example with and without docker<br>
if [ $1 == 'docker' ]<br>
then<br>
   java -jar cromwell-58.jar run myWorkflow_withdocker.wdl --inputs testinput.json<br>
else<br>
   java -jar cromwell-58.jar run myWorkflow.wdl --inputs testinput.json<br>
fi<br>
