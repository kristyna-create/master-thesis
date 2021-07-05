import excel "C:\Users\Kristyna\Disk Google\Diplomka\Code_data_revision\data\US_Policy_Uncertainty_Data.xlsx", sheet("Main Index") firstrow case(lower) clear

rename news_based_policy_uncert_index pu_index

destring year, replace force

drop if year == . //for the last observation

replace date = ym(year,month)
format date %tm

//graph

//important dates: year 2006, month 11; year 2007, month 7; year 2008, month 10;
// year 2011, month 8; year 2013, month 12; year 2017, month 4

twoway line pu_index date, ylabel(,labsize(3)) yscale(range(35 300)) tlabel(1999m1(36)2017m12, format(%tmCY) labsize(3)) ytitle("", size(3)) xtitle("", size(3)) ///
lcolor(gs0) lpattern(solid) text(33 570 "Jul 07", place(n) size(3))  text(243 585 "Oct 08", place(n) size(3)) text(286 619 "Aug 11", place(n) size(3))
//text(40 562 "Nov 06", place(n) size(3))  
//  text(162.73 687 "04.17", place(n) size(2)) ///
 
