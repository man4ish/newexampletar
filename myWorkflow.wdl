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
        python3 /Users/mkumar1/wdl/tar_example/script.py -t $path/exomiser_genome_template_b38.yml -o ${base}.out_file
    }

    output {
        File out = '${base}.out_file'
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
