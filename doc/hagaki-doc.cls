\NeedsTeXFormat{LaTeX2e}
\ProvidesExplClass{hagaki-doc}{2021/12/22}{}{}

% -- layout

\LoadClass{jlreq}
\RequirePackage[margin=2.5cm]{geometry}
\pagestyle{plain}

\dim_set:Nn \parindent { 0mm }
\dim_set:Nn \parskip { 0mm }

% -- font

\RequirePackage{luatexja-fontspec}
\setmainfont{Helvetica}
\setmainjfont{NotoSansJP}
\setmonofont{JetBrainsMono}

% -- tabular

\RequirePackage{tabularx}
\RequirePackage{booktabs}

\dim_set:Nn \abovetopsep { .8\baselineskip }
\dim_set:Nn \belowbottomsep { .8\baselineskip }

% -- image

\RequirePackage{graphicx}

\dim_set:Nn \fboxsep { 0mm }
\dim_set:Nn \fboxrule { 0.1mm }

% -- code

\newcommand\code[1]{
  \texttt{#1}
}
\cs_set_eq:NN \pkg \code
\cs_set_eq:NN \file \code

\newcommand\cmd[1]{
  \hbox{}\char`\\\texttt{#1}
}

\RequirePackage{listings}
\lstset{
  basicstyle=\ttfamily
}

\ExplSyntaxOff
\RequirePackage{fancyvrb}
\DefineShortVerb{\|}