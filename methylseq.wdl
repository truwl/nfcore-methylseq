version 1.0

workflow methylseq {
	input{
		File samplesheet
		Boolean? single_end
		String outdir = "./results"
		String? email
		String aligner = "bismark"
		Boolean? comprehensive
		Boolean? save_align_intermeds
		Boolean? pbat
		Boolean? rrbs
		Boolean? slamseq
		Boolean? em_seq
		Boolean? single_cell
		Boolean? accel
		Boolean? cegx
		Boolean? epignome
		Boolean? zymo
		String? genome
		File? fasta
		String? fasta_index
		String? bismark_index
		String? bwa_meth_index
		Boolean? save_reference
		String igenomes_base = "s3://ngi-igenomes/igenomes/"
		Boolean? igenomes_ignore
		Int? clip_r1
		Int? clip_r2
		Int? three_prime_clip_r1
		Int? three_prime_clip_r2
		Boolean? save_trimmed
		Boolean? non_directional
		Boolean? cytosine_report
		Boolean? relax_mismatches
		Float num_mismatches = 0.6
		Boolean? unmapped
		Int? meth_cutoff
		String? known_splices
		Boolean? local_alignment
		Int? minins
		Int? maxins
		Int? bismark_align_cpu_per_multicore
		String? bismark_align_mem_per_multicore
		Int? min_depth
		Boolean? ignore_flags
		Boolean? methyl_kit
		Boolean? skip_trimming
		Boolean? skip_deduplication
		Boolean? help
		String publish_dir_mode = "copy"
		Boolean validate_params = true
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		Boolean? show_hidden_params
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_name
		String? config_profile_description
		String? config_profile_contact
		String? config_profile_url

	}

	call make_uuid as mkuuid {}
	call touch_uuid as thuuid {
		input:
			outputbucket = mkuuid.uuid
	}
	call run_nfcoretask as nfcoretask {
		input:
			samplesheet = samplesheet,
			single_end = single_end,
			outdir = outdir,
			email = email,
			aligner = aligner,
			comprehensive = comprehensive,
			save_align_intermeds = save_align_intermeds,
			pbat = pbat,
			rrbs = rrbs,
			slamseq = slamseq,
			em_seq = em_seq,
			single_cell = single_cell,
			accel = accel,
			cegx = cegx,
			epignome = epignome,
			zymo = zymo,
			genome = genome,
			fasta = fasta,
			fasta_index = fasta_index,
			bismark_index = bismark_index,
			bwa_meth_index = bwa_meth_index,
			save_reference = save_reference,
			igenomes_base = igenomes_base,
			igenomes_ignore = igenomes_ignore,
			clip_r1 = clip_r1,
			clip_r2 = clip_r2,
			three_prime_clip_r1 = three_prime_clip_r1,
			three_prime_clip_r2 = three_prime_clip_r2,
			save_trimmed = save_trimmed,
			non_directional = non_directional,
			cytosine_report = cytosine_report,
			relax_mismatches = relax_mismatches,
			num_mismatches = num_mismatches,
			unmapped = unmapped,
			meth_cutoff = meth_cutoff,
			known_splices = known_splices,
			local_alignment = local_alignment,
			minins = minins,
			maxins = maxins,
			bismark_align_cpu_per_multicore = bismark_align_cpu_per_multicore,
			bismark_align_mem_per_multicore = bismark_align_mem_per_multicore,
			min_depth = min_depth,
			ignore_flags = ignore_flags,
			methyl_kit = methyl_kit,
			skip_trimming = skip_trimming,
			skip_deduplication = skip_deduplication,
			help = help,
			publish_dir_mode = publish_dir_mode,
			validate_params = validate_params,
			email_on_fail = email_on_fail,
			plaintext_email = plaintext_email,
			max_multiqc_email_size = max_multiqc_email_size,
			monochrome_logs = monochrome_logs,
			multiqc_config = multiqc_config,
			tracedir = tracedir,
			show_hidden_params = show_hidden_params,
			max_cpus = max_cpus,
			max_memory = max_memory,
			max_time = max_time,
			custom_config_version = custom_config_version,
			custom_config_base = custom_config_base,
			hostnames = hostnames,
			config_profile_name = config_profile_name,
			config_profile_description = config_profile_description,
			config_profile_contact = config_profile_contact,
			config_profile_url = config_profile_url,
			outputbucket = thuuid.touchedbucket
            }
		output {
			Array[File] results = nfcoretask.results
		}
	}
task make_uuid {
	meta {
		volatile: true
}

command <<<
        python <<CODE
        import uuid
        print("gs://truwl-internal-inputs/nf-methylseq/{}".format(str(uuid.uuid4())))
        CODE
>>>

  output {
    String uuid = read_string(stdout())
  }
  
  runtime {
    docker: "python:3.8.12-buster"
  }
}

