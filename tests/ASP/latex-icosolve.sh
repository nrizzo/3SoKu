#!/bin/bash
# WIP script to solve the IcoSoKu instance described by input-ico.lp and
# generate a LaTeX document containing the solution.
# ~ Nicola Rizzo

# 1) solving the problem
echo -n "Solving the instance... "
sol=$(clingo 3SoKu.lp variants/ico.lp input-ico.lp | \
	grep SATISFIABLE -B 1 | head -n 1 | tr " " "\n")
echo "solved."

# 2) assemble and compilation of the XeLaTeX document
pre='\documentclass[12pt,a4paper]{article}
\usepackage[utf8]{inputenc}
\usepackage[italian]{babel}
\usepackage{amsmath, amsfonts, amssymb, graphicx}
\usepackage[pdf]{pstricks}
\usepackage{booktabs, setspace, pgfplots, multirow, pgfplotstable}
\pgfplotsset{width=10cm,compat=1.9}
\newcolumntype{C}{>{\centering\arraybackslash}p{5mm}}% a centered fixed-width-column
\pgfplotstableset{
	every column/.style={column type=C},
	every head row/.style={
      before row={
        \toprule
      },
      %after row=\midrule,
    },
    every last row/.style={
      after row=\bottomrule
    }
}
\usepackage{tikz}
\usetikzlibrary{calc, tikzmark}
\usepackage{pst-solides3d, xcolor}

\begin{document}
\pagestyle{empty}
\section*{Icosoku solution (Minizinc)}
\psset{viewpoint=160 0 16,Decran=160,unit=2cm}
\vspace*{4.5cm}
\begin{center}
  \psSolid[object=icosahedron,a=2,
    action=draw*,
    fillcolor=yellow!30]\tikzmark{ico}
\end{center}
\begin{tikzpicture}[remember picture, overlay]
  \node at ($(pic cs:ico) + (0, 4.5)$)     {A};
  \node at ($(pic cs:ico) + (-3.8, +2)$)   {B};
  \node at ($(pic cs:ico) + (-1.5, +2.3)$) {C};
  \node at ($(pic cs:ico) + (+1.5, +2.3)$) {D};
  \node at ($(pic cs:ico) + (+3.8, +2)$)   {E};
  \node at ($(pic cs:ico) + (0.3, 1.75)$)  {F};
  \node at ($(pic cs:ico) + (-3.8, -2)$)   {G};
  \node at ($(pic cs:ico) + (0.3, -1.75)$) {H};
  \node at ($(pic cs:ico) + (+3.8, -2)$)   {I};
  \node at ($(pic cs:ico) + (+1.5, -2.3)$) {J};
  \node at ($(pic cs:ico) + (-1.5, -2.3)$) {K};
  \node at ($(pic cs:ico) + (0, -4.5)$)    {L};
\end{tikzpicture}
\vspace*{3cm}

\vspace{1cm}
\begin{center}
\begin{tabular}{lcccccccccccc}
\toprule
\multirow{2}*{\textbf{Instance solved:}}'

premid=' & A & B & C & D & E & F & G & H & I & J & K & L \\'
premid+=" & $(echo "$sol" | grep cap | sort | \
	cut -d ')' -f1 | cut -d ',' -f2 | \
	tr '\n' ' ' | sed 's/ / \& /g' | sed 's/\(.*\)\&/\1 /') \\\\"

mid='\bottomrule
\end{tabular}
\end{center}
\vspace{1cm}
\begin{center}
\textbf{Solution:}\\\vspace*{.5cm}'

arrangement=$(echo "$sol" | grep put | \
	cut -d '(' -f2 | cut -d ')' -f1 | \
	tr "a-z" "A-Z")

midpostfake=""
while read line
do
	midpostfake+="\pgfplotstabletypeset[]{\n"
	midpostfake+="${line:0:1} ${line:2:1} ${line:4:1}\n"
	midpostfake+="$(echo $line | cut -d ',' -f4) "
	midpostfake+="$(echo $line | cut -d ',' -f5) "
	midpostfake+="$(echo $line | cut -d ',' -f6)\n"
	midpostfake+="}\qquad\n"
done <<< $arrangement

midpost=$(echo -e "$midpostfake")

post='\end{center}
\end{document}'

echo -n "Compiling the document showing the solution... "
mkdir temp
cd temp

echo "$pre$premid$mid$midpost$post" > sol.tex
xelatex sol.tex >/dev/null 2>/dev/null
xelatex sol.tex >/dev/null 2>/dev/null
cp sol.pdf ../
rm sol.*

cd ..
rmdir temp

echo "compiled (sol.pdf)."
