version 1.0

task myTask 
{
    input 
    {
       File tarfile
       String base = basename(tarfile)
    }
    
    command {
        set -exo pipefail
        mkdir bundle
        echo ~{tarfile}
        tar -xzf ~{tarfile} -C bundle
        path=$(realpath bundle)
        echo $path 
        mv bundle/*/* bundle
        python3 /software/reboot-utils/reboot-utils-0.2.2.3/bin/exomiser_from_template.py -t $path/exomiser_genome_template_b38.yml -v $path/cmh003012-01_family.vcf.gz -p $path/result -o ${base}.out_file -b cmh003012-01 -d $path/analysis/cmh003012-01.ped
    }

    output {
        File out = '${base}.out_file'
    }

    runtime {
        docker: "docker.io/man4ish/buildexomiser:1.0.0"
    }
}

workflow myWorkflow 
{
    input 
    {
         File bndl
    }
    call myTask 
    {
         input: tarfile=bndl
    }
}
