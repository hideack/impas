Impas
=====

![Impas](https://raw.github.com/hideack/impas/master/public/images/impas-logo.png)



Functions
----------
Impas(インパス)はあなたが登録したURLからランキングを生成するAPIサービスです。    
Impasは登録したURLに対して付与された各種ソーシャルメディアの指数を計測し、指数に基づいたランキング情報を生成します。
現在取得するソーシャルメディアとしては

- twitter上でのツイート数
- facebook上でのいいね数
- はてなブックマークでのブックマーク数
- ImpasへのURL登録回数

がランキング用の指数として利用されます。


URLの登録及び、ランキング情報の取得はImpasが用意するAPIから操作することができます。   
また、APIの操作はRuby用のクライアントからも操作できます。

- Impas-client
 - https://github.com/hideack/impas-client
 - https://rubygems.org/gems/impas-client
 

![Over view](https://raw.github.com/hideack/impas/master/public/images/impas-overview.png)


Installation
-----------

### Server side application
config.ru を利用して任意のRubyアプリケーションサーバでrackupします。

### Crawler

```
bundle exec padrino rake all_crawle
```

API
-----

## POST /api/group/[operation key]
集計グループの新規追加

### POST body parameters
- name
 - Cruese group name

```javascript
{"name":"sample3"}
```

### Response

```javascript
{
  "result":"ok",
  "explain":"",
  "description":{}
}
```

### Status

- 200
 - API呼び出し成功
- 400
 - APIで引き渡されたパラメータが不正
- 401
 - APIキー(グループキー, 制御キー)が不正


## DELETE /api/url/[operation key]/[group key]
登録した集計グループの削除

### HTTP Response
- 200
 - 集計グループの削除成功
- 401
 - 操作用のオペレーションキー誤り
- 404
 - 削除対象のグループキーが存在しない


## GET /api/url/[operation key]
集計グループ一覧の取得。

### Response

```
{
    "result": "ok",
    "explain": "",
    "description": {
        "groups": [
            {
                "name": "test",
                "key": "ab284585faac7fa8205e1d15d90ee348"
            },
            {
                "name": "test2",
                "key": "1258240ff6be2b37fcc39ef3aeca81b9"
            }
        ]
    }

}
```

### Status

- 200
 - API呼び出し成功
- 400
 - APIで引き渡されたパラメータが不正
- 401
 - APIキー(グループキー, 制御キー)が不正


## POST /api/url/[group key]
集計グループにURLを登録。

### POST body Parameters
- url
 - Registration URL

```javascript
{"url":"http://github.com/hideack"}
```

### Response

```javascript
{
  "result":"ok",
  "explain":"",
  "description":{}
}
```

### Status

- 200
 - API呼び出し成功
- 400
 - APIで引き渡されたパラメータが不正
- 401
 - APIキー(グループキー, 制御キー)が不正


## GET /api/ranking/[group key]/[ranking type]/[limit]
対象集計グループに対するランキングを取得します。


### parameters
- group key : グループ毎に割り当てられたキーを指定
- ranking type : ランキングソート種別を指定
 - tw: twitterツイート数降順でソート
 - fb: facebookいいね数降順でソート
 - hatena: はてなブックマーク数降順でソート
 - all: 上記全てのパラメータを加算した結果でソート 
- limit : 最大取得数を指定


```javascript
{

    "result": "ok",
    "explain": "",
    "description": {
        "ranking": [
            {
                "callcount": 3,
                "fb": 0,
                "hatena": 110,
                "tw": 5019,
                "url": "http://www.youtube.com/watch?v=UGP_hoQpLZQ"
            },
            {
                "callcount": 1,
                "fb": 5222,
                "hatena": 18,
                "tw": 1885,
                "url": "http://www.youtube.com/watch?v=iyw6-KVmgow"
            },
            {
                "callcount": 1,
                "fb": 0,
                "hatena": 4,
                "tw": 525,
                "url": "http://www.youtube.com/watch?v=r9pqRJgc5Wg"
            }
        ]
    }
}
```

Thanks
-------
- Team REMP 
 - hika69, [@hika69](http://twitter.com/hika69) 


Contributing
------------

1. Fork it.
2. Create a branch (`git checkout -b my_markup`)
3. Commit your changes (`git commit -am "Added Snarkdown"`)
4. Push to the branch (`git push origin my_markup`)
5. Open a [Pull Request][1]
6. Enjoy a refreshing Diet Coke and wait

License
-------

## Copyright
&copy; @hideack

## License
MIT LICENSE

[1]: http://github.com/hideack/impas/pulls

