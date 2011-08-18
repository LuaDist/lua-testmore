#! /usr/bin/lua
--
-- lua-TestMore : <http://fperrad.github.com/lua-TestMore/>
--
-- Copyright (C) 2010-2011, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua Grammar

=head2 Synopsis

    % prove 204-grammar.t

=head2 Description

See "Lua 5.2 Reference Manual", section 9 "The Complete Syntax of Lua",
L<http://www.lua.org/manual/5.2/manual.html#9>.

=cut

--]]

require 'Test.More'

plan(6)

--[[ empty statement ]]
f, msg = load [[; a = 1]]
type_ok(f, 'function', "empty statement")

--[[ orphan break ]]
f, msg = load [[
function f()
    print "before"
    do
        print "inner"
        break
    end
    print "after"
end
]]
if arg[-1] == 'luajit' then
    like(msg, "^[^:]+:%d+: no loop to break", "orphan break")
else
    like(msg, "^[^:]+:%d+: <break> at line 5 not inside a loop", "orphan break")
end

if arg[-1] == 'luajit' then
    todo("LuaJIT TODO. break", 1)
end
--[[ break anywhere ]]
lives_ok( [[
function f()
    print "before"
    while true do
        print "inner"
        break
        print "break"
    end
    print "after"
end
]], "break anywhere")

--[[ goto ]]
if arg[-1] == 'luajit' then
    todo("LuaJIT TODO. goto", 3)
end
f, msg = load [[
::label::
goto unknown
]]
like(msg, ":%d+: no visible label 'unknown' for <goto> at line %d+", "unknown goto")

f, msg = load [[
::label::
goto label
::label::
]]
like(msg, ":%d+: label 'label' already defined on line %d+", "repeated label")

f, msg = load [[
::e::
goto f
local x
::f::
goto e
]]
like(msg, ":%d+: <goto f> at line %d+ jumps into the scope of local 'x'", "bad goto")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
