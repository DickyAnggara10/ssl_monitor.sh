
domains=("youtube.com" "google.com" "codingcollective.com")

for domain in "${domains[@]}"
do

    output=$(echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -text)
    

    if [[ $? -eq 0 ]]; then
        # Ekstrak informasi yang relevan dari output
        subject=$(echo "$output" | grep -A 1 "Subject:" | tail -n 1 | awk '{$1=$1;print}')
        issuer=$(echo "$output" | grep -A 1 "Issuer:" | tail -n 1 | awk '{$1=$1;print}')
        start_date=$(echo "$output" | grep -i "not before" | awk -F= '{print $2}')
        end_date=$(echo "$output" | grep -i "not after" | awk -F= '{print $2}')
        key_type=$(echo "$output" | grep -i "Public Key Type:" | awk '{$1=$1;print}')
        provider=$(echo "$output" | grep -A 1 "CA Issuers" | tail -n 1 | awk '{$1=$1;print}')
        

        echo "Domain: $domain"
        echo "Subject: $subject"
        echo "Issuer: $issuer"
        echo "SSL Start Date: $start_date"
        echo "SSL End Date: $end_date"
        echo "Key Type: $key_type"
        echo "Certificate Provider: $provider"
        echo "---------------------------"
    else
        echo "Tidak dapat menghubungi domain: $domain"
        echo "---------------------------"
    fi
done
