********************************************************************************
** Do file that converts Census i.xls to cob`i'.dta for 2001 Census
** by Jun Sung Kim on Nov 19, 2021
********************************************************************************
clear all
set more off

cd "D:\Dropbox\0_02_Jun_Research\ABS_Census\2001"

forvalues i = 1(1)625 {
import excel using `i'.xls, sheet("T 07A") clear
keep A
keep in 2
ren A lga_info
compress
gen LGA2001 = `i'
sort LGA2001
tempfile lga
save `lga'.dta, replace

import excel using `i'.xls, sheet("T 07A") clear

keep in 10/37
keep A B C D F G H J K L
drop if A==""

replace B = "" if B==".."
replace B ="" if B=="n.a."
replace C = "" if C==".."
replace C ="" if C=="n.a."
replace D = "" if D==".."
replace D ="" if D=="n.a."
replace F = "" if F==".."
replace F ="" if F=="n.a."
replace G = "" if G==".."
replace G ="" if G=="n.a."
replace H = "" if H==".."
replace H ="" if H=="n.a."
replace J = "" if J==".."
replace J ="" if J=="n.a."
replace K = "" if K==".."
replace K ="" if K=="n.a."
replace L = "" if L==".."
replace L ="" if L=="n.a."

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

gen LGA2001 = `i'

sort LGA2001

tempfile lgat
save `lgat'.dta, replace

import excel using `i'.xls, sheet("T 07B") clear

keep in 10/38
keep A B C D F G H J K L
drop if A==""

replace B = "" if B==".."
replace B ="" if B=="n.a."
replace C = "" if C==".."
replace C ="" if C=="n.a."
replace D = "" if D==".."
replace D ="" if D=="n.a."
replace F = "" if F==".."
replace F ="" if F=="n.a."
replace G = "" if G==".."
replace G ="" if G=="n.a."
replace H = "" if H==".."
replace H ="" if H=="n.a."
replace J = "" if J==".."
replace J ="" if J=="n.a."
replace K = "" if K==".."
replace K ="" if K=="n.a."
replace L = "" if L==".."
replace L ="" if L=="n.a."

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

gen LGA2001 = `i'
sort LGA2001

append using `lgat'.dta

merge m:1 LGA2001 using `lga'.dta
drop _merge

compress

*cd "D:\Dropbox\Solar_HP_New\Census2001\COBdata"

save ./COBdtas/cob`i'.dta, replace
}

