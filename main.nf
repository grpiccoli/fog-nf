#!/usr/bin/env nextflow

raw_isoseq = params.isoseq
out_dir = file(params.outdir)

out_dir.mkdir()

isoseq_reads = Channel.fromPath("${raw_isoseq}/**/*.fastq.gz", type: 'file').buffer(size:1)

process fastqc {
	label 'fastqc'
	label 'parellel'
	tag "$in_fastq"
	time '10h'
	cpus { 12 }

	input:
		file 'read.fastq.gz' from isoseq_reads

	output:
		file("${out_dir}/*.zip") into fastqc_files

	"""
	read.fastq.gz -t {task.cpus} --noextract -o ${out_dir}
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
