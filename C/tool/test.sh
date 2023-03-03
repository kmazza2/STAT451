cd ./test
num_tests=$(ls -1 | grep '.test$' | wc -l | tr -d ' ')
if [ ${num_tests} -ne 0 ]
then
	echo "TAP version 14"
	echo "1..${num_tests}"
	i=1
	for test in *.test
	do
		if ./${test}
		then
			echo "ok ${i} - ${test}"
		else
			echo "not ok ${i} - ${test}"
		fi
	i=$((i+1))
	done
else
	echo "Error: did you forget to run \`make'?" >&2
	exit 1
fi
