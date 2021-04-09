rm -r cromwell-executions/myWorkflow
#java -jar ~/bin/cromwell-58.jar run exomiser_jar_v2.wdl -i jarinput_v2.json
java -jar ~/bin/cromwell-58.jar run exomiser_jar.wdl -i jarinput.json
