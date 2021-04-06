version 1.0
task myTask {
    input {
    File tarfile
    String base = basename(tarfile)
    }
    
    command {
        set -exo pipefail
        mkdir bundle
        tar -xzf ~{tarfile} -C bundle
        mv bundle/*/* bundle
        PWD=/Users/mkumar1/Desktop/apps/Exomiser
        python3 /Users/mkumar1/wdl/cromwell/script.py -t $PWD/bundle/exomiser_genome_template_b38.yml -o ${base}.out_file
    }

    output {
        File out = '${base}.out_file'
    }
}

workflow myWorkflow {
    input {
         File bndl
    }
    call myTask {
         input: tarfile=bndl
    }
}

