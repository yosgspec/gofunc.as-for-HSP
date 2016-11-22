# gofunc.as-for-HSP
gosubを隠蔽して引数とか戻り値っぽいものを使用するためのモジュール。

## 注意点
* あくまでも実体はラベルであるため、モジュールを跨ぐには小細工が必要。
* 引数に見えるものは全てstr型となるためキャストが必須。
* そのため一括キャスト用にintsとdoubulesを用意。
* ->zipArray、unzipArray追加。その他配列補助命令、関数大幅追加。
* 渡せる型はint,double,str型のみ。
* 引数最大個数10個まで。
* 使いたい人がもしいればご自由に。ライセンスはパブリックドメインです。
* そのほかバグ未保障。

## モジュール仕様
### gofuncモジュール<命令・関数>一覧    

  #define funcArea { ... }

* この中にdef文を配置するとブロックを作り、  
  関数の起動を阻止することができる。

  #define fn(funcName)

* 関数名から固有の定義名を生成する。  
  #enumで関数と紐づけたい時などに使用。

  #define def(funcName [, str p1, str p2, ...str p10])

* 関数の開始を示す。  
	p1～p10は与えられた引数となるが、str型固定となる。  
	必要に応じて個別にキャスト(型変換)を行う。

  #define resolve var Result

* def文の返り値を指定する。

  #define endef

* def文の終了を明示する。

  str #defcfunc call(variable label funcName [, var p1,var p2, ...var p10])
  str #defcfunc funcall(variable label funcName [, var p1, var p2, ...var p10])

* def文で定義された関数を呼ぶ。  
	返り値にresolveで指定された値が返る。  
	labelは変数に代入された状態である必要がある。

  #deffunc subcall [, var p1, var p2, ...var p10]

* def文で定義された関数を呼ぶ。  
	返り値を取得しない。  
	素のlabelを指定可。  
	なお、引数としてstr、int、double型以外の型は受け付けない。  
	配列はzipArrayを用いて渡すこと。

  #deffunc ints [ref int p1, int p2, ...int p10]
  #deffunc doubles [ref double p1, double p2, ...double p10]

* 引数に含めた物をintまたはdouble型にキャスト(変換)して返す。

  str #defcfunc zipArray(array anyArray)

* 配列を可逆的変換可能な文字列へ変換する。

  #deffunc unzipArray str zipString, ref array ResultArray

* zipArrayで変換された文字列を配列に復元して、  
	ResultArrayに返す。

  #deffunc pushArray array anyArray, var addItem

* 配列の最後にaddItemで指定した値を追加する。

  #deffunc unshiftArray array anyArray, var addItem

* 配列の最前にaddItemで指定した値を追加する。

  #deffunc popArray array anyArray [, ref var removeItem]

* 配列の最後を削除し、removeItemに削除した値を返す。

  #deffunc shiftArray array anyArray [, ref var removeItem]

* 配列の最前を削除し、removeItemに削除した値を返す。

  #deffunc copyArray array baseArray, ref array cloneArray

* 配列をcloneArrayへコピーして返す。

  #deffunc addRange ref array array1, array array2

* 配列 array1の後に配列 array2を結合する

  str #defcfunc joinStr(array anyArray [, str delimiter]

* 配列を任意の文字列で区切った文字列に変換する。  
	デフォルトでは","で区切られる。

### サンプル  

  #runtime "hsp3cl"
  #include "gofunc.as"

  #module Program
    #deffunc main
      getfunc=*hoge
      mes call(getfunc,"say!")
      fl=*baz
      mes call(fl,1,2,3,4,5)
      subcall *huga,1,2,3,4,5
    return

    def(baz,a,b,c,d,e)
      ints a,b,c,d,e
      resolve a+b+c+d+e
    endef

    def(huga,a,b,c,d,e)
      mes a+b+c+d+e
    endef

    def(hoge,foo)
      mes foo
      aa="[]"
      pushArray aa,500
      mes joinStr(aa)
      pushArray aa,1000
      mes joinStr(aa)
      unshiftArray aa,1500
      popArray aa,pop
      bb="[]"
      unshiftArray bb,200
      unshiftArray bb,400
      unshiftArray bb,600

      mes joinStr(aa)
      mes joinStr(bb)
      addRange aa,bb
      mes joinStr(aa)
      mes pop
      resolve foo+"hello!"
    endef
  #global
  main
