#!/bin/bash
# WIP script to solve the IcoSoKu instance described by input-ico.dzn and
# generate a LaTeX document containing the solution.

# 1) solving the problem (with the randomized search strategy)
echo -n "Solving instance... "
sol=$(minizinc --solver gecode latex-IcoSoKu.mzn input-ico.dzn)
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

premid=$(echo "$sol" | head -n 2)

mid='\bottomrule
\end{tabular}
\end{center}
\vspace{1cm}
\begin{center}
\textbf{Solution:}\\\vspace*{.5cm}'

midpost=$(echo "$sol" | tail -n +3 | head -n -1)

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
