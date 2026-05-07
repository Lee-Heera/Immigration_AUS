clear all
set more off

*cd "C:\Users\jskim\Dropbox\Choon_Jun\Census1996\COBdta"
cd "D:\Dropbox\0_02_Jun_Research\ABS_Census\2016\COBdtas"

* LGA merge codes
import excel using "D:\Dropbox\0_02_Jun_Research\ABS_Census\LGA_new_crosswalk2001_2016\LGAFINAL_ALL_2021H.xlsx", sheet("LGA2016") first clear
sort LGA2016
tempfile lgacode
save `lgacode'.dta, replace

* Loop and append all LGAs' COB data
use cob1.dta, clear
ren A cob
replace cob = "Born elsewhere(e)" if (cob=="Iran" | cob=="Zimbabwe" | cob=="Pakistan" | cob=="Country of Birth not stated")
*additional
replace cob = "Born elsewhere(e)" if (cob=="Croatia" | cob=="The Former Yugoslav Republic of Macedonia"  | cob=="Malta" | cob=="Turkey")

collapse (sum) M1 F1 T1 M2 F2 T2 M3 F3 T3, by(LGA2016 lga_info cob)
tempfile all
save `all'.dta, replace

forvalues i = 2(1)544 {
	use cob`i'.dta, clear
	ren A cob
	replace cob = "Born elsewhere(e)" if (cob=="Iran" | cob=="Zimbabwe" | cob=="Pakistan" | cob=="Country of Birth not stated")
	replace cob = "Born elsewhere(e)" if (cob=="Croatia" | cob=="The Former Yugoslav Republic of Macedonia"  | cob=="Malta" | cob=="Turkey")
	collapse (sum) M1 F1 T1 M2 F2 T2 M3 F3 T3, by(LGA2016 lga_info cob)
	append using `all'.dta
	save `all'.dta, replace
}

* Merge in the consistent LGA codes
sort LGA2016
merge m:1 LGA2016 using `lgacode'.dta
tab _merge
drop _merge

save "TEMP_2011_from2016_v401.dta", replace

collapse (sum) M1 F1 T1 M2 F2 T2 M3 F3 T3, by(LGAFINAL21 cob)

drop if cob=="Total"

* fix cob names
replace cob = "Australia" if cob=="Australia(b)"
replace cob = "China" if cob=="China (excludes SARs and Taiwan)(c)"
replace cob = "Hong Kong" if cob=="Hong Kong (SAR of China)(c)"
replace cob = "United Kingdom" if cob=="United Kingdom, Channel Islands and Isle of Man(d)"
replace cob = "Born elsewhere" if cob=="Born elsewhere(e)"

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
replace countrycode = "VNM" if cob=="Vietnam"

ren T2 pop
keep cob LGAFINAL21 pop countrycode
gen year = 2011

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
save "COB2011_robust_from2016_v401.dta", replace


use "TEMP_2011_from2016_v401.dta", clear

collapse (sum) M1 F1 T1 M2 F2 T2 M3 F3 T3, by(LGAFINAL21_H cob)

drop if cob=="Total"

* fix cob names
replace cob = "Australia" if cob=="Australia(b)"
replace cob = "China" if cob=="China (excludes SARs and Taiwan)(c)"
replace cob = "Hong Kong" if cob=="Hong Kong (SAR of China)(c)"
replace cob = "United Kingdom" if cob=="United Kingdom, Channel Islands and Isle of Man(d)"
replace cob = "Born elsewhere" if cob=="Born elsewhere(e)"

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
replace countrycode = "VNM" if cob=="Vietnam"

ren T2 pop
keep cob LGAFINAL21_H  pop countrycode
gen year = 2011

* generate share_cob
* generate share_cob
gen pop_immi=pop
gen pop2=pop
replace pop_immi=. if cob=="Australia" | cob=="Born elsewhere"
replace pop2=. if cob=="Born elsewhere"
bysort LGAFINAL21_H : egen tot_pop = total(pop)
bysort LGAFINAL21_H : egen totimmi=total(pop_immi)
bysort LGAFINAL21_H : egen tot_pop2=total(pop2)
gen share_cob = pop/totimmi
gen share2_cob= pop/tot_pop2

* generate share of natives
gen totaus = pop if cob=="Australia"
gen pct_native = totaus/tot_pop

bysort LGAFINAL21_H : egen share_native = min(pct_native)
drop pct_native totaus

sort LGAFINAL21_H  cob
save "COB2011_robust_from2016_v401_LGAFINAL21_H.dta", replace
