-->> Z256 <<--

-->> Init <<--
local version = "03.05.2024.0001"
local update = false
local w,h = term.getSize()
local runningProgram = shell.getRunningProgram()

-->> Shorthand Functions <<--
local t, tx = term, textutils
clr, cp, st, sb = t.clear, t.setCursorPos, t.setTextColor, t.setBackgroundColor

-->> Base Functions <<--
table.find = function(t1, v)
    for i=1, #t1 do
        if t1[i] == v then
            return true, i
        end
    end
    return false
end

-->> Updater <<--
local grabFreshVariables = function()
    w,h = t.getSize() -- Grab screen size again in case screen changes size
end

local pastebinList = { -- Usage: " print(pastebinList["Functions"]) " Output >> "4VbEEWLm"
    ["Functions"] = "4VbEEWLm",
    ["Autofarm Turtle"] = "BWgiKauH",
    ["LinChat"] = "DpT5Wv2V",
    ["Reactor Monitor System"] = "iVMEAcFY",
    ["Autobuilder"] = "3ay0CwYP",
    ["BPEditor"] = "Eucr5bsP"
}

-->> Updater Functions <<--
Retrieve = function()
    local web = http.get("https://pastebin.com/raw/"..pastebinList["Functions"])
    if web then
        local latest = web.readAll() web.close()
        local f = fs.open(fs.getDir(runningProgram).."/"..runningProgram, "r")
        if f then local current = f.readAll() f.close() else return false end
        if latest ~= current then -- OUT OF SYNC
            local f = fs.open(fs.getDir(runningProgram).."/"..runningProgram, "w")
            f.write(latest) f.close()
        end
    else
        return false
    end
end
if http and update then grabLatest() end

-->> Rednet <<--
openModem = function()
    for _, side in ipairs(peripheral.getNames()) do
        if peripheral.getType(side) == "modem" then
            if rednet.isOpen(side) then
                return true, side
            else
                if rednet.open(side) then
                    return true, side
                end
            end
        end
    end
    return false, nil
end

-->> Misc <<--
Union = function(t1,t2) -- Filter out duplicate table items between 2 tables + combines: Input >> {1,1,2,2,3,3}, {4,4,5,5,6,6}: Output >> {1,2,3,4,5,6}
    local filter, output = {}, {}
    for i=1, #t1 do
        if not table.find(filter, t1[i]) then
            table.insert(output, t1[i])
            table.insert(filter, t1[i])
        end
    end
    for i=1, #t2 do
        if not table.find(filter, t2[i]) then
            table.insert(output, t2[i])
            table.insert(filter, t2[i])
        end
    end
    return output
end

Intersection = function(t1, t2) -- Filter out differences between 2 tables + combines: Input >> {1,2,3,4}, {2,3,4,5}: Output >> {2,3,4}
    local filter, output = {}, {}
    for i=1, #t1 do
        if table.find(t2, t1[i]) and not table.find(filter, t1[i]) then
            table.insert(output, t1[i])
        else
            table.insert(filter, t1[i])
        end
    end
    return output
end

function Cartesian(t1,t2) -- Combine both tables into all possible coordinates: Input >> {1,2,3}, {4,5,6}: Output >> {{1,4},{1,5},{1,6},{2,4},{2,5},{2,6},{3,4},{3,5},{3,6}}
	local output = {}
	for i = 1, #t1 do
		for j = 1, #t2 do
			table.insert(output, {t1[i], t2[j]})
		end
	end
	return output
end







