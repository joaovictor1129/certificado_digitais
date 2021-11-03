# Executa um laço de repetição em cada url e nos traz a data de expiração dos certificados.

certificados="$(

for lista in $(cat uif) 
do
 echo "A url é: $lista" && \
 echo " " | openssl s_client -servername $lista -connect $lista:443 2>/dev/null | \
 openssl x509 -noout -issuer -subject -dates 2>/dev/null && \
 echo -e "\n"
done
)"

#echo "$certificados"

# Realiza a ordenação dos certicados por meses

meses="Jan\nFeb\nMar\nApr\nMay\nJun\nJul\nAug\nSep\nOct\nNov\nDec"

ord_mes="$(
for data in $(echo -e $meses)
do 
  echo "$certificados" | \
  grep -B4 notAfter="$data" && echo -e " "
done
)"

# Verifica os proximos 2 meses

mes_atual=$(date +%b)
prox_mes=$(date +%b --date '+1 month')
noventa_dias=$(date +%b --date '+2 month')

# Exibe a saida ordenada por meses

echo "-- Certificados deste mes ($mes_atual) ---" && echo " " && echo "$ord_mes" | grep -B5 notAfter="$mes_atual" && echo -e "\n"
echo "-- Certificados próximo mes ($prox_mes) ---" && echo " " && echo "$ord_mes" | grep -B5 notAfter="$prox_mes" && echo -e "\n"
echo "-- Certificados dos próximos 90 dias ($noventa_dias) ---"  && echo "$ord_mes" | grep -B5 notAfter="$noventa_dias"
