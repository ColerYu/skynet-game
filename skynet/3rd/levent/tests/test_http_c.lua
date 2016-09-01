local c = require "levent.http.c"
print("test:", c.version())

local requests = {
    {
        name = "curl get",
        is_request = true,
        raw = "GET /test HTTP/1.1\r\n"..
            "User-Agent: curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1\r\n"..
            "Host: 0.0.0.0=5000\r\n"..
            "Accept: */*\r\n"..
            "\r\n",
        keepalive = true,
        http_major = 1,
        http_minor = 1,
        method = "GET",
        request_url= "/test",
        request_path = "/test",
        num_headers = 3,
        headers = {
            ["User-Agent"] = "curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1",
            ["Host"] = "0.0.0.0=5000",
            ["Accept"] = "*/*"
        },
    },
    {
        name = "firefox get",
        is_request = true,
        raw= "GET /favicon.ico HTTP/1.1\r\n" ..
             "Host: 0.0.0.0=5000\r\n" ..
             "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0\r\n" ..
             "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n" ..
             "Accept-Language: en-us,en;q=0.5\r\n" ..
             "Accept-Encoding: gzip,deflate\r\n" ..
             "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n" ..
             "Keep-Alive: 300\r\n" ..
             "Connection: keep-alive\r\n" ..
             "\r\n",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_url= "/favicon.ico",
        request_path= "/favicon.ico",
        num_headers= 8,
        headers=
            { ["Host"]= "0.0.0.0=5000",
              ["User-Agent"] = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0",
              ["Accept"]= "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
              ["Accept-Language"]= "en-us,en;q=0.5",
              ["Accept-Encoding"]= "gzip,deflate",
              ["Accept-Charset"]= "ISO-8859-1,utf-8;q=0.7,*;q=0.7",
              ["Keep-Alive"]= "300",
              ["Connection"]= "keep-alive",
            }
    },
    {
        name= "dumbfuck",
        is_request=true,
        raw= "GET /dumbfuck HTTP/1.1\r\n" ..
             "aaaaaaaaaaaaa:++++++++++\r\n" ..
             "\r\n",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_path= "/dumbfuck",
        request_url= "/dumbfuck",
        num_headers= 1,
        headers=
          { ["aaaaaaaaaaaaa"] =  "++++++++++"
          }
    },
    {
        is_request = "true",
        name= "fragment in uri",
        raw= "GET /forums/1/topics/2375?page=1#posts-17408 HTTP/1.1\r\n"..
                 "\r\n",
        keepalive = true,
        http_major = 1,
        http_minor = 1,
        method = "GET",
        request_url = "/forums/1/topics/2375?page=1#posts-17408",
        query_string = "page=1",
        fragment = "posts-17408",
        request_path = "/forums/1/topics/2375",
        num_headers = 0,
    },
    {
        name= "get no headers no body",
        is_request = "true",
        raw= "GET /get_no_headers_no_body/world HTTP/1.1\r\n" ..
             "\r\n",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_path= "/get_no_headers_no_body/world",
        request_url= "/get_no_headers_no_body/world",
        num_headers= 0,
    },
    {
        name = "get one header no body",
        is_request = true,
        raw= "GET /get_one_header_no_body HTTP/1.1\r\n" ..
             "Accept: */*\r\n" ..
             "\r\n",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_path= "/get_one_header_no_body",
        request_url= "/get_one_header_no_body",
        num_headers= 1,
        headers= { ["Accept"] =  "*/*" },
    },
    {
        name= "get funky content length body hello",
        is_request=true,
        raw= "GET /get_funky_content_length_body_hello HTTP/1.0\r\n"..
             "conTENT-Length: 5\r\n"..
             "\r\n" ..
             "HELLO",
        keepalive= false,
        http_major= 1,
        http_minor= 0,
        method= "GET",
        request_path= "/get_funky_content_length_body_hello",
        request_url= "/get_funky_content_length_body_hello",
        num_headers= 1,
        headers= {["conTENT-Length"]="5"} ,
        body= "HELLO",
    },
    {
        name= "post identity body world",
        is_request = true,
        raw= "POST /post_identity_body_world?q=search#hey HTTP/1.1\r\n"..
             "Accept: */*\r\n" ..
             "Transfer-Encoding: identity\r\n"..
             "Content-Length: 5\r\n"..
             "\r\n"..
             "World",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "POST",
        query_string= "q=search",
        fragment= "hey",
        request_path= "/post_identity_body_world",
        request_url= "/post_identity_body_world?q=search#hey",
        num_headers= 3,
        headers= { ["Accept"] = "*/*",
            ["Transfer-Encoding"] = "identity",
            ["Content-Length"] = "5"
        },
        body= "World"
    },
    {
        name= "post - chunked body: all your base are belong to us",
        is_request = true,
        raw= "POST /post_chunked_all_your_base HTTP/1.1\r\n" ..
             "Transfer-Encoding: chunked\r\n" ..
             "\r\n" ..
             "1e\r\nall your base are belong to us\r\n" ..
             "0\r\n" ..
             "\r\n",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "POST",
        request_path= "/post_chunked_all_your_base",
        request_url= "/post_chunked_all_your_base",
        num_headers= 1,
        headers= { ["Transfer-Encoding"] =  "chunked"},
        body= "all your base are belong to us"
    },
    {
        name= "two chunks ; triple zero ending",
        is_request = true,
        raw= "POST /two_chunks_mult_zero_end HTTP/1.1\r\n" ..
             "Transfer-Encoding: chunked\r\n" ..
             "\r\n" ..
             "5\r\nhello\r\n"..
             "6\r\n world\r\n"..
             "000\r\n"..
             "\r\n",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "POST",
        request_path= "/two_chunks_mult_zero_end",
        request_url= "/two_chunks_mult_zero_end",
        num_headers= 1,
        headers= { ["Transfer-Encoding"] = "chunked"},
        body= "hello world",
    },
    {
        name= "chunked with trailing headers. blech.",
        is_request=true,
        raw= "POST /chunked_w_trailing_headers HTTP/1.1\r\n" ..
             "Transfer-Encoding: chunked\r\n" ..
             "\r\n" ..
             "5\r\nhello\r\n" ..
             "6\r\n world\r\n" ..
             "0\r\n" ..
             "Vary: *\r\n" ..
             "Content-Type: text/plain\r\n" ..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "POST",
        request_path= "/chunked_w_trailing_headers",
        request_url= "/chunked_w_trailing_headers",
        num_headers= 3,
        headers= { ["Transfer-Encoding"] = "chunked",
            ["Vary"] = "*",
            ["Content-Type"] = "text/plain",
        },
        body= "hello world"
    },
    {
        name= "with bullshit after the length",
        is_request = true,
        raw= "POST /chunked_w_bullshit_after_length HTTP/1.1\r\n"..
             "Transfer-Encoding: chunked\r\n"..
             "\r\n"..
             "5; ihatew3;whatthefuck=aretheseparametersfor\r\nhello\r\n"..
             "6; blahblah; blah\r\n world\r\n"..
             "0\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "POST",
        request_path= "/chunked_w_bullshit_after_length",
        request_url= "/chunked_w_bullshit_after_length",
        num_headers= 1,
        headers= { ["Transfer-Encoding"] = "chunked"},
        body= "hello world"
    },
    {  
        name= "with quotes",
        is_request = true,
        raw= "GET /with_\"stupid\"_quotes?foo=\"bar\" HTTP/1.1\r\n\r\n",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        query_string= "foo=\"bar\"",
        request_path= "/with_\"stupid\"_quotes",
        request_url= "/with_\"stupid\"_quotes?foo=\"bar\"",
        num_headers= 0,
        headers= {},
    },
    {
        name = "apachebench get",
        is_request = true,
        raw= "GET /test HTTP/1.0\r\n"..
             "Host: 0.0.0.0:5000\r\n"..
             "User-Agent: ApacheBench/2.3\r\n"..
             "Accept: */*\r\n\r\n",
        keepalive= false,
        http_major= 1,
        http_minor= 0,
        method= "GET",
        request_path= "/test",
        request_url= "/test",
        num_headers= 3,
        headers= {["Host"] = "0.0.0.0:5000",
                  ["User-Agent"] = "ApacheBench/2.3",
                  ["Accept"] = "*/*",
                 },
    },
    { 
        name = "query url with question mark",
        is_request = true,
        raw= "GET /test.cgi?foo=bar?baz HTTP/1.1\r\n\r\n",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        query_string= "foo=bar?baz",
        request_path= "/test.cgi",
        request_url= "/test.cgi?foo=bar?baz",
        num_headers= 0,
        headers= {},
    },
    {
        name = "newline prefix get",
        is_request = true,
        raw= "\r\nGET /test HTTP/1.1\r\n\r\n",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_path= "/test",
        request_url= "/test",
        num_headers= 0,
        headers= { },
    },
    {
        name = "upgrade request",
        is_request = true,
        raw= "GET /demo HTTP/1.1\r\n"..
             "Host: example.com\r\n"..
             "Connection: Upgrade\r\n"..
             "Sec-WebSocket-Key2: 12998 5 Y3 1  .P00\r\n"..
             "Sec-WebSocket-Protocol: sample\r\n"..
             "Upgrade: WebSocket\r\n"..
             "Sec-WebSocket-Key1: 4 @1  46546xW%0l 1 5\r\n"..
             "Origin: http://example.com\r\n"..
             "\r\n"..
             "Hot diggity dogg",
        keepalive= true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_path= "/demo",
        request_url= "/demo",
        num_headers= 7,
        upgrade=true,
        headers= { ["Host"] = "example.com",
                   ["Connection"]= "Upgrade" ,
                   ["Sec-WebSocket-Key2"]= "12998 5 Y3 1  .P00" ,
                   ["Sec-WebSocket-Protocol"]= "sample" ,
                   ["Upgrade"]= "WebSocket" ,
                   ["Sec-WebSocket-Key1"]= "4 @1  46546xW%0l 1 5" ,
                   ["Origin"]= "http://example.com" ,
                 }
    },
    {
        name = "connect request",
        is_request=true,
        raw= "CONNECT 0-home0.netscape.com:443 HTTP/1.0\r\n"..
             "User-agent: Mozilla/1.1N\r\n"..
             "Proxy-authorization: basic aGVsbG86d29ybGQ=\r\n"..
             "\r\n"..
             "some data\r\n"..
             "and yet even more data",
        keepalive=false,
        http_major= 1,
        http_minor= 0,
        method= "CONNECT",
        request_url= "0-home0.netscape.com:443",
        num_headers= 2,
        upgrade=true,
        headers= { ["User-agent"] = "Mozilla/1.1N",
                   ["Proxy-authorization"] = "basic aGVsbG86d29ybGQ="
                 }
    },
    {
        name= "report request",
        is_request=true,
        raw= "REPORT /test HTTP/1.1\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "REPORT",
        request_path= "/test",
        request_url= "/test",
        num_headers= 0,
        headers= {},
    },
    {
        name= "request with no http version",
        is_request=true,
        raw= "GET /\r\n"..
             "\r\n",
        keepalive=false,
        http_major= 0,
        http_minor= 9,
        method= "GET",
        request_path= "/",
        request_url= "/",
        num_headers= 0,
        headers= {},
    },
    {
        name= "m-search request",
        is_request=true,
        raw= "M-SEARCH * HTTP/1.1\r\n"..
             "HOST: 239.255.255.250:1900\r\n"..
             "MAN: \"ssdp:discover\"\r\n"..
             "ST: \"ssdp:all\"\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "M-SEARCH",
        request_path= "*",
        request_url= "*",
        num_headers= 3,
        headers= { ["HOST"] = "239.255.255.250:1900",
                   ["MAN"]= "\"ssdp:discover\"",
                   ["ST"]= "\"ssdp:all\"",
                 }
    },
    {
        name= "line folding in header value",
        is_request=true,
        raw= "GET / HTTP/1.1\r\n"..
             "Line1:   abc\r\n"..
             "\tdef\r\n"..
             " ghi\r\n"..
             "\t\tjkl\r\n"..
             "  mno \r\n"..
             "\t \tqrs\r\n"..
             "Line2: \t line2\t\r\n"..
             "Line3:\r\n"..
             " line3\r\n"..
             "Line4: \r\n"..
             " \r\n"..
             "Connection:\r\n"..
             " close\r\n"..
             "\r\n",
        keepalive=false,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_path= "/",
        request_url= "/",
        num_headers= 5,
        headers= { ["Line1"]= "abc\tdef ghi\t\tjkl  mno \t \tqrs",
                 ["Line2"]= "line2\t",
                 ["Line3"]= "line3",
                 ["Line4"]= "",
                 ["Connection"]= "close"
                 }
    },
    {
        name= "host terminated by a query string",
        is_request=true,
        raw= "GET http://hypnotoad.org?hail=all HTTP/1.1\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        query_string= "hail=all",
        request_url= "http://hypnotoad.org?hail=all",
        host= "hypnotoad.org",
        num_headers= 0,
        headers= {}
    },
    {
        name= "host:port terminated by a query string",
        is_request=true,
        raw= "GET http://hypnotoad.org:1234?hail=all HTTP/1.1\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        query_string= "hail=all",
        request_url= "http://hypnotoad.org:1234?hail=all",
        host= "hypnotoad.org",
        port= 1234,
        num_headers= 0,
        headers= {}
    },
    {
        name= "host:port terminated by a space",
        is_request=true,
        raw= "GET http://hypnotoad.org:1234 HTTP/1.1\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_url= "http://hypnotoad.org:1234",
        host= "hypnotoad.org",
        port= 1234,
        num_headers= 0,
        headers= { },
    },
    {
        name = "PATCH request",
        is_request=true,
        raw= "PATCH /file.txt HTTP/1.1\r\n"..
             "Host: www.example.com\r\n"..
             "Content-Type: application/example\r\n"..
             "If-Match: \"e0023aa4e\"\r\n"..
             "Content-Length: 10\r\n"..
             "\r\n"..
             "cccccccccc",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "PATCH",
        request_path= "/file.txt",
        request_url= "/file.txt",
        num_headers= 4,
        headers= {["Host"]= "www.example.com",
                  ["Content-Type"]= "application/example",
                  ["If-Match"]= "\"e0023aa4e\"",
                  ["Content-Length"]= "10",
                 },
        body= "cccccccccc"
    },
    {
        name = "connect caps request",
        is_request=true,
        raw= "CONNECT HOME0.NETSCAPE.COM:443 HTTP/1.0\r\n"..
             "User-agent: Mozilla/1.1N\r\n"..
             "Proxy-authorization: basic aGVsbG86d29ybGQ=\r\n"..
             "\r\n",
        keepalive=false,
        http_major= 1,
        http_minor= 0,
        method= "CONNECT",
        request_url= "HOME0.NETSCAPE.COM:443",
        upgrade = true,
        num_headers= 2,
        headers= {["User-agent"]= "Mozilla/1.1N",
                  ["Proxy-authorization"]= "basic aGVsbG86d29ybGQ=",
                 }
    },
    {
        name= "utf-8 path request",
        is_request=true,
        raw= "GET /δ¶/δt/pope?q=1#narf HTTP/1.1\r\n"..
             "Host: github.com\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        query_string= "q=1",
        fragment= "narf",
        request_path= "/δ¶/δt/pope",
        request_url= "/δ¶/δt/pope?q=1#narf",
        num_headers= 1,
        headers= {["Host"]= "github.com"}
    },
    {
        name = "hostname underscore",
        is_request=true,
        raw= "CONNECT home_0.netscape.com:443 HTTP/1.0\r\n"..
             "User-agent: Mozilla/1.1N\r\n"..
             "Proxy-authorization: basic aGVsbG86d29ybGQ=\r\n"..
             "\r\n",
        keepalive=false,
        http_major= 1,
        http_minor= 0,
        method= "CONNECT",
        request_url= "home_0.netscape.com:443",
        upgrade = true,
        num_headers= 2,
        headers= {["User-agent"]= "Mozilla/1.1N",
                  ["Proxy-authorization"]= "basic aGVsbG86d29ybGQ=",
                 }
    },

    -- see https://github.com/ry/http-parser/issues/47
    {
        name = "eat CRLF between requests, no \"Connection: close\" header",
        is_request=true,
        raw= "POST / HTTP/1.1\r\n"..
             "Host: www.example.com\r\n"..
             "Content-Type: application/x-www-form-urlencoded\r\n"..
             "Content-Length: 4\r\n"..
             "\r\n"..
             "q=42\r\n", -- note the trailing CRLF
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "POST",
        request_path= "/",
        request_url= "/",
        num_headers= 3,
        headers= {["Host"]= "www.example.com",
                  ["Content-Type"]= "application/x-www-form-urlencoded",
                  ["Content-Length"]= "4",
                 },
        body= "q=42"
    },

    -- see https://github.com/ry/http-parser/issues/47 
    {
        name = "eat CRLF between requests even if \"Connection: close\" is set",
        is_request=true,
        raw= "POST / HTTP/1.1\r\n"..
             "Host: www.example.com\r\n"..
             "Content-Type: application/x-www-form-urlencoded\r\n"..
             "Content-Length: 4\r\n"..
             "Connection: close\r\n"..
             "\r\n"..
             "q=42\r\n", -- note the trailing CRLF
        keepalive=false,
        http_major= 1,
        http_minor= 1,
        method= "POST",
        request_path= "/",
        request_url= "/",
        num_headers= 4,
        headers= {["Host"]= "www.example.com",
                  ["Content-Type"]= "application/x-www-form-urlencoded",
                  ["Content-Length"]= "4",
                  ["Connection"]= "close",
                 },
        body= "q=42"
    },
    {
        name = "PURGE request",
        is_request=true,
        raw= "PURGE /file.txt HTTP/1.1\r\n"..
             "Host: www.example.com\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "PURGE",
        request_path= "/file.txt",
        request_url= "/file.txt",
        num_headers= 1,
        headers= { ["Host"]= "www.example.com"},
    },
    {
        name = "SEARCH request",
        is_request=true,
        raw= "SEARCH / HTTP/1.1\r\n"..
             "Host: www.example.com\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "SEARCH",
        request_path= "/",
        request_url= "/",
        num_headers= 1,
        headers= { ["Host"]= "www.example.com"},
    },
    {
        name= "host:port and basic_auth",
        is_request=true,
        raw= "GET http://a%12:b!&*$@hypnotoad.org:1234/toto HTTP/1.1\r\n"..
             "\r\n",
        keepalive=true,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_path= "/toto",
        request_url= "http://a%12:b!&*$@hypnotoad.org:1234/toto",
        host= "hypnotoad.org",
        userinfo= "a%12:b!&*$",
        port= 1234,
        num_headers= 0,
        headers= { },
    },
    {
        name= "line folding in header value",
        is_request=true,
        raw= "GET / HTTP/1.1\n"..
             "Line1:   abc\n"..
             "\tdef\n"..
             " ghi\n"..
             "\t\tjkl\n"..
             "  mno \n"..
             "\t \tqrs\n"..
             "Line2: \t line2\t\n"..
             "Line3:\n"..
             " line3\n"..
             "Line4: \n"..
             " \n"..
             "Connection:\n"..
             " close\n"..
             "\n",
        keepalive=false,
        http_major= 1,
        http_minor= 1,
        method= "GET",
        request_path= "/",
        request_url= "/",
        num_headers= 5,
        headers= {["Line1"]= "abc\tdef ghi\t\tjkl  mno \t \tqrs" ,
                  ["Line2"]= "line2\t" ,
                  ["Line3"]= "line3" ,
                  ["Line4"]= "" ,
                  ["Connection"]= "close" ,
                 }
    }
}

