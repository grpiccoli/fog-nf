#!/usr/bin/env nextflow

raw_isoseq = params.isoseq
out_dir = file(params.outdir)

out_dir.mkdir()

isoseq_reads = file("${raw_isoseq}/*.fastqc.gz")

process fastqc {
	label: 'fastqc'
	label: 'parellel'
	tag { "${param.projectName}.fastqc.${sample}" }
	cpus { 12 }
	publishDir "${out_dir}/qc/raw/${sample}", mode:'copy',overwrite: false

	input:
		set sample, file(in_fastq) from isoseq_reads

	output:
		file("${sample}_fastqc/*.zip") into fastqc_files

	"""
	mkdir -p ${sample}_fastqc
	module load singularity/3.6.4
	-o ${sample}_fastqc -t 12 --noextract ${sample}
	"""
}

workflow.onComplete {
	println ( workflow.success ? """
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """ : """
        Failed: ${workflow.errorReport}
        exit status : ${workflow.exitStatus}
        """
 )
}
