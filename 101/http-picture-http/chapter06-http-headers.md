# 第六章 HTTP首部

HTTP请求（响应）报文
- 报文首部
  - 请求行
    - 方法（only 请求报文）
    - URI（only 请求报文）
    - HTTP版本
    - 状态码，包括数字和原因短语（only 响应报文）
  - HTTP首部字段
    - 请求首部字段 Request Header Fields（only 请求报文）
    - 响应首部字段 Response Header Fields（only 响应报文）
    - 通用首部字段 General Header Fields
    - 实体首部字段 Entity Header Fields
    - 其他
- CRLF
- 报文主体

## 6.2 HTTP首部字段

### 6.2.1 HTTP首部字段传递重要信息
### 6.2.2 HTTP首部字段结构
### 6.2.3 4种HTTP首部字段类型


### 6.2.4 HTTP/1.1 首部字段一览

通用首部字段
- Cache-Control
- Connection
- Date
- Pragma
- Trailer
- Transfer-Encoding
- Upgrade
- Via
- Warning

请求首部字段
- Accept
- Accept-Charset
- Accept-Encoding
- Accept-Language
- Authorization
- Expect
- From
- Host
- If-Match
- If-Modified-Since
- If-None-Match
- If-Range
- If-Unmodified-Since
- Max-Forwards
- Proxy-Authorization
- Range
- Referer
- TE
- User-Agent


响应首部字段
- Accept-Ranges
- Age
- ETag
- Location
- Proxy-Authenticate
- Retry-After
- Server
- Vary
- WWW-Authenticate


实体首部字段
- Allow
- Content-Encoding
- Content-Language
- Content-Length
- Content-Location
- Content-MD5
- Content-Range
- Content-Type
- Expires
- Last-Modified

### 6.2.5 非HTTP/1.1首部字段
- Cookie
- Set-Cookie
- Content-Disposition
- ......
（这些非正式的首部字段统一归纳在 RFC4229 HTTP Header Field Registrations 中。）

### 6.2.6 End-to-End首部和Hop-by-Hop首部 

端到端首部 End-to-end Header
- 会转发给请求/响应对应的最终接收目标。
- 且必须保存在由缓存生成的响应中。
- 必须被转发。

逐跳首部 Hop-by-hop Header
- 只对单次转发有效，会因通过缓存或代理而不再转发。
- HTTP/1.1和之后版本，如果要使用hop-by-hop首部，需提供Connection首部字段。
- HTTP/1.1中的逐跳首部字段
  - Connection
  - Keep-Alive
  - Proxy-Authenticate
  - Proxy-Authentication
  - Trailer
  - TE
  - Transfer-Encoding
  - Upgrade

### 6.3 HTTP/1.1通用首部字段

### 6.3.1 Cache-Control

一个例子：
```http
Cache-Control: private, max-age=0, no-cache
```

Cache-Control指令
- 缓存请求指令
  - no-cache
  - no-store
  - max-age = [seconds]
  - max-stale(= [seconds])
  - min-fresh = [seconds]
  - no-transform
  - only-if-cached
  - cache-extension
- 缓存响应指令
  - public
  - private
  - no-cache
  - no-store
  - no-transform
  - must-revalidate
  - proxy-revalidate
  - max-age = [seconds]
  - s-maxage = [seconds]
  - cache-extension

表示是否能缓存的指令

- public指令。
  - public，表示可向任意方提供响应的缓存。
  - 缓存响应指令。

```http
Cache-Control: public
```

- private指令。
  - private，仅向特定用户返回响应。
  - 缓存响应指令。
  - 源服务器 对 缓存服务器 说：这份缓存只可以提供给那个家伙使用噢。

```http
Cache-Control: private
```

- no-cache指令。
  - no-cache
    - 使用 no-cache 指令的目的是为了防止从缓存返回过期的资源。
      - 从字面意思上很容易把no-cache误解成不缓存，但事实上no-cache代表不缓存过期的资源，缓存会向源服务器进行有效期确认后处理资源，也许称为 do-not-serve-from-cache-without-revalidation 更合适。no-store才是真正地不进行缓存。
    - 缓存请求指令 + 缓存响应指令。
      - 缓存请求指令：强制向源服务器再次验证。
      - 缓存响应指令: 缓存前必须先确认其有效性。
  - 客户端 对 缓存服务器 说：我不要缓存过的，请给我从源服务器那里拿来的资源。
    - 客户端将不会接收缓存过的响应。
    - “中间”的缓存服务器必须把客户端请求转发给源服务器。
  - 源服务器 对 缓存服务器 说：你可以缓存，但每次使用前记得先想我确认一下。[?] "确认“的意思是？
    - 缓存服务器不能对资源进行缓存。
    - 源服务器以后也将不再对缓存服务器请求中提出的资源有效性进行确认，且禁止其对响应资源进行缓存操作。
    - 由服务器返回的响应中，若报文首部字段Cache-Control中对no-cache字段名具体指定参数值，那么客户端在接收到这个被指定参数值的首部字段对应的响应报文后，就不能使用缓存。换言之，无参数值的首部字段可以使用缓存。

```http
Cache-Control: no-cache
```

```http
Cache-Control: no-cache=Location
```

控制可执行缓存的对象的指令

- no-store指令: 缓存服务器不能在本地存储请求或响应的任一部分。

```http
Cache-Control: no-store
```

---

指定缓存期限和认证的指令
- (1) s-maxage指令
- (2) max-age指令
- (3) min-fresh指令
- (4) max-stale指令
- (5) only-if-cached指令
- (6) must-revaliate指令
- (7) proxy-revaliate指令
- (8) no-transform指令

Cache-Control扩展
- (9) cache-extension token


(1) s-maxage指令(the prefix 's' stands for 'shared')

```http
Cache-Control: s-maxage=604800 (单位：秒)
```

(2) max-age指令

```http
Cache-Control: maxage=604800 (单位：秒)
```

[?] what's the difference between 's-maxage' directive and 'max-age' directive in the 'Cache-Control' header of HTTP?
- s-maxage is used in shared cache, such as CDN or proxies; max-age is utilized in private cache, such as web browswer;
- s-maxage is used only in responses; max-age is used inj both requests and responses;

(3) min-fresh指令

```http
Cache-Control: min-fresh=60 (单位：秒)
```






---


### 6.3.
### 6.3.
### 6.3.
### 6.3.
### 6.3.
### 6.3.
### 6.3.
### 6.3.
### 6.3.
### 6.3.
### 6.3.














































