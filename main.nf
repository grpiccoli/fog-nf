#!/usr/bin/env nextflow

raw_isoseq = params.isoseq
out_dir = file(params.outdir)

out_dir.mkdir()

isoseq_reads = Channel.fromPath("${raw_isoseq}/**/*.fastq.gz", type: 'file')

process fastqc {
	label 'fastqc'
	label 'parellel'
	tag { "${param.projectName}.fastqc.${in_fastq}" }
	cpus { 12 }
	publishDir "${out_dir}/qc/raw/${sample}", mode:'copy',overwrite: false

	input:
		file in_fastq from isoseq_reads

	output:
		file("${in_fastq}_fastqc/*.zip") into fastqc_files

	"""
	mkdir -p ${in_fastq}_fastqc
	module load singularity/3.6.4
	-o ${in_fastq}_fastqc -t 12 --noextract ${im_fastq}
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