task touch_uuid {
    input {
        String outputbucket
    }

    command <<<
        echo "sentinel" > sentinelfile
        gsutil cp sentinelfile ~{outputbucket}/sentinelfile
    >>>

    output {
        String touchedbucket = outputbucket
    }

    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task fetch_results {
    input {
        String outputbucket
        File execution_trace
    }
    command <<<
        cat ~{execution_trace}
        echo ~{outputbucket}
        mkdir -p ./resultsdir
        gsutil cp -R ~{outputbucket} ./resultsdir
    >>>
    output {
        Array[File] results = glob("resultsdir/*")
    }
    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task run_nfcoretask {
    input {
        String outputbucket
		File samplesheet
		Boolean? single_end
		String outdir = "./results"
		String? email
		String aligner = "bismark"
		Boolean? comprehensive
		Boolean? save_align_intermeds
		Boolean? pbat
		Boolean? rrbs
		Boolean? slamseq
		Boolean? em_seq
		Boolean? single_cell
		Boolean? accel
		Boolean? cegx
		Boolean? epignome
		Boolean? zymo
		String? genome
		File? fasta
		String? fasta_index
		String? bismark_index
		String? bwa_meth_index
		Boolean? save_reference
		String igenomes_base = "s3://ngi-igenomes/igenomes/"
		Boolean? igenomes_ignore
		Int? clip_r1
		Int? clip_r2
		Int? three_prime_clip_r1
		Int? three_prime_clip_r2
		Boolean? save_trimmed
		Boolean? non_directional
		Boolean? cytosine_report
		Boolean? relax_mismatches
		Float num_mismatches = 0.6
		Boolean? unmapped
		Int? meth_cutoff
		String? known_splices
		Boolean? local_alignment
		Int? minins
		Int? maxins
		Int? bismark_align_cpu_per_multicore
		String? bismark_align_mem_per_multicore
		Int? min_depth
		Boolean? ignore_flags
		Boolean? methyl_kit
		Boolean? skip_trimming
		Boolean? skip_deduplication
		Boolean? help
		String publish_dir_mode = "copy"
		Boolean validate_params = true
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		Boolean? show_hidden_params
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_name
		String? config_profile_description
		String? config_profile_contact
		String? config_profile_url

	}
	command <<<
		export NXF_VER=21.10.5
		export NXF_MODE=google
		echo ~{outputbucket}
		/nextflow -c /truwl.nf.config run /methylseq-1.6.1  -profile truwl,nfcore-methylseq  --input ~{samplesheet} 	~{"--samplesheet '" + samplesheet + "'"}	~{true="--single_end  " false="" single_end}	~{"--outdir '" + outdir + "'"}	~{"--email '" + email + "'"}	~{"--aligner '" + aligner + "'"}	~{true="--comprehensive  " false="" comprehensive}	~{true="--save_align_intermeds  " false="" save_align_intermeds}	~{true="--pbat  " false="" pbat}	~{true="--rrbs  " false="" rrbs}	~{true="--slamseq  " false="" slamseq}	~{true="--em_seq  " false="" em_seq}	~{true="--single_cell  " false="" single_cell}	~{true="--accel  " false="" accel}	~{true="--cegx  " false="" cegx}	~{true="--epignome  " false="" epignome}	~{true="--zymo  " false="" zymo}	~{"--genome '" + genome + "'"}	~{"--fasta '" + fasta + "'"}	~{"--fasta_index '" + fasta_index + "'"}	~{"--bismark_index '" + bismark_index + "'"}	~{"--bwa_meth_index '" + bwa_meth_index + "'"}	~{true="--save_reference  " false="" save_reference}	~{"--igenomes_base '" + igenomes_base + "'"}	~{true="--igenomes_ignore  " false="" igenomes_ignore}	~{"--clip_r1 " + clip_r1}	~{"--clip_r2 " + clip_r2}	~{"--three_prime_clip_r1 " + three_prime_clip_r1}	~{"--three_prime_clip_r2 " + three_prime_clip_r2}	~{true="--save_trimmed  " false="" save_trimmed}	~{true="--non_directional  " false="" non_directional}	~{true="--cytosine_report  " false="" cytosine_report}	~{true="--relax_mismatches  " false="" relax_mismatches}	~{"--num_mismatches " + num_mismatches}	~{true="--unmapped  " false="" unmapped}	~{"--meth_cutoff " + meth_cutoff}	~{"--known_splices '" + known_splices + "'"}	~{true="--local_alignment  " false="" local_alignment}	~{"--minins " + minins}	~{"--maxins " + maxins}	~{"--bismark_align_cpu_per_multicore " + bismark_align_cpu_per_multicore}	~{"--bismark_align_mem_per_multicore '" + bismark_align_mem_per_multicore + "'"}	~{"--min_depth " + min_depth}	~{true="--ignore_flags  " false="" ignore_flags}	~{true="--methyl_kit  " false="" methyl_kit}	~{true="--skip_trimming  " false="" skip_trimming}	~{true="--skip_deduplication  " false="" skip_deduplication}	~{true="--help  " false="" help}	~{"--publish_dir_mode '" + publish_dir_mode + "'"}	~{true="--validate_params  " false="" validate_params}	~{"--email_on_fail '" + email_on_fail + "'"}	~{true="--plaintext_email  " false="" plaintext_email}	~{"--max_multiqc_email_size '" + max_multiqc_email_size + "'"}	~{true="--monochrome_logs  " false="" monochrome_logs}	~{"--multiqc_config '" + multiqc_config + "'"}	~{"--tracedir '" + tracedir + "'"}	~{true="--show_hidden_params  " false="" show_hidden_params}	~{"--max_cpus " + max_cpus}	~{"--max_memory '" + max_memory + "'"}	~{"--max_time '" + max_time + "'"}	~{"--custom_config_version '" + custom_config_version + "'"}	~{"--custom_config_base '" + custom_config_base + "'"}	~{"--hostnames '" + hostnames + "'"}	~{"--config_profile_name '" + config_profile_name + "'"}	~{"--config_profile_description '" + config_profile_description + "'"}	~{"--config_profile_contact '" + config_profile_contact + "'"}	~{"--config_profile_url '" + config_profile_url + "'"}	-w ~{outputbucket}
	>>>
        
    output {
        File execution_trace = "pipeline_execution_trace.txt"
        Array[File] results = glob("results/*/*html")
    }
    runtime {
        docker: "truwl/nfcore-methylseq:1.6.1_0.1.0"
        memory: "2 GB"
        cpu: 1
    }
}
    