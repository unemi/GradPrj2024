# マルチエージェントシミュレーション
## 個体集団
* 個体の表現＋相互作用＋（環境条件）
* 初期状態、状態遷移規則　各個体：状態→行動→次の状態

## 個体の状態
位置（2次元連続値座標）、自分の見た目（可変）、見た目の好み
	性格（ばらつき）：積極性、寛容性、浮気度、移動力
	パートナー：一人 or いない

## 個体の移動規則
* 引力：好きな個人、面白いイベント、学校・職場への定期的移動
* 斥力：嫌いな人、危険なイベント、

## 個体の求愛行動
* 求愛するかどうか：
見つけた相手の好みの度合い＋積極性（＋パートナーがいる場合は浮気度）
* 求愛を受理するかどうか：
	* 	好み度合い＋寛容性（＋パートナーがいる場合は浮気度）
	* 	自分が求愛している相手なら受け入れる。
	*  	複数から求愛されている場合は？
		* そのなかの裁量な相手を受け入れる。
		* 
	* 	自分が他の人に求愛中の場合は？　とりあえず逐次処理、競合は避ける。