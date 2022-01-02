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

sumstats eval1.txt eval2.txt >"${tmp}/../results.txt"
read -r -a results <<< "$(tac "${tmp}/../results.txt" | sed '6q;d')"

tp=${results[1]}
fp=${results[2]}
fn=${results[5]}
tn=${results[6]}

sensitivity="$(bc <<< "scale=3; ${tp}/(${tp}+${fn})")"
specificity="$(bc <<< "scale=3; ${tn}/(${tn}+${fp})")"
precision="$(bc <<< "scale=3; ${tp}/(${tp}+${fp})")"
neg_predictivity="$(bc <<< "scale=3; ${tn}/(${tn}+${fn})")"

printf "Sensitivity (Se): %s\nSpecificity(Sp): %s\nPrecision(+P): %s\nNegative predictivity(-P): %s\n" "$sensitivity" "$specificity" "$precision" "$neg_predictivity"
printf "Sensitivity (Se): %s\nSpecificity(Sp): %s\nPrecision(+P): %s\nNegative predictivity(-P): %s\n" "$sensitivity" "$specificity" "$precision" "$neg_predictivity" >> "${tmp}/../results.txt"


