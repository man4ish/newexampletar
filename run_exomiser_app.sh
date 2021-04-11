rm -r cromwell-executions/myWorkflow
java -jar ~/bin/cromwell-58.jar run exomiser_app.wdl -i exomiser_app_input.json
