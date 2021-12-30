if [ -z "$1" ]; then
	printf "ERROR: No path provided!\n" 
	exit 1
fi

tmp="$(pwd)"

FILES="$1"
cd "$FILES" || exit 1

rm -f eval1.txt
rm -f eval2.txt

for f in *.cls; do
	basename=$(basename "$f")
	basename="${basename%.*}"

	printf "%s : %s\n" "$f" "$basename"

	wrann -r "$basename" -a qrs <"$f"
	bxb -r "$basename" -a fatr qrs -l eval1.txt eval2.txt
done

sumstats eval1.txt eval2.txt >"${tmp}/results.txt"