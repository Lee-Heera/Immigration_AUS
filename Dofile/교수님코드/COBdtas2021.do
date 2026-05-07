********************************************************************************
** Do file that converts Census i.xls to cob`i'.dta for 2021 Census
** by Jun Sung Kim on Nov 13, 2023
********************************************************************************
clear all
set more off

cd "D:\Dropbox\0_02_Jun_Research\ABS_Census\2021"

forvalues i = 1(1)547 {
import excel using `i'.xlsx, sheet("T08") clear
keep A
keep in 2
ren A lga_info
compress
gen LGA2021 = `i'
sort LGA2021
tempfile lga
save `lga'.dta, replace

import excel using `i'.xlsx, sheet("T08") clear

keep in 11/47
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

drop if B==. & C==. & D==. & F==. & G==. & H==. & J==. & K==. & L==.

ren B M1
ren C F1
ren D T1

ren F M2
ren G F2
ren H T2

ren J M3
ren K F3
ren L T3

gen LGA2021 = `i'

sort LGA2021
merge m:1 LGA2021 using `lga'.dta
drop _merge

compress
save ./COBdtas/cob`i'.dta, replace
}

