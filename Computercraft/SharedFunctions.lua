local x,y = term.getSize()
local version = "2.7.8"
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

--Top Level--

function compatabilityLayer()
LinuxWritePrint = lPrint
headlessGet = get
Scroll = menu
ScrollV2 = menu
end

--Mid Level (Functions that are relied on by low lvl functions)--
table.find = function(t1, v)
    for i=1, #t1 do
        if t1[i] == v then
            return true, i
        end
    end
    return false
end

function lPrint(txt,_,x1,y1,tColor,bColor,clear)
if type(x1) ~= "number" or type(y1) ~= "number" then
    return "lPrint [x/y not a number]"
end
if type(clear) ~= "boolean" then
    clear = false
end
if type(tColor) == "number" then
    term.setTextColor(tColor)
end
if type(bColor) == "number" then
    term.setBackgroundColor(bColor)
end
term.setCursorPos(x1,y1)
if clear then
    term.clearLine()
end
write(tostring(txt))
end

function openModem()
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

function Cartesian(t1,t2) -- Combine both tables into all possible coordinates: Input >> {1,2,3}, {4,5,6}: Output >> {{1,4},{1,5},{1,6},{2,4},{2,5},{2,6},{3,4},{3,5},{3,6}}
    local output = {}
    for i = 1, #t1 do
        for j = 1, #t2 do
            table.insert(output, {t1[i], t2[j]})
        end
    end
    return output
end

function readLinesFromFile(file,start,stop)
local lines = {}
local h = fs.open(file , "r")
local i = 1
repeat
local tmp = h.readLine()
if i >= start and i <= stop then
    table.insert(lines,tmp)
end
if i > stop then
    break
end
i = i+1
until nil
return lines
end

function Confliction(fileName,fileLocation)
term.clear()
lPrint("File confliction!",write,x/2-string.len("File confliction!")/2,1,colors.red,colors.black,true)
lPrint("File: "..fileName.." exists at: "..fileLocation,write,x/2-string.len("File: "..fileName.." exists at: "..fileLocation)/2,y/2,colors.yellow,colors.black,true)
lPrint("Overwrite?",write,1,y-2,colors.gray,colors.black)
lPrint("C to confirm",write,x-string.len("C to confirm"),y-2,colors.gray,colors.black)
local option = menu({"Yes","No","Maybe"},nil,nil,colors.white,colors.black,1,y-1,{"[","]"},false)
return option
end

function getHub(pathRepo, localFilePath,flag)
    if type(pathRepo) ~= "string" or type(localFilePath) ~= "string" then
        return "getHub [pathRepo/localFilePath invalid]"
    end
    if string.lower(flag) ~= "y" and fs.exists(localFilePath) then
        local v = fs.open(".tmp/tab" , "w")
        local lines = readLinesFromFile("Functions.lua",98,104)
        for i = 1,#lines do
            v.writeLine(lines[i])
        end
        v.close() else
        fs.move(localFilePath , ".archive/"..localFilePath)
    end
    local githubFileUrl = "https://raw.githubusercontent.com/" .. pathRepo
    local request = http.get(githubFileUrl)
    if request then
        local response = request.getResponseCode()
        if response == 200 then
            local h = fs.open(localFilePath, "w")
            h.write(request.readAll())
            h.close()
        end
    end
end

function get(url,location)
    if url == nil or location == nil then
        return false
    end
    -- Add a cache buster so that spam protection is re-checked
    local cacheBuster = ("%x"):format(math.random(0, 2 ^ 30))
    local response, err = http.get(
        "https://pastebin.com/raw/" .. textutils.urlEncode(url) .. "?cb=" .. cacheBuster
    )

    if response then
        -- If spam protection is activated, we get redirected to /paste with Content-Type: text/html
        local headers = response.getResponseHeaders()
        if not headers["Content-Type"] or not headers["Content-Type"]:find("^text/plain") then
            return
        end
        local sResponse = response.readAll()
        response.close()
        local h = fs.open(location , "w")
        h.write(sResponse)
        h.close()
        return true
    else
        return false
    end
end

--Low Level--

--Z256--

Retrieve = function()
    local web = http.get("https://pastebin.com/raw/"..pastebinList["Functions"])
    if web then
        local latest = web.readAll() web.close()
        local f = fs.open(fs.getDir(runningProgram).."/"..runningProgram, "r")
        if f then local current = f.readAll() f.close() else return false end
        if latest ~= current then -- OUT OF SYNC
            local f = fs.open(fs.getDir(runningProgram).."/"..runningProgram, "w")
            if f then f.write(latest) f.close() end
            require("Functions")
        end
    else
        return false
    end
end
if http and update then Retrieve() end

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

--Avatarfreak345--

function menu(tbl,_,_,tColor,bColor,tableX,tableY,tblSelectorIcon,center)
local selected = 1
local tmp = {[200] = -1, [17]  = -1, [31] = 1, [208] = 1}

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
    lPrint(tblSelectorIcon[1]..tbl[selected]..tblSelectorIcon[2],"write",tableX,tableY,tColor,bColor,true)
end
local _,key = os.pullEvent("key")
if key ~= keys.c then
    if tmp[key] then
        selected = selected+tmp[key] 
    end else
    break
end
until nil

return tbl[selected]
end

function statusBar(x1, y1, greenColor, redColor, min, max, current, length)
    if type(min) ~= "number" or type(max) ~= "number" or type(current) ~= "number" or type(length) ~= "number" then
        return "statusBar [min/max/current/length not equal to number]"
    end
    lPrint(tostring(current),nil,1,1,true,colors.purple)
    os.pullEvent("key")
    current = (current < 0) and 0 or (current > max) and max or current
    lPrint(string.rep(" ", length), nil, x1, y1, nil, nil, redColor or colors.red)
    lPrint(string.rep(" ", math.floor((current - min) / (max - min) * length)), term, x1, y1, nil, nil, greenColor or colors.green)
    
    term.setBackgroundColor(colors.black)
end

function Input(txt,format,clear,x1,y1,tColor,bColor)
if type(x1) == "number" and type(y1) == "number" then
    if clear then
        lPrint(tostring(txt),"write",x1,y1,tColor,bColor,true) else
        lPrint(tostring(txt),"write",x1,y1,tColor,bColor)
    end
end
if type(format) == "string" then
    return read(format) else
    return read()
end
end