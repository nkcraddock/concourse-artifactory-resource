request_payload=$(mktemp $TMPDIR/artifactory-resource-request.XXXXXX)

cat > $request_payload <&0

url=$(jq -r '.source.url // ""' < $request_payload)
if [ -z "$url" ]; then
	echo "invalid request (missing url)"
	exit 1
fi

path=$(jq -r '.source.path // ""' < $request_payload)
if [ -z "$path" ]; then
	echo "invalid request (missing path)"
	exit 1
fi

user=$(jq -r '.source.user // ""' < $request_payload)
if [ -z "$user" ]; then
	echo "invalid request (missing user)"
	exit 1
fi

password=$(jq -r '.source.password // ""' < $request_payload)
if [ -z "$password" ]; then
	echo "invalid request (missing password)"
	exit 1
fi

regexp=$(jq -r '.source.regexp // ""' < $request_payload)
if [ -z "$regexp" ]; then
	echo "invalid request (missing regexp)"
	exit 1
fi

jfrog_args="--url=$url --user=$user --password=$password"

