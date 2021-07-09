rule makeResfinderSummary:    
    input:
    #TODO make fasta or fastq
        resfinder_output_dir = expand(OUT + "/results_per_sample/{sample}", sample=SAMPLE_NAME)

    output:
        #hier gaat het nog fout
        genes_summary = OUT + "/summary/summary_amr_genes.csv",
        pheno_summary = OUT + "/summary/summary_amr_phenotype.csv"

    #conda: 
    #    "../../envs/resfinder.yaml"

    message:
        "Creating a summary file"
    
    resources:
        mem_mb=config["mem_mb"]

    threads: 
        config["threads"]

    params:
        species = config["Parameters"]["species"]

    shell:
        "python3 bin/python_scripts/make_summary.py -sr {output.genes_summary} {output.pheno_summary} -i {input.resfinder_output_dir} -st resfinder"