import excel "C:\Users\Kristyna\Disk Google\Diplomka\Code_data_revision\adf_kpss_level.xls", sheet("Sheet1") clear

keep A B H I O U
replace A = log(A)
replace B = log(B)
replace H = log(H)
replace I = log(I)

rename A real_GDP
rename B CaseShiller_HPI
rename H res_inv
rename I CPI
rename O mortg_average
rename U WuXia_SR

gen t = _n

tsset t

var real_GDP CaseShiller_HPI res_inv CPI mortg_average WuXia_SR, lags(1/9) //7 selected lags plus 2 because the maximum order of integration is 2

//Granger causality tests, null hypothesis: variable X does not Granger-cause variable [Y]
//=> a rejection of the null supports the presence of Granger causality
//tests include only the first 7 lags following T-Y procedure, the additional 2 lags are there only to fix up asymptotics

//CaseShiller_HPI Granger causes real_GDP
test [real_GDP]L1.CaseShiller_HPI [real_GDP]L2.CaseShiller_HPI [real_GDP]L3.CaseShiller_HPI [real_GDP]L4.CaseShiller_HPI [real_GDP]L5.CaseShiller_HPI [real_GDP]L6.CaseShiller_HPI [real_GDP]L7.CaseShiller_HPI
//yes, p-value 0.0186, reject the null of non-causality

//res_inv Granger causes real_GDP
test [real_GDP]L1.res_inv [real_GDP]L2.res_inv [real_GDP]L3.res_inv [real_GDP]L5.res_inv [real_GDP]L7.res_inv
//yes, p-value 0.0000, reject the null of non-causality


//CPI Granger causes real_GDP
test [real_GDP]L1.CPI [real_GDP]L2.CPI [real_GDP]L3.CPI [real_GDP]L4.CPI [real_GDP]L5.CPI [real_GDP]L6.CPI [real_GDP]L7.CPI
//no, p-value  0.3013, we cannot reject the null of non-causality


//mortg_average Granger causes real_GDP
test [real_GDP]L1.mortg_average [real_GDP]L2.mortg_average [real_GDP]L3.mortg_average [real_GDP]L4.mortg_average [real_GDP]L5.mortg_average [real_GDP]L6.mortg_average [real_GDP]L7.mortg_average
//yes, p-value 0.0117, reject the null of non-causality


//WuXia_SR Granger causes real_GDP
test [real_GDP]L1.WuXia_SR [real_GDP]L2.WuXia_SR [real_GDP]L3.WuXia_SR [real_GDP]L4.WuXia_SR [real_GDP]L5.WuXia_SR [real_GDP]L6.WuXia_SR [real_GDP]L7.WuXia_SR
//no, p-value 0.2058, we cannot reject the null of non-causality

//-------------------------------------------------------------------//

//real_GDP Granger causes CaseShiller_HPI
test [CaseShiller_HPI]L1.real_GDP [CaseShiller_HPI]L3.real_GDP [CaseShiller_HPI]L5.real_GDP [CaseShiller_HPI]L7.real_GDP
//yes, p-value 0.0000, reject the null of non-causality

//res_inv Granger causes CaseShiller_HPI
test [CaseShiller_HPI]L1.res_inv [CaseShiller_HPI]L2.res_inv [CaseShiller_HPI]L3.res_inv [CaseShiller_HPI]L5.res_inv [CaseShiller_HPI]L7.res_inv
//yes, p-value 0.0000, reject the null of non-causality

//CPI Granger causes CaseShiller_HPI
test [CaseShiller_HPI]L1.CPI [CaseShiller_HPI]L2.CPI [CaseShiller_HPI]L3.CPI [CaseShiller_HPI]L4.CPI [CaseShiller_HPI]L5.CPI [CaseShiller_HPI]L6.CPI [CaseShiller_HPI]L7.CPI
//no, p-value 0.4914, we cannot reject the null of non-causality

//mortg_average Granger causes CaseShiller_HPI
test [CaseShiller_HPI]L1.mortg_average [CaseShiller_HPI]L2.mortg_average [CaseShiller_HPI]L3.mortg_average [CaseShiller_HPI]L4.mortg_average [CaseShiller_HPI]L5.mortg_average [CaseShiller_HPI]L6.mortg_average [CaseShiller_HPI]L7.mortg_average
//no, p-value 0.2141, we cannot reject the null of non-causality

//WuXia_SR Granger causes CaseShiller_HPI
test [CaseShiller_HPI]L1.WuXia_SR [CaseShiller_HPI]L2.WuXia_SR [CaseShiller_HPI]L3.WuXia_SR [CaseShiller_HPI]L4.WuXia_SR [CaseShiller_HPI]L5.WuXia_SR [CaseShiller_HPI]L6.WuXia_SR [CaseShiller_HPI]L7.WuXia_SR
//yes, p-value 0.0032, reject the null of non-causality

//------------------------------------------------------------------//

//real_GDP Granger causes res_inv
test [res_inv]L1.real_GDP [res_inv]L3.real_GDP [res_inv]L5.real_GDP [res_inv]L7.real_GDP
//yes, p-value  0.0000, reject the null of non-causality


