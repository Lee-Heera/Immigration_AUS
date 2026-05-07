********************************************************************************
** Do file that converts Census i.xls to cob`i'.dta for 2016 Census
** by Heera Lee, 2025.09.02.
********************************************************************************
clear all
set more off

cd "/Users/ihuila/Desktop/data/2025ABS/rawdata/2016"

forvalues i = 1(1)544 {
import excel using `i'.xls, sheet("T 08") clear
keep A
keep in 2
ren A lga_info
compress
gen LGA2016 = `i'
sort LGA2016
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

gen LGA2016 = `i'

sort LGA2016
merge m:1 LGA2016 using `lga'.dta
drop _merge

compress
save /Users/ihuila/Desktop/data/2025ABS/afterABS3/2016/cob`i'.dta, replace
}

