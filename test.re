= 長い章見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□

== ブロック命令
=== ソースコード
採番付きリストの場合はlistです（@<list>{list2-1}）。@<fn>{f2-1}

//list[list2-1][@<b>{Ruby}の@<tt>{hello}コード][ruby]{
puts 'Hello, World!'
//}

//footnote[f2-1][コードハイライトは外部パッケージに委任しています。TeXではjlisting、HTMLではRouge？]

行番号と採番付きのリストはlistnumです。

//listnum[list2-2][行番号はリテラルな文字で特に加工はしていない][ruby]{
class Hello
  def initialize
    @msg = 'Hello, World!'
  end
end
//}

採番なしはemlistを使います。キャプションはあったりなかったりします。

//emlist[][c]{
printf("hello");
//}

//emlist[Python記法][python]{
print('hello');
//}

行番号付きのパターンとしてemlistnumがあります。

//emlistnum[][c]{
printf("hello");
//}

//firstlinenum[101]
//emlistnum[Python記法][python]{
print('hello');
//}

ソースコード引用を主ターゲットにするのには一応sourceというのを用意しています@<fn>{type}。

//footnote[type][書籍だと、いろいろ使い分けが必要なんですよ……（4、5パターンくらい使うことも）。普通の用途ではlistとemlistで十分だと思いますし、見た目も同じでよいのではないかと。TeXの抽象タグ名は変えてはいます。]

//source[hello.rb][ruby]{
puts 'Hello'
//}

#@# //source{
#@# //}
#@# FIXME:キャプションなしはLaTeXだとエラーになることがわかった。Re:VIEW側修正予定

実行例を示すとき用にはcmdを用意しています。いずれにせよ、商業書籍レベルでは必要なので用意しているものの、原稿レベルで書き手が使うコードブロックはほどほどの数に留めておいたほうがいいのではないかと思います。TeX版の紙面ではデフォルトは黒アミ。印刷によってはベタ黒塗りはちょっと怖いかもなので、あまり長々したものには使わないほうがいいですね。

//cmd{
$ @<b>{ls /}
//}