//CaseShiller_HPI Granger causes res_inv
test [res_inv]L1.CaseShiller_HPI [res_inv]L2.CaseShiller_HPI [res_inv]L3.CaseShiller_HPI [res_inv]L4.CaseShiller_HPI [res_inv]L5.CaseShiller_HPI [res_inv]L6.CaseShiller_HPI [res_inv]L7.CaseShiller_HPI
//yes, p-value  0.0007, reject the null of non-causality


//CPI Granger causes res_inv
test [res_inv]L1.CPI [res_inv]L2.CPI [res_inv]L3.CPI [res_inv]L4.CPI [res_inv]L5.CPI [res_inv]L6.CPI [res_inv]L7.CPI
//no, p-value  0.7639, we cannot reject the null of non-causality

//mortg_average Granger causes res_inv
test [res_inv]L1.mortg_average [res_inv]L2.mortg_average [res_inv]L3.mortg_average [res_inv]L4.mortg_average [res_inv]L5.mortg_average [res_inv]L6.mortg_average [res_inv]L7.mortg_average
//yes, p-value 0.0000, reject the null of non-causality

//WuXia_SR Granger causes res_inv
test [res_inv]L1.WuXia_SR [res_inv]L2.WuXia_SR [res_inv]L3.WuXia_SR [res_inv]L4.WuXia_SR [res_inv]L5.WuXia_SR [res_inv]L6.WuXia_SR [res_inv]L7.WuXia_SR
//yes, p-value  0.0021, reject the null of non-causality


//------------------------------------------------------------------//

foreach var of varlist CaseShiller_HPI mortg_average WuXia_SR {
test [CPI]L1.`var' [CPI]L2.`var' [CPI]L3.`var' [CPI]L4.`var' [CPI]L5.`var' [CPI]L6.`var' [CPI]L7.`var'

}

test [CPI]L1.real_GDP [CPI]L3.real_GDP [CPI]L5.real_GDP [CPI]L7.real_GDP
test [CPI]L1.res_inv [CPI]L2.res_inv [CPI]L3.res_inv [CPI]L5.res_inv [CPI]L7.res_inv

//real_GDP Granger causes CPI
//yes, p-value 0.0000, reject the null of non-causality

//CaseShiller_HPI Granger causes CPI
//no, p-value 0.0824, we cannot reject the null of non-causality at 5%

//res_inv Granger causes CPI
//yes, p-value 0.0000, reject the null of non-causality 

//mortg_average Granger causes CPI
//no, p-value 0.3251, we cannot reject the null of non-causality 

//WuXia_SR Granger causes CPI
//no, p-value 0.1896, we cannot reject the null of non-causality



//------------------------------------------------------------------//

foreach var of varlist CaseShiller_HPI CPI WuXia_SR {
test [mortg_average]L1.`var' [mortg_average]L2.`var' [mortg_average]L3.`var' [mortg_average]L4.`var' [mortg_average]L5.`var' [mortg_average]L6.`var' [mortg_average]L7.`var'

}

test [mortg_average]L1.res_inv [mortg_average]L2.res_inv [mortg_average]L3.res_inv [mortg_average]L5.res_inv [mortg_average]L7.res_inv
test [mortg_average]L1.real_GDP [mortg_average]L3.real_GDP [mortg_average]L5.real_GDP [mortg_average]L7.real_GDP

//real_GDP Granger causes mortg_average
//yes, p-value 0.0000, reject the null of non-causality

//CaseShiller_HPI Granger causes mortg_average
//no, p-value 0.3766, we cannot reject the null of non-causality

//res_inv Granger causes mortg_average
//yes, p-value 0.0000, we can reject the null of non-causality

//CPI Granger causes mortg_average
//no, p-value 0.3680, we cannot reject the null of non-causality

//WuXia_SR Granger causes mortg_average
//no, p-value 0.2329, we cannot reject the null of non-causality



//------------------------------------------------------------------//

foreach var of varlist CaseShiller_HPI CPI mortg_average {
test [WuXia_SR]L1.`var' [WuXia_SR]L2.`var' [WuXia_SR]L3.`var' [WuXia_SR]L4.`var' [WuXia_SR]L5.`var' [WuXia_SR]L6.`var' [WuXia_SR]L7.`var'

}

test [WuXia_SR]L1.res_inv [WuXia_SR]L2.res_inv [WuXia_SR]L3.res_inv [WuXia_SR]L5.res_inv [WuXia_SR]L7.res_inv
test [WuXia_SR]L1.real_GDP [WuXia_SR]L3.real_GDP [WuXia_SR]L5.real_GDP [WuXia_SR]L7.real_GDP

//real_GDP Granger causes WuXia_SR
//yes, p-value 0.0000, reject the null of non-causality

//CaseShiller_HPI Granger causes WuXia_SR
//no, p-value 0.4243, we cannot reject the null of non-causality

//res_inv Granger causes WuXia_SR
//yes, p-value 0.0000, reject the null of non-causality

//CPI Granger causes WuXia_SR
//yes, p-value 0.0002, we can reject the null of non-causality

//mortg_average Granger causes WuXia_SR
//yes, p-value 0.0021, we can reject the null of non-causality
























