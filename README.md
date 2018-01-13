# exp-review-cls

2018 Kenshi Muto

Re:VIEWクラスファイルの習作。

syntax-bookを表現するクラスファイルを作成する。

- jlreqクラスベース
- とりあえずlualatexを使用してみている。が、残念ながらDebian StretchのTeXLive2016ではluatex, luatex-jaなどが古くたくさんの問題が発生する。debではなくTeXLive先端環境が必要なため、実用性は低め。
- ある程度見えたらuplatexも考える。→いちおうuplatex版も用意した。当面こっちのほうが安全そう。

- mdframedよりもtcolorboxのほうがよいのだろうか→tcolorbox版にした
- リスト採番を図表と同じようにしようとするとフロートにするしかないか。長いものが多いためフロートには不向き。リテラル表現のほうがよさそう

## 利用
- まだ開発中。
- 「フォントをTeXから見えるところに置く」とは、otfファイルを「`<TeXLive環境/>/texmf/fonts/opentype/`」などに置き、「`sudo texhash`」を実行することを表す。otfファイルの置き場所の候補は `kpsewhich --show-path="opentype fonts"` でわかる(「`//`」が末尾に付いたパスはその下位フォルダもすべて探索される)。texhashを実行するまで、TeXシステムからは把握されないことに注意。 `kpsewhich フォントファイル名` でファイル名が出てくればよい。

### LuaLateXの場合
- TeXLive 2016のLuaTeXではjlreqが使用している一部のコマンドが動作しない。
- TeXLive 2017以上(できるだけ先端)を用意する。
- jlreqは含まれているはずだが、必要に応じて `tlmgr install jlreq` で最新のjlreqを入れる。
- config.ymlのtexcommandを「"lualatex"」にする。
- 現在sty/lualatex-ja-fonts.sty ではNotoフォントJP版を使う設定になっているので、NotoフォントをTeXから見えるところに置くか、styファイルを変更する。

### upLaTeXの場合
- TeXLive 2016でも動作するが、jlreqが含まれていない可能性がある。`tlmgr install jlreq` で最新のjlreqを入れる(なお、Debianの場合、個人フォルダにしかインストールできない)。
- 現在sty/uplatex-ja-fonts.sty ではモリサワの商用フォントPr6Nセットを使う設定になっているので、それらのフォントをTeXから見えるところに置くか、styファイルを変更する。詳細については「`texdoc pxchfon`」や http://zrbabbler.sp.land.to/pxchfon.html を参照。
