local x,y = term.getSize()
local version = "03.05.2024.0001"
local update = false
local runningProgram = shell.getRunningProgram()
local t, tx = term, textutils
clr, cp, st, sb = t.clear, t.setCursorPos, t.setTextColor, t.setBackgroundColor
local pastebinList = { -- Usage: " print(pastebinList["Functions"]) " Output >> "4VbEEWLm"
    ["Functions"] = "4VbEEWLm",
    ["Autofarm Turtle"] = "BWgiKauH",
    ["LinChat"] = "DpT5Wv2V",
    ["Reactor Monitor System"] = "iVMEAcFY",
    ["Autobuilder"] = "3ay0CwYP",
    ["BPEditor"] = "Eucr5bsP"
}
--Idiot--
function compatabilityLayer()
LinuxWritePrint = lPrint
headlessGet = get
Scroll = ScrollV3
ScrollV2 = ScrollV3
end

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

table.find = function(t1, v)
    for i=1, #t1 do
        if t1[i] == v then
            return true, i
        end
    end
    return false
end

--Avatarfreak345--

function lPrint(txt,x1,y1,clear,tColor,bColor)
if type(x1) ~= "number" or type(y1) ~= "number" then
	return "lPrint [x/y not a number]"
end
if type(clear) ~= "boolean" then
	clear = false
end
term.setTextColor(tColor)
term.setBackgroundColor(bColor)
term.setCursorPos(x1,y1)
if clear then
	term.clearLine()
end
write(tostring(txt))
end

function menu(tbl,tableX,tableY,tColor,bColor,tblSelectorIcon,center)
local selected = 1
local tmp = {["w"] = 1,["s"] = -1}

if type(center) ~= "boolean" then
	center = false
end

if tonumber(tableX) == nil or tonumber(tableY) == nil then
	if center == false then
		return "menu [tableX/tableY = nil & center == false]"
	end
end

if type(tbl) ~= "table" then
	return "menu [tbl must be a table]"
end

if tblSelectorIcon == nil or type(tblSelectorIcon) ~= "table" or #tblSelectorIcon ~= 2 then
	tblSelectorIcon = {"[","]"}
end

repeat
selected = (selected < 1) and #tbl or (selected > #tbl) and 1 or selected
if center then
	lPrint(tblSelectorIcon[1]..tbl[selected]..tblSelectorIcon[2],"write",x/2-string.len(tbl[selected])/2,y/2,true,colors.yellow,colors.black) else
	lPrint(tblSelectorIcon[1]..tbl[selected]..tblSelectorIcon[2],"write",tableX,tableY,true,colors.yellow,colors.black)
end
local _,char = os.pullEvent("char")
if char ~= "c" then
	if tmp[char] then
		selected = selected+tmp[char] 
	end else
	break
end
until nil

return tbl[selected]
end

function openModem()
--Thanks ChatGPT--
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

lPrint("Test",1,1,true,colors.yellow,colors.green)