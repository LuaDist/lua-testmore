
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--

local _G = _G
local ipairs = ipairs
local loadstring = loadstring
local pairs = pairs
local pcall = pcall
local require = require
local tostring = tostring
local type = type

module 'Test.More'

local tb = require 'Test.Builder'

function plan (num)
    tb.plan(num)
end

function ok (cond, desc)
    tb.ok(cond, desc)
end

function nok (cond, desc)
    tb.ok(not cond, desc)
end

function is (got, expected, desc)
    local pass = got == expected
    tb.ok(pass, desc)
    if not pass then
        tb.diag("         got: " .. tostring(got)
           .. "\n    expected: " .. tostring(expected))
    end
end

function isnt (got, expected, desc)
    local pass = got ~= expected
    tb.ok(pass, desc)
    if not pass then
        tb.diag("         got: " .. tostring(got)
           .. "\n    expected: anything else")
    end
end

function like (got, pattern, desc)
    local pass = tostring(got):match(pattern)
    tb.ok(pass, desc)
    if not pass then
        tb.diag("                  " .. tostring(got)
           .. "\n    doesn't match '" .. tostring(pattern) .. "'")
    end
end

function unlike (got, pattern, desc)
    local pass = not tostring(got):match(pattern)
    tb.ok(pass, desc)
    if not pass then
        tb.diag("                  " .. tostring(got)
           .. "\n    matches '" .. tostring(pattern) .. "'")
    end
end

local cmp = {
    ['<']  = function (a, b) return a <  b end,
    ['<='] = function (a, b) return a <= b end,
    ['>']  = function (a, b) return a >  b end,
    ['>='] = function (a, b) return a >= b end,
    ['=='] = function (a, b) return a == b end,
    ['~='] = function (a, b) return a ~= b end,
}

function cmp_ok (this, op, that, desc)
    local pass = cmp[op](this, that)
    tb.ok(pass, desc)
    if not pass then
        tb.diag("    " .. tostring(this)
           .. "\n        " .. op
           .. "\n    " .. tostring(that))
    end
end

function type_ok (val, t, desc)
    if type(val) == t then
        tb.ok(true, desc)
    else
        tb.ok(false, desc)
        tb.diag("    " .. tostring(val) .. " isn't a '" .. t .."' it's '" .. type(val) .. "'")
    end
end

function pass (desc)
    tb.ok(true, desc)
end

function fail (desc)
    tb.ok(false, desc)
end

function require_ok (mod)
    local r, msg = pcall(require, mod)
    tb.ok(r, "require '" .. mod .. "'")
    if not r then
        tb.diag("    " .. msg)
    end
end

function eq_array (got, expected, desc)
    for i, v in ipairs(expected) do
        local val = got[i]
        if val ~= v then
            tb.ok(false, desc)
            tb.diag("    at index: " .. tostring(i)
               .. "\n         got: " .. tostring(val)
               .. "\n    expected: " .. tostring(v))
            return
        end
    end
    local extra = #got - #expected
    if extra ~= 0 then
        tb.ok(false, desc)
        tb.diag("    " .. tostring(extra) .. " unexpected item(s)")
    else
        tb.ok(true, desc)
    end
end

function is_deeply (got, expected, desc)
    local msg

    local function deep_eq (t1, t2)
        for k, v in pairs(t2) do
            local val = t1[k]
            if type(v) == 'table' then
                local r = deep_eq(val, v)
                if not r then
                    return false
                end
            else
                if val ~= v then
                    msg = "diff"
                    return false
                end
            end
        end
        for k, _ in pairs(t1) do
            local val = t2[k]
            if val == nil then
                msg = "unexpected key"
                return false
            end
        end
        return true
    end -- deep_eq

    local pass = deep_eq(got, expected)
    tb.ok(pass, desc)
    if not pass then
        tb.diag("    " .. msg)
    end
end

function error_is (code, expected, desc)
    if type(code) == 'string' then
        code = loadstring(code)
    end
    local r, msg = pcall(code)
    if r then
        tb.ok(false, desc)
        tb.diag("    unexpected success"
           .. "\n    expected: " .. tostring(expected))
    else
        is(msg, expected, desc)
    end
end

function error_like (code, pattern, desc)
    if type(code) == 'string' then
        code = loadstring(code)
    end
    local r, msg = pcall(code)
    if r then
        tb.ok(false, desc)
        tb.diag("    unexpected success"
           .. "\n    expected: " .. tostring(pattern))
    else
        like(msg, pattern, desc)
    end
end

function lives_ok (code, desc)
    if type(code) == 'string' then
        code = loadstring(code)
    end
    local r, msg = pcall(code)
    tb.ok(r)
    if not r then
        tb.diag("    " .. msg)
    end
end

function diag (msg)
    tb.diag(msg)
end

function note (msg)
    tb.note(msg)
end

function explain (msg)
    tb.explain(msg)
end

function skip (reason, count)
    tb.skip(reason, count)
end

function todo (reason, count)
    tb.todo(reason, count)
end

for k, v in pairs(_G.Test.More) do
    if k:sub(1, 1) ~= '_' then
        -- injection
        _G[k] = v
    end
end

_VERSION = "0.0.0"
_DESCRIPTION = "lua-TestMore : an Unit Testing Framework"
_COPYRIGHT = "Copyright (c) 2009 Francois Perrad"
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--