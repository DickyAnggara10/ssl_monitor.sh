domains=("youtube.com" "google.com" "codingcollective.com")

monitor_ssl() {
  for domain in "${domains[@]}"; do
    echo "Domain: $domain"
    echo "------------------------------"
    echo "Informasi Sertifikat SSL:"
    echo "------------------------------"


    certificate_info=$(openssl s_client -connect "$domain":443 -servername "$domain" -showcerts </dev/null 2>/dev/null | openssl x509 -noout -text)

    echo "$certificate_info"

    echo "------------------------------"
    echo
  done
}


monitor_ssl
