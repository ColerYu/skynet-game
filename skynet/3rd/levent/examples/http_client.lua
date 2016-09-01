local levent = require "levent.levent"
local http   = require "levent.http"

local urls = {
    "http://www.google.com",
    "http://yahoo.com",
    "http://example.com",
    "http://qq.com",
}

function request(url)
    local response, err = http.get(url)
    if not response then
        print(url, "error:", err)
    else
        print(url, response:get_code())
    end
end

function main()
    for _, url in ipairs(urls) do
        levent.spawn(request, url)
    end
end

levent.start(main)
