{smcl}
{hline}
help for {hi:fretex}
{hline}

{title:Esporta l'output di fre in LaTex}

{p 8 12 2}
{cmd:fretex} {it:varname} {ifin} [{cmd:,} {help fretex##freopt:{it:fre_options}}] {help fretex##latexopt:{it:latex_options}}

{title:Description}

{p 4 4 2}{cmd:fretex} permette di esportare in LaTex l'output del comando {cmd:fre}. {it:varname} è la variabile categorica di cui si vuole esportare la distribuzione di frequenza.
Per funzionare correttamente nel preambolo del documento LaTex devono essere specificate le seguenti direttive:

{synopt:{space 4}\usepackage{tabularx}}{p_end}
{synopt:{space 4}\usepackage{array}}{p_end}
{synopt:{space 4}\usepackage{gensymb}}{p_end}
{synopt:{space 4}\usepackage[italian]{babel}}{p_end}
{synopt:{space 4}\renewcommand{\arraystretch}{1.1}}{p_end}
{synopt:{space 4}\newcolumntype{Z}{>{\centering\arraybackslash}X}}{p_end}


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


{marker latexopt}{title:LaTex options}

{p 4 8 2}{cmd:texfile(filename)}: specifica il file .tex (ed eventuale percorso) in cui salvare il codice della tabella. Questa opzione è obbligatoria.

{p 4 8 2}{cmd:replace}: specifica di sovrascrivere il file indicato in {cmd:texfile(filename)}.

{p 4 8 2}{cmd:caption(string)}: specifica il testo da inserire nell'opzione \caption{} del pacchetto table di LaTex. Di default è vuoto.

{p 4 8 2}{cmd:label(string)}: specifica il testo da inserire nell'opzione \label{} del pacchetto table di LaTex. Il comando prevede il prefisso tbl: per cui l'opzione {cmd:label(Tab1)} produce il codice Latex \label{tbl:Tab1}.

{p 4 8 2}{cmd:position(string)}: specifica la posizione della tabella secondo le regole LaTex. Il default è {cmd:position(!htp)}

{p 4 8 2}{cmd:intc1(string)}: specifica il testo da inserire come descrizione della prima colonna della tabella. Di default {cmd:intc1()} è vuoto.

{p 4 8 2}{cmd:note(string)}: specifica il testo da inserire come nota a piè di tabella. Di default è vuoto.

{p 4 8 2}{cmd:fontsize(string)}: specifica la dimensione del font da usare nella tabella. I valori ammessi sono quelli di LaTex, cioè Huge, huge, LARGE, Large, large, normalsize (default), small, footnotesize, scriptsize e tiny.
Si veda la documentazione di LaTex per maggiori informazioni.

{p 4 8 2}{cmd:bold}: specifica di formattare in bold la prima riga della tabella e le righe dei totali.

{p 4 8 2}{cmd:fullpage}: specifica che la larghezza della tabella equivale ai margini della pagina. Altrimenti la larghezza viene determinata da LaTex in base al contenuto delle diverse colonne.

{p 4 8 2}{cmd:fixc1}: specifica che la larghezza della prima colonna corriponde alla larghezza del contenuto della prima colonna. Altrimenti la largezza della prima colonna corrisponde alla larghezza fissata per le colonne successive.




{title:Examples}

{pstd}
{cmd:.} {stata sysuse auto, clear}

{pstd}
{cmd:.} {stata fretex foreign, texfile(ex1.tex) replace}

{pstd}
{cmd:.} {stata fretex rep78, texfile(ex2.tex) replace}

{pstd}
{cmd:.} {stata fretex foreign, includelabeled texfile(ex3.tex) replace}

{pstd}
{cmd:.} {stata fretex rep78, include(1/7 .a .b .c) texfile(ex4.tex) replace}




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
Stata: {help frexls} if installed

{psee}
Jann, B. (2007). fre: Stata module to display one-way frequency table. Available from {browse "http://ideas.repec.org/c/boc/bocode/s456835.html":http://ideas.repec.org/c/boc/bocode/s456835.html}.
