= 前書き
PREDEF内に列挙したものは前付として章採番なしです。後付のPOSTDEFも同様。`あ'い`A'B、@<tt>{`あ'い`A'B}

PREDEF内/POSTDEFのリストの採番表記は「リスト1」のようになります: @<list>{main1}

（正確にはi18n.yml/locale.ymlのformat_number_header_without_chapterが使われます）

//list[main1][main()]{
`あ'い`A'B
int
main(int argc, char **argv)
{
    puts("OK");
    return 0;
}
//}

図（@<img>{fractal}）、表（@<table>{tbl1}）も同様に章番号なしです。

//image[fractal][フラクタル][latex::width=80mm]{
//}

//image[fractal-50mm][フラクタル（50mm）]{
//}

//table[tbl1][前付表]{
A	B
-----------------
C	D
//}
