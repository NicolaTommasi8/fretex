capture program drop frexls
program define frexls

*! version 0.0.8  TomaHawk  18oct2017
version 14

syntax varlist [if] [in] [, NOMISsing AScending DEscending NOLabel NOValue all ///
                            Format(integer 2) includelabeled include(str asis) ///
                            /**
                             tabulate(#)         tabulate # smallest and # largest values; default is 20  DA AGGIUNGERE
                             rows(#)             tabulate # rows; equivalent to tabulate(#/2)  DA AGGIUNGERE
                             nolabel             omit labels     DA AGGIUNGERE
                             noname              omit variable name  DA AGGIUNGERE
                             includelabeled      include all labeled values    DA AGGIUNGERE
                             include(numlist)    include all values in numlist    DA AGGIUNGERE
                             **/  ///
                            xlsfile(str) replace sheet(str) sheetmodify sheetreplace cell(str) caption(str asis) note(str asis) ///
                            wintr1(real 40) resc_size(real 16) fontname(str asis) fontsize(real 11) pattern_intc(str asis) ///
                            intc1(str) intc_size(real 15) bold   ///
                            /* options for export excel */ ]

mata: mata clear

**`format' si applica direttamente in excel



if "`fontname'"=="" {
  local font_flag = 0
  local fontname = "Calibri"
}
else local font_flag = 1

if "`sheet'" == "" local sheet = "Foglio 1"
if "`include'" != "" local include = "include(`include')"



**** CONTROLLI  ****
   **0
   assert `:word count `varlist''  == 1

   **1
   local cell = upper("`cell'")

   **2
   **if  "`firstrow'" != "variables" & "`firstrow'" != "varlabels" di as error "l'opzione firstrow è specificata in maniera errata!"

   **3
   if "`cell'"=="" local cell A1


**** END CONTROLLI  ****



**tempvar x variabili temporanee
**tempname per scalari e matrici
**tempfile per files

qui count `if'
scalar define `TT' = r(N)

qui fre `varlist' `if' `in', `nomissing' `ascending' `descending' `all' `nolabel' `novalue' `includelabeled' `include'

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

local N_missing = r(N_missing)

local temp  "`r(lab_valid)'"
local temp : list clean temp
forvalues i=1(1)`r(r_valid)' {
  local int : word `i' of `temp'
  **local int = ustrnormalize("`int'","nfc")

  if `i'==1 mata: vec_lab_valid = "`int'"
  else mata: vec_lab_valid = vec_lab_valid \ "`int'"
}


if `r(r_missing)' > 0 {
  local temp = r(lab_missing)
  forvalues i=1(1)`r(r_missing)' {
    local int : word `i' of `temp'
    if `i'==1 mata: vec_lab_missing = "`int'"
    else mata: vec_lab_missing = vec_lab_missing \ "`int'"
  }
}
else mata: vec_lab_missing = ""

if "`replace'" != "" capture erase "`xlsfile'"

if regexm("`cell'","([0-9]*$)") {
      local tryN = regexs(1)
    }

if regexm("`cell'","(^[A-Z]*)") {
      local tryS=  regexs(1)
    }

**di "`tryN'"
**di "`tryS'"


local enda "end"
mata

vec_valid = st_matrix("r(valid)")
vec_missing =  st_matrix("r(missing)")

if ( rows(vec_missing) == 0) vec_missing = 0;


tot_valid = colsum(vec_valid)

tot_fin = tot_valid :+ colsum(vec_missing)


vec_tot_percent = (vec_valid :/ tot_fin) :*100

//vec_tot_percent = vec_tot_percent

vec_valid_percent = (vec_valid :/ tot_valid) :*100
vec_cumul_percent = runningsum(vec_valid_percent)
//vec_valid_percent = vec_valid_percent :/ colsum(vec_valid_percent)
//vec_valid_percent


 vec_T_lab = "Totale"
 vec_T_valid = colsum(vec_valid)
 vec_T_percent = colsum(vec_tot_percent)
 //vec_T_lab
 //vec_T_valid
 //vec_T_percent



if ("`nomissing'" == "") {
 vec_T_lab = "Totale Valide" \ vec_lab_missing \ "Totale"
 vec_T_valid = colsum(vec_valid) \ vec_missing \ colsum(vec_valid) :+ colsum(vec_missing)
 vec_T_percent = colsum(vec_tot_percent) \ (vec_missing:/tot_fin):*100  \ colsum(vec_tot_percent) :+ colsum((vec_missing:/tot_fin):*100)
 vec_T_pct_valid = colsum(vec_valid_percent)
};

if ("`nomissing'" != "" | `N_missing' == 0) {
 vec_T_lab = "Totale"
 vec_T_valid = colsum(vec_valid)
 vec_T_percent = colsum(vec_tot_percent)
 vec_T_pct_valid = colsum(vec_valid_percent)
}




intestazione = ("`intc1'","Frequenza","Percentuale","Valide","Cumulata")
if ("`nomissing'" != "") intestazione = "`intc1'","Frequenza","Percentuale","Cumulata";


b = xl()

if ("`replace'" != "") b.create_book("`xlsfile'", "`sheet'", "xlsx")
if ("`replace'" == "" & "`sheetreplace'"!="") {
  b.load_book("`xlsfile'")
  b.add_sheet("`sheet'")
  b.clear_sheet("`sheet'")
  b.set_sheet("`sheet'")
}
if ("`replace'" == "" & "`sheetmodify'"!="") {
  b.load_book("`xlsfile'")
  b.set_sheet("`sheet'")
}
b.set_mode("open")
b.set_sheet_gridlines("`sheet'", "off")

Ysp = `tryN'
Xsp = b.get_colnum("`tryS'")



if ("`caption'" != "") {
  b.put_string(Ysp,Xsp,"`caption'")
  b.set_font_bold(Ysp,Xsp,"on")
};

if ("`caption'" != "")  Y0X0 = Ysp+1;
if ("`caption'" == "") Y0X0 = Ysp;

b.put_string(Y0X0,Xsp,intestazione)
rowi=Y0X0+1
Y1=Y0X0+1
b.put_string(rowi,Xsp,vec_lab_valid)

coli = Xsp+1
b.put_number(rowi,coli,vec_valid)

coli = coli+1
b.put_number(rowi,coli,vec_tot_percent)

if ("`nomissing'" == "") {
coli = coli+1
b.put_number(rowi,coli,vec_valid_percent)
 }

coli = coli+1
b.put_number(rowi,coli,vec_cumul_percent)

//rowi
rowi = rowi + rows(vec_valid)
YTv=rowi
//rowi
if ("`nomissing'" != ""  | `N_missing' == 0 ) {
  b.put_string(rowi,Xsp,vec_T_lab)
  coli = Xsp+1
  b.put_number(rowi,coli,vec_T_valid)
  coli = coli+1
  b.put_number(rowi,coli,vec_T_percent)
};

if ("`nomissing'" == "") {
  b.put_string(rowi,Xsp,vec_T_lab)
  coli = Xsp+1
  b.put_number(rowi,coli,vec_T_valid)
  coli = coli+1
  b.put_number(rowi,coli,vec_T_percent)
  coli = coli+1
  b.put_number(rowi,coli,vec_T_pct_valid)
};
row_end_data = rowi-1



Yn = rowi + rows(vec_T_valid) - 1
X1 = Xsp
X2 = Xsp+1
X3 = Xsp+2
Xn = Xsp+3
if ("`nomissing'" == "") Xn = Xsp+4;

if ("`note'"!="" ) {
  Ynote = Yn+1
  b.put_string(Ynote,Xsp,"`note'")
}



//Formattazione

//font & dimensione
rfs = (Ysp,Yn)
cfs = (Xsp,Xn)
if (`font_flag' == 1) b.set_font(rfs, cfs, "`fontname'", `fontsize')

cols = (X1,Xn)
rows = (Y1,Yn)
//riga intestazione
b.set_horizontal_align(Y0X0,cols,"center")
b.set_vertical_align(Y0X0,cols,"center")
if ("`bold'"=="bold") b.set_font_bold(Y0X0,cols,"on")
if ("`pattern_intc'" != "")  b.set_fill_pattern(Y0X0,cols,"solid","`pattern_intc'")
b.set_row_height(Y0X0,Y0X0, `intc_size')

//skyblue

cols = (X2,Xn)
//corpo tabella
b.set_horizontal_align(rows,cols,"center")
b.set_vertical_align(rows,cols,"center")

cols = (X3,Xn)
b.set_number_format(rows,cols,"number_d`format'")


 // b.set_row_height(1, 3, 25)
b.set_column_width(X1, X1, `wintr1')
Y1Yn = (Y1,Yn)
//b.set_text_wrap(Y1Yn,X1,"on")
b.set_column_width(X2, Xn, `resc_size')


//bold sui totali
if ("`bold'"=="bold") {
  cols=(Xsp,Xn)
  b.set_font_bold(YTv,cols,"on")
  if ("`nomissing'" == "") b.set_font_bold(Yn,cols,"on");
}



//BORDI

//bordi iniziali
colsf = (X1,Xn)
b.set_top_border(Y0X0,colsf,"medium","black")
b.set_bottom_border(Y0X0,colsf,"thin","black")
//rowsf = (Y0X0,Yn)
//b.set_left_border(rowsf,X2,"thin","black")

// bordo finale
b.set_bottom_border(Yn,colsf,"medium","black")


 if ("`note'"!="") {
  fontsize_note = `fontsize' - 2
  b.set_font(Ynote, Xsp , "`fontname'", fontsize_note)
 }



  b.close_book()

`enda'

di as txt _n `"Apri il file excel:  {ul:{bf:{browse `"`c(pwd)'/`xlsfile'"':`xlsfile'}}} "'
**di _newline as input "Hai occupato il range `cell'-`alfaE'`An', foglio `sheet', file `xlsfile'"

end
exit





