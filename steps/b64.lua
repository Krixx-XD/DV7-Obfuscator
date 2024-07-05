--Copyright(C) By The DV7s

local a = {}
local function b(c)
    local d = {}
    for e = 1, #c do
        d[c:sub(e, e)] = e - 1
    end
    return d
end
local f = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local g = b(f)
g["-"] = g["+"]
g["_"] = g["/"]
function a.decode(h)
    return a.binaryToAscii(a.base64ToBinary(h))
end
function a.encode(h)
    return a.binaryToBase64(a.asciiToBinary(h))
end
function a.asciiToBinary(i)
    return {string.byte(i, 1, #i)}
end
function a.binaryToAscii(j)
    return string.char(unpack(j))
end
function a.binaryToBase64(k)
    local l = #k
    local m = l % 3 == 0 and 0 or 3 - l % 3
    local n = {}
    for e = 1, l do
        n[e] = k[e]
    end
    for e = 1, m do
        n[l + e] = 0
    end
    local o = ""
    for e = 1, #n, 3 do
        o = o .. f:sub(bit.rshift(n[e], 2) + 1, bit.rshift(n[e], 2) + 1)
        o =
            o ..
            f:sub(
                bit.bor(bit.lshift(bit.band(n[e], 0x3), 4), bit.rshift(n[e + 1] or 0, 4)) + 1,
                bit.bor(bit.lshift(bit.band(n[e], 0x3), 4), bit.rshift(n[e + 1] or 0, 4)) + 1
            )
        o =
            o ..
            f:sub(
                bit.bor(bit.lshift(bit.band(n[e + 1] or 0, 0xF), 2), bit.rshift(n[e + 2] or 0, 6)) + 1,
                bit.bor(bit.lshift(bit.band(n[e + 1] or 0, 0xF), 2), bit.rshift(n[e + 2] or 0, 6)) + 1
            )
        o = o .. f:sub(bit.band(n[e + 2] or 0, 0x3F) + 1, bit.band(n[e + 2] or 0, 0x3F) + 1)
    end
    if m > 0 then
        o = o:sub(1, -m - 1) .. string.rep("=", m)
    end
    return o
end
function a.base64ToBinary(h)
    local n = {}
    if #h % 4 == 1 then
        error("Malformed Input")
    elseif #h % 4 ~= 0 then
        h = h .. string.rep("=", 4 - #h % 4)
    end
    for e = 1, #h - 3, 4 do
        for p = 0, 3 do
            if h:sub(e + p, e + p) ~= "=" and not g[h:sub(e + p, e + p)] then
                error("Malformed Input")
            elseif h:sub(e + p, e + p) == "=" and math.abs(#h - (e + p)) > 2 then
                error("Malformed Input")
            end
        end
        table.insert(n, bit.bor(bit.lshift(g[h:sub(e, e)], 2), bit.rshift(g[h:sub(e + 1, e + 1)], 4)))
        if h:sub(e + 2, e + 2) ~= "=" then
            table.insert(
                n,
                bit.bor(bit.lshift(bit.band(g[h:sub(e + 1, e + 1)], 0xF), 4), bit.rshift(g[h:sub(e + 2, e + 2)], 2))
            )
        end
        if h:sub(e + 3, e + 3) ~= "=" then
            table.insert(n, bit.bor(bit.lshift(bit.band(g[h:sub(e + 2, e + 2)], 0x3), 6), g[h:sub(e + 3, e + 3)]))
        end
    end
    return n
end
return a
