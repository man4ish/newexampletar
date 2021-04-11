rm -r cromwell-executions/myWorkflow

#java -jar ~/bin/dxWDL-v1.50.jar compile exomiser_app_v2.wdl -project project-G1jvZBj9K3Gk6zJB2k0Z69Pj
#java -jar dxWDL-0.59.jar compile exomiser.wdl -project project-xxxx
#java -jar ~/bin/cromwell-58.jar run exomiser_app_v2.wdl -i exomiser_app_input_v2.json
java -jar ~/bin/cromwell-58.jar run exomiser_app_v2.wdl -i input.json
