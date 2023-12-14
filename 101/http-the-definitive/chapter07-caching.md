
# Chapter 7. Caching 缓存

- how caches improve performance and reduce cost?
- how to measure their effectiveness?
- where to place caches to maximize impact?
- how HTTP keeps cached copies fresh?
- how caches interact with other caches and servers?

## 7.1 Redundant Data Transfers 冗余的数据传输

## 7.2 Bandwith Bottlenecks 带宽瓶颈

## 7.3 Flash Crowds 瞬间拥塞

## 7.4 Distance Delays 距离时延

## 7.5 Hits and Misses 命中和未命中的

### 7.5.1 Revalidations 再验证

- To make revalidations efficient, HTTP defines special requests that can quickly check if content is still fresh, **without fetching the entire object from the server**.

- When a cache needs to revalidate a cached copy, it sends a small revalidation request to the origin server.
  - If the content hasn't changed, the server responds with a tiny 304 Not Modified response.
  - As soon as the cache learns the copy is still valid, it marks the copy temporarily fresh again and serves the copy to the client.
    - This is called a "revalidate hit" or a "slow hit".
      - It's slower than a pure cache hit, because it does need to check with the origin server, but it's faster than a cache miss, because no object data is retrieved from the server.

- HTTP gives us a few tools to revalidate cached objects, but the most popular is the If-Modified-Since header.
  - When added to a GET request, this header tells the server to send the object only if it has been modified since the time the copy was cached.

### 7.5.2 Hit Rate 命中率

- Cache administrators would like the cache hit rate to approach 100%.
- The actual hit rate you get depends on 
  - how big your caches is
  - how similar the interests of the cache users are
  - how frequently the cached data is changing or personalized
  - how the caches are configured
- Hit rate is notoriously difficult to predict, but a hit rate of 40% is decent for a modest web cache today.

### 7.5.3 Byte Hit Rate字节命中率

- Docuement hit rate doesn't tell the whole story, though, because documents are not all the same size.
  - Some large objects might be accessed less often but contribute more to overall data traffic, because of their size.
    - For this reason, some people prefer the "byte hit rate" metric (especially those folks who are billed for each byte of traffic!)

- Document hit rate and byte hit rate are both useful gauges of cache performance.
  - Document hit rate describes how many web transactions are kept off the outgoing network.
    - Because transactions have a fixed time component that can often be large (setting up a TCP connection to a server, for example), improving the document hit rate will optimize for overall latency(delay) reduction.
  - Byte hit rate describes how many bytes are kept off the Internet.
    - Improving the byte hit rate will optimize for bandwidth savings.


### 7.5.4 Distinguishing Hits and Misses 区分命中和未命中的情况

- Unfortunately, HTTP provides no way for a client to tell if a response was a cache hit or an origin server access.
  - In both cases, the response code will be 200 OK, indicating that the response has a body.
  - Some commercial proxy caches attach additional information to Via headers to describe what happened in the cache.
- One way that a client can usually detect if the response came from a cache is to use the Date header.
  - By comparing the value of the Date header in the response to the current time, a client can often detect a cached response by its older date value. [?] how?
- Another way a clent can detect a cached response is the Age header, which tells how old the response is. [?] how?


## 7.6 Cache Topologies 缓存的拓扑结构

- Cache can be dedicated to a single user or shared between thousands of users.
  - Dedicated caches are called "private caches".
    - Private caches are personal caches, containing popular pages for a single user.
  - Shared caches are called "public caches".
    - Public caches contain the pages popular in the user community.

### 7.6.1 Private Caches 私有缓存

- Web browsers have private caches built right in - most browsers cache popular documents in the disk and memory of your personal computer and allow you to configure the cache size and settings.
  - You also can peek inside the browser caches to see what they contain. [?] how?


### 7.6.2 Public Proxy Caches 公有代理缓存

- Proxy caches follow the rules for proxies described in Chapter 6. [?] read Chapter 6.
- You can configure your browser to use a proxy cache by specifying a manual proxy or by configuring a proxy auto-configuration (see Section 6.4.1).
- You also can force HTTP requests through caches without configuring your browser by using intercepting proxies (see Chapter 20).

### 7.6.3 Proxy Cache Hierarchies 代理缓存的层次结构

- In practice, it often makes sense to deploy "hierarchies" of caches, where cache misses in smaller caches are funneled to larger parent caches that service the leftover "distilled" traffic.



### 7.6.4 Cache Meshes, Content Routing, and Peering 网状缓存、内容路由以及对等缓存

- Some network architects build complex "cache meshes" instead of simple cache hierarchies.
  - Proxy caches in cache meshes talk to each other in more sophisticated ways, and make dynamic cache communication decisions, deciding which parent caches to talk to, or deciding to bypass caches entirely and direct themselves to the origin server.
    - Such proxy caches can be described as "content routers", because they make routing decisions about how to access, manage, and deliver content.

- Caches designed for content routing within cache meshes may do all of the following (among other things):
  - Select between a parent cache or origin server dynamically, based on the URL.
  - Select a particular parent cache dynamically, based on the URL.
  - Search caches in the local area for a cached copy before going to a parent cache.
  - Allow other caches to access portions of their cached content, but do not permit Internet transit through their cache.

- Those more complex relationships between caches allow different organizations to peer with each other, connecting their caches for mutual benefit.
  - Caches that provide selective peering support are called "sibling caches".
  - Because HTTP doesn't provide sibling cache support, people have extended HTTP with protocols, such as the Internet Cache Protocol (ICP) and the HyperText Caching Protocol(HTCP). We'll talk about these protocols in Chapter 20.


## 7.7 Cache Processing Steps 缓存的处理步骤

![Figure 7-11. Processing a fresh cache hit](https://learning.oreilly.com/api/v2/epubs/urn:orm:book:1565925092/files/httpatomoreillycomsourceoreillyimages97036.png)
- A basic cache-processing sequence for an HTTP GET message consists of seven steps:
  - 1. Receiving - Cache reads the arriving request message from the network.
  - 2. Parsing - Cache parses the message, extracting the URL and headers.
  - 3. Lookup - Cache checks if a local copy is available and, if not, fetches a copy (and stores it locally).
  - 4. Freshness check - Cache checks if cached copy is fresh enough and, if not, asks server for any updates.
  - 5. Response creation - Cache makes a response message with the new headers and cached body.
  - 6. Sending - Cache sends the response back to the client over the network.
  - 7. Logging - Optionally, cache creates a log file entry describing the transaction.


### 7.7.1 Step 1: Receiving 第一步——接收

### 7.7.2 Step 2: Parsing 第二步——解析

### 7.7.3 Step 3: Lookup 第三步——查找

### 7.7.4 Step 4: Freshness Check 第四步——新鲜度检测

### 7.7.5 Step 5: Response Creation 第五步——创建响应

Note that the cache should NOT adjust the Date header. The Date header represents the date of the object when it was originally genereated at the origin server.

### 7.7.6 Step 6: Sending 第六步——发送

### 7.7.7 Step 7: Logging 第七步——日志

- Most caches keep log files and statistics about cache usage. [?] how about Chrome? Firefox?
- The most popular cache log formats are the Squid log format and the Netscape extended common log format, but many cache products allow you to create custom log files.

### 7.7.8 Cache Processing Flowchart 缓存处理流程图

![Cache Get request flowchart](https://learning.oreilly.com/api/v2/epubs/urn:orm:book:1565925092/files/httpatomoreillycomsourceoreillyimages97038.png)
Figure 7-12. Cache GET request flowchart, shows, in simplified form, how a cache processes a request to GET a URL.

## 7.8 Keeping Copies Fresh 保持副本的新鲜

HTTP includes simple mechanisms to keep cached data sufficiently consistent with servers, without requiring servers to remember which caches have copies of their documents. HTTP calls these simple mechanisms "document expiration" and "server revalidation".

### 7.8.1 Document Expiration 文档过期

- HTTP lets an origin server attach an "expiration date" to each document, using special HTTP Cache-Control and Expires headers.
![Figure 7-13. Expires and Cache Control headers](https://learning.oreilly.com/api/v2/epubs/urn:orm:book:1565925092/files/httpatomoreillycomsourceoreillyimages97040.png)
- Until a cache document expires, the cache can serve the copy as often as it wants, without ever contacting the server - unless, of course, a client request includes headers that prevent a cached or unvalidated resource.
  - But, once the cached document expires, the cache must check with the server to ask if the document has changed and, if so, get a fresh copy (with a new expiration date).

### 7.8.2 Expiration Dates and Ages 过期日期和使用期

- Servers specify expiration dates using the HTTP/1.0+ Expires or the HTTP/1.1 Cache-Control: max-age response headers, which accompany a response body.
- The Expires and Cache-Control: max-age headers do basically the same thing, but the newer Cache-Control header is preferred, because it uses a relative time instead of an absolute date.
  - Absolute dates depend on computer clocks being set correctly.
- Header: Cache-Control: max-age
  - The max-age value defines the maximum age of the document - the maximum legal elapsed time (in seconds) from when a document is first generated to when it can no longer be considered fresh enough to serve.
  - e.g., "Cache-Control: max-age=484200"
- Header: Expires
  - Specifies an absolute expiration date. If the expiration date is in the past, the document is no longer fresh.
  - e.g., "Expires: Fri, 05 Jul 2002, 05:00:00 GMT"

### 7.8.3 Server Revalidation 服务器再验证

- Just because a cached document has expired doesn't mean it is actually different from what's living on the origin server; it just means that it's time to check.
  - This is called "server revalidation," meaning the cache needs to ask the origin server whether the document has changed:
    - If revalidation shows the content has changed, the cache gets a new copy of the document, stores it in place of the old data, and sends the document to the client.
    - If revalidation shows the content has not changed, the cache only gets new headers, including a new expiration date, and updates the headers in the cache.
  - This is a nice system.
    - The cache doesn't have to verify a document's freshness for every request - it has to revalidate with the server only once the document has expired.
      - This saves server traffic and provides better user response time, without serving stale content.

### 7.8.4 Revalidation with Conditional Methods 用条件方法再验证

- HTTP's conditional methods make revalidation efficient.
  - HTTP allows a cache to send a "conditional GET" to the origin server, asking the server to send back an object body only if the document is different from the copy currently in the cache.
    - In this manner, the freshness check and the object fetch are combined into a single conditional GET.
    - Conditional GET's are initiated by adding special conditional headers to GET request messages.
    - The web server returns the object only if the condition is true.
- HTTP defines five conditional request headers.
  - The two that are most useful for cache revalidation are "If-Modified-Since" and "If-None-Match".
    - "If-Modified-Since: date"
      - Perform the requested method if the document has been modified since the specified date.
      - This is used in conjunction with the Last-Modified server response header, to fetch content only if the content has been modified from the cached version.
    - "If-None-Match: tags"
      - Instead of matching on last-modified date, the server may provide special tags (see ETag) on the document that act like serial numbers.
      - The If-None-Match header performs the requested method if the cached tags differ from the tags in the server's document.

### 7.8.5 If-Modified-Since:Date再验证

- The most common revalidation header is "If-Modified-Since".
  - "If-Modified-Since" revalidation requests often are called "IMS" requests.
  - IMS requests instruct a server to perform the request only if the resource has changed since a certain date:
    - If the document was modified since the specified date, the If-Modified-Since condition is true, and the GET succeeds normally. The new document is returned to the cache, along with new headers containing, among other information, a new expiration date.
    - If the document was not modified since the specified date, the condition is false, and a small 304 Not Modified response message is returned to the client, without a document body, for efficiency.
      - Headers are turned in the response; however, only the headers that need updating from the original need to be returned.
        - For example, the Content-Type header does not usually need to be sent, since it usually has not changed. A new expiration date typically is sent.

- The If-Modified-Since header works in conjunction with the Last-Modified server response header.
  - The origin server attaches the last modification date to served documents. When a cache wants to revalidate a cached document, it includes an If-Modified-Since header with the date the cached copy was last modified:
  - If the content has changed in the meantime, the last modification date will be different, and the origin server will send back the new document. Otherwise, the server will note that the cache's last-modified date matches the server document's current last-modified date, and it will return a 304 Not Modified response.

```http
If-Modified-Since: <cached last-modified date>
```

- Note that some web servers don't implement If-Modified-Since as a true date comparison. Instead, they do a string match between the IMS date and the last-modified date.
  - As such, the semantics behave as "if not last modified on this exact date" instead of "if modified since this date."
  - This alternative semantic works fine for cache expiration, when you are using the last-modified date as a kind of serial number, but it prevents clients from using the If-Modified-Since header for true time-based purposes.

![Figure 7-14. If-Modified-Since revalidations return 304 if unchanged or 200 with new body if changed](https://learning.oreilly.com/api/v2/epubs/urn:orm:book:1565925092/files/httpatomoreillycomsourceoreillyimages97042.png)


### 7.8.6 If-None-Match: Entity Tag Revalidation (If-None-Match: 实体标签再验证)

- There are some situations when the last-modified date revalidation isn't adequate:
  - Some documents may be rewritten periodically (e.g., from a background process) but actually often contain the same data. The modification dates will change, even though the content hasn't.
  - Some documents may have changed, but only in ways that aren't important enough to warrant caches worldwide to reload the data (e.g., spelling or comment changes).
  - Some servers cannot accurately determine the last modification dates of their pages.
  - For servers that serve documents that change in sub-second intervals (e.g., real-time monitors), the one-second granularity of modification dates might not be adequate.

- To get around these problems, HTTP allows you to compare document "version identifiers" called "entity tags(ETags)".
  - Entity tags are arbitrary labels (quoted strings) attached to the document.
    - They might contain a serial number or version name for the document, or a checksum or other fingerprint of the document content.
  - When the publisher makes a document change, he can change the document's entity tag to represent this new version.
    - Cache can then use the If-None-Match conditional header to GET a new copy of the document if the entity tags have changed.

![Figure 7-15. If-None-Match revalidate because entity tag still matches](https://learning.oreilly.com/api/v2/epubs/urn:orm:book:1565925092/files/httpatomoreillycomsourceoreillyimages97044.png)

- Several entity tags can be included in an If-None-Match header, to tell the server that the cache already has copies of objects with those entity tags:
```http
If-None-Match: "v2.6"
If-None-Match: "v2.4", "v2.5", "v2.6"
If-None-Match: "foobar", "Profiles in Courage"
```

### 7.8.7 Weak and Strong Validators 强弱验证器

- Cache use entity tags to determine whether the cached version is up-to-date with respect to the server (much like they use last-modified dates). In this way, entity tags and last-modified dates both are "cache validators".
- Servers may sometimes want to allow cosmetic or insignificant changes to documents without invalidating all cached copies.
  - **HTTP/1.1 supports "weak validators," which allow the server to claim "good enough" equivalence even if the contents have changed slightly.**
- Strong validators change any time the content changes. Weak validators allow some content change but generally change when the significant meaning of the content changes.
  - **Some operations cannot be performed using weak validators (such as conditional partial-range fetches), so servers identify validators that are weak with a "W/" prefix.**
  - A strong entity tag must change whenever the associated entity value changes in any way. A weak entity tag should change whenever the associated entity changes in any way. 
  - A weak entity tag should change whenever the associated entity changes in a semantically significanty way.

```http
ETag: W/"v2.6"
If-None-Match: W/"v2.6"
```

- Note that an origin server must avoid reusing a specific strong entity tag value for two different entities, or reusing a specific weak entity tag value for two semantcially different entities.
  - Cache entries might persist for arbitrarily long periods, regardless of expiration times, so it might be inappropriate to expect that a cache will never again attempt to validate an entry using a validator that it obtained at some point in the past.

### 7.8.8 When to use entity tags and last-modified dates 什么时候应该使用实体标签和最近修改日期

- HTTP/1.1 clients must use an entity tag validator if a server sends back an entity tag.
  - If the server sends back only a Last-Modified value, the client use If-Modified-Since validation.
  - If both an entity tag and a last-modified date are available, the client should use both revalidation schemes, allowing both HTTP/1.0 and HTTP/1.1 caches to respond appropriately.
- HTTP/1.1 origin servers should send an entity tag validator unless it is not feasible to generate one, and it may be a weak entity tag instead of a strong entity tag, if there are benefits to weak validators. Also, it's preferred to also send a last-modified value.
- If an HTTP/1.1 cache or server receives a request with both If-Modified-Since and entity tag conditional headers, it must not return a 304 Not Modified response unless doing so is consistent with all of the conditional header fields in the request.


```
Note that all HTTP dates and times are expressed in Greenwich Mean Time (GMT).
GMT is the time at the prime meridian (0 longitude) that passes through Greenwich, UK.
GMT is five hours ahead of U.S. Eastern Standard Time, so midnight EST is 05:00 GMT.
```

## 7.9 Controlling Cachability 控制缓存的能力

- HTTP defines several ways for **a server** to specify **how long a document can be cached before it expires**.
- In decreasing order of priority, the server can:
  - Attach a "Cache-Control: no-store" header to the response
  - Attach a "Cache-Control: must-revalidate" header to the response
  - Attach a "Cache-Control: no-cache" header to the response
  - Attach a "Cache-Control: max-age" header to the response
  - Attach an "Expires date header" to the response
  - Attach no expiration information, letting the cache determine its own heuristic expiration date

### 7.9.1 No-Cache and No-Store Headers / no-Store与no-Cache响应首部

- HTTP/1.1 offers several ways to mark an object uncachable.
- Here are a few HTTP headers that mark a document uncachable:

```http
Pragma: no-cache
Cache-Control: no-cache
Cache-Control: no-store
```

- RFC 2616 allows a cache to store a response that is marked "no-cache"; however, the cache needs to revalidate the response with the origin server before serving it.
- A response that is marked "no-store" forbids a cache from making a copy of the response. A cache should not store this response.

- The "Pragma: no-cache" header is included in HTTP 1.1 for backward compatibility with HTTP 1.0+.
  - It is technically valid and defined only for HTTP requests; however, it is widely used as an extension header for both HTTP 1.0 and 1.1 requests and responses.
- HTTP 1.1 applications should use "Cache-Control: no-cache", except when dealing with HTTP 1.0 applications, which understand only "Pragma: no-cache".

### 7.9.2 Max-Age Response Headers / max-age响应首部

- The "Cache-Control: max-age" header indicates the number of seconds since it came from the server for which a document can be considered fresh.
  - There is also an s-maxage header that acts like max-age but applies only to shared(public) caches:

```http
Cache-Control: max-age=3600
Cache-Control: s-maxage=3600
```

- Servers can request that caches either not cache a document or refresh on every access by setting the maximum aging to zero:

```http
Cache-Control: max-age=0
Cache-Control: s-maxage=0
```

### 7.9.3 Expires Response Headers / Expires响应首部

- The **deprecated Expires header** specifies an actual expiration date instead of a time in seconds.
  - The HTTP designers later decided that, because many servers have unsynchronized or incorrect clocks, it would be better to represent expiration in elapsed seconds, rather than absolute time.
  - An analogous freshness lifetime can be calculated by computing the number of seconds difference between the expires value and the date value:

```http
Expires: Fri, 05 Jul 2002, 05:00:00 GMT
```

- Some servers also send back an "Expires: 0" response header to try to make documents always expire, but this syntax is illegal and can cause problems with some software.
  - You should try to support this construct as input, but shouldn't generate it.

### 7.9.4 Must-Revalidate Response Headers / must-revaliate响应首部

- The "Cache-Control: must revalidate" header tells the cache to bypass the freshness calculation mechanisms and revalidate on every access:

```http
Cache-Control: must-revalidate
```

- **Attaching this header to a response is actually a stronger caching limitation than using "Cache-Control: no-cache", because this header instructs a cache to ALWAYS revalidate the response before serving the cached copy.**
  - This is true even if the server is unavailable, in which case the cache should not serve the cached copy, as it can't revalidate the response.
  - Only the "no-store" directive is more limiting on a cache's behavior, because the no-store directive instructs the cache to not even make a copy of the resource(thereby always forcing the cache to retrieve the resource)

### 7.9.5 Heuristic Expiration / 试探性过期

- **If the response doesn't contain either a "Cache-Control: max-age" header or an "Expires header", the cache may compute a heuristic maximum age.**
  - Any algorithm may be used, but if the resulting maximum age is greater than 24 hours, a Heuristic Expiration Warning(Warning 13) header should be added to the response headers.
    - **As far as we know, few browsers make this warning information available to users.**

- One popular heuristic expiration algorithm, the **LM-Factor** algorithm, can be used **if the document contains a last-modified date**.
- The LM-Factor algorithm uses the last-modified date as an estimate of how volatile a document is. Here's the logic:
  - If a cached document was last changed in the distant past, it may be a stable document and less likely to change suddenly, so it is safer to keep it in the cache longer.
  - If the cached document was modified just recently, it probably changes frequently, so we should cache it only a short while before revalidating with the server.

- The actual LM-Factor algorithm computes the time between when the cache talked to the server and when the server said the document was last modified, takes some fraction of this intervening time, and uses this fraction as the freshness duration in the cache.
  - Here is some Perl pseudocode for the LM-factor algorithm:

```perl
$time_since_modify = max(0, $server_Date - $server_Last_Modified);
$server_freshness_limit = int($time_since_modify * $lm_factor);
```



### 7.9.6 客户端的新鲜度限制
### 7.9.7 注意事项


## 7.10 Setting Cache Controls 设置缓存控制
### 7.10.1 控制Apache的HTTP首部
### 7.10.2 通过 HTTP-EQUIV 控制HTML缓存
## 7.11 Detailed Algorithms 详细算法
### 7.11.1 使用期和新鲜生存期
### 7.11.2 使用期的计算
### 7.11.3 完整的使用期计算算法
### 7.11.4 新鲜生存期计算
### 7.11.5 完整的服务器——新鲜度算法
## 7.12 Caches and Advertising 缓存和广告
### 7.12.1 发布广告者的两难处境
### 7.12.2 发布者的响应
### 7.12.3 日志迁移
### 7.12.4 命中计数和使用限制
## 7.13 For More Information 更多信息





