clear all
set more off

cd "D:\Dropbox\0_02_Jun_Research\ABS_Census\2006\COBdtas"

* LGA merge codes
import excel using "D:\Dropbox\0_02_Jun_Research\ABS_Census\LGA_new_crosswalk2001_2016\LGAFINAL_ALL_2021H.xlsx", sheet("LGA2006") first clear
sort LGA2006
tempfile lgacode
save `lgacode'.dta, replace

* Loop and append all LGAs' COB data
use cob1.dta, clear
ren A cob
replace cob = "Born elsewhere(f)" if (cob=="Bosnia and Herzegovina" | cob=="Papua New Guinea" | cob=="South Eastern Europe, nfd(d)" | cob=="Yugoslavia, Federal Republic of(d)" | cob=="Yugoslavia, Former nfd(d)" | cob=="Country of birth not stated")
* Additional cob drop
replace cob = "Born elsewhere(f)" if (cob=="Croatia" | cob=="Former Yugoslav Republic of Macedonia (FYROM)" | cob=="Malta" | cob=="Turkey" )

collapse (sum) M1 F1 T1 M2 F2 T2 M3 F3 T3, by(LGA2006 lga_info cob)
tempfile all
save `all'.dta, replace

forvalues i = 2(1)671 {
	use cob`i'.dta, clear
	ren A cob
	replace cob = "Born elsewhere(f)" if (cob=="Bosnia and Herzegovina" | cob=="Papua New Guinea" | cob=="South Eastern Europe, nfd(d)" | cob=="Yugoslavia, Federal Republic of(d)" | cob=="Yugoslavia, Former nfd(d)" | cob=="Country of birth not stated")
	replace cob = "Born elsewhere(f)" if (cob=="Croatia" | cob=="Former Yugoslav Republic of Macedonia (FYROM)" | cob=="Malta" | cob=="Turkey" )
	collapse (sum) M1 F1 T1 M2 F2 T2 M3 F3 T3, by(LGA2006 lga_info cob)
	append using `all'.dta
	save `all'.dta, replace
}

save "TEMP_1996_from2006_v401.dta", replace

* Merge in the consistent LGA codes
sort LGA2006
merge m:1 LGA2006 using `lgacode'.dta
tab _merge
drop _merge

collapse (sum) M1 F1 T1 M2 F2 T2 M3 F3 T3, by(LGAFINAL21 cob)

drop if cob=="Total" | cob=="Overseas visitors"

* fix cob names
replace cob = "China" if cob=="China (excl. SARs and Taiwan Province)(b)"
replace cob = "Hong Kong" if cob=="Hong Kong (SAR of China)(b)"
replace cob = "Indonesia" if cob=="Indonesia(c)"
*replace cob = "FYROM" if cob=="Former Yugoslav Republic of Macedonia (FYROM)"
replace cob = "United Kingdom" if cob=="United Kingdom(e)"
replace cob = "Born elsewhere" if cob=="Born elsewhere(f)"

* generate country code
gen countrycode = "AUS" if cob=="Australia"
replace countrycode = "CAN" if cob=="Canada"
replace countrycode = "CHN" if cob=="China"
replace countrycode = "EGY" if cob=="Egypt"
replace countrycode = "FJI" if cob=="Fiji"
replace countrycode = "DEU" if cob=="Germany"
replace countrycode = "GRC" if cob=="Greece"
replace countrycode = "HKG" if cob=="Hong Kong"
replace countrycode = "IND" if cob=="India"
replace countrycode = "IDN" if cob=="Indonesia"
replace countrycode = "IRQ" if cob=="Iraq"
replace countrycode = "IRL" if cob=="Ireland"
replace countrycode = "ITA" if cob=="Italy"
replace countrycode = "JPN" if cob=="Japan"
replace countrycode = "KOR" if cob=="Korea, Republic of (South)"
replace countrycode = "LBN" if cob=="Lebanon"
replace countrycode = "MYS" if cob=="Malaysia"
*replace countrycode = "MLT" if cob=="Malta"
replace countrycode = "NLD" if cob=="Netherlands"
replace countrycode = "NZL" if cob=="New Zealand"
replace countrycode = "PHL" if cob=="Philippines"
replace countrycode = "POL" if cob=="Poland"
replace countrycode = "SGP" if cob=="Singapore"
replace countrycode = "ZAF" if cob=="South Africa"
replace countrycode = "LKA" if cob=="Sri Lanka"
replace countrycode = "THA" if cob=="Thailand"
*replace countrycode = "TUR" if cob=="Turkey"
replace countrycode = "GBR" if cob=="United Kingdom"
replace countrycode = "USA" if cob=="United States of America"
replace countrycode = "VNM" if cob=="Viet Nam"

ren T1 pop
keep cob LGAFINAL21 pop countrycode
gen year = 1996

* generate share_cob
* generate share_cob
gen pop_immi=pop
gen pop2=pop
replace pop_immi=. if cob=="Australia" | cob=="Born elsewhere"
replace pop2=. if cob=="Born elsewhere"
bysort LGAFINAL21: egen tot_pop = total(pop)
bysort LGAFINAL21: egen totimmi=total(pop_immi)
bysort LGAFINAL21: egen tot_pop2=total(pop2)
gen share_cob = pop/totimmi
gen share2_cob= pop/tot_pop2

* generate share of natives
gen totaus = pop if cob=="Australia"
gen pct_native = totaus/tot_pop

bysort LGAFINAL21: egen share_native = min(pct_native)
drop pct_native totaus

sort LGAFINAL21 cob
save "COB1996_robust_from2006_v401.dta", replace


use "TEMP_1996_from2006_v401.dta", clear

* Merge in the consistent LGA codes
sort LGA2006
merge m:1 LGA2006 using `lgacode'.dta
tab _merge
drop _merge

collapse (sum) M1 F1 T1 M2 F2 T2 M3 F3 T3, by(LGAFINAL21_H cob)

drop if cob=="Total" | cob=="Overseas visitors"

* fix cob names
replace cob = "China" if cob=="China (excl. SARs and Taiwan Province)(b)"
replace cob = "Hong Kong" if cob=="Hong Kong (SAR of China)(b)"
replace cob = "Indonesia" if cob=="Indonesia(c)"
*replace cob = "FYROM" if cob=="Former Yugoslav Republic of Macedonia (FYROM)"
replace cob = "United Kingdom" if cob=="United Kingdom(e)"
replace cob = "Born elsewhere" if cob=="Born elsewhere(f)"

* generate country code
gen countrycode = "AUS" if cob=="Australia"
replace countrycode = "CAN" if cob=="Canada"
replace countrycode = "CHN" if cob=="China"
replace countrycode = "EGY" if cob=="Egypt"
replace countrycode = "FJI" if cob=="Fiji"
replace countrycode = "DEU" if cob=="Germany"
replace countrycode = "GRC" if cob=="Greece"
replace countrycode = "HKG" if cob=="Hong Kong"
replace countrycode = "IND" if cob=="India"
replace countrycode = "IDN" if cob=="Indonesia"
replace countrycode = "IRQ" if cob=="Iraq"
replace countrycode = "IRL" if cob=="Ireland"
replace countrycode = "ITA" if cob=="Italy"
replace countrycode = "JPN" if cob=="Japan"
replace countrycode = "KOR" if cob=="Korea, Republic of (South)"
replace countrycode = "LBN" if cob=="Lebanon"
replace countrycode = "MYS" if cob=="Malaysia"
*replace countrycode = "MLT" if cob=="Malta"
replace countrycode = "NLD" if cob=="Netherlands"
replace countrycode = "NZL" if cob=="New Zealand"
replace countrycode = "PHL" if cob=="Philippines"
replace countrycode = "POL" if cob=="Poland"
replace countrycode = "SGP" if cob=="Singapore"
replace countrycode = "ZAF" if cob=="South Africa"
replace countrycode = "LKA" if cob=="Sri Lanka"
replace countrycode = "THA" if cob=="Thailand"
*replace countrycode = "TUR" if cob=="Turkey"
replace countrycode = "GBR" if cob=="United Kingdom"
replace countrycode = "USA" if cob=="United States of America"
replace countrycode = "VNM" if cob=="Viet Nam"

ren T1 pop
keep cob LGAFINAL21_H pop countrycode
gen year = 1996

* generate share_cob
* generate share_cob
gen pop_immi=pop
gen pop2=pop
replace pop_immi=. if cob=="Australia" | cob=="Born elsewhere"
replace pop2=. if cob=="Born elsewhere"
bysort LGAFINAL21_H: egen tot_pop = total(pop)
bysort LGAFINAL21_H: egen totimmi=total(pop_immi)
bysort LGAFINAL21_H: egen tot_pop2=total(pop2)
gen share_cob = pop/totimmi
gen share2_cob= pop/tot_pop2

* generate share of natives
gen totaus = pop if cob=="Australia"
gen pct_native = totaus/tot_pop

bysort LGAFINAL21_H: egen share_native = min(pct_native)
drop pct_native totaus

sort LGAFINAL21_H cob
save "COB1996_robust_from2006_v401_LGAFINAL21_H.dta", replace
