if [ -z "$1" ]; then
	printf "ERROR: No path provided!\n"
	exit 1
fi

cd "$1"
for f in *.atr; do
	basename="$(basename "$f")"
	basename="${basename%.*}"

  rdann -r "$basename" -a atr -p N V > "${basename}-fatr.txt"
  wrann -r "$basename" -a fatr < "${basename}-fatr.txt"
	printf "%s : %s\n" "$f" "$basename"
done
