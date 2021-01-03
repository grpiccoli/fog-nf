#!/usr/bin/env nextflow

raw_isoseq = params.isoseq
out_dir = file(params.outdir)

out_dir.mkdir()

isosamples = Channel.fromPath("$raw_isoseq/**/", type: 'file').buffer(size:1)
isoseq_reads = Channel.fromPath("$raw_isoseq/**/*.fastq.gz", type: 'file').buffer(size:1)

process fastqc {
	label 'fastqc'
	tag "$iso_sample"
	cpus { 12 }
	time '6h'

	input:
		file iso_sample from isoseq_reads

	"""
	fastqc $iso_sample -t ${task.cpus} --noextract -o $out_dir
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
