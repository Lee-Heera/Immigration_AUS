clear all
set more off

cd "D:\Dropbox\0_02_Jun_Research\ABS_Census\2006"

forvalues i = 1(1)513 { 
import excel using `i'.xls, sheet("T 08") clear
keep A
keep in 2
ren A lga_info
compress
gen LGA2006 = `i'
sort LGA2006
tempfile lga
save `lga'.dta, replace

import excel using `i'.xls, sheet("T 08") clear

keep in 10/52
keep A B C D F G H J K L
drop if A==""

replace B = "" if B==".."
replace C = "" if C==".."
replace D = "" if D==".."
replace F = "" if F==".."
replace G = "" if G==".."
replace H = "" if H==".."
replace J = "" if J==".."
replace K = "" if K==".."
replace L = "" if L==".."

destring B C D F G H J K L, replace

ren B M1
ren C F1
ren D T1

ren F M2
ren G F2
ren H T2

ren J M3
ren K F3
ren L T3

gen LGA2006 = `i'

sort LGA2006
merge m:1 LGA2006 using `lga'.dta
drop _merge

compress
save ./COBdtas/cob`i'.dta, replace
}

forvalues i = 514(1)671 { 
import excel using `i'.xlsx, sheet("T 08") clear
keep A
keep in 2
ren A lga_info
compress
gen LGA2006 = `i'
sort LGA2006
tempfile lga
save `lga'.dta, replace

import excel using `i'.xlsx, sheet("T 08") clear

keep in 10/52
keep A B C D F G H J K L
drop if A==""

replace B = "" if B==".."
replace C = "" if C==".."
replace D = "" if D==".."
replace F = "" if F==".."
replace G = "" if G==".."
replace H = "" if H==".."
replace J = "" if J==".."
replace K = "" if K==".."
replace L = "" if L==".."

destring B C D F G H J K L, replace

ren B M1
ren C F1
ren D T1

ren F M2
ren G F2
ren H T2

ren J M3
ren K F3
ren L T3

gen LGA2006 = `i'

sort LGA2006
merge m:1 LGA2006 using `lga'.dta
drop _merge

compress
save ./COBdtas/cob`i'.dta, replace
}

