data/columbia-testing.json: assets/COLUMBIA_SURVEILLANCE_TESTING_RESULTS_-_Sheet1.csv Makefile ./process/clean-columbia-results.js
	mkdir -p data
	csvjson $< | \
		./process/clean-columbia-results.js > \
		$@

ZIP_CODES = 10027 10031

data/percentpositive-by-modzcta.json: Makefile
	mkdir -p data
	curl -L https://raw.githubusercontent.com/nychealth/coronavirus-data/master/trends/$(basename $(notdir $@)).csv | \
		csvcut -c week_ending,$(subst $(space),$(comma),$(strip $(addprefix PCTPOS_,$(ZIP_CODES)))) | \
		csvjson \
		> $@

null  :=
space := $(null) #
comma := ,

clean:
	rm -rf data