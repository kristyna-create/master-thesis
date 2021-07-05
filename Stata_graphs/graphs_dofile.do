cd "C:\Users\Kristyna\Disk Google\Diplomka\Code_data_revision\Stata_graphs"


import excel "gamma_small.xlsx", sheet("Sheet1") clear

rename A yearlab
rename B gamma_small
drop C
destring, replace force
compress

replace gamma_small = -150 if gamma_small == 1.000e-10
replace gamma_small = 700 if gamma_small == 1.000e-5
replace gamma_small = 1600 if gamma_small == 0.001
replace gamma_small = 3000 if gamma_small == 0.005
replace gamma_small = 5000 if gamma_small == 0.01
replace gamma_small = 8000 if gamma_small == 0.05
replace gamma_small = 12000 if gamma_small == 0.1

line gamma_small yearlab, lcolor(gs0) lpattern(solid) ylabel(-150 "10{superscript:-10}" 700 "10{superscript:-5}" 1600 "0.001" 3000 "0.005" 5000 "0.01" 8000 "0.05" 12000 "0.1", labsize(3) angle(0)) ///
xlabel(2002(3)2017,labsize(3)) ytitle("", size(3)) xtitle("", size(3)) aspect(0.4, placement(top))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\gamma_small.pdf", as(pdf) replace


import excel "gamma_medium.xlsx", sheet("Sheet1") clear

rename A yearlab
rename B gamma_medium
destring, replace force
compress

replace gamma_medium = -150 if gamma_medium == 1.000e-10
replace gamma_medium = 700 if gamma_medium == 1.000e-5
replace gamma_medium = 1600 if gamma_medium == 0.001
replace gamma_medium = 3000 if gamma_medium == 0.005
replace gamma_medium = 5000 if gamma_medium == 0.01
replace gamma_medium = 8000 if gamma_medium == 0.05
replace gamma_medium = 12000 if gamma_medium == 0.1

line gamma_medium yearlab, lcolor(gs0) lpattern(solid) ylabel(-150 "10{superscript:-10}" 700 "10{superscript:-5}" 1600 "0.001" 3000 "0.005" 5000 "0.01" 8000 "0.05" 12000 "0.1", labsize(3) angle(0)) ///
xlabel(2002(3)2017,labsize(3)) ytitle("", size(3)) xtitle("", size(3)) aspect(0.4, placement(top))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\gamma_medium.pdf", as(pdf) replace



import excel "gamma_large.xlsx", sheet("Sheet1") clear

rename A yearlab
rename B gamma_large
destring, replace force



replace gamma_large = 1.000e-4 if gamma_large == 1.000e-5

/*
replace gamma_large = 1500 if gamma_large == 0.005
replace gamma_large = 3000 if gamma_large == 0.01
replace gamma_large = 5019 if gamma_large == 0.05
replace gamma_large = 10019 if gamma_large == 0.1
*/

line gamma_large yearlab, lcolor(gs0) lpattern(solid) ylabel(1.000e-10 "10{superscript:-10}" 1.000e-4 "10{superscript:-5}" 0.001 "0.001", labsize(3) angle(0)) ///
xlabel(2002(3)2017,labsize(3)) ytitle("", size(3)) xtitle("", size(3)) aspect(0.4, placement(top))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\gamma_large.pdf", as(pdf) replace


import excel "lambda_t.xlsx", sheet("Sheet1") clear

rename A yearlab
rename B lambda_small
rename C lambda_medium
rename D lambda_large
destring, replace force

line lambda_small yearlab, lcolor(gs0) lpattern(solid) ylabel(,labsize(3)) xlabel(2002(3)2017,labsize(3)) ytitle("", size(3)) xtitle("", size(3))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\lambda_small.pdf", as(pdf) replace

line lambda_medium yearlab, lcolor(gs0) lpattern(solid) ylabel(,labsize(3)) xlabel(2002(3)2017,labsize(3)) ytitle("", size(3)) xtitle("", size(3))

line lambda_large yearlab, lcolor(gs0) lpattern(solid) ylabel(,labsize(3)) xlabel(2002(3)2017,labsize(3)) ytitle("", size(3)) xtitle("", size(3))


import excel "DDS_probabilities.xlsx", sheet("Sheet1") clear

rename A yearlab
rename B pr_small
rename C pr_medium
rename D pr_large
destring, replace force

line pr_small yearlab, lpattern(solid) lcolor(black) || line pr_medium yearlab, lpattern(dash) lcolor(black) || ///
line pr_large yearlab, lpattern(shortdash) lcolor(black) legend(order(1 "small VAR" 2 "medium VAR" 3 "large VAR") pos(1) ring(0) bplacement(neast) col(1)) ///
ylabel(,labsize(3)) xlabel(2002(3)2017,labsize(3)) ytitle("", size(3)) xtitle("", size(3))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\DDS_graph.pdf", as(pdf) replace


//Graph of the effective fed funds rate, Wu and Xia and Krippner SSR
import excel "EFFR_Krippner_WuXia_rates.xlsx", sheet("Sheet1") firstrow clear

gen date = ym(year,month)
format date %tm

line EffectiveFederalFundsRate date, lcolor(gs9) lwidth(medthick) || line WuXiaShadowRate date, lcolor(gs0) || line KrippnerSSR date, lcolor(gs5) lpattern(dash) ///
ylabel(,labsize(3)) tlabel(1999m1(36)2017m12, format(%tmCY) labsize(3)) ytitle("rate (%)", size(4)) xtitle("", size(3))  ///
legend(order(1 "effective fed funds rate" 2 "Wu and Xia shadow rate" 3 "Krippner's SSR") pos(1) ring(0) bplacement(neast) col(1)) yline(0, lpattern(shortdash) lcolor(black))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\shadow_rates.pdf", as(pdf) replace



//IMPULSE RESPONSES

//--------------------------------------------------------------------------------//
//WINNING MODELS

import excel "IRF_baseline_small_October2008.xlsx", sheet("Sheet1") firstrow clear

drop E F G H I J K L M
destring, replace force

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.12, labsize(5)) ysc(r(-0.005 0.122)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off) ///
title("{bf:October 2008}", ring(0) pos(12) color(black) size(6))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Presentation\IRF_baseline_small_October2008.pdf", as(pdf) replace



import excel "IRF_baseline_small_December2013.xlsx", sheet("Sheet1") firstrow clear

destring, replace force

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.12, labsize(5)) ysc(r(-0.01 0.13)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off) ///
title("{bf:December 2013}", ring(0) pos(12) color(black) size(6))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Presentation\IRF_baseline_small_December2013.pdf", as(pdf) replace



import excel "IRF_baseline_small_April2017.xlsx", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.1, labsize(5)) ysc(r(-0.005 0.11)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off) ///
title("{bf:April 2017}", ring(0) pos(12) color(black) size(6))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Presentation\IRF_baseline_small_April2017.pdf", as(pdf) replace



import excel "IRF_baseline_big_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(-0.02(0.02)0.04, labsize(5)) ysc(r(-0.021 0.041)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off) ///
title("{bf:November 2006}", ring(0) pos(12) color(black) size(6))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Presentation\IRF_baseline_big_November2006.pdf", as(pdf) replace


import excel "IRF_baseline_big_July2007", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(-0.004 0 0.006, labsize(5)) ysc(r(-0.005 0.0061)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off) ///
title("{bf:July 2007}", ring(0) pos(12) color(black) size(6))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Presentation\IRF_baseline_big_July2007.pdf", as(pdf) replace



import excel "IRF_baseline_big_August2011.xlsx", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(-0.01 0 0.01, labsize(5)) ysc(r(-0.011 0.011))  xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off) ///
title("{bf:August 2011}", ring(0) pos(12) color(black) size(6))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Presentation\IRF_baseline_big_August2011.pdf", as(pdf) replace


//--------------------------------------------------------------------------------//
//Second-best models instead of the big ones

import excel "IRF_baseline_small_November2006_2ndbest.xlsx", sheet("Sheet1") firstrow clear //nevychazi vubec

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(-0.00002 "-2{char 215}10{superscript:-5}" 0 0.00002 "2{char 215}10{superscript:-5}", labsize(5)) ysc(r(-0.000022 0.000022))  ///
xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_baseline_small_November2006_2ndbest.pdf", as(pdf) replace


import excel "IRF_baseline_small_July2007_2ndbest.xlsx", sheet("Sheet1") firstrow clear //nevychazi vubec

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(-0.00002 "-2{char 215}10{superscript:-5}" 0 0.00002 "2{char 215}10{superscript:-5}", labsize(5)) ysc(r(-0.000022 0.000022)) ///
xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_baseline_small_July2007_2ndbest.pdf", as(pdf) replace


import excel "IRF_baseline_small_August2011_2ndbest.xlsx", sheet("Sheet1") firstrow clear 

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.08, labsize(5)) ysc(r(-0.0005 0.085)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off) ///
title("{bf:August 2011}", ring(0) pos(12) color(black) size(6))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Presentation\IRF_baseline_small_August2011_2ndbest.pdf", as(pdf) replace

//--------------------------------------------------------------------------------//


//not second-best models, but with higher gamma - medium models with gamma=0.1 (the highest one)
import excel "IRF_baseline_small_November2006_model2_gamma7", sheet("Sheet1") firstrow clear 

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.06, labsize(5)) ysc(r(-0.0005 0.065)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off) ///
title("{bf:November 2006}", ring(0) pos(12) color(black) size(6))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Presentation\IRF_baseline_small_November2006_model2_gamma7.pdf", as(pdf) replace


import excel "IRF_baseline_small_July2007_model2_gamma7", sheet("Sheet1") firstrow clear 

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.06, labsize(5)) ysc(r(-0.0005 0.065)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off) ///
title("{bf:July 2007}", ring(0) pos(12) color(black) size(6))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Presentation\IRF_baseline_small_July2007_model2_gamma7.pdf", as(pdf) replace


//--------------------------------------------------------------------------------//

//IMPULSE RESPONSES - ROBUSTNESS CHECKS

//Krippner's SSR

import excel "IRF_RC_Krippner_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.01)0.05, labsize(5)) ysc(r(-0.0005 0.055)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

/*
scatter q_16 nhor, msymbol(circle) mcolor(gs5) msize(vsmall) || line q_50 nhor, lpattern(solid) lcolor(black) || ///
scatter q_84 nhor, plotregion(margin(zero)) msymbol(circle) mcolor(gs5) msize(vsmall) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)
*/

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_Krippner_November2006.pdf", as(pdf) replace


import excel "IRF_RC_Krippner_July2007", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.01)0.05, labsize(5)) ysc(r(-0.0005 0.055)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_Krippner_July2007.pdf", as(pdf) replace


import excel "IRF_RC_Krippner_October2008", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.1, labsize(5)) ysc(r(-0.0005 0.105)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_Krippner_October2008.pdf", as(pdf) replace


import excel "IRF_RC_Krippner_August2011", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.01)0.05, labsize(5)) ysc(r(-0.003 0.055)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_Krippner_August2011.pdf", as(pdf) replace


import excel "IRF_RC_Krippner_December2013", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.08, labsize(5)) ysc(r(-0.008 0.085)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_Krippner_December2013.pdf", as(pdf) replace

import excel "IRF_RC_Krippner_April2017", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_Krippner_April2017.pdf", as(pdf) replace




//IPI

import excel "IRF_RC_IPI_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_IPI_November2006.pdf", as(pdf) replace


import excel "IRF_RC_IPI_July2007", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_IPI_July2007.pdf", as(pdf) replace


import excel "IRF_RC_IPI_October2008", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_IPI_October2008.pdf", as(pdf) replace


import excel "IRF_RC_IPI_August2011", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.06, labsize(5)) ysc(r(-0.0018 0.065)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_IPI_August2011.pdf", as(pdf) replace


import excel "IRF_RC_IPI_December2013", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_IPI_December2013.pdf", as(pdf) replace

import excel "IRF_RC_IPI_April2017", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.08, labsize(5)) ysc(r(-0.005 0.085)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_IPI_April2017.pdf", as(pdf) replace


//MA_realGDP
import excel "IRF_RC_MA_realGDP_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_MA_realGDP_November2006.pdf", as(pdf) replace


import excel "IRF_RC_MA_realGDP_July2007", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_MA_realGDP_July2007.pdf", as(pdf) replace


import excel "IRF_RC_MA_realGDP_October2008", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.02)0.1, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_MA_realGDP_October2008.pdf", as(pdf) replace


import excel "IRF_RC_MA_realGDP_August2011", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_MA_realGDP_August2011.pdf", as(pdf) replace


import excel "IRF_RC_MA_realGDP_December2013", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(-0.05(0.05)0.1, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_MA_realGDP_December2013.pdf", as(pdf) replace

import excel "IRF_RC_MA_realGDP_April2017", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-0.003 0.085)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_MA_realGDP_April2017.pdf", as(pdf) replace

//FHFA_HPI
import excel "IRF_RC_FHFA_HPI_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_FHFA_HPI_November2006.pdf", as(pdf) replace


import excel "IRF_RC_FHFA_HPI_July2007", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-0.0001 0.053)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_FHFA_HPI_July2007.pdf", as(pdf) replace


import excel "IRF_RC_FHFA_HPI_October2008", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_FHFA_HPI_October2008.pdf", as(pdf) replace


import excel "IRF_RC_FHFA_HPI_August2011", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_FHFA_HPI_August2011.pdf", as(pdf) replace


import excel "IRF_RC_FHFA_HPI_December2013", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.05)0.1, labsize(5)) ysc(r(-0.005 0.105)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_FHFA_HPI_December2013.pdf", as(pdf) replace

import excel "IRF_RC_FHFA_HPI_April2017", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-0.001 0.081)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_FHFA_HPI_April2017.pdf", as(pdf) replace

//ordering2
import excel "IRF_RC_ordering2_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.01)0.05, labsize(5)) ysc(r(-0.003 0.051)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_ordering2_November2006.pdf", as(pdf) replace


import excel "IRF_RC_ordering2_July2007", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0(0.01)0.05, labsize(5)) ysc(r(-0.003 0.051)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_ordering2_July2007.pdf", as(pdf) replace


import excel "IRF_RC_ordering2_October2008", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ysc(r(-0.004 0.011)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_ordering2_October2008.pdf", as(pdf) replace


import excel "IRF_RC_ordering2_August2011", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-0.004 0.061)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_ordering2_August2011.pdf", as(pdf) replace


import excel "IRF_RC_ordering2_December2013", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_ordering2_December2013.pdf", as(pdf) replace

import excel "IRF_RC_ordering2_April2017", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-0.004 0.081)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_RC_ordering2_April2017.pdf", as(pdf) replace


//--------------------------------------------------------------------------------//

//response of residential investment to Krippner, November 2006
import excel "IRF_Krippner_resinv_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0 15 30 45, labsize(5)) ysc(r(-1 48)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_Krippner_resinv_November2006.pdf", as(pdf) replace


//response of residential investment to Krippner, August 2011
import excel "IRF_Krippner_resinv_August2011", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-13 32)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_Krippner_resinv_August2011.pdf", as(pdf) replace


//response of mortgage average to Krippner, November 2006
import excel "IRF_Krippner_ma_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-0.18 0.11)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_Krippner_ma_November2006.pdf", as(pdf) replace


//response of mortgage average to Krippner, August 2011
import excel "IRF_Krippner_ma_August2011", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-0.22 0.22)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_Krippner_ma_August2011.pdf", as(pdf) replace



