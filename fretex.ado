capture program drop fretex
program define fretex

*! version 0.0.8  TomaHawk  15nov2017
version 14

**to do 1. opzione per piazzare la tabella in senso orizzontale nella pagina. per adesso è fissata al centro (\centering)



syntax varlist(max=1) [if] [in] [, NOMISsing AScending DEscending NOLabel NOValue all ///
                                   Format(integer 2) includelabeled include(str asis) /*options for fre*/  ///
                                   texfile(str) replace caption(str) label(str) intc1(str) note(str) bold ///
                                   fullpage fixc1 position(str) fontsize(string) /*options for latex*/ ///
                             ]


**macro list
mata: mata clear

**** CONTROLLI  ****

**** END CONTROLLI  ****

if "`bold'" != "" local bold = "\setrow{\bfseries}"
if "`include'" != "" local include = "include(`include')"
if "`position'" == "" local position = "!htp"


qui count `if'
scalar define `TT' = r(N)

qui fre `varlist' `if' `in', `nomissing' `ascending' `descending' `all' `novalue' `includelabeled' `include'

/*****************************************************************************
    r(N)            number of observations
    r(N_valid)      number of nonmissing observations
    r(N_missing)    number of missing observations
    r(r)            number of rows (values, categories, levels)
    r(r_valid)      number of nonmissing rows
    r(r_missing)    number of missing rows

    Macros:

    r(depvar)       name of tabulated variable
    r(label)        label of tabulated variable
    r(lab_valid)    row labels of nonmissing values
    r(lab_missing)  row labels of missing values

    Matrices:

    r(valid)        frequency counts of nonmissing values
    r(missing)      frequency counts of missing values
******************************************************************************/

local N_valid = r(N_valid)
local N = r(N)

local lab_valid  "`r(lab_valid)'"
**local lab_valid : list clean temp

if `r(r_missing)' > 0 local lab_missing = r(lab_missing)
else local lab_missing = ""

local nmiss = `r(r_missing)'

local enda "end"
mata

vec_valid = st_matrix("r(valid)")
vec_missing =  st_matrix("r(missing)")

if ( rows(vec_missing) == 0) vec_missing = 0;

tot_valid = colsum(vec_valid)

tot_fin = tot_valid :+ colsum(vec_missing)

vec_tot_percent = (vec_valid :/ tot_fin) :*100

vec_pct_missing = (vec_missing :/ tot_fin) :*100

vec_valid_percent = (vec_valid :/ tot_valid) :*100
vec_cumul_percent = runningsum(vec_valid_percent)

 vec_T_valid = colsum(vec_valid)
 vec_T_percent = colsum(vec_tot_percent)

if ("`nomissing'" == "") {
  vec_T_valid = colsum(vec_valid) \ vec_missing \ colsum(vec_valid) :+ colsum(vec_missing)
  vec_T_percent = colsum(vec_tot_percent) \ (vec_missing:/tot_fin):*100  \ colsum(vec_tot_percent) :+ colsum((vec_missing:/tot_fin):*100)
  vec_T_pct_valid = colsum(vec_valid_percent)
};

st_matrix("vec_valid",vec_valid)
st_matrix("vec_tot_percent",vec_tot_percent)
st_matrix("vec_valid_percent",vec_valid_percent)
st_matrix("vec_cumul_percent",vec_cumul_percent)
st_matrix("vec_T_percent",vec_T_percent)
st_matrix("vec_T_pct_valid",vec_T_pct_valid)
st_matrix("vec_missing",vec_missing)
st_matrix("vec_pct_missing",vec_pct_missing)

`enda'

if "`fullpage'" == "" {
  if "`nomissing'" == "" local def_cols = "lcccc"
  else local def_cols = "lccc"
}
else {
  if "`fixc1'"=="" local X = "X"
  else local X = "l"
  if "`nomissing'" == "" local def_cols = "`X'ZZZZ"
  else local def_cols = "`X'ZZZ"
}

local table_ncols = strlen("`def_cols'")

local nrows_valid = rowsof(vec_valid)
local nrows_missing = rowsof(vec_missing)

if "`texfile'" != "" {
  qui file open texfile using "`texfile'", write replace
}

file write texfile "\begin{center}" _n
file write texfile "\begin{table}[`position']" _n
if "`caption'"!="" file write texfile "\caption{`caption'}" _n
if "`label'"!="" file write texfile "\label{tbl:`label'}" _n
file write texfile "\centering" _n

if "`fontsize'" != "" file write texfile "\\`fontsize'" _n

if "`fullpage'" == "" file write texfile "\begin{tabular}{`def_cols'}" _n
else file write texfile "\begin{tabularx}{\textwidth}{`def_cols'}" _n
file write texfile "\toprule" _n
if "`nomissing'" == "" file write texfile "`bold'`intc1' & `bold'Frequenza & `bold'Percentuale & `bold'Valide & `bold'Cumulata \\" _n
else file write texfile "`bold' `intc1' & `bold'Frequenza & `bold'Percentuale & `bold'Cumulata \\" _n
file write texfile "\midrule" _n

if ("`nomissing'" == "") {
  forvalues r =1(1)`nrows_valid' {
    local introw : word `r' of `lab_valid'
    local vec_valid = vec_valid[`r',1]
    local vec_tot_percent : display %6.`format'f vec_tot_percent[`r',1]
    local vec_valid_percent : display %6.`format'f vec_valid_percent[`r',1]
    local vec_cumul_percent : display %6.`format'f vec_cumul_percent[`r',1]
    file write texfile `" `introw' & `vec_valid' & `vec_tot_percent' & `vec_valid_percent' & `vec_cumul_percent' \\ "' _n
  }

  local vec_T_percent : display %6.`format'f vec_T_percent[1,1]
  local vec_T_pct_valid : display %6.`format'f vec_T_pct_valid[1,1]
  if `nmiss' > 0 | "`includelabeled'" != "" | "`include'" != "" {
    file write texfile `" `bold'Totale Valide & `bold'`N_valid' & `bold' `vec_T_percent'  & `bold'`vec_T_pct_valid' &  \\ "' _n

    forvalues r =1(1)`nrows_missing' {
       local introw : word `r' of `lab_missing'
       local vec_missing = vec_missing[`r',1]
       local vec_pct_missing : display %6.`format'f vec_pct_missing[`r',1]
       file write texfile `" `introw' & `vec_missing' & `vec_pct_missing' &  &  \\"' _n
     }
  }

  local N_N : display %6.`format'f `N'/`N'*100
  file write texfile `" `bold'Totale & `bold'`N' & `bold'`N_N' &  &  \\"' _n
}

else {
  forvalues r =1(1)`nrows_valid' {
    local introw : word `r' of `lab_valid'
    local vec_valid = vec_valid[`r',1]
    local vec_tot_percent : display %6.`format'f vec_tot_percent[`r',1]
    local vec_cumul_percent : display %6.`format'f vec_cumul_percent[`r',1]
    file write texfile `" `introw' & `vec_valid' & `vec_tot_percent' & `vec_cumul_percent' \\"' _n
  }
  local vec_T_percent: display %6.`format'f vec_T_percent[1,1]
  file write texfile `" `bold'Totale & `bold'`N_valid' & `bold'`vec_T_percent' &  \\"' _n
}

file write texfile "\bottomrule" _n

if "`note'" != "" file write texfile "\multicolumn{`table_ncols'}{l}{\scriptsize{`note'}}" _n
**\scriptsize or \footnotesize
if "`fullpage'" == "" file write texfile "\end{tabular}" _n
else file write texfile "\end{tabularx}" _n

file write texfile "\end{table}" _n
file write texfile "\end{center}" _n
if "`texfile'" != "" file close texfile

end
exit
