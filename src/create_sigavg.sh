if [ -z "$1" ]; then
	printf "ERROR: No path provided!\n"
	exit 1
fi

cd "$1" || exit 1
for f in *.atr; do
	basename="$(basename "$f")"
	basename="${basename%.*}"

  sigavg -r "$basename" -a atr -p N -d -0.060 0.100 -t 14400 > "${basename}-avg-N.txt"
  printf "%s : %s\n" "$f" "${basename}-avg-N.txt"
  sigavg -r "$basename" -a atr -p V -d -0.060 0.100 > "${basename}-avg-V.txt"
  printf "%s : %s\n" "$f" "${basename}-avg-V.txt"
done
