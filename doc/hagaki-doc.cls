\NeedsTeXFormat{LaTeX2e}
\ProvidesExplClass{hagaki-doc}{2021/12/22}{}{}

% -- debug

% \RequirePackage{lua-visual-debug}

% -- layout

\LoadClass{ jlreq }
\RequirePackage[ margin=2.5cm ]{ geometry }
\pagestyle{ plain }

\dim_set:Nn \parindent { 0mm }
\dim_set:Nn \parskip { 0mm }

\renewcommand\@maketitle{
  \raggedright
  { \Huge\bfseries \@title \par }
  \vspace{4mm}
  { \large \bfseries \@author \hspace{3mm} | \hspace{3mm} \@date }
  \vspace{20mm}
}

\ModifyHeading{ section }{
  font = \Large\bfseries
}
\ModifyHeading{ subsection }{
  font = \large\bfseries
}

\cs_new:Npn \__hgkd_desc_label:n #1 {
  \normalfont\bfseries #1 \hfill
}
\renewenvironment{ description }{
  \list{}{
    \dim_set_eq:NN \labelwidth \leftmargin
    \dim_set:Nn \labelsep { 1\zw }
    \dim_add:Nn \labelwidth { - \labelsep }
    \cs_set_eq:NN \makelabel \__hgkd_desc_label:n
  }
}{
  \endlist
}

% -- font

\RequirePackage{ luatexja-fontspec }
\setmainfont{ Helvetica.ttc }[
  UprightFeatures = { FontIndex = 4 },
  BoldFeatures    = { FontIndex = 1 }
]
\setmainjfont{ NotoSansJP }[
  UprightFont = NotoSansJP-Light,
  BoldFont    = NotoSansJP-Medium
]
\setmonofont{ JetBrainsMono }

% -- tabular

\RequirePackage{ tabularx }
\RequirePackage{ booktabs }

\dim_set:Nn \abovetopsep { .8\baselineskip }
\dim_set:Nn \belowbottomsep { .8\baselineskip }

% -- image

\RequirePackage{ graphicx }
\RequirePackage{ wrapfig }

\dim_set:Nn \fboxsep { 0mm }
\dim_set:Nn \fboxrule { 0.1mm }

\NewDocumentCommand\image{ O{} m }{
  \fbox{
    \includegraphics[#1]{#2}
  }
}

% -- url

\RequirePackage{ hyperref }
\hypersetup{
  hidelinks,
  colorlinks  = true,
  linkcolor   = blue,
  urlcolor    = blue
}
\AtBeginDocument{
  \hypersetup{
    pdftitle  = \@title,
    pdfauthor = \@author
  }
}

% -- code

\newcommand\code[1]{
  \texttt{#1}
}
\newcommand\pkg[1]{
  #1
}
\newcommand\cs[1]{
  \char`\\\texttt{#1}
}

\RequirePackage{ listings }
\lstset{
  basicstyle=\ttfamily
}
