Impas
=====

Functions
----------
Impasは登録したURLに対して付与された各種ソーシャルメディアの指数を計測し、指数に基づいたランキング情報を生成します。
現在取得するソーシャルメディアはtwitter上でのツイート数、facebook上でのいいね数、はてなブックマークでのブックマーク数及び、
ImpasへのURL登録回数がランキング用の指数として利用されます。


URLの登録及び、ランキング情報の取得はImpasが用意するAPIから操作することができます。
また、APIの操作はRuby用のクライアントからも操作できます。

- Impas-client
 - https://github.com/hideack/impas-client

Installation
-----------

### Server side application
- nil

### Crawler

```
bundle exec padrino rake all_crawle
```

API
-----
## Responses
### HTTP Responses
- 400
 - Invalid JSON parameters passed.
- 401
 - Invalid API passed.


## POST /api/group/[operation key]
### POST boyd parameters
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

## GET /api/url/[operation key]
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

## POST /api/url/[group key]

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

## GET /api/ranking/[group key]/[ranking type]/[limit]
### parameters
- group key
- ranking type
 - all:
 - tw:
 - fb:
 - hatena:
- limit
 - Top *** ranking

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