local responses = {
    {
        name = "google 301",
        raw = "HTTP/1.1 301 Moved Permanently\r\n"..
             "Location: http://www.google.com/\r\n"..
             "Content-Type: text/html; charset=UTF-8\r\n"..
             "Date: Sun, 26 Apr 2009 11:11:49 GMT\r\n"..
             "Expires: Tue, 26 May 2009 11:11:49 GMT\r\n"..
             "Cache-Control: public, max-age=2592000\r\n"..
             "Server: gws\r\n"..
             "Content-Length: 219\r\n"..
             "\r\n"..
             "<HTML><HEAD><meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\">\n"..
             "<TITLE>301 Moved</TITLE></HEAD><BODY>\n"..
             "<H1>301 Moved</H1>\n"..
             "The document has moved\n"..
             "<A HREF=\"http://www.google.com/\">here</A>.\r\n"..
             "</BODY></HTML>\r\n",
        keepalive = true,
        http_major = 1,
        http_minor = 1,
        status_code = 301,
        status = "Moved Permanently",
        num_headers = 7,
        headers = {
            ["Location"] = "http://www.google.com/",
            ["Content-Type"] = "text/html; charset=UTF-8",
            ["Date"] = "Sun, 26 Apr 2009 11:11:49 GMT",
            ["Expires"] = "Tue, 26 May 2009 11:11:49 GMT",
            ["Cache-Control"] = "public, max-age=2592000",
            ["Server"] = "gws",
            ["Content-Length"] = "219"
        },
        body = "<HTML><HEAD><meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\">\n"..
             "<TITLE>301 Moved</TITLE></HEAD><BODY>\n"..
             "<H1>301 Moved</H1>\n"..
             "The document has moved\n"..
             "<A HREF=\"http://www.google.com/\">here</A>.\r\n"..
             "</BODY></HTML>\r\n",
    },
    --[[
    The client should wait for the server's EOF. That is, when content-length
    is not specified, and "Connection: close", the end of body is specified
    by the EOF.
    Compare with APACHEBENCH_GET
    ]]
    {
        name= "no content-length response",
        raw= "HTTP/1.1 200 OK\r\n"..
             "Date: Tue, 04 Aug 2009 07:59:32 GMT\r\n"..
             "Server: Apache\r\n"..
             "X-Powered-By: Servlet/2.5 JSP/2.1\r\n"..
             "Content-Type: text/xml; charset=utf-8\r\n"..
             "Connection: close\r\n"..
             "\r\n"..
             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"..
             "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"..
             "  <SOAP-ENV:Body>\n"..
             "    <SOAP-ENV:Fault>\n"..
             "       <faultcode>SOAP-ENV:Client</faultcode>\n"..
             "       <faultstring>Client Error</faultstring>\n"..
             "    </SOAP-ENV:Fault>\n"..
             "  </SOAP-ENV:Body>\n"..
             "</SOAP-ENV:Envelope>",
        keepalive=false,
        message_complete_on_eof = true,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 5,
        headers= {
        ["Date"]= "Tue, 04 Aug 2009 07:59:32 GMT" ,
        ["Server"]= "Apache",
        ["X-Powered-By"]= "Servlet/2.5 JSP/2.1",
        ["Content-Type"]= "text/xml; charset=utf-8",
        ["Connection"]= "close",
        },
        body= "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"..
              "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"..
              "  <SOAP-ENV:Body>\n"..
              "    <SOAP-ENV:Fault>\n"..
              "       <faultcode>SOAP-ENV:Client</faultcode>\n"..
              "       <faultstring>Client Error</faultstring>\n"..
              "    </SOAP-ENV:Fault>\n"..
              "  </SOAP-ENV:Body>\n"..
              "</SOAP-ENV:Envelope>"
    },
    {
      name= "404 no headers no body",
      raw= "HTTP/1.1 404 Not Found\r\n\r\n",
      keepalive=false,
      message_complete_on_eof = true,
      http_major= 1,
      http_minor= 1,
      status_code= 404,
      status= "Not Found",
      num_headers= 0,
      headers= {},
    },
    {
        name= "301 no response phrase",
        raw= "HTTP/1.1 301\r\n\r\n",
        keepalive = false,
        message_complete_on_eof= true,
        http_major= 1,
        http_minor= 1,
        status_code= 301,
        num_headers= 0,
        headers= {},
    },
    {
        name="200 trailing space on chunked body",
        raw= "HTTP/1.1 200 OK\r\n"..
             "Content-Type: text/plain\r\n"..
             "Transfer-Encoding: chunked\r\n"..
             "\r\n"..
             "25  \r\n"..
             "This is the data in the first chunk\r\n"..
             "\r\n"..
             "1C\r\n"..
             "and this is the second one\r\n"..
             "\r\n"..
             "0  \r\n"..
             "\r\n",
        keepalive = true,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 2,
        headers= { ["Content-Type"] = "text/plain",
                   ["Transfer-Encoding"] = "chunked",
            },
        body = "This is the data in the first chunk\r\n" ..
             "and this is the second one\r\n"
    },
    {
        name="no carriage ret",
        raw= "HTTP/1.1 200 OK\n"..
             "Content-Type: text/html; charset=utf-8\n"..
             "Connection: close\n"..
             "\n"..
             "these headers are from http://news.ycombinator.com/",
        keepalive=false,
        message_complete_on_eof= true,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 2,
        headers= { ["Content-Type"]= "text/html; charset=utf-8",
                   ["Connection"] =  "close"},
        body= "these headers are from http://news.ycombinator.com/"
    },
    {
        name="proxy connection",
        raw= "HTTP/1.1 200 OK\r\n"..
             "Content-Type: text/html; charset=UTF-8\r\n"..
             "Content-Length: 11\r\n"..
             "Proxy-Connection: close\r\n"..
             "Date: Thu, 31 Dec 2009 20:55:48 +0000\r\n"..
             "\r\n"..
             "hello world",
        keepalive=false,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 4,
        headers= { ["Content-Type"]= "text/html; charset=UTF-8",
                   ["Content-Length"]= "11" ,
                   ["Proxy-Connection"]= "close" ,
                   ["Date"]= "Thu, 31 Dec 2009 20:55:48 +0000",
        },
        body= "hello world"
    },

    -- shown by
    -- curl -o /dev/null -v "http://ad.doubleclick.net/pfadx/DARTSHELLCONFIGXML;dcmt=text/xml;"
    {
        name="underscore header key",
        raw= "HTTP/1.1 200 OK\r\n"..
             "Server: DCLK-AdSvr\r\n"..
             "Content-Type: text/xml\r\n"..
             "Content-Length: 0\r\n"..
             "DCLK_imp: v7;x;114750856;0-0;0;17820020;0/0;21603567/21621457/1;;~okv=;dcmt=text/xml;;~cs=o\r\n\r\n",
        keepalive = true,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 4,
        headers= { ["Server"]= "DCLK-AdSvr",
                   ["Content-Type"]= "text/xml",
                   ["Content-Length"]= "0",
                   ["DCLK_imp"]= "v7;x;114750856;0-0;0;17820020;0/0;21603567/21621457/1;;~okv=;dcmt=text/xml;;~cs=o" 
        },
    },

    --[[
    The client should not merge two headers fields when the first one doesn't
    have a value.
    ]]
    {
        name= "bonjourmadame.fr",
        raw= "HTTP/1.0 301 Moved Permanently\r\n"..
             "Date: Thu, 03 Jun 2010 09:56:32 GMT\r\n"..
             "Server: Apache/2.2.3 (Red Hat)\r\n"..
             "Cache-Control: public\r\n"..
             "Pragma: \r\n"..
             "Location: http://www.bonjourmadame.fr/\r\n"..
             "Vary: Accept-Encoding\r\n"..
             "Content-Length: 0\r\n"..
             "Content-Type: text/html; charset=UTF-8\r\n"..
             "Connection: keep-alive\r\n"..
             "\r\n",
        keepalive = true,
        http_major= 1,
        http_minor= 0,
        status_code= 301,
        status= "Moved Permanently",
        num_headers= 9,
        headers= {
            ["Date"]= "Thu, 03 Jun 2010 09:56:32 GMT" ,
            ["Server"]= "Apache/2.2.3 (Red Hat)" ,
            ["Cache-Control"]= "public" ,
            ["Pragma"]= "" ,
            ["Location"]= "http://www.bonjourmadame.fr/" ,
            ["Vary"]=  "Accept-Encoding" ,
            ["Content-Length"]= "0" ,
            ["Content-Type"]= "text/html; charset=UTF-8" ,
            ["Connection"]= "keep-alive" ,
        }
    },

    -- Should handle spaces in header fields
    {
        name= "field underscore",
        raw= "HTTP/1.1 200 OK\r\n"..
             "Date: Tue, 28 Sep 2010 01:14:13 GMT\r\n"..
             "Server: Apache\r\n"..
             "Cache-Control: no-cache, must-revalidate\r\n"..
             "Expires: Mon, 26 Jul 1997 05:00:00 GMT\r\n"..
             ".et-Cookie: PlaxoCS=1274804622353690521; path=/; domain=.plaxo.com\r\n"..
             "Vary: Accept-Encoding\r\n"..
             "_eep-Alive: timeout=45\r\n".. -- semantic value ignored 
             "_onnection: Keep-Alive\r\n".. -- semantic value ignored
             "Transfer-Encoding: chunked\r\n"..
             "Content-Type: text/html\r\n"..
             "Connection: close\r\n"..
             "\r\n"..
             "0\r\n\r\n",
        keepalive=false,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 11,
        headers= { 
            ["Date"]= "Tue, 28 Sep 2010 01:14:13 GMT",
            ["Server"]= "Apache",
            ["Cache-Control"]= "no-cache, must-revalidate",
            ["Expires"]= "Mon, 26 Jul 1997 05:00:00 GMT",
            [".et-Cookie"]= "PlaxoCS=1274804622353690521; path=/; domain=.plaxo.com",
            ["Vary"]= "Accept-Encoding",
            ["_eep-Alive"]= "timeout=45",
            ["_onnection"]= "Keep-Alive",
            ["Transfer-Encoding"]= "chunked",
            ["Content-Type"]= "text/html",
            ["Connection"]= "close",
        }
    },

    -- Should handle non-ASCII in status line
    {  
        name= "non-ASCII in status line",
        raw= "HTTP/1.1 500 Oriëntatieprobleem\r\n"..
             "Date: Fri, 5 Nov 2010 23:07:12 GMT+2\r\n"..
             "Content-Length: 0\r\n"..
             "Connection: close\r\n"..
             "\r\n",
        keepalive=false,
        http_major= 1,
        http_minor= 1,
        status_code= 500,
        status= "Oriëntatieprobleem",
        num_headers= 3,
        headers= {
            ["Date"]= "Fri, 5 Nov 2010 23:07:12 GMT+2",
            ["Content-Length"]= "0",
            ["Connection"]= "close",
        }
    },

    -- Should handle HTTP/0.9
    {
        name= "http version 0.9",
        raw= "HTTP/0.9 200 OK\r\n"..
             "\r\n",
        keepalive=false,
        message_complete_on_eof= true,
        http_major= 0,
        http_minor= 9,
        status_code= 200,
        status= "OK",
        num_headers= 0,
        headers= {},
    },

    --[[
    The client should wait for the server's EOF. That is, when neither
    content-length nor transfer-encoding is specified, the end of body
    is specified by the EOF.
    ]]
    {
        name= "neither content-length nor transfer-encoding response",
        raw= "HTTP/1.1 200 OK\r\n"..
             "Content-Type: text/plain\r\n"..
             "\r\n"..
             "hello world",
        keepalive=false,
        message_complete_on_eof= true,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 1,
        headers= { ["Content-Type"]= "text/plain"},
        body= "hello world"
    },
    {  
        name= "HTTP/1.0 with keep-alive and EOF-terminated 200 status",
        raw= "HTTP/1.0 200 OK\r\n"..
             "Connection: keep-alive\r\n"..
             "\r\n",
        keepalive=false,
        message_complete_on_eof= true,
        http_major= 1,
        http_minor= 0,
        status_code= 200,
        status= "OK",
        num_headers= 1,
        headers= { ["Connection"] = "keep-alive"}
    },
    {
        name= "HTTP/1.0 with keep-alive and a 204 status",
        raw= "HTTP/1.0 204 No content\r\n"..
             "Connection: keep-alive\r\n"..
             "\r\n",
        keepalive = true,
        http_major= 1,
        http_minor= 0,
        status_code= 204,
        status= "No content",
        num_headers= 1,
        headers= { ["Connection"]= "keep-alive" }
    },
    {
        name= "HTTP/1.1 with an EOF-terminated 200 status",
        raw= "HTTP/1.1 200 OK\r\n"..
             "\r\n",
        keepalive=false,
        message_complete_on_eof= true,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 0,
        headers={}
    },
    {
        name= "HTTP/1.1 with a 204 status",
        raw= "HTTP/1.1 204 No content\r\n"..
             "\r\n",
        keepalive = true,
        http_major= 1,
        http_minor= 1,
        status_code= 204,
        status= "No content",
        num_headers= 0,
        headers={},
     },
    {
        name= "HTTP/1.1 with a 204 status and keep-alive disabled",
        raw= "HTTP/1.1 204 No content\r\n"..
             "Connection: close\r\n"..
             "\r\n",
        keepalive=false,
        http_major= 1,
        http_minor= 1,
        status_code= 204,
        status= "No content",
        num_headers= 1,
        headers= { ["Connection"]= "close"},
    },
    {
        name= "HTTP/1.1 with chunked endocing and a 200 response",
        raw= "HTTP/1.1 200 OK\r\n"..
             "Transfer-Encoding: chunked\r\n"..
             "\r\n"..
             "0\r\n"..
             "\r\n",
        keepalive = true,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 1,
        headers={ ["Transfer-Encoding"]= "chunked" }
    },

    -- Should handle spaces in header fields
    {
        name= "field space",
        raw= "HTTP/1.1 200 OK\r\n"..
             "Server: Microsoft-IIS/6.0\r\n"..
             "X-Powered-By: ASP.NET\r\n"..
             "en-US Content-Type: text/xml\r\n".. -- this is the problem 
             "Content-Type: text/xml\r\n"..
             "Content-Length: 16\r\n"..
             "Date: Fri, 23 Jul 2010 18:45:38 GMT\r\n"..
             "Connection: keep-alive\r\n"..
             "\r\n"..
             "<xml>hello</xml>", -- fake body
        keepalive = true,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        status= "OK",
        num_headers= 7,
        headers= { 
            ["Server"]=  "Microsoft-IIS/6.0" ,
            ["X-Powered-By"]= "ASP.NET" ,
            ["en-US Content-Type"]= "text/xml" ,
            ["Content-Type"]= "text/xml" ,
            ["Content-Length"]= "16" ,
            ["Date"]= "Fri, 23 Jul 2010 18:45:38 GMT" ,
            ["Connection"]= "keep-alive" ,
        },
        body= "<xml>hello</xml>"
    },
    { 
        name= "amazon.com",
        raw= "HTTP/1.1 301 MovedPermanently\r\n"..
             "Date: Wed, 15 May 2013 17:06:33 GMT\r\n"..
             "Server: Server\r\n"..
             "x-amz-id-1: 0GPHKXSJQ826RK7GZEB2\r\n"..
             "p3p: policyref=\"http://www.amazon.com/w3c/p3p.xml\",CP=\"CAO DSP LAW CUR ADM IVAo IVDo CONo OTPo OUR DELi PUBi OTRi BUS PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA HEA PRE LOC GOV OTC \"\r\n"..
             "x-amz-id-2: STN69VZxIFSz9YJLbz1GDbxpbjG6Qjmmq5E3DxRhOUw+Et0p4hr7c/Q8qNcx4oAD\r\n"..
             "Location: http://www.amazon.com/Dan-Brown/e/B000AP9DSU/ref=s9_pop_gw_al1?_encoding=UTF8&refinementId=618073011&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=center-2&pf_rd_r=0SHYY5BZXN3KR20BNFAY&pf_rd_t=101&pf_rd_p=1263340922&pf_rd_i=507846\r\n"..
             "Vary: Accept-Encoding,User-Agent\r\n"..
             "Content-Type: text/html; charset=ISO-8859-1\r\n"..
             "Transfer-Encoding: chunked\r\n"..
             "\r\n"..
             "1\r\n"..
             "\n\r\n"..
             "0\r\n"..
             "\r\n",
        keepalive = true,
        http_major= 1,
        http_minor= 1,
        status_code= 301,
        status= "MovedPermanently",
        num_headers= 9,
        headers= {["Date"]= "Wed, 15 May 2013 17:06:33 GMT",
                  ["Server"]= "Server",
                  ["x-amz-id-1"]= "0GPHKXSJQ826RK7GZEB2",
                  ["p3p"]= "policyref=\"http://www.amazon.com/w3c/p3p.xml\",CP=\"CAO DSP LAW CUR ADM IVAo IVDo CONo OTPo OUR DELi PUBi OTRi BUS PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA HEA PRE LOC GOV OTC \"",
                  ["x-amz-id-2"]= "STN69VZxIFSz9YJLbz1GDbxpbjG6Qjmmq5E3DxRhOUw+Et0p4hr7c/Q8qNcx4oAD",
                  ["Location"]= "http://www.amazon.com/Dan-Brown/e/B000AP9DSU/ref=s9_pop_gw_al1?_encoding=UTF8&refinementId=618073011&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=center-2&pf_rd_r=0SHYY5BZXN3KR20BNFAY&pf_rd_t=101&pf_rd_p=1263340922&pf_rd_i=507846",
                  ["Vary"]= "Accept-Encoding,User-Agent",
                  ["Content-Type"]= "text/html; charset=ISO-8859-1",
                  ["Transfer-Encoding"]= "chunked",
                 },
        body= "\n"
    },
    {
        name= "empty reason phrase after space",
        raw= "HTTP/1.1 200 \r\n"..
             "\r\n",
        keepalive=false,
        message_complete_on_eof= true,
        http_major= 1,
        http_minor= 1,
        status_code= 200,
        num_headers= 0,
        headers= {},
    }
}

local function test_parse_url()
    local url = "http://xjdrew@example.com:8080/t/134467?uid=1827#reply22"
    local t = c.parse_url(url)
    assert(t, "parse url failed:" .. url)
    assert(t.schema == "http")
    assert(t.userinfo == "xjdrew")
    assert(t.host == "example.com")
    assert(t.port == 8080)
    assert(t.request_path == "/t/134467")
    assert(t.query_string == "uid=1827")
    assert(t.fragment == "reply22")
end

local function message_eq(msg, ret)
    assert(ret.complete, msg.name)
    assert(msg.http_major == ret.http_major, msg.name)
    assert(msg.http_minor == ret.http_minor, msg.name)

    if msg.is_request then
        assert(msg.method == ret.method, msg.name)
    else
        assert(msg.status_code == ret.status_code, msg.name)
        assert(msg.status == ret.status, msg.name)
    end

    assert(msg.keepalive == ret.keepalive, msg.name)
    assert(msg.request_url == ret.request_url, msg.name)
    if msg.request_url and msg.method ~= "CONNECT" then
        local url = c.parse_url(msg.request_url)
        assert(msg.host == url.host, msg.name)
        assert(msg.userinfo == url.userinfo, msg.name)
        assert(msg.request_path == url.request_path, msg.name)
        assert(msg.query_string == url.query_string, msg.name)
        assert(msg.fragment == url.fragment, msg.name)
        assert(msg.port == url.port, msg.name)
    end

    assert(msg.body == ret.body, msg.name)
    local num_headers = 0
    for header, value in pairs(ret.headers) do
        assert(msg.headers[header] == value, msg.name .. ":" .. header)
        num_headers = num_headers + 1
    end
    assert(msg.num_headers == num_headers, msg.name)
    assert(msg.upgrade == ret.upgrade, msg.name)
