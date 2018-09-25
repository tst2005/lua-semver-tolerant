local v = require "semver"
local t = require "semver-tolerant"

local f2name = {
	[v] = "semver",
	[t] = "semver-tolerant",
}
local count = 0
local function test(expected, f, ...)
	count = count +1
	local ok,err = pcall(f, ...)
	if ok ~= expected then
		print("test"..count..": "..f2name[f].." should "..(expected and "not " or "").."fail with value "..tostring(...))
--	else	print("test"..count..": ok")
	end
	--print(tostring(err))
	return err
end

local ok,KO=true,false

local function test_KO_ok(value)
	test(KO, v, value)
	test(ok, t, value)
end
local function test_ok_ok(value)
	test(ok,v, value)
	test(ok, t, value)
end
local function test_KO_KO(value)
	test(KO, v, value)
	test(KO, t, value)
end

test_ok_ok "1"
test_ok_ok "1.0"
test_ok_ok "1.0.0"

test_ok_ok "0"
test_ok_ok "0.1"
test_ok_ok "0.0.1"

test_ok_ok "1..1"

test_KO_ok "v1"
test_KO_ok "v1.0"
test_KO_ok "1.0.0alpha1"
test_KO_ok "1.0.0beta2"
test_KO_ok "1.0.0rc3"


-- python versions --
-- https://www.python.org/dev/peps/pep-0386/

test_ok_ok "1.5.1"
test_KO_ok "1.5.2b2"
test_ok_ok "161"
test_KO_ok "3.10a"
test_ok_ok "8.02"
test_KO_KO "3.4j"
test_ok_ok "1996.07.12"
test_KO_KO "3.2.pl0"
test_KO_ok "3.1.1.6"
test_KO_KO "2g6"
test_KO_KO "11g"
test_ok_ok "0.960923"
test_KO_ok "2.2beta29"
test_KO_KO "1.13++"
test_KO_KO "5.5.kw"
test_KO_ok "2.0b1pl0"

test_ok_ok "0.4"
test_ok_ok "0.4.0"
test_ok_ok "0.4.1"
test_KO_ok "0.5a1"
test_KO_ok "0.5b3"
test_ok_ok "0.5"
test_ok_ok "0.9.6"
test_ok_ok "1.0"
test_KO_ok "1.0.4a3"
test_KO_ok "1.0.4b1"
test_ok_ok "1.0.4"

local sv = t("1.2.3.4-foobar.5")
assert(sv.major==1)
assert(sv.minor==2)
assert(sv.patch>3 and sv.patch<4)
assert(t.tostring(sv)=="1.2.3.4-foobar.5")

local x = "1.0.0.1"
assert(x~=tostring(t(x)))
assert(x==t.tostring(t(x)))

for _i, x in ipairs{
	"1.0",
	"1.0.0",
	"1.0.0.0",
	"1.2.3.4",
	"1.2.3.4-foobar.5",
	"1.2.3.4+foobar.5",
}do
	print(x==t.tostring(t(x)), x, "tolerant", t.tostring(t(x)), "semver", tostring(t(x)), t(x).patch%1>0 and "tolerant with patch hack" or "usual tolerant")
end
