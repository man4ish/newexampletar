version 1.0

task myTask 
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

workflow myWorkflow 
{
    input 
    {
       File templatefile
       File family_vcf
       File ped_file 
    }
    call myTask 
    {
         input: templatefile=templatefile, family_vcf=family_vcf, ped_file=ped_file
    }
}
