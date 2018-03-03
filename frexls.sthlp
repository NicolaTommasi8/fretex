{smcl}
{hline}
help for {hi:frexls}
{hline}

{title:Esporta l'output di fre in Microsoft Excel}

{p 8 12 2}
{cmd:frexls} {it:varname} {ifin} [{cmd:,} {help frexls##freopt:{it:fre_options}}] {help frexls##excelopt:{it:excel_options}}

{title:Description}

{p 4 4 2}{cmd:frexls} permette di esportare in Microsoft Excel l'output del comando {cmd:fre}. {it:varname} è la variabile categorica di cui si vuole esportare la distribuzione di frequenza.
Il comado usa la classe mata {cmd:xl()} (help {help [M-5] xl())} per esportare in Excel 1997/2003 i files di estensione .xls e in Excel 2007/2013 i files di estensione .xlsx.


{marker freopt}{title:fre options}

{p 4 8 2}{opt all} visualizza tutti valori della variabile {it:varname}. Questa opzione interagisce con le opzioni {opt includelabeled} e {opt include(numlist)}

{p 4 8 2}{opt f:ormat(#)} numero di decimali per le percentuali; il default è 2.

{p 4 8 2}{opt nomis:sing} omette i valori missing

{p 4 8 2}{opt as:cending} visualizza le righe in ordine ascendente di frequenza

{p 4 8 2}{opt de:scending} visualizza le righe in ordine discendente di frequenza

{p 4 8 2}{opt nov:alue} omette i valori della variabile

{p 4 8 2}{opt nol:abel} omette le labels dei valori della variabile

{p 4 8 2}{opt i:ncludelabeled} include tutti i valori previsti dalla label

{p 4 8 2}{opt i:nclude(numlist)} include tutti i valori indicati nella numlist


{marker excelopt}{title:excel options}

{p 4 8 2}{cmd:xlsfile(filename.ext)}: specifica il file .xls o .xlsx (ed eventuale percorso) in cui salvare il codice della tabella. Questa opzione e l'estensione del file sono obbligatori.

{p 4 8 2}{cmd:sheet(sheetname)}: specifica il nome del foglio in cui scrivere l'output. Di default si usa "Foglio 1".

{p 4 8 2}{cmd:replace}: specifica di sovrascrivere il file indicato in {cmd:texfile(filename.ext)}.

{p 4 8 2}{cmd:sheetreplace}: specifica di sovrascrivere il foglio indicato in {cmd:sheet(sheetname)}.

{p 4 8 2}{cmd:sheetmodify}: specifica di modificare il foglio indicato in {cmd:sheet(sheetname)}.

{p 4 8 2}{cmd:cell}: specifica la cella da cui iniziare l'output Di default si usa A1. Usare solo la notazione lettera e numero.

{p 4 8 2}{cmd:caption(string)}: specifica il testo da inserire come titolo della tabella. Di default è vuoto.

{p 4 8 2}{cmd:note(string)}: specifica il testo da inserire come nota a piè di tabella. Di default è vuoto.

{p 4 8 2}{cmd:intc1(string)}: specifica il testo da inserire come descrizione della prima colonna della tabella. Di default {cmd:intc1()} è vuoto.

{p 4 8 2}{cmd:wintr1(number)}: specifica la larghezza della prima colonna della tabella. Di default il valore è pari a 40.

{p 4 8 2}{cmd:intc_size(number)}: specifica l'altezza della prima riga della tabella. Di default il valore è pari a 15.

{p 4 8 2}{cmd:resc_size(number)}: specifica la larghezza delle colonne del corpo della tabella cioè delle colonne con i risultati delle statistiche specificate in
{cmd:statistics(}{it:statname}{cmd:)}. Di default il valore è 16.

{p 4 8 2}{cmd:fontname(string)}: specifica il font da usare nella tabella. Il default è {cmd:fontname(Calibri)}

{p 4 8 2}{cmd:fontsize(number)}: specifica la dimensione del font usato nella tabella. Il default è 11.

{p 4 8 2}{cmd:pattern_intc(string)}: specifica il colore di sfondo della prima riga della tabella. I colori possono essere indicati nel formato RGB
all'interno di virgolette ({cmd:pattern_intc("255 255 255")} o usando uno dei colori predefiniti per l'esportazione in excel, vedi
 {cmd:{help [M-5] xl():[M-5] xl()}} alla sezione Format colors. Di default non è previsto nessun colore.

{p 4 8 2}{cmd:bold}: specifica di formattare in bold la prima riga della tabella e le righe dei totali.




{title:Examples}

{pstd}
{cmd:.} {stata sysuse auto, clear}

{pstd}
{cmd:.} {stata frexls foreign, xlsfile(fre.xlsx) replace cell(B2) wintr1(13) resc_size(13)}

{pstd}
{cmd:.} {stata frexls rep78, xlsfile(fre.xlsx) sheetmodify cell(H2) wintr1(13) resc_size(13)}

{pstd}
{cmd:.} {stata frexls foreign, includelabeled xlsfile(fre.xlsx) sheetmodify cell(B12) wintr1(13) resc_size(13)}

{pstd}
{cmd:.} {stata frexls rep78, include(1/7 .a .b .c) xlsfile(fre.xlsx) sheetmodify cell(O2) wintr1(30) resc_size(13)}




{title:Limitations}
{pstd}
...

{title:Author}

{pstd}Nicola Tommasi{p_end}
{pstd}nicola.tommasi@univr.it{p_end}


{marker also}{...}
{title:Also see}

{psee}
Stata:  {help [M-5] xl()}

{psee}
Stata: {help fre} if installed

{psee}
Stata: {help fretex} if installed

{psee}
Huber, C. (2017) {browse "https://blog.stata.com/2017/01/10/creating-excel-tables-with-putexcel-part-1-introduction-and-formatting/":Creating Excel tables with putexcel, part 1: Introduction and formatting}, {it:The Stata Blog}

{psee}
Huber, C. (2017) {browse "https://blog.stata.com/2017/01/24/":Creating Excel tables with putexcel, part 2: Macro, picture, matrix, and formula expressions}, {it:The Stata Blog}

{psee}
Huber, C. (2017) {browse "https://blog.stata.com/2017/04/06/":Creating Excel tables with putexcel, part 3: Writing custom reports for arbitrary variables}, {it:The Stata Blog}

{psee}
Crow, K. (2013) {browse "https://blog.stata.com/2013/09/25/export-tables-to-excel/":Export tables to Excel}, {it:The Stata Blog}

{psee}
Jann, B. (2007). fre: Stata module to display one-way frequency table. Available from {browse "http://ideas.repec.org/c/boc/bocode/s456835.html":http://ideas.repec.org/c/boc/bocode/s456835.html}.
