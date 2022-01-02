if [ -z "$1" ]; then
	printf "ERROR: No path provided!\n"
	exit 1
fi

if [ -z "$2" ]; then
    printf "ERROR: No average sampling time provided!\n"
    exit 1
fi

cd "$1" || exit 1
for f in *.atr; do
	basename="$(basename "$f")"
	basename="${basename%.*}"

  sigavg -r "$basename" -a atr -p N -d -0.0417 0.0695 -t $2 > "${basename}-avg-N-${2}.txt"
  printf "%s : %s\n" "$f" "${basename}-avg-N-${2}.txt"
  sigavg -r "$basename" -a atr -p V -d -0.0417 0.0695 > "${basename}-avg-V-${2}.txt"
  printf "%s : %s\n" "$f" "${basename}-avg-V-${2}.txt"
done
