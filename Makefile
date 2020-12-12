ZIP_CODES = 10027 10031

data/percentpositive-by-modzcta.csv: Makefile
	mkdir -p data
	curl -L https://raw.githubusercontent.com/nychealth/coronavirus-data/master/trends/$(notdir $@) | \
		csvcut -c week_ending,$(subst $(space),$(comma),$(strip $(addprefix PCTPOS_,$(ZIP_CODES)))) \
		> $@

null  :=
space := $(null) #
comma := ,