**importing excel dataset before startin commands 
**Encodeing of categorical variables to be able to use it in regression
**# Bookmark #13
encode Club, gen(clubnames)
drop Club 
encode Ownership, gen (ownerstructure)
drop Ownership
encode Nationality, gen(nation)
drop Nationality

**Creating individual variables for the different ownershipstructures
*Check the values of the variabkes after the encoding of variables
*May not be neccessary in the main model but can be used for individual modesl
gen member= ownerstructure==1
gen mixedmodel= ownerstructure==2
gen Privforinv= ownerstructure==3
gen privdominv= ownerstructure==4

**Order clubs and year
**# Bookmark #10
order clubnames Year


**Label the stock exchange variable
**# Bookmark #9
label define Stockexch 1 "Listed at stock exchange" 0 "Not listed at stock exchange"
label values Stockexch Stockexch 

label variable member "Member association"
label variable mixedmodel "Mixed model of members and investors"
label variable Privforinv "Private foreign majority investor"
label variable privdominv "Private domestic majority investor"

**Establish dataset as panel data with "Club" as section identifier and "Year" as time identifier
**# Bookmark #8
xtset clubnames Year

**# Bookmark #3
**converting observations that are 0 to missing values 
mvdecode Attendance, mv(0)
mvdecode ELORating, mv(0)
mvdecode Revenue, mv(0)
mvdecode Fixedassets, mv(0)
mvdecode Socialmedia, mv(0)
mvdecode Squadvalue, mv(0)
mvdecode Wages, mv(0)

**Generate variable operating profits with transfer balance
gen oper_prof_trans = Operatingprofits + TransferBalance
label variable oper_prof_trans "Operating profits including transfer balance"

**Summary of means based on the different ownership structures and nation - Descriptive statistics 
bys ownerstructure: sum Operatingprofits oper_prof_trans Wages Socialmedia ELORating
bys Stockexch: sum Operatingprofits oper_prof_trans Wages Socialmedia ELORating



//Sport performance 
*Regression with all four ownership categories
xtreg ELORating Wages member i.Stockexch i.nation, robust
xtreg ELORating Wages mixedmodel i.Stockexch i.nation, robust
xtreg ELORating Wages Privforinv i.Stockexch i.nation, robust
xtreg ELORating Wages privdominv i.Stockexch i.nation, robust
xtreg ELORating Wages i.ownerstructure i.Stockexch i.nation, robust

**Run wit asdoc to export to word
asdoc xtreg ELORating Wages member i.Stockexch i.nation, robust
asdoc xtreg ELORating Wages mixedmodel i.Stockexch i.nation, robust
asdoc xtreg ELORating Wages Privforinv i.Stockexch i.nation, robust
asdoc xtreg ELORating Wages privdominv i.Stockexch i.nation, robust
asdoc xtreg ELORating Wages i.ownerstructure i.Stockexch i.nation, robust

// Financial performance regressions
**Excluding player trading
xtreg Operatingprofits Wages Socialmedia member i.Stockexch i.nation, robust
xtreg Operatingprofits Wages Socialmedia mixedmodel i.Stockexch i.nation, robust
xtreg Operatingprofits Wages Socialmedia Privforinv i.Stockexch i.nation, robust
xtreg Operatingprofits Wages Socialmedia privdominv i.Stockexch i.nation, robust
xtreg Operatingprofits Wages Socialmedia i.ownerstructure i.Stockexch i.nation, robust

** Including player trading
xtreg oper_prof_trans Wages Socialmedia member i.Stockexch i.nation, robust
xtreg oper_prof_trans Wages Socialmedia mixedmodel i.Stockexch i.nation, robust
xtreg oper_prof_trans Wages Socialmedia Privforinv i.Stockexch i.nation, robust
xtreg oper_prof_trans Wages Socialmedia privdominv i.Stockexch i.nation, robust
xtreg oper_prof_trans Wages Socialmedia i.ownerstructure i.Stockexch i.nation, robust

**for exporting to word - asdoc is applied





//Tests for choice of model, collinearity, and heteroskedasticity

*test for choosing between pooled OLS and random effects 
quietly xtreg ELORating Wages i.ownerstructure i.Stockexch i.nation, re 
xttest0 

quietly xtreg Operatingprofits Wages Socialmedia i.ownerstructure i.Stockexch i.nation, re 
xttest0 

quietly xtreg oper_prof_trans Wages Socialmedia i.ownerstructure i.Stockexch i.nation, re
xttest0
** the resutls of tests shows that the random effects GLS model is appropriate to use as the Prob > chi2 = 0,000


**Colinearity test (Run with asdoc for export to word)
pwcorr ELORating Operatingprofits oper_prof_trans Wages Socialmedia nation member mixedmodel Privforinv privdominv

*Vif tests are runed after eached regression
vif, uncentered 


**Breusch-Pagan test for heteroskedasticity - run after rehressions
*Sport performance model
reg ELORating Wages member i.Stockexch i.nation
estat hettest 
reg ELORating Wages member i.Stockexch i.nation
estat hettest
reg ELORating Wages mixedmodel i.Stockexch i.nation
estat hettest
reg ELORating Wages Privforinv i.Stockexch i.nation
estat hettest
reg ELORating Wages privdominv i.Stockexch i.nation
estat hettest
reg ELORating Wages i.ownerstructure i.Stockexch i.nation
estat hettest

*Financial performance model (excluding player trading)
reg Operatingprofits Wages Socialmedia member i.Stockexch i.nation
estat hettest
reg Operatingprofits Wages Socialmedia mixedmodel i.Stockexch i.nation
estat hettest
reg Operatingprofits Wages Socialmedia Privforinv i.Stockexch i.nation
estat hettest
reg Operatingprofits Wages Socialmedia privdominv i.Stockexch i.nation
estat hettest
reg Operatingprofits Wages Socialmedia i.ownerstructure i.Stockexch i.nation
estat hettest
*Including player trading 
reg oper_prof_trans Wages Socialmedia member i.Stockexch i.nation
estat hettest
reg oper_prof_trans Wages Socialmedia mixedmodel i.Stockexch i.nation
estat hettest
reg oper_prof_trans Wages Socialmedia Privforinv i.Stockexch i.nation
estat hettest
reg oper_prof_trans Wages Socialmedia privdominv i.Stockexch i.nation
estat hettest
reg oper_prof_trans Wages Socialmedia i.ownerstructure i.Stockexch i.nation
estat hettest
