rule runResfinderFastq:
    """Run resfinder and pointfinder"""
    input:
        r1 = lambda wildcards: SAMPLES[wildcards.sample]["R1"],
        r2 = lambda wildcards: SAMPLES[wildcards.sample]["R2"]

    output:
        #TODO check which one is the good one
        #output_dir = directory(OUT + "/results_per_sample/{sample}")
        #Directory per sample
        output_dir = directory(OUT + "/results/resfinder/{sample}")
    
    #conda:
        #"../../envs/resfinder.yaml"

    message:
        "Processing received fastq sample in ResFinder and PointFinder"

    params:
        l = config["resfinder_min_coverage"],
        t = config["resfinder_identity_threshold"],
        species = config["species"],
        resfinder_db = config["resfinder_db"],
        pointfinder_db = config["pointfinder_db"],
        run_pointfinder = config["run_pointfinder"]

    resources: 
        mem_gb=config["mem_gb"]["resfinder"]

    threads: config["threads"]["resfinder"]
    
    shell:
        """
if [ {params.run_pointfinder} == "1" ]; then
    python3 bin/resfinder/run_resfinder.py -o {output.output_dir} -s \"{params.species}\" -l {params.l} -t {params.t} --acquired --point -ifq {input.r1} {input.r2} -db_res {params.resfinder_db} -db_point {params.pointfinder_db}
else
    python3 bin/resfinder/run_resfinder.py -o {output.output_dir} -s \"{params.species}\" -l {params.l} -t {params.t} --acquired -ifq {input.r1} {input.r2} -db_res {params.resfinder_db} -db_point {params.pointfinder_db}
fi
        """