end

local function test_message(msg)
    local parser = c.new()
    local ret = {}
    local _, err = parser:execute(msg.raw, nil, ret)
    if err then
        print(err)
        error(msg.name .. ":" .. c.http_errno_name(err))
    end
    if msg.message_complete_on_eof then
        parser:execute("", nil, ret)
    end
    message_eq(msg, ret)
end

local function count_parsed_messages(...)
    for i, m in ipairs({...}) do
        if m.upgrade then
            return i
        end
    end
    return select('#', ...)
end

local function test_multiple(...)
    local message_count = count_parsed_messages(...)
    local msgs = {...}
    local raw = ""
    for i=1,message_count do
        raw = raw .. msgs[i].raw
    end
    local from = 0
    local parser = c.new()
    local rets = {}
    for i =1, message_count do
        local ret = {}
        local parsed, err = parser:execute(raw, from, ret)
        assert(not err, msgs[i].name)
        table.insert(rets, ret)
        from = from + parsed
    end
    if msgs[message_count].message_complete_on_eof then
        parser:execute("", nil, rets[message_count])
    end
    assert(#rets == message_count, msgs[message_count].name)
    for i =1, message_count do
        message_eq(msgs[i], rets[i])
    end
end

local function test_scan(...)
    local message_count = count_parsed_messages(...)
    local msgs = {...}
    local raw = ""
    for i=1,message_count do
        raw = raw .. msgs[i].raw
    end

    local parser = c.new()
    local rets = {}
    local ret
    for i=1, #raw do
        if not ret then
            ret = {}
        end
        if ret.complete then
            table.insert(rets, ret)
            ret = {}
            if #rets == message_count then
                break
            end
        end
        local count = #rets + 1
        local input = raw:sub(i, i)
        local _, err = parser:execute(input, nil, ret)
        assert(not err, msgs[count].name)
    end
    if msgs[message_count].message_complete_on_eof then
        parser:execute("", nil, ret)
    end
    if ret.complete then
        table.insert(rets, ret)
    end
    assert(#rets == message_count, msgs[message_count].name)
    for i =1, message_count do
        message_eq(msgs[i], rets[i])
    end
end

local function test_messages(messages, tag)
    local count = 0
    local width = 6
    io.write(string.format("test multiple %s:%10d", tag, 0))
    for i in ipairs(messages) do
        if messages[i].keepalive then
            for j in ipairs(messages) do
                if messages[j].keepalive then
                    for k in ipairs(messages) do
                        test_multiple(messages[i], messages[j], messages[k])
                        count = count + 1
                        io.write(string.format("%s%6d", string.rep("\b", width), count))
                        io.flush()
                        -- print(string.format("multiple %s %d %d %d", tag, i,j,k), "pass")
                    end
                end
            end
        end
    end
    io.write("\n")
end

local function test_messages_scan(messages, tag)
    local count = 0
    local width = 6
    io.write(string.format("test scan multiple %s:%6d", tag, 0))
    for i in ipairs(messages) do
        if messages[i].keepalive then
            for j in ipairs(messages) do
                if messages[j].keepalive then
                    for k in ipairs(messages) do
                        test_scan(messages[i], messages[j], messages[k])
                        count = count + 1
                        io.write(string.format("%s%6d", string.rep("\b", width), count))
                        io.flush()
                        -- print(string.format("scan %s %d %d %d", tag, i,j,k), "pass")
                    end
                end
            end
        end
    end
    io.write("\n")
end

local function main()
    test_parse_url()

    for i, request in ipairs(requests) do
        test_message(request)
        print("request:", i, "pass")
    end

    for i, response in ipairs(responses) do
        test_message(response)
        print("response:", i, "pass")
    end

    test_messages(responses, "response")
    test_messages(requests, "request")

    test_messages_scan(responses, "response")
    test_messages_scan(requests, "request")
end

--test_messages(requests[1].raw .. requests[1].raw)
main()
print("test pass")

