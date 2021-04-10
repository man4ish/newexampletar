version 1.0

task myTask1 
{
    input 
    {
       File templatefile
       File family_vcf
       File ped_file
       String base = basename(templatefile)
    }
    
    command {
        set -exo pipefail
        path=$(realpath templatefile)
        echo $path 
        python3 /software/reboot-utils/reboot-utils-0.2.2.3/bin/exomiser_from_template.py -t ${templatefile} -v ${family_vcf} -p $path/result -o ${base}.yaml -b cmh003012-01 -d ${ped_file}
    }

    output {
        File out = '${base}.yaml'
    }

    runtime {
        docker: "docker.io/man4ish/buildexomiser:1.0.0"
    }
}

task myTask2 
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
       
        mkdir -p $path/output
        #mkdir -p '${base}_result'/output

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
             echo "$oprefix: $path/"$prefix_fname"/output/result" >> '${base}.yaml.tmp'
             #echo "$oprefix: ${base}_result/output/result" >> '${base}.yaml.tmp'
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

        java -Xms2g -Xmx8g -jar /software/reboot-utils/exomiser-cli-12.1.0/exomiser-cli-12.1.0.jar --analysis ${yaml_file} --spring.config.location=${prop_file}
        tar czvf $path/output.tar.gz $path/output 
        mkdir -p '${base}_result' 
        cp $path/output.tar.gz '${base}_result/output.tar.gz' 
    }
    output {
        File out = '${base}_result/output.tar.gz'
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
         File templatefile
         File family_vcf
         File ped_file
         File yaml_file
         File prop_file
         File data_dir
    }
    call myTask1
    {
         input: templatefile=templatefile, family_vcf=family_vcf, ped_file=ped_file
    } 
    call myTask2 
    {
         input: yaml_file=yaml_file, prop_file=prop_file, data_dir=data_dir 
    }
}
