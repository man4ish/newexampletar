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
        set -exo pipefail
        path=$(realpath ${prop_file})
        #echo $(pwd)

        while IFS= read -r line
        do
          if [[ "$line" == *"vcf:"* ]]; then
             vcf="$(cut -d':' -f1 <<<"$line")"
             vcf_fname="$(cut -d':' -f2 <<<"$line")"
             vcf_name=`echo $vcf_fname | sed 's/ *$//g'`
             echo "$vcf: $path/"$vcf_name >> '${base}.yaml.tmp'
          elif [[ "$line" == *"ped:"* ]]; then
             ped="$(cut -d':' -f1 <<<"$line")"
             ped_name="$(cut -d':' -f2 <<<"$line")"
             ped_fname=`echo $ped_name | sed 's/ *$//g'`
             echo "$ped: $path/"$ped_fname >> '${base}.yaml.tmp'
          elif [[ "$line" == *"outputPrefix:"* ]]; then
             oprefix="$(cut -d':' -f1 <<<"$line")"
             oprefix_name_name="$(cut -d':' -f2 <<<"$line")"
             prefix_name=`echo $oprefix_name | sed 's/ *$//g'`
             echo "$oprefix: $path/"$prefix_fname"/result" >> '${base}.yaml.tmp'
          else
             echo "$line" >> '${base}.yaml.tmp'
          fi
        done < "${yaml_file}"
        mv '${base}.yaml.tmp' '${yaml_file}' 
        
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
        #java -Xms8g -Xmx16g -jar /software/reboot-utils/exomiser-cli-12.1.0/exomiser-cli-12.1.0.jar --analysis ${yaml_file} --spring.config.location=${prop_file}       
    }
    output {
        File out = '${base}.results.gz'
    }

    runtime {
        docker: "docker.io/man4ish/buildexomiser:1.0.0"
        memory: "20G"
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
