impas
=====


Functions
----------


Installation
-----------

### Server side application
- foo

### Crawler
- foo

API
-----
## Responses
### HTTP Responses
- 400
 - Invalid JSON parameters passed.
- 401
 - Invalid API passed.


## POST /api/group/[operation key]
### Parameters
- name
 - Cruese group name

```json
{"name":"sample3"}
```

### Response

```json
{
  "result":"ok",
  "explain":"",
  "description":{}
}
```

## POST /api/url/[group key]

### Parameters
- url
 - Registration URL

```json
{"url":"http://github.com/hideack"}
```

### Response

```json
{
  "result":"ok",
  "explain":"",
  "description":{}
}
```


## GET /api/url/[group key]/[cruese url]


Usage
-----




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

