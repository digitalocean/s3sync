#!/bin/bash
set -ueo pipefail

ME=$(basename "$0")
S3_PATH="${S3_PATH:-s3://${AWS_BUCKET_NAME}/}"
S3_ENDPOINT="${S3_ENDPOINT:-}"

download() {
	aws s3 sync \
		"${S3_PATH}" \
		"${LOCAL_DIR}" \
		--endpoint="${S3_ENDPOINT}" \
		--delete

	# fix any permissions issues
	chmod -vR a=rwx "${LOCAL_DIR}"
}

upload() {
	aws s3 sync \
		"${LOCAL_DIR}" \
		"${S3_PATH}" \
		--endpoint="${S3_ENDPOINT}" \
		--delete
}

watch_upload() {
	inotifywait -mr "${LOCAL_DIR}" -e create -e delete -e move -e modify --format '%w%f %e' | \
	while read -r file _ ; do
		# ignore sqlite tmp files
		if [[ "${file}" =~ \.db-(journal|wal|shm)$ ]]; then
			continue
		fi
		# sleeping before execution to accumulate any other file changes...
		sleep 5
		upload
	done
}

main() {
	case "${1}" in
		download)
			download
			;;
		upload)
			watch_upload
			;;
		help|--help|-h)
			cat <<-EOF
			Usage: ${ME} [command]

			Commands:
			  upload - watch for changes in LOCAL_DIR and sync LOCAL_DIR to S3
			  download - download all remote files to LOCAL_DIR and exit
			EOF
			exit 0
			;;
		*)
			echo "$(date -u): Unknown command: ${1}" > /dev/stderr
			exit 1
			;;
	esac
}


main "$@"