//response of residential investment to WuXia, November 2006
import excel "IRF_WuXia_resinv_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-11 45)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_WuXia_resinv_November2006.pdf", as(pdf) replace


//response of residential investment to WuXia, August 2011
import excel "IRF_WuXia_resinv_August2011", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(0 20 40 60, labsize(5)) ysc(r(-5 65)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_WuXia_resinv_August2011.pdf", as(pdf) replace


//response of mortgage average to WuXia, November 2006
import excel "IRF_WuXia_ma_November2006", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-0.22 0.11)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_WuXia_ma_November2006.pdf", as(pdf) replace


//response of mortgage average to WuXia, August 2011
import excel "IRF_WuXia_ma_August2011", sheet("Sheet1") firstrow clear

line q_16 nhor, lpattern(dash) lcolor(gs0) lwidth(medthick) || line q_50 nhor, lpattern(solid) lcolor(black) lwidth(medthick) || ///
line q_84 nhor, plotregion(margin(zero)) lpattern(dash) lcolor(gs0) lwidth(medthick) ///
ylabel(, labsize(5)) ysc(r(-0.35 0.25)) xlabel(6(6)60,labsize(4)) ytitle("", size(3)) xtitle("", size(3)) xscale(titlegap(*4)) legend(off)

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\IRF_WuXia_ma_August2011.pdf", as(pdf) replace




//--------------------------------------------------------------------------------//
//FEVD
//always proportion of forecast error variance of variable HOUSE PRICES explained by other variables
//nezapomenout prepsat v grafech promenne u RC

import excel "FEVD_baseline_small_October2008.xlsx", sheet("Sheet1") firstrow clear

graph bar real_GDP HPI CPI WuXia, over(horizon, gap(*0.5)) stack bar(1, bcolor(gs4)) bar(2, bcolor(gs12)) bar(3, bcolor(gs10)) bar(4, bcolor(gs0)) ///
legend(order(1 "real GDP" 2 "house prices" 3 "CPI" 4 "Wu-Xia rate") ///
pos(3) ring(0.00000001) bplacement(seast) col(1) size(vsmall) symxsize(3) symysize(2) textwidth(12) bmargin(small)) aspect(0.4) b1title("forecast horizon", size(3))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\FEVD_baseline_small_October2008.pdf", as(pdf) replace


import excel "FEVD_baseline_small_December2013.xlsx", sheet("Sheet1") firstrow clear

graph bar real_GDP HPI CPI WuXia, over(horizon, gap(*0.5)) stack bar(1, bcolor(gs4)) bar(2, bcolor(gs12)) bar(3, bcolor(gs10)) bar(4, bcolor(gs0)) ///
legend(order(1 "real GDP" 2 "house prices" 3 "CPI" 4 "Wu-Xia rate") ///
pos(3) ring(0.00000001) bplacement(seast) col(1) size(vsmall) symxsize(3) symysize(2) textwidth(12) bmargin(small)) aspect(0.4) b1title("forecast horizon", size(3))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\FEVD_baseline_small_December2013.pdf", as(pdf) replace


import excel "FEVD_baseline_small_April2017.xlsx", sheet("Sheet1") firstrow clear

graph bar real_GDP HPI rinv CPI mortgage_average WuXia, over(horizon, gap(*0.5)) stack ///
legend(order(6 "Wu-Xia rate" 5 "mortgage average" 4 "CPI" 3 "residential investment" 2 "house prices" 1 "real GDP") ///
pos(3) ring(0.00000001) bplacement(seast) col(1) size(vsmall) symxsize(3) symysize(2) textwidth(20) bmargin(small)) aspect(0.4) b1title("forecast horizon", size(3))
//bar(1, bcolor(midblue)) bar(2, bcolor(pink)) bar(3, bcolor(midgreen)) bar(4, bcolor(gold)) bar(5, bcolor(cranberry)) bar(6, bcolor(lime)) ///



graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\FEVD_baseline_small_April2017.pdf", as(pdf) replace




//FEVD robustness checks - only for April 2017

//Krippner
import excel "FEVD_Krippner_April2017.xlsx", sheet("Sheet1") firstrow clear

graph bar real_GDP HPI rinv CPI mortgage_average WuXia, over(horizon, gap(*0.5)) stack bar(1, bcolor(gs4)) bar(2, bcolor(gs12)) bar(3, bcolor(gs6)) ///
bar(4, bcolor(gs10)) bar(5, bcolor(gs14)) bar(6, bcolor(gs0)) legend(order(1 "real GDP" 2 "house prices" 3 "residential investment" 4 "CPI" 5 "mortgage average" 6 "Krippner's SSR") ///
pos(3) ring(0.00000001) bplacement(seast) col(1) size(vsmall) symxsize(3) symysize(2) textwidth(20) bmargin(small)) aspect(0.4) b1title("forecast horizon", size(3))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\FEVD_Krippner_April2017.pdf", as(pdf) replace


//IPI
import excel "FEVD_IPI_April2017.xlsx", sheet("Sheet1") firstrow clear

graph bar real_GDP HPI rinv CPI mortgage_average WuXia, over(horizon, gap(*0.5)) stack bar(1, bcolor(gs4)) bar(2, bcolor(gs12)) bar(3, bcolor(gs6)) ///
bar(4, bcolor(gs10)) bar(5, bcolor(gs14)) bar(6, bcolor(gs0)) legend(order(1 "IPI" 2 "house prices" 3 "residential investment" 4 "CPI" 5 "mortgage average" 6 "Wu-Xia rate") ///
pos(3) ring(0.00000001) bplacement(seast) col(1) size(vsmall) symxsize(3) symysize(2) textwidth(20) bmargin(small)) aspect(0.4) b1title("forecast horizon", size(3))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\FEVD_IPI_April2017.pdf", as(pdf) replace


//MA real GDP
import excel "FEVD_MA_realGDP_April2017.xlsx", sheet("Sheet1") firstrow clear

graph bar real_GDP HPI rinv CPI mortgage_average WuXia, over(horizon, gap(*0.5)) stack bar(1, bcolor(gs4)) bar(2, bcolor(gs12)) bar(3, bcolor(gs6)) ///
bar(4, bcolor(gs10)) bar(5, bcolor(gs14)) bar(6, bcolor(gs0)) legend(order(1 "MA's real GDP" 2 "house prices" 3 "residential investment" 4 "CPI" 5 "mortgage average" 6 "Wu-Xia rate") ///
pos(3) ring(0.00000001) bplacement(seast) col(1) size(vsmall) symxsize(3) symysize(2) textwidth(20) bmargin(small)) aspect(0.4) b1title("forecast horizon", size(3))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\FEVD_MA_realGDP_April2017.pdf", as(pdf) replace



//FHFA HPI
import excel "FEVD_FHFA_HPI_April2017.xlsx", sheet("Sheet1") firstrow clear

graph bar real_GDP HPI rinv CPI mortgage_average WuXia, over(horizon, gap(*0.5)) stack bar(1, bcolor(gs4)) bar(2, bcolor(gs12)) bar(3, bcolor(gs6)) ///
bar(4, bcolor(gs10)) bar(5, bcolor(gs14)) bar(6, bcolor(gs0)) legend(order(1 "real GDP" 2 "FHFA HPI" 3 "residential investment" 4 "CPI" 5 "mortgage average" 6 "Wu-Xia rate") ///
pos(3) ring(0.00000001) bplacement(seast) col(1) size(vsmall) symxsize(3) symysize(2) textwidth(20) bmargin(small)) aspect(0.4) b1title("forecast horizon", size(3))

graph export "C:\Users\Kristyna\Disk Google\Diplomka\Psani\graphs\FEVD_FHFA_HPI_April2017.pdf", as(pdf) replace





















