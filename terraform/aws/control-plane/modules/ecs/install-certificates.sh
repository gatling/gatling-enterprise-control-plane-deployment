set -e

# Decode base64-encoded certificates from environment variable and extract PEM blocks
printf %s "$CUSTOM_CA_CERTIFICATES_B64" | base64 -d | awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/' > "$CUSTOM_CA_FILE_PATH"

# Split PEM chain into individual certificate files
tmpdir=$(mktemp -d)
cert_prefix="$tmpdir/cert-"
cert_suffix=".pem"

# Write a new certificate file per certificate
# Mandatory for import in default JVM truststore
awk '
/-----BEGIN CERTIFICATE-----/ { n++; collecting=1 }
collecting { print > "'"$cert_prefix"'" n "'"$cert_suffix"'" }
/-----END CERTIFICATE-----/ { collecting=0 }
' "$CUSTOM_CA_FILE_PATH"

# Import each certificate into the default JVM truststore
count=0
for cert in "$cert_prefix"*"$cert_suffix"; do
    [ -f "$cert" ] || continue
    count=$((count + 1))

    keytool -importcert -noprompt \
      -alias "custom-ca-$count" \
      -file "$cert" \
      -keystore "$JAVA_HOME/lib/security/cacerts" \
      -storepass changeit \
      2>/dev/null || true
done

# Copy updated truststore to shared volume
cp -R "$JAVA_HOME/lib/security/." /shared-java-security/

# Cleanup
rm -rf "$tmpdir"

echo "✓ Successfully imported $count custom CA certificate(s)"