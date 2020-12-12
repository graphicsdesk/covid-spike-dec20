data/testrate-by-modzcta.csv:
	mkdir -p data
	curl -LO https://raw.githubusercontent.com/nychealth/coronavirus-data/master/trends/$@
