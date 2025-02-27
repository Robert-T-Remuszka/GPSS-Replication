clear all
do Globals.do

use "${GpssData}/input_BAR2.dta", clear

/*********************
This code comes straight from the GPSS replication package. I have simply copied lines
9 through 149 of their "make_rotemberg_summary_BAR.do" file.
*********************/
local controls male race_white native_born educ_hs educ_coll veteran nchild
local weight pop1980

local y wage_ch
local x emp_ch

local ind_stub init_sh_ind_
local growth_stub nat_empl_ind_

local time_var year
local cluster_var czone

qui tab year2, gen(year_)
drop year_1

levelsof `time_var', local(years)

/** Demean growth rates **/
egen mean_growth = rowmean(`growth_stub'*)
foreach growth of varlist `growth_stub'* {
	qui replace `growth' = `growth' - mean_growth
	}
drop mean_growth

/* Construct initial industry shares  and controls */
sort czone year
foreach ind_var of varlist sh_ind_* {
	gen `ind_var'_1980b = `ind_var' if year == 1980
	by czone (year): gen init_`ind_var' = `ind_var'_1980b[1]
	drop `ind_var'_1980b
	qui sum init_`ind_var'
	if r(mean) == 0 { // ROB NOTE: Looks like if the industry has a 0 initial share (across all czones) they drop it and save the industry identifier
		drop init_`ind_var'
		if regexm("`ind_var'", "`ind_stub'(.*)") {
			local ind_num = regexs(1)
			}
		}
	}

foreach var of varlist init_sh_ind_* { // ROB NOTE: Here they create a corresponding variable for the employment growth by industry excluding dropped industries; this one still varies over time though
	if regexm("`var'", "init_sh_ind_(.*)") {
		local ind = regexs(1) 
		gen nat1980_empl_ind_`ind' = `growth_stub'`ind'
		}
	}

sort czone year
foreach control of varlist `controls' { // ROB NOTE: Baseline controls
	gen `control'_1980b = `control' if year == 1980
	by czone (year): gen init_`control' = `control'_1980b[1]
	drop `control'_1980b
}

local ind_stub init_sh_ind_
local controls init_male init_race_white init_native_born init_educ_hs init_educ_coll init_veteran init_nchild
local growth_stub nat1980_empl_ind_



foreach year in `years' {
	foreach ind_var of varlist `ind_stub'* { // ROB NOTE: Interacts the shares with year FE; note this is 1 or 0
		gen t`year'_`ind_var' = `ind_var' * (year == `year')
		}
	foreach var of varlist `growth_stub'* { // ROB NOTE: Store growth rates "wide", 0 if they are missing
		gen t`year'_`var'b = `var' if year == `year'
		egen t`year'_`var' = max(t`year'_`var'b), by(czone)
		drop t`year'_`var'b
		replace t`year'_`var' = 0 if t`year'_`var' == .
		}
	foreach ind_var of varlist `controls' { // ROB NOTE: Interact the years with baseline controls
		if `year' != 1980 {
			gen t`year'_`ind_var' = `ind_var' * (year == `year')
			}
		}
	}

qui desc t*_`growth_stub'*, varlist full
disp wordcount(r(varlist))
qui desc t*_`ind_stub'*, varlist
disp wordcount(r(varlist))

egen test = rowtotal(`ind_stub'*), 
foreach ind_var of varlist `ind_stub'* { // ROB NOTE: Is this just a check that the Bartiks look okay?
	replace `ind_var' = `ind_var' / test
	if regexm("`ind_var'", "`ind_stub'(.*)") {
		local ind_num = regexs(1)
		replace `growth_stub'`ind_num' = 0 if `growth_stub'`ind_num' == .
		gen b_`ind_num' = `ind_var' * `growth_stub'`ind_num'
		}
	}
egen z3 = rowtotal(b_*)
drop b_*


local controls t*_init_male t*_init_race_white t*_init_native_born t*_init_educ_hs t*_init_educ_coll t*_init_veteran t*_init_nchild year_*



drop if czone == .
/* Looks like this implements a few extra checks
foreach var of varlist `ind_stub'* { // ROB NOTE: Run regressions; implement tsls 'manually' and then using in one go ivreghdfe, see top of script for `x'
	if regexm("`var'", "`ind_stub'(.*)") {
		local ind = regexs(1) 
		}
	tempvar temp
	qui gen `temp' = `var' * `growth_stub'`ind'
	qui regress `x' `temp' `controls' [aweight=`weight'], cluster(czone) absorb(czone)    // ROB: First stage - note that the controls are at baseline and interacted with time
	local pi_`ind' = _b[`temp']
	qui test `temp'
	local F_`ind' = r(F)
	qui reghdfe  `y' `temp' `controls'   [aweight=`weight'], cluster(czone) absorb(czone)  // Rob: Second stage
	local gamma_`ind' = _b[`temp']
	qui ivreghdfe  `y' `controls' (`x'=`temp') [aweight=`weight'], cluster(czone) absorb(czone)
	local beta_`ind' = string(_b[`x'], "%9.3f") 
	drop `temp'
	}


foreach var of varlist `ind_stub'42 `ind_stub'351 `ind_stub'0 `ind_stub'362 `ind_stub'270 { // ROB: I think these are the top 5 industries?
	if regexm("`var'", "`ind_stub'(.*)") {
		local ind = regexs(1) 
		}
	tempvar temp
	qui gen `temp' = `var' * `growth_stub'`ind'
	ch_weak, p(.05) beta_range(-10(.1)10)   y(`y') x(`x') z(`temp') weight(`weight') controls(`controls') cluster(czone) absorb(czone) // ROB: Regresses residuals on instrumen for a range of beta to check exclusion
	disp r(beta_min) ,  r(beta_max)
	local ci_min_`ind' =string( r(beta_min), "%9.2f")
	local ci_max_`ind' = string( r(beta_max), "%9.2f")
	disp "`ind', `beta_`ind'', `F_`ind'', [`ci_min_`ind'', `ci_max_`ind'']"
	drop `temp'
	}


preserve // ROB: Calculate the size of employment in a czone, year, ind cell
keep `ind_stub'* czone year `weight'
reshape long `ind_stub', i(czone year) j(ind)
gen `ind_stub'pop = `ind_stub'*`weight'
collapse (sd) `ind_stub'sd = `ind_stub' (rawsum) `ind_stub'pop `weight' [aweight = `weight'], by(ind year)
tempfile tmp
save `tmp'
restore
*/


/**********
ROB: Saving from here. Implement the Rotemberg weights in Julia
************/
export delimited "${data}/RotembergReady.csv", replace


******* Continue
/*
local ind_stub init_sh_ind_
local controls init_male init_race_white init_native_born init_educ_hs init_educ_coll init_veteran init_nchild
local growth_stub nat1980_empl_ind_
*/

bartik_weight, z(t*_`ind_stub'*) weightstub(t*_`growth_stub'*) x(`x') y(`y')  controls(`controls') weight_var(`weight')  absorb(czone) 

mat beta = r(beta)
mat alpha = r(alpha)
mat gamma = r(gam)
mat pi = r(pi)
mat G = r(G)
qui desc t*_`ind_stub'*, varlist
local varlist = r(varlist)

clear
svmat beta
svmat alpha
svmat gamma
svmat pi
svmat G

gen ind = ""
gen year = ""
local t = 1
foreach var in `varlist' {
	if regexm("`var'", "t(.*)_`ind_stub'(.*)") {
		qui replace year = regexs(1) if _n == `t'
		qui replace ind = regexs(2) if _n == `t'
		}
	local t = `t' + 1
}