\NeedsTeXFormat{LaTeX2e}
\ProvidesExplClass{hagaki}{2021/12/18}{}{}
\RequirePackage{tikz}
% \RequirePackage{lua-visual-debug}

% -- 基本的なレイアウト --

\LoadClass{ltjsarticle}
% フォント
\RequirePackage[haranoaji]{luatexja-preset}
% ページスタイル
\pagestyle{empty}
% 紙サイズを指定
\dim_set:Nn \paperheight { 148mm }
\dim_set:Nn \paperwidth { 100mm }
% 版面を紙一杯に広げる
\dim_set:Nn \topmargin { 0pt }
\dim_set:Nn \headheight { 0pt }
\dim_set:Nn \headsep { 0pt }
\dim_set:Nn \footskip { 0pt }
\dim_set:Nn \voffset { -1in }
\dim_set:Nn \hoffset { -1in }
\dim_set:Nn \oddsidemargin { 0pt }
\dim_set:Nn \evensidemargin { 0pt }
\dim_set:Nn \textwidth { 100mm }
\dim_set:Nn \textheight { 148mm }
% 行設定
\skip_set:Nn \parindent { 0pt }
\skip_set:Nn \parskip { 0pt }
% フォントサイズ
\renewcommand\Large{
  \fontsize{10mm}{10mm}\selectfont
  \ltjsetparameter{kanjiskip=.33\zw}
}
\renewcommand\large{
  \fontsize{6mm}{6mm}\selectfont
  \ltjsetparameter{kanjiskip=.33\zw}
}
\renewcommand\normalsize{
  \fontsize{3.5mm}{3.5mm}\selectfont
  \ltjsetparameter{kanjiskip=.2\zw}
}

\cs_new:Nn \hgk_put_recipient_postal_code: {
  \normalsize
}
\cs_new:Nn \hgk_put_recipient_address: {
  \normalsize
}
\cs_new:Nn \hgk_put_recipient_name: {
  \Large
}
\cs_new:Nn \hgk_put_sender_postal_code: {
  \normalsize
}
\cs_new:Nn \hgk_put_sender_address: {
  \normalsize
}
\cs_new:Nn \hgk_put_sender_name: {
  \large
}

% -- インターフェイス --

\keys_define:nn { hgk / sender }{
  postal_code .tl_set:N = \l__hgk_sender_postal_code_tl,
  name        .tl_set:N = \l__hgk_sender_name_tl,
  address     .tl_set:N = \l__hgk_sender_address_tl
}
\newcommand\sender[1]{
  \keys_set:nn { hgk / sender }{ #1 }
}

\keys_define:nn { hgk / recipient }{
  postal_code .tl_set:N = \l__hgk_recipient_postal_code_tl,
  name        .tl_set:N = \l__hgk_recipient_name_tl,
  address     .tl_set:N = \l__hgk_recipient_address_tl
}
\newcommand\recipient[1]{
  \keys_set:nn { hgk / recipient }{ #1 }
}

% -- 描画 --

% #1: アンカーの位置, #2: 座標, #3: テキスト
\cs_new:Npn \__hgk_put_txt:nnn #1 #2 #3 {
  \node[anchor=#1] at (#2) { \tate\mbox{#3} };
}

% #1: 正規表現, #2: 文字列, #3: 前半を格納する変数, #4: 後半を格納する変数
\cs_new:Npn \__hgk_regex_split_two:nNNN #1 #2 #3 #4 {
  \exp_args:NnV \regex_split:nnN { #1 } #2 \l_tmpa_seq
  \seq_pop_left:NN \l_tmpa_seq #3
  \seq_pop_left:NN \l_tmpa_seq #4
}

% #1: 右端の文字の x 座標, #2: 右端の文字の y 座標, #3: 文字間隔, #4: 文字列,
% #5: 挿入する関数
\cs_new:Npn \__hgk_put_postal_code:nnnnn #1 #2 #3 #4 #5 {
  \dim_set:Nn \l_tmpa_dim { #1 } % 現在の box の右端の x 座標
  \tl_map_inline:Nn #4 {
    \node[] at (\l_tmpa_dim, #2) { #5 ##1 };
    \dim_add:Nn \l_tmpa_dim { #3 }
  }
}

\dim_new:N \__hgk_bottom_line_dim
\dim_set:Nn \__hgk_bottom_line_dim { 114mm }

\newcommand\makebody{
  \begin{tikzpicture}[
    % 座標系の変更
    xscale=-1,
    yscale=-1,
    % その他の設定
    inner~sep=0pt
  ]
    \useasboundingbox (0,0) rectangle (\paperwidth, \paperheight);

    % 作業用の配置 ---------–––––––––––––––––––––––––––––––––––––––––––––––––––––-
    % \node[] (image) at (.5\paperwidth, .5\paperheight) {
    %   \includegraphics[width=\paperwidth]{resources/new-years-card.jpg}
    % };
    % \draw[step=10mm, line~width=0.2mm,  blue] (0mm, 0mm) grid (\paperwidth, \paperheight);
    % \draw[step=1mm,  line~width=0.01mm, blue] (0mm, 0mm) grid (\paperwidth, \paperheight);

    % 宛名 -------------––––––––––––––––––––––––––––––––––––––––––––––––––––––––-
    % 郵便番号
    \__hgk_regex_split_two:nNNN
      { - } \l__hgk_recipient_postal_code_tl \l_tmpb_tl \l_tmpa_tl
    \__hgk_put_postal_code:nnnnn { 10.85mm }{ 16mm }{ 6.8mm } \l_tmpa_tl
      \hgk_put_recipient_postal_code:
    \__hgk_put_postal_code:nnnnn { 38.85mm }{ 16mm }{ 7mm } \l_tmpb_tl
      \hgk_put_recipient_postal_code:
    % 住所
    \__hgk_put_txt:nnn { north }{ 10mm, 24mm }{
      \hgk_put_recipient_address:\l__hgk_recipient_address_tl
    }
    % 宛名
    \__hgk_regex_split_two:nNNN
      { \s } \l__hgk_recipient_name_tl \l_tmpa_tl \l_tmpb_tl
    \__hgk_put_txt:nnn { north }{ 41mm, 28mm }{ \hgk_put_recipient_name:\l_tmpa_tl }
    \__hgk_put_txt:nnn { north }{ 41mm, 66mm }{ \hgk_put_recipient_name:\l_tmpb_tl }
    \__hgk_put_txt:nnn { south }{ 41mm, \__hgk_bottom_line_dim }{ \hgk_put_recipient_name:様 }

    % 差出人 ------------------------------------––––––––––––––---–––––––--------
    % 住所
    \__hgk_put_txt:nnn { south }{ 73mm, \__hgk_bottom_line_dim }{
      \hgk_put_sender_address:\l__hgk_sender_address_tl
    }
    % 名前
    \__hgk_regex_split_two:nNNN
      { \s } \l__hgk_sender_name_tl \l_tmpa_tl \l_tmpb_tl
    \__hgk_put_txt:nnn { south }{ 85mm, \__hgk_bottom_line_dim }{
      \hgk_put_sender_name: \l_tmpa_tl \hspace{1\zw} \l_tmpb_tl
    }
    % 郵便番号
    \__hgk_regex_split_two:nNNN
      { - } \l__hgk_sender_postal_code_tl \l_tmpb_tl \l_tmpa_tl
    \__hgk_put_postal_code:nnnnn { 67.5mm }{ 126mm }{ 4mm } \l_tmpa_tl
      \hgk_put_sender_postal_code:
    \__hgk_put_postal_code:nnnnn { 84.5mm }{ 126mm }{ 4mm } \l_tmpb_tl
      \hgk_put_sender_postal_code:
  \end{tikzpicture}
}