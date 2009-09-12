#! lua
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--
-- Copyright (C) 2009, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua for statement

=head2 Synopsis

    % prove 014-fornum.t

=head2 Description

See "Lua 5.1 Reference Manual", section 2.4.5 "For Statement",
L<http://www.lua.org/manual/5.1/manual.html#2.4.5>.

See "Programming in Lua", section 4.3 "Control Structures".

=cut

--]]

print("1..36")

for i = 1, 10, 2 do
    print("ok " .. (i+1)/2 .. " - for 1, 10, 2")
end

for i = 1, 10, 2 do
    function f ()
        print("ok " .. (i+11)/2 .. " - for 1, 10, 2 lex")
    end
    f()
end

function f (i)
    print("ok " .. (i+21)/2 .. " - for 1, 10, 2 !lex")
end
for i = 1, 10, 2 do
    f(i)
end

for i = 3, 5 do
    print("ok " .. 13+i .. " - for 3, 5")
    i = i + 1
end

for i = 5, 1, -1 do
    print("ok " .. 24-i .. " - for 5, 1, -1")
end

for i = 5, 5 do
    print("ok " .. 19+i .. " - for 5, 5")
end

for i = 5, 5, -1 do
    print("ok " .. 20+i .. " - for 5, 5, -1")
end

v = false
for i = 5, 3 do
    v = true
end
if v then
    print("nok 26 - for 5, 3")
else
    print("ok 26 - for 5, 3")
end

v = false
for i = 5, 7, -1 do
    v = true
end
if v then
    print("nok 27 - for 5, 7, -1")
else
    print("ok 27 - for 5, 7, -1")
end

v = false
for i = 5, 7, 0 do
    v = true
end
if v then
    print("nok 28 - for 5, 7, 0")
else
    print("ok 28 - for 5, 7, 0")
end

v = nil
for i = 1, 10, 2 do
    if i > 4 then break end
    print("ok " .. (i+57)/2 .. " - for break")
    v = i
end
if v == 3 then
    print("ok 31 - break")
else
    print("nok 31 - " .. v)
end

local function first() return 1 end
local function limit() return 8 end
local function step()  return 2 end
for i = first(), limit(), step() do
    print("ok " .. (i+63)/2 .. " - with functions")
end

local a = {}
for i = 1, 10 do
    a[i] = function () return i end
end
if(a[5]() == 5) then
    print("ok 36 - for & upval")
else
    print("nok 36 - for & upval")
end

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4: