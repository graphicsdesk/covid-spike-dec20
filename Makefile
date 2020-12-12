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