####################
# Makefile

ROOT_DIR = ./

GATHER_DIR = $(ROOT_DIR)gather/
GATHERED_DIR = $(ROOT_DIR)gathered/
GATHER_SOURCE = $(wildcard $(GATHER_DIR)*.Rmd)
GATHERED = $(patsubst $(GATHER_DIR)%.Rmd, $(GATHERED_DIR)%.rda, $(GATHER_SOURCE))

COOK_DIR = $(ROOT_DIR)cook/
COOKED_DIR = $(ROOT_DIR)cooked/
COOK_SOURCE = $(wildcard $(COOK_DIR)*.Rmd)
COOKED = $(patsubst $(COOK_DIR)%.Rmd, $(COOKED_DIR)%.rda, $(COOK_SOURCE))

PRESENT_SOURCE = $(wildcard *.Rmd)
PRESENTED = $(patsubst %.Rmd, %.html, $(PRESENT_SOURCE))

KNIT = Rscript -e "rmarkdown::render('$<')"
GATHER = Rscript -e "rmarkdown::render('$(<:.sql=.Rmd)', output_dir = '$(GATHERED_DIR)')"
COOK = Rscript -e "rmarkdown::render('$<', output_dir = '$(COOKED_DIR)')"
PRESENT = Rscript -e "rmarkdown::render_site('$<')"

#///////////////////////////////////////////////////
## M A I N   R E C I P E
all: $(GATHERED) $(COOKED) $(PRESENTED)

## End Main recipe
##==================================================

#///////////////////////////////////////////////////
## O N L Y  C O O K
no_gather: $(COOKED)

## End no_gather
##==================================================

#///////////////////////////////////////////////////
## G A T H E R
$(GATHER_DIR)%.Rmd:$(GATHER_DIR)%.sql
	@echo =============================================
	@echo == SQL updated for $(@:.Rmd=.)
	@echo =============================================
	touch $@

$(GATHERED_DIR)%.rda:$(GATHER_DIR)%.Rmd
	@echo =============================================
	@echo == Working on $(<:.Rmd=.)
	@echo =============================================
	$(GATHER)

## End Gather
##==================================================

#///////////////////////////////////////////////////
# C O O K
$(COOKED_DIR)%.rda:$(COOK_DIR)%.Rmd $(GATHERED)
	@echo =============================================
	@echo == Working on $(<:.Rmd=.)
	@echo =============================================
	$(COOK)

## End Cook
##==================================================

#///////////////////////////////////////////////////
# P R E S E N T
%.html:%.Rmd $(COOKED)
	@echo =============================================
	@echo == Working on $(<:.Rmd=.)
	@echo =============================================
	$(PRESENT)

## End Cook
##==================================================


clean:
	rm -fv $(GATHERED_DIR)/*.rda
	rm -fv $(COOKED_DIR)/*.rda