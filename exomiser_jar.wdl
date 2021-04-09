version 1.0

task myTask 
{
    input 
    {
       File yaml_file
       File prop_file
       String base = basename(prop_file)
    }
    
    command {
        echo ${yaml_file}
        set -exo pipefail
        java -Xms8g -Xmx32g -jar /software/reboot-utils/exomiser-cli-12.1.0/exomiser-cli-12.1.0.jar --analysis ${yaml_file} --spring.config.location=${prop_file}       
    }
    output {
        File out = '${base}.results.gz'
    }

    runtime {
        docker: "docker.io/man4ish/buildjarexomiser:1.0.0"
    }
}

workflow myWorkflow 
{
    input 
    {
         File yaml_file
         File prop_file
    }
    call myTask 
    {
         input: yaml_file=yaml_file, prop_file=prop_file 
    }
}
