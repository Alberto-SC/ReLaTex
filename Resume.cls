\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{Resume}[2022/10/04 AwesomeCV yet another alternative class for a resume/curriculum vitae. inspired by LianTze Lim]

%% Pass all options not explicit defined to the class extarticle 
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}

%% TODO 
%% Add a logo or photo, photo is not required for most companies but you can add a personal logo instead 
\newif\if@photo
\DeclareOption{photo}{\@phototrue}
%% Quit or keep all icons with just an option
\newif\if@icons
\DeclareOption{icons}{\@iconstrue}

% Process the options that were passed in
\ProcessOptions\relax

\LoadClass{extarticle}

% Load all the required packages
\RequirePackage{etoolbox}
\RequirePackage[a-1b]{pdfx}
\RequirePackage{accsupp}
\RequirePackage[margin=2cm]{geometry}
\RequirePackage[fixed]{fontawesome5}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{scrlfile}
\RequirePackage{xparse}
\RequirePackage{paracol}
\RequirePackage[newcommands]{ragged2e}
\RequirePackage[skins]{tcolorbox}
\RequirePackage[inline]{enumitem}
\RequirePackage{graphicx}
\RequirePackage{trimclip}
\RequirePackage{dashrule}
\RequirePackage{multirow,tabularx}
\RequirePackage{changepage}
\RequirePackage{afterpage}
\RequirePackage{luacode}
\RequirePackage{xcolor}

% Define a custom error message for when the wrong compiler is used
\newcommand{\compilerError}[1]{
    \GenericError{[Resume.cls]}{Bad compiler}%
                 {[Resume.cls] Use luaLatex to compile this file}
                 {[Resume.cls] End compilation}
}

% Check if LuaLaTeX or LuaXetex is being used; if not, throw an error
\ifluatex
  \RequirePackage{fontspec}
  \else
    \ifxetex
      \RequirePackage{fontspec}
    \else
      \compilerError{} 
      \end{document}
    \fi
\fi

\newcommand{\URL}[2]{\href{#1}{\colorlet{temp}{.}\color{blue}{\underline{\color{temp}#2}}\color{temp}}}  


% Set some default settings for lists
\setlist[itemize]{label=\itemmarker}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vspace{0.25\baselineskip}}

% Set some settings for hypertext links
\AtBeginDocument{%
  \hypersetup{hidelinks}
  \urlstyle{same}
}
% Set some settings for the "itemize" environment
\AtBeginEnvironment{itemize}{\small}

% Define some color values
\colorlet{accent}{blue!70!black}
\colorlet{emphasis}{black}
\colorlet{heading}{black}
\colorlet{headingrule}{black}
\colorlet{subheading}{emphasis}
\colorlet{body}{black!80!white}
\colorlet{name}{heading}
\colorlet{tagline}{accent}

% Define some commands for markers
\newcommand{\itemmarker}{{\small\textbullet}}
\newcommand{\ratingmarker}{\faCircle}


% Set the paragraph indentation to 0pt and define a divider for sections
\setlength{\parindent}{0pt}
\newcommand{\divider}{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\smallskip}

% Define an environment for full width text
\newenvironment{fullwidth}{%
  \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
  {\end{adjustwidth}}

% Define a command for detokenizing text to avoid encoding issues
\newcommand{\utffriendlydetokenize}[1]{%
\scantokens{
  \catcode`\_=12%
  \catcode`\&=12%
  \catcode`\$=12%
  \catcode`\#=12%
  \catcode`\~=12%
  {#1}
}
}

% \ExplSyntaxOn
% \NewDocumentCommand{\printinfo}{m m o}{%
%   \BeginAccSupp{method=escape,ActualText={#1:~#2}}
%   \IfNoValueTF{#3}{%
%     \mbox{\textcolor{accent}{\normalfont #1}~\utffriendlydetokenize{#2}\hspace{2em}}%
%   }{%
%     \mbox{\textcolor{accent}{\normalfont #1}~
%     \href{#3}{\utffriendlydetokenize{#2}}\hspace{2em}}
%   }%
%   \EndAccSupp{}
% }%

% Define a command for printing information fields
\ExplSyntaxOn
\NewDocumentCommand{\printinfo}{m m o o}{%
  \BeginAccSupp{method=escape,ActualText={#1:~#2}}
  \IfNoValueTF{#3}{%
    \mbox{\textcolor{accent}{\normalfont #1}~\utffriendlydetokenize{#2}\hspace{2em}}%
  }{%
    \IfNoValueTF{#4}{
      \mbox{\textcolor{accent}{\normalfont #1}~
      \href{#3}{\utffriendlydetokenize{#2}}\hspace{2em}}
    }
    {
      \mbox{\textcolor{accent}{\normalfont #1}~
      \URL{#3}{#4}\hspace{2em}}
    }
  }%
  \EndAccSupp{}
}%

% Define a command for creating new information fields
\NewDocumentCommand{\NewInfoField}{m m o}{%
  \IfNoValueF{#3}{\csdef{#1 hyperprefix}{#3}}%
  \csdef{#1 symbol}{#2}%

  \csdef{#1}##1{%
    \IfNoValueTF {#3}
      {\printinfo{\csuse{#1 symbol}}{##1}}%
      {\printinfo{\csuse{#1 symbol}}{##1}[\csuse{#1 hyperprefix}##1]}%
  }%
}
\ExplSyntaxOff


% Define commands for setting personal information
\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\tagline}[1]{\def\@tagline{#1}}
\newcommand{\personalinfo}[1]{\def\@personalinfo{#1}}


% If you need a link provide a third parameter at least with https:// , you can also write a preffix for many links from the same site or just for convenience
% Define information fields
\NewInfoField{email}{\faAt}[mailto:]
\NewInfoField{mailaddress}{\faEnvelope}
\NewInfoField{phone}{\faPhone}[tel:]
\NewInfoField{homepage}{\faGlobe}[https://]
\NewInfoField{twitter}{\faTwitter}[https://twitter.com/]
\NewInfoField{linkedin}{\faLinkedin}[https://linkedin.com/in/]
\NewInfoField{github}{\faGithub}[https://github.com/]
\NewInfoField{orcid}{\faOrcid}[https://orcid.org/]
\NewInfoField{location}{\faMapMarker}
\NewInfoField{medium}{\faMedium}
\NewInfoField{english}{\faComments}

% Define font styles for different sections of the CV
\newcommand{\namefont}{\huge\bfseries}
\newcommand{\taglinefont}{\large\bfseries}
\newcommand{\personalinfofont}{\small\bfseries}
\newcommand{\cvsectionfont}{\Large\bfseries}

% Define the header of the CV
\newcommand{\makecvHeader}{%
  \begingroup
    \begin{minipage}{\textwidth}%
    \raggedright%
    \begin{tabularx}{\textwidth}{@{}m{0.5\textwidth} l X m{0.5\textwidth}@{}}
        \namefont\color{name}\MakeUppercase{\@name} & \raggedleft\taglinefont\color{tagline}\@tagline 
    \end{tabularx}
    \personalinfofont\@personalinfo\par
    \end{minipage}\hfill%
  \endgroup\medskip
}

% Redefine the quote environment with a different font and color
\renewenvironment{quote}{\color{accent}\itshape\large}{\par}

% Define the section styles for the CV
\newcommand{\cvsection}[2][]{
  \nointerlineskip\bigskip
  \ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
  {\color{heading}\cvsectionfont\MakeUppercase{#2}}\\[-1ex]%
  {\color{headingrule}\rule{\linewidth}{2pt}\par}\medskip
}


% Define the event style for work and education experiences
\newcommand{\cvevent}[4]{%
  {\large\color{emphasis}#1\par}
  \smallskip\normalsize
  \ifstrequal{#2}{}{}{
    \textbf{\color{accent}#2}\par
    \smallskip
  }
  \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{\faCalendar~#3}}}\par
  \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][l]{\faMapMarker~#4}}}\par
  \medskip\normalsize
}

% Define the achievement style for notable accomplishments
\newcommand{\cvachievement}[3]{%
  \begin{tabularx}{\linewidth}{@{}p{2.5em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
  \multirow{2}{*}{\Large\color{accent}#1} & \bfseries\textcolor{emphasis}{#2}\\
  & #3
  \end{tabularx}%
  \smallskip
}

% Define a set of skills/technologies used, taking a list of , separated items.
\newcommand{\cvskills}[2]{%
  \textbf{\textsc{#1}} \par
  \footnotesize{\foreach \n in {#2}{\cvtag{\n}}}
  \par
  \smallskip
}

\newcommand\link[2]{\color{emphasis}\href{#1}{#2}\color{Black} }
\newcommand{\sociallink}[3]{\mbox{\textcolor{emphasis}{#1}\hspace{0.5em}\link{#2}{#3}\hspace{1em}}}
\newcommand*{\githublink}[1]{\sociallink{\faGithub}{#1}{#1}}         
\newcommand*{\website}[2]{\sociallink{\faLink}{#1}{#2}}


\newcommand{\additem}[1]{\item #1}
\NewDocumentCommand{\cvproject}{ m m m m >{\SplitList{|}}m m }{%
  \begin{minipage}[t]{\dimexpr(\linewidth) - 1.5em}
    \large\textbf{\textsc{#1}} \hfill \textsc{#2}\smallskip\\
    \ifstrequal{#3}{}{}{#3\\}

    #4\smallskip\\

    \begin{itemize}
      \footnotesize{\ProcessList{#5}{\additem}}\\
    \end{itemize}
    \footnotesize{\foreach \n in {#6}{\cvtag{\n}}}\\
  \end{minipage}
  \\*
  \smallskip
}


\newcommand{\cvtag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{#1};
}

\newcommand{\cvlanguaje}[3]{
  \begin{tabularx}{\linewidth}{@{}p{2.5em} @{\hspace{7ex}} >{\raggedright\arraybackslash}X@{}}
    \multirow{1}{*}{\color{accent}#1}  \multirow{1}{*}{\scriptsize{#2}} & \textcolor{emphasis}{#3}\\
    \end{tabularx}
    \smallskip
}

\newenvironment{cvcolumn}[1]{\begin{minipage}[t]{#1}\raggedright}{\end{minipage}}

\newcommand{\addsidebar}[2][]{\marginpar{%
  \ifstrequal{#1}{}{}{\vspace*{#1}}%
  \input{#2}}%
}
\newcommand{\addnextpagesidebar}[2][]{\afterpage{\addsidebar[#1]{#2}}}

\AtBeginDocument{%
  \pagestyle{empty}
  \color{body}
  \raggedright
}


\newenvironment{scholarship}{%
  \begin{tabular}{Y p{\rightcolumnlength}}
}{%
  \end{tabular}
}

\newcommand\scholarshipentry[2]{
  #1    &  #2 \\
}

