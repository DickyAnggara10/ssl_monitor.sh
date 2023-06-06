
domains=("youtube.com" "yahoo.com" "codingcollective.com")


monitor_ssl() {
  for domain in "${domains[@]}"; do
    echo "Domain: $domain"
    echo "------------------------------"


    certificate_info=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -text)

    if [[ -n "$certificate_info" ]]; then
      echo "Informasi Sertifikat SSL:"
      echo "------------------------------"
      echo "$certificate_info"

 
      expiry_date=$(echo "$certificate_info" | awk -F "Not After : " '{print $2}')
      expiry_timestamp=$(date -d "$expiry_date" +%s)
      current_timestamp=$(date +%s)
      expiry_days=$(( (expiry_timestamp - current_timestamp) / 86400 ))

  
      echo "Tanggal Kedaluwarsa: $expiry_days hari"
    else
      echo "Sertifikat SSL tidak ditemukan."
    fi

    echo "------------------------------"
    echo
  done
}


monitor_ssl
