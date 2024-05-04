local x,y = term.getSize()

--New--

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