% This package is distriibuted under the MIT License.

\NeedsTeXFormat{LaTeX2e}
\ProvidesExplClass{hagaki}{2022/05/09}{0.3.2}{}

% -- エラーの出力

\msg_new:nnn { hagaki } { missing-engine-format }
  {
    You~are~processing~this~document~with~\c_sys_engine_format_str.~
    hagaki~only~works~with~lualatex.
  }

\sys_if_engine_luatex:F { \msg_error:nn { hagaki } { missing-engine-format } }

% -- 基本的なレイアウト

\LoadClass{ ltjsarticle }
% ページスタイル
\pagestyle{ empty }
% 紙サイズを指定
\dim_set:Nn     \paperwidth     { 100mm }
\dim_set:Nn     \paperheight    { 148mm }
% 版面を紙一杯に広げる
\dim_set:Nn     \topmargin      { 0pt }
\dim_set:Nn     \headheight     { 0pt }
\dim_set:Nn     \headsep        { 0pt }
\dim_set:Nn     \footskip       { 0pt }
\dim_set:Nn     \voffset        { -1in }
\dim_set:Nn     \hoffset        { -1in }
\dim_set:Nn     \oddsidemargin  { 0pt }
\dim_set:Nn     \evensidemargin { 0pt }
\dim_set_eq:NN  \textwidth      \paperwidth
\dim_set_eq:NN  \textheight     \paperheight
% 行設定
\skip_set:Nn    \parindent     { 0pt }
\skip_set:Nn    \parskip       { 0pt }

% luatex にページサイズを伝える
\AtBeginDocument
  {
    \dim_set_eq:NN \pageheight \paperheight
    \dim_set_eq:NN \pagewidth \paperwidth
  }

% -- インターフェイス

\keys_define:nn { hgk / sender }
  {
    postal_code .tl_set:N = \l__hgk_sender_postal_code_tl,
    name        .code:n   = \seq_set_from_clist:Nn \l__hgk_sender_name_seq {#1},
    address     .tl_set:N = \l__hgk_sender_address_tl
  }
\newcommand \sender[1]
  {
    \keys_set:nn { hgk / sender } {#1}
  }

\seq_new:N \l__hgk_rcpt_name_seq
\keys_define:nn { hgk / recipient }
  {
    postal_code .tl_set:N = \l__hgk_rcpt_postal_code_tl,
    name        .code:n   = \seq_set_from_clist:Nn \l__hgk_rcpt_name_seq {#1},
    address     .tl_set:N = \l__hgk_rcpt_address_tl
  }
\newcommand \recipient[1]
  {
    \keys_set:nn { hgk / recipient } {#1}
    \__hgk_draw:
  }

\keys_define:nn { hgk / style }
  {
    top_line    .dim_set:N = \l__hgk_top_line_dim,
    bottom_line .dim_set:N = \l__hgk_bottom_line_dim,
    recipient / address_position  .dim_set:N = \l__hgk_rcpt_address_pos_dim,
    recipient / name_position     .dim_set:N = \l__hgk_rcpt_name_pos_dim,
    recipient / name_indent       .dim_set:N = \l__hgk_rcpt_name_indent_dim,
    recipient / family_name_width .dim_set:N = \l__hgk_rcpt_family_name_width_dim,
    sender / address_position     .dim_set:N = \l__hgk_sender_address_pos_dim,
    sender / name_position        .dim_set:N = \l__hgk_sender_name_pos_dim
  }

\dim_set:Nn \l__hgk_top_line_dim                { 24mm }
% \dim_set:Nn \l__hgk_bottom_line_dim             { 130mm }
\dim_set:Nn \l__hgk_rcpt_address_pos_dim        { 10mm }
\dim_set:Nn \l__hgk_rcpt_name_pos_dim           { 41mm }
\dim_set:Nn \l__hgk_rcpt_name_indent_dim        { 4mm }
\dim_set:Nn \l__hgk_rcpt_family_name_width_dim  { 38mm }
\dim_set:Nn \l__hgk_sender_address_pos_dim      { 73mm }
\dim_set:Nn \l__hgk_sender_name_pos_dim         { 85mm }

\newcommand \hagakisetup[1]
  {
    \keys_set:nn { hgk / style } {#1}
  }

% -- クラスオプション

\dim_new:N  \l__hgk_sender_postal_code_pos_dim
\dim_set:Nn \l__hgk_sender_postal_code_pos_dim { 140.5mm }
\dim_set:Nn \l__hgk_bottom_line_dim { 130mm }
\bool_new:N \l__hgk_option_rensuji_bool
\bool_new:N \l__hgk_option_debug_bool

\DeclareOption { nenga }
  {
    \dim_set:Nn \l__hgk_sender_postal_code_pos_dim { 126mm }
    \dim_set:Nn \l__hgk_bottom_line_dim { 114mm }
  }
\DeclareOption { rensuji }
  {
    \bool_set_true:N \l__hgk_option_rensuji_bool
  }
\DeclareOption { debug }
  {
    \bool_set_true:N \l__hgk_option_debug_bool
  }
\ProcessOptions

\bool_if:NT \l__hgk_option_rensuji_bool { \RequirePackage{ lltjext } }

% \bool_if:NT \l__hgk_option_debug_bool
%   {
%     \RequirePackage{ lua-visual-debug }
%   }

% -- 処理

% #1,#2: 座標, #3: テキスト
\cs_new:Npn \__hgk_put:nnn #1 #2 #3
  {
    \put
      (
        \dim_to_decimal:n {#1},
        \dim_to_decimal:n {#2}
      ) {#3}
  }

% #1,#2: 座標, #3: テキスト
\cs_new:Npn \__hgk_put_txt:nnn #1 #2 #3
  {
    \hbox_set:Nn \l_tmpa_box { \tate #3 }
    \__hgk_put:nnn
      { \box_ht_plus_dp:N \l_tmpa_box / 2 + #1 }
      {#2}
      { \box_use:N \l_tmpa_box }
  }

% 正規表現による文字列の分割
% #1: 正規表現, #2: 文字列, #3: 前半を格納する変数, #4: 後半を格納する変数
\cs_generate_variant:Nn \regex_split:NnN { NVN }
\cs_new:Npn \__hgk_regex_split_two:NNnn #1 #2 #3 #4
  {
    \regex_split:NVN #1 #2 \l_tmpa_seq
    % 苗字が省略された場合に対応するため、右側の要素から取り出す
    \seq_pop_right:NN \l_tmpa_seq #4
    \seq_pop_right:NN \l_tmpa_seq #3
    \tl_if_eq:NNT #3 \q_no_value { \tl_set:Nn #3 { } }
  }

% 郵便番号を配置
% #1: 右端の文字の x 座標, #2: 右端の文字の y 座標, #3: 文字間隔, #4: 文字列,
% #5: 挿入するコード
\cs_new:Npn \__hgk_put_postal_code:nnnNn #1 #2 #3 #4 #5
  {
    \dim_set:Nn \l_tmpa_dim {#1} % 現在の box の右端の x 座標
    \tl_reverse:N #4
    \tl_map_inline:Nn #4
      {
        \hbox_set:Nn \l_tmpa_box { #5 ##1 }
        \dim_set:Nn \l_tmpb_dim { \box_ht_plus_dp:N \l_tmpa_box / 2 }
        \__hgk_put:nnn
          { \l_tmpb_dim + \l_tmpa_dim }
          { \l_tmpb_dim + #2 }
          { \box_use:N \l_tmpa_box }
        \dim_add:Nn \l_tmpa_dim {#3}
      }
  }

% 宛先の氏名を配置
\dim_new:N \l__hgk_rcpt_name_width_dim
\dim_set:Nn \l__hgk_rcpt_name_width_dim { \l__hgk_bottom_line_dim - \l__hgk_top_line_dim }
\cs_new:Npn \__hgk_generate_rcpt:nn #1 #2
  {
    \hbox_to_wd:nn \l__hgk_rcpt_name_width_dim
      {
        \skip_horizontal:N \l__hgk_rcpt_name_indent_dim
        \hgk_rcpt_name_style:
        \hbox_to_wd:nn \l__hgk_rcpt_family_name_width_dim {#1}
        % 引数を hbox に入れない場合、字間が詰められてしまう
        \hbox:n {#2} \hfill 様
      }
  }

% 差出人の氏名を配置
\cs_new:Npn \__hgk_generate_sender:nn #1 #2
  {
    \hbox_overlap_left:n
      {
        \hgk_sender_name_style:
        % 引数を hbox に入れない場合、字間が詰められてしまう
        \hbox:n {#1} \skip_horizontal:n { 1\zw } \hbox:n {#2}
      }
  }

% 複数の氏名を配置
\regex_new:N \l__hgk_space_regex
\regex_set:Nn \l__hgk_space_regex { \s }
\cs_new:Npn \__hgk_map_names_function:nn #1 #2
  {
    \seq_map_inline:Nn #1
      {
        \tl_set:Nn \l_tmpa_tl { ##1 }
        \__hgk_regex_split_two:NNnn
          \l__hgk_space_regex \l_tmpa_tl \l_tmpa_tl \l_tmpb_tl
        #2 \l_tmpa_tl \l_tmpb_tl
      }
  }

% デバッグ用のグリッドを描画
% #1: 横, #2: 縦, #3: 間隔, #4: 線幅
\cs_new:Npn \__hgk_draw_grid:nnnn #1 #2 #3 #4
  {
    \multiput( 0, \dim_to_decimal:n {#2} )( \dim_to_decimal:n {#3}, 0 )
      { \int_eval:n { \dim_ratio:nn {#1} {#3} } }
      { \rule {#4} {#2} }
    \multiput( \dim_to_decimal:n {#1}, 0 )( 0, \dim_to_decimal:n {#3} )
      { \int_eval:n { \dim_ratio:nn {#2} {#3} } }
      { \rule {#1} {#4} }
  }

% 描画
% 郵便番号の分割に使う正規表現
\regex_new:N \l__hgk_hyphen_regex
\regex_set:Nn \l__hgk_hyphen_regex { - }
\cs_new:Nn \__hgk_draw:
  {
    \bool_if:NT \l__hgk_option_rensuji_bool
      {
        \regex_set:Nn \l_tmpa_regex { (\d{1,4}) }
        \regex_replace_all:NnN \l_tmpa_regex { \c{rensuji}\{\1\} } \l__hgk_rcpt_address_tl
        \regex_replace_all:NnN \l_tmpa_regex { \c{rensuji}\{\1\} } \l__hgk_sender_address_tl
      }
    \clearpage
    % picture 環境の線幅と左下の隅の座標を負の値にすることで、
    % 右上の隅を原点とし、左向きを x 軸正方向、下向きを y 軸正方向とした座標系になる
    \dim_set:Nn \unitlength { -1pt }
    \begin{ picture } ( \paperwidth, \paperheight ) ( -\paperwidth, -\paperheight )
      % -- デバッグ
      \bool_if:NT \l__hgk_option_debug_bool
        {
          \color_group_begin:
            \color_select:n { blue!25 }
            \__hgk_draw_grid:nnnn \paperwidth \paperheight { 2mm } { 0.01mm }
            \color_select:n { blue }
            \__hgk_draw_grid:nnnn \paperwidth \paperheight { 10mm } { 0.2mm }
          \color_group_end:
        }
      % -- 宛名
      % 郵便番号
      \__hgk_regex_split_two:NNnn
        \l__hgk_hyphen_regex \l__hgk_rcpt_postal_code_tl \l_tmpb_tl \l_tmpa_tl
      \__hgk_put_postal_code:nnnNn { 10.85mm } { 16mm } { 6.8mm } \l_tmpa_tl
        \hgk_rcpt_postal_code_style:
      \__hgk_put_postal_code:nnnNn { 38.85mm } { 16mm } { 7mm } \l_tmpb_tl
        \hgk_rcpt_postal_code_style:
      % 住所
      \__hgk_put_txt:nnn \l__hgk_rcpt_address_pos_dim { 24mm }
        {
          \hbox_overlap_right:n { \hgk_rcpt_address_style: \l__hgk_rcpt_address_tl }
        }
      % 宛名
      \__hgk_put_txt:nnn \l__hgk_rcpt_name_pos_dim \l__hgk_top_line_dim
        {
          \hbox_overlap_right:n
            {
              \vbox:n
                {
                  \__hgk_map_names_function:nn \l__hgk_rcpt_name_seq \__hgk_generate_rcpt:nn
                }
            }
        }

      % -- 差出人
      % 住所
      \__hgk_put_txt:nnn \l__hgk_sender_address_pos_dim \l__hgk_bottom_line_dim
        {
          \hbox_overlap_left:n { \hgk_sender_address_style: \l__hgk_sender_address_tl }
        }
      % 名前
      \__hgk_put_txt:nnn \l__hgk_sender_name_pos_dim \l__hgk_bottom_line_dim
        {
          \vbox:n
            {
              \__hgk_map_names_function:nn \l__hgk_sender_name_seq \__hgk_generate_sender:nn
            }
        }
      % 郵便番号
      \__hgk_regex_split_two:NNnn
        \l__hgk_hyphen_regex \l__hgk_sender_postal_code_tl \l_tmpb_tl \l_tmpa_tl
      \__hgk_put_postal_code:nnnNn { 67.5mm } \l__hgk_sender_postal_code_pos_dim { 4mm } \l_tmpa_tl
        \hgk_sender_postal_code_style:
      \__hgk_put_postal_code:nnnNn { 84.5mm } \l__hgk_sender_postal_code_pos_dim { 4mm } \l_tmpb_tl
        \hgk_sender_postal_code_style:
    \end{ picture }
  }

% -- デフォルトのスタイル

\cs_new:Nn \__hgk_huge_txt_style:
  {
    \fontsize{10mm}{10mm}\selectfont
    \ltjsetparameter{kanjiskip=.33\zw}
  }
\cs_new:Nn \__hgk_large_txt_style:
  {
    \fontsize{6mm}{6mm}\selectfont
    \ltjsetparameter{kanjiskip=.33\zw}
  }
\cs_new:Nn \__hgk_normal_txt_style:
  {
    \fontsize{3.5mm}{3.5mm}\selectfont
    \ltjsetparameter{kanjiskip=.2\zw}
  }

\cs_set_eq:NN \hgk_rcpt_postal_code_style:    \__hgk_normal_txt_style:
\cs_set_eq:NN \hgk_rcpt_address_style:        \__hgk_normal_txt_style:
\cs_set_eq:NN \hgk_rcpt_name_style:           \__hgk_huge_txt_style:
\cs_set_eq:NN \hgk_sender_postal_code_style:  \__hgk_normal_txt_style:
\cs_set_eq:NN \hgk_sender_address_style:      \__hgk_normal_txt_style:
\cs_set_eq:NN \hgk_sender_name_style:         \__hgk_large_txt_style:
