version 1.0

task myTask 
{
    input 
    {
       File yaml_file
       File prop_file
       File data_dir
       String base = basename(prop_file)
    }
    
    command {
        set -exo pipefail
        path=$(realpath ${data_dir})
        #echo $(pwd)
        
        while IFS= read -r line
        do
          if [[ "$line" == "exomiser.data-directory"* ]]; then
             A="$(cut -d'=' -f1 <<<"$line")"
             echo "$A=$path" >> '${base}.tmp'
          else 
             echo "$line" >> '${base}.tmp'   
          fi
        done < "${prop_file}"
       
        mv '${base}.tmp' '${prop_file}'
        path=$(realpath yaml_file)
        java -Xms8g -Xmx32g -jar /software/reboot-utils/exomiser-cli-12.1.0/exomiser-cli-12.1.0.jar --analysis ${yaml_file} --spring.config.location=${prop_file}       
    }
    output {
        File out = '${base}.results.gz'
    }

    runtime {
        docker: "docker.io/man4ish/buildexomiser:1.0.0"
        memory: "24G"
    }
}

workflow myWorkflow 
{
    input 
    {
         File yaml_file
         File prop_file
         File data_dir
    }
    call myTask 
    {
         input: yaml_file=yaml_file, prop_file=prop_file, data_dir=data_dir 
    }
}
