# exp-review-cls

2018 Kenshi Muto

Re:VIEWクラスファイルの習作。

syntax-bookを表現するクラスファイルを作成する。

- jlreqクラスベース
- とりあえずlualatexを使用してみている。が、残念ながらDebian StretchのTeXLive2016ではluatex, luatex-jaなどが古くたくさんの問題が発生する。debではなくTeXLive先端環境が必要なため、実用性は低め。
- ある程度見えたらuplatexも考える。

- mdframedよりもtcolorboxのほうがよいのだろうか
- リスト採番を図表と同じようにしようとするとフロートにするしかないか。長いものが多いためフロートには不向き。リテラル表現のほうがよさそう
