#!/bin/bash

# Daftar domain yang akan dipantau
domains=("example.com" "google.com" "facebook.com")

# Fungsi untuk memantau sertifikat SSL
monitor_ssl() {
  for domain in "${domains[@]}"; do
    echo "Domain: $domain"
    echo "------------------------------"
    echo "Informasi Sertifikat SSL:"
    echo "------------------------------"

    # Mendapatkan informasi sertifikat SSL menggunakan perintah openssl
    certificate_info=$(openssl s_client -connect "$domain":443 -servername "$domain" -showcerts 2>/dev/null | openssl x509 -noout -text)

    # Ekstrak dan tampilkan detail sertifikat
    subject=$(echo "$certificate_info" | awk -F 'subject=' '/subject=/ {print $2}')
    issuer=$(echo "$certificate_info" | awk -F 'issuer=' '/issuer=/ {print $2}')
    validity=$(echo "$certificate_info" | awk -F 'notBefore=' '/notBefore=/ {print "Mulai: " $2} ; /notAfter=/ {print "Hingga: " $2}')
    start_date=$(echo "$certificate_info" | awk -F 'notBefore=' '/notBefore=/ {print $2}')
    end_date=$(echo "$certificate_info" | awk -F 'notAfter=' '/notAfter=/ {print $2}')
    key_type=$(echo "$certificate_info" | awk '/Public Key Type:/ {print $4}')

    echo "Subjek: $subject"
    echo "Penerbit: $issuer"
    echo "Validitas: $validity"
    echo "Tanggal Mulai SSL: $start_date"
    echo "Tanggal Berakhir SSL: $end_date"
    echo "Tipe Kunci: $key_type"

    echo "------------------------------"
    echo
  done
}

# Panggil fungsi monitor_ssl
monitor_ssl
