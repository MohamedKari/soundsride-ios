GCP_API_KEY=$(cat GCP_API_KEY)
curl \
"https://maps.googleapis.com/maps/api/directions/json?\
origin=51.44884518463667,6.973410280988168\
&destination=51.4486026860226,6.973455426507329\
&mode=DRIVING\
&departure_time=now\
&traffic_model=best_guess\
&key=$GCP_API_KEY"