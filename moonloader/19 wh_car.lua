require 'moonloader'
requests = require 'requests'
sampev = require'samp.events'
imgui = require 'imgui'
vkeys = require'vkeys'
encoding = require("encoding"); encoding.default = 'CP1251'; u8 = encoding.UTF8  
function json(filePath)
    local class = {}
        function class.save(tbl)
        if tbl then local F = io.open(filePath, 'w');	F:write(encodeJson(tbl) or {});	F:close();	return true, 'ok' end
        return false, 'table = nil'
    end
    function class.load(defaultTable)
        if not doesFileExist(filePath) then;	class.save(defaultTable or {});	end
        local F = io.open(filePath, 'r+');	local TABLE = decodeJson(F:read() or {}); F:close()
        for def_k, def_v in pairs(defaultTable) do;  if TABLE[def_k] == nil then;   TABLE[def_k] = def_v;   end;    end
        return TABLE
    end; return class
end
function tableInFloat4(table) return imgui.ImFloat4(table[1],table[2],table[3],table[4]) end
function Float4InTable(float) return {float[1],float[2],float[3],float[4]} end
function Float4ToHex(float) return join_argb(float[4]*255,float[1]*255,float[2]*255,float[3]*255) end
function Float4ToImVec4(float) return imgui.ImVec4(float[1],float[2],float[3],float[4]) end
function join_argb(a, r, g, b) local argb = b argb = bit.bor(argb, bit.lshift(g, 8)) argb = bit.bor(argb, bit.lshift(r, 16)) argb = bit.bor(argb, bit.lshift(a, 24)) return argb end
createDirectory(getWorkingDirectory()..'/config/')
jPath = getWorkingDirectory() .. '/config/wh_cars.json'
j = json(jPath).load({
	line = {1,1,1,1},
	cars = {},
})

window = imgui.ImBool(false)

line = tableInFloat4(j.line)

add_id = imgui.ImInt(400)

search = imgui.ImBuffer(256)

font = renderCreateFont('arial',10,0x4)

function main()
	while not isSampAvailable() do wait(0) end
	
	sampRegisterChatCommand('whcar',function() window.v = not window.v end)

	while true do wait(0)
		imgui.Process = window.v
        MY_ID = select(2,sampGetPlayerIdByCharHandle(PLAYER_PED))
        MY_NICK = sampGetPlayerNickname(MY_ID)
        MYPOS = {getCharCoordinates(PLAYER_PED)}
        local sw,sh = getScreenResolution()

        if #j.cars ~= 0 then
	        for k,v in ipairs(getAllVehicles()) do
	        	for kk,vv in ipairs(j.cars) do
	        		if cars[vv[2]] ~= nil and vv[1] and getCarModel(v) == vv[2] then
	        			local x,y,z = getCarCoordinates(v)
	        			if select(4,convert3DCoordsToScreenEx(x,y,z)) > 1 then
	        				local w1 = {convert3DCoordsToScreen(x,y,z)}
	        				local w2 = {convert3DCoordsToScreen(MYPOS[1],MYPOS[2],MYPOS[3])}
	        				renderDrawLine(w1[1],w1[2],w2[1],w2[2],2,Float4ToHex(line.v))
	        				renderFontDrawText(font,cars[vv[2]],w1[1]-(renderGetFontDrawTextLength(font,cars[vv[2]]))/2,w1[2],Float4ToHex(line.v))
	        			end
	        		end
	        	end
	        end
	    end

	end
end


function imgui.OnDrawFrame()
	local sw,sh = getScreenResolution()

	if window.v then
		-- imgui.SetNextWindowSize(imgui.ImVec2(500,500),1)
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2,sh/2), imgui.Cond.FirstUseEver)
		imgui.Begin('Author: AkeGGa || wh_car',window,32+64)

		if imgui.Button('ALL CARS',imgui.ImVec2(-1,0)) then imgui.OpenPopup('cars') end

		imgui.InputInt('add car by modelId',add_id,0,0)
		if cars[add_id.v] ~= nil then
			imgui.Text(u8(cars[add_id.v]))
			if imgui.Button(u8('�������� '..cars[add_id.v])) then
				table.insert(j.cars,{false,add_id.v})
				json(jPath).save(j)
			end
		else
			imgui.Text(u8'������ �� ����!')
		end

		if imgui.ColorEdit4(u8'���� �����',line) then
			j.line = Float4InTable(line.v)
			json(jPath).save(j)
		end

		imgui.Separator()

		for k,v in ipairs(j.cars) do
			if cars[v[2]] ~= nil then
				if imgui.Button(u8(v[1] and '��������' or '���������') .. '##'..k) then v[1] = not v[1] json(jPath).save(j) end
				imgui.SameLine()
				imgui.Text(string.format('%s[%s]',u8(cars[v[2]]),v[2]))
				imgui.SameLine()
				if imgui.Button('DELETE##'..k) then table.remove(j.cars,k) json(jPath).save(j) end
			end
		end

		if imgui.BeginPopup('cars') then
			imgui.Text(u8('����[������]'))
			imgui.InputText('search',search)
			if #search.v > 0 then
				for k,v in pairs(cars) do
					if u8(v):find(search.v) or k == tonumber(search.v) then
						imgui.Text(string.format('%s[%s]',u8(v),k))
					end
				end
			end
			imgui.EndPopup()
		end

		imgui.End()
	end

end





function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 5.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
    colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()

local origsampAddChatMessage = sampAddChatMessage
function sampAddChatMessage(text,...); origsampAddChatMessage((tostring(text)):format(...),-1); end

function imgui.CenterColumnText(col,text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    if col == nil then
        imgui.Text(text)
    else
        imgui.TextColored(col,text)
    end
end

function imgui.CenterText(color,text)
    color = color or imgui.GetStyle().Colors[imgui.Col.Text]
    local width = imgui.GetWindowWidth()
    for line in text:gmatch('[^\n]+') do
        local lenght = imgui.CalcTextSize(line).x
        imgui.SetCursorPosX((width - lenght) / 2)
        imgui.TextColored(color, line)
    end
end




function getIdByCarName(n)
	for k,v in pairs(cars) do
		if n == v then
			return k
		end
	end
	return nil
end

cars = {
	[400] = 'Porsche Cayenne',
	[401] = '�� 2712',
	[402] = 'Mercedes E63 AMG',
	[403] = 'Scania',
	[404] = 'Volvo 940',
	[405] = 'Audi RS-6 Avant',
	[406] = '��� 130 (��������)',
	[407] = '����� (��������)',
	[408] = '��� (���������)',
	[409] = 'Rolls-Royce',
	[410] = 'Mercedes-Benz C63S',
	[411] = 'MMC Lancer EVO',
	[412] = 'Mercedes W123',
	[413] = '������� ���-672',
	[414] = '������� ����-5256',
	[415] = 'Lamborghini Aventador',
	[416] = 'Mercedes Benz Sprinter (�����������)',
	[417] = '������� ��������',
	[418] = '������� ��� �079',
	[419] = 'Opel Astra GTC',
	[420] = 'Ford Focus 3 (�����)',
	[421] = 'Peugeout 406',
	[422] = 'JEEP GC',
	[423] = '��������� �����������',
	[424] = 'Mahindra retriever',
	[425] = '������� ��������',
	[426] = '��� - 4147',
	[427] = '������ �������',
	[428] = 'Ford Transit ����������',
	[429] = 'MAYBACH X222',
	[430] = '����������� �����',
	[431] = '������� Setra',
	[432] = '����',
	[433] = '���� (�������)',
	[434] = 'Hotknife ������',
	[435] = '������',
	[436] = 'KIA Rio',
	[437] = '������� �����c',
	[438] = 'Renault Logan (�����)',
	[439] = '��� 2101',
	[440] = 'Yamaha �����������',
	[441] = '�������� ���������� ������� RC Bandit',
	[442] = '��� �1',
	[443] = '������� Packer',
	[444] = 'Monster ������',
	[445] = 'Skoda Octavia RS',
	[446] = '����� SQUALO',
	[447] = '������ �������� Seasparrow',
	[448] = '������ (��������)',
	[449] = '�������� �������',
	[450] = '������',
	[451] = 'FERRARI 488 GTB',
	[452] = '����� SPEEDER',
	[453] = '�������� �����',
	[454] = '���� TROPIC',
	[455] = '������������',
	[456] = '��� NEXT',
	[457] = '��������',
	[458] = 'Audi A4',
	[459] = 'Mercedes-Benz Vito',
	[460] = '�������� ��-2B',
	[461] = 'Honda CB 750',
	[462] = 'Scooter',
	[463] = 'Harley Chopper',
	[464] = '���������� �������',
	[465] = '���������� ��������',
	[466] = 'BMW G30',
	[467] = '��� 2107',
	[468] = 'MotoCross',
	[469] = '�������� Robinson R22',
	[470] = '����',
	[471] = 'Snowmobile',
	[472] = '���������� �����',
	[473] = '����� DINGHY',
	[474] = 'Volkswagen Passat (���)',
	[475] = 'BMW X5',
	[476] = '��������� �����������',
	[477] = 'Mazda Rx-7',
	[478] = '�� 27151',
	[479] = 'Renault Logan',
	[480] = 'AUDI R8',
	[481] = '��������� BMX',
	[482] = '������',
	[483] = '������� ��� - 3205',
	[484] = '��������',
	[485] = '���-24 ������',
	[486] = '���������',
	[487] = '�������� Robinson R44',
	[488] = '�������� (���)',
	[489] = 'TLC 200',
	[490] = 'RANGE ROVER VOGUE',
	[491] = 'Honda Civic',
	[492] = '��� 2109',
	[493] = '����� JETMAX',
	[494] = 'DODGE CHALLANGER',
	[495] = 'Ford Raptor',
	[496] = 'Opel Ascona',
	[497] = '����������� ��������',
	[498] = '������� ��� - 695',
	[499] = '����� NEXT',
	[500] = '������ ������ ��� Hunter',
	[501] = '���������� ��������',
	[502] = 'Rolls Royce Wraith',
	[503] = 'NISSAN GT-R 35',
	[504] = '��������',
	[505] = 'Bentley Bentyaga',
	[506] = 'PORSCHE 911',
	[507] = 'BMW E34',
	[508] = 'Ford Raptor (Ranger F150)',
	[509] = '��������',
	[510] = '��������� BTBike',
	[511] = '������� �������',
	[512] = '������� ���������� ��-2',
	[513] = '������� ��������',
	[514] = '����� 5410',
	[515] = 'Renault Mangum',
	[516] = 'Ford Focus 3',
	[517] = '���-2203 ��������',
	[518] = 'E���',
	[519] = '������� �������',
	[520] = '�����������',
	[521] = '�� (������)',
	[522] = 'Ducati Desmosed.RR',
	[523] = '����������� ��������',
	[524] = '���������',
	[525] = '���������',
	[526] = 'Ford Sierra',
	[527] = 'Volkswagen Golf',
	[528] = '��� Patriot',
	[529] = 'Mercedes-Benz W126',
	[530] = '���������',
	[531] = '�������',
	[532] = '�������',
	[533] = 'Audi TTRS',
	[534] = 'BMW E30',
	[535] = 'Subaru Impreza RS SPORT',
	[536] = 'Volvo 240',
	[539] = '��������� �������',
	[540] = 'Mercedes E55',
	[541] = 'Ferrari Portofino',
	[542] = '���� 969',
	[543] = 'TESLA MODEL S',
	[544] = 'Mercedes Unimog (��������)',
	[545] = '������� (���� - 400)',
	[546] = '�� 2125 �����',
	[547] = 'Audi 80',
	[548] = '������� �������� ��������',
	[549] = '���',
	[550] = '��� 2170',
	[551] = 'BMW E39',
	[552] = 'Mercedes Benz Unimog (������ �����)',
	[553] = '�������� �������',
	[554] = 'UAZ Patriot',
	[555] = '��� 968�',
	[556] = '������ (��������� �1) Monster',
	[557] = '������ (��������� �2) Monster',
	[558] = 'BMW M4',
	[559] = 'Toyota Supra',
	[560] = 'Subaru WRX Sti',
	[561] = '��� 2115',
	[562] = 'Nissan Skyline GT-R 34',
	[563] = '�������� ��������',
	[564] = '���������� ����',
	[565] = '��� 2108',
	[566] = 'Daewoo Lanos',
	[567] = '��� 2106',
	[568] = 'Bandito �����',
	[571] = '�������',
	[572] = '�������������',
	[573] = 'MERCEDES G65 6X6',
	[574] = '�������',
	[575] = '���-�-20 "������"',
	[576] = '����-408',
	[577] = '������������ ������� Aeroflot',
	[578] = '���� NEXT (�������)',
	[579] = 'MERCEDES G65',
	[580] = '���-13 "�����"',
	[581] = 'Suzuki Hayabusa',
	[582] = 'Mercedes Benz Sprinter ���',
	[583] = '��������',
	[584] = '��������',
	[585] = 'Mercedes S600',
	[586] = 'Harley Fat Boy',
	[587] = 'AUDI QUATTRO',
	[588] = '������� ����',
	[589] = 'VW Golf GTI 2021',
	[590] = '�����',
	[591] = '��� �� �������',
	[592] = '������� �������� �������',
	[593] = '�������� ������� �� 2',
	[594] = '������',
	[595] = '����� LAUNCH',
	[596] = '��� 2107 (���)',
	[597] = 'Renault Logan (���)',
	[598] = 'BMW M5 G30 (���)',
	[599] = '��� 469 (���)',
	[600] = '�� 2717',
	[601] = '���-4',
	[602] = 'Lexus RC-F',
	[603] = 'Dodge Charger 1969',
	[604] = 'Porsche Panamera T.',
	[605] = 'Lamborghini Huracan',
	[606] = '������ (�����)',
	[607] = '������ (�����)',
	[608] = '���������� ����',
	[609] = 'Avia A31',
	[610] = '�����������',
	[611] = '������ (�����)',
	[612] = 'BMW M5 E60',
	[613] = 'NIVA Urban',
	[614] = 'BMW X6M E71',
	[699] = 'MINI John Cooper Works GP [R56]',
	[793] = 'AUDI Q7',
	[794] = 'BMW M2',
	[795] = 'Mercedes-Benz 4X4*2',
	[796] = 'Mercedes-Benz G-CLASS W464',
	[797] = 'FORD MUSTANG GT 5.0',
	[798] = 'Mercedes-Benz W221 S63',
	[799] = '��� 31105 "�����"',
	[907] = 'BMW X5 F15',
	[908] = 'BMW X5M E70',
	[909] = 'Hyundai Santa Fe',
	[965] = 'Mercedes-Maybach PULLMAN',
	[999] = 'LAMBORGHINI URUS',
	[1326] = 'Mercedes-Benz ML63 AMG W164',
	[15065] = 'Toyota Chaser',
	[15066] = 'Volkswagen Touareg',
	[15067] = 'BMW E38 740',
	[15068] = 'Toyota Mark 2',
	[15069] = 'Toyota Camry V50',
	[15070] = '��� �������',
	[15071] = 'Lexus LX570',
	[15072] = 'Lexus IS200',
	[15073] = 'BMW 740 F02',
	[15074] = 'Lada 2114',
	[15075] = 'Jeep Grand Cherokee Trackhawk',
	[15076] = 'Cadillac Escalade',
	[15077] = 'Honda Accord',
	[15078] = 'Lada 2110',
	[15079] = 'Lada 2104',
	[15080] = '��� 2105',
	[15081] = 'Volkswagen Scirocco',
	[15082] = 'Mercedes-Benz 560 SEC',
	[15083] = '��� 66 "������"',
	[15084] = 'Alfa Romeo 155',
	[15085] = 'BUGATTI CHIRON',
	[15086] = 'Lexus IS F',
	[15087] = 'Mazda 3 MPS',
	[15088] = 'Mazda MX-5',
	[15089] = 'AUDI RS7',
	[15091] = 'Mercedes-Benz 300 SL',
	[15090] = 'Nissan Silvia S15',
	[15092] = 'VOLVO XC90',
	[15093] = 'Mercedes-Benz W124 E',
	[15094] = 'BMW X6M F16',
	[15095] = 'Mercedes-Benz Actros',
	[15096] = 'Volvo FM12',
	[15097] = '����� Volvo',
	[15098] = 'Ka��� 54115',
	[15099] = '���',
	[15100] = 'Scania R700',
	[15101] = '��� 130 (�����)',
	[15102] = 'MAN TGS',
	[15103] = '��� 131',
	[15104] = 'Tesla Cybertruck',
	[15105] = 'BMW M1',
	[15106] = 'BMW Z4 M40 2019',
	[15107] = 'BMW M5 F90',
	[15108] = 'Maserati LEVANTE 201',
	[15109] = 'BMW I8 ROADSTER',
	[15110] = '���������� Tesla Cybertruck',
	[15111] = '������ Tesla Cybertruck',
	[15112] = '������ ���������� Tesla Cybertruck',
	[15113] = 'CHEVROLET CORVETTE ZR1',
	[15114] = 'Mercedes-Benz GT63S',
	[15115] = 'Jeep Grand Cherokee',
	[15116] = 'MCLAREN P1',
	[15117] = '������� ������������',
	[15118] = 'Toyota Prado 2016',
	[15119] = '��� ������',
	[15120] = 'Mercedes-Benz E63',
	[15121] = 'Lada Vesta',
	[15122] = 'Jeep (���������)',
	[15123] = 'Lada Vesta ���',
	[15124] = '��� 3102',
	[15125] = 'Mitsubishi Lancer X',
	[15126] = 'TESLA X',
	[15127] = 'BMW 1000R',
	[15128] = 'Toyota Camry 40',
	[15129] = 'KTM',
	[15130] = 'CrossBike',
	[15131] = 'Subaru Impreza WRX',
	[15132] = 'DUCATI Diavel',
	[15133] = '��-5',
	[15134] = 'Kawasaki Ninja H2R',
	[15135] = 'Quad ����������',
	[15136] = 'Suzuki Hayabusa',
	[15137] = 'FENYR SUPERSPORT',
	[15138] = 'BMW 1000R',
	[15139] = 'HARLEY-DAVIDSON RSR-2',
	[15140] = 'Mercedes C63 �����',
	[15141] = 'Mercedes Benz CLS63',
	[15142] = 'Mercedes Benz E63 2021',
	[15143] = 'Mercedes AMG C63 S',
	[15144] = 'AUDI S3',
	[15145] = '��� 21099',
	[15146] = 'Rolls Royce CULLINAN',
	[15147] = 'Mercedes-Benz X',
	[15148] = 'RANGE ROVER VELAR',
	[15149] = 'AUDI RS6 C5',
	[15150] = 'LADA 2112 ����',
	[15151] = 'LADA 2112',
	[15152] = 'Volvo V40',
	[15153] = 'BMW X7',
	[15154] = '������',
	[15155] = 'Mercedes W124 Coupe AMG',
	[15156] = 'Bentley Turbo R',
	[15157] = 'Toyota Camry V70',
	[15158] = 'BMW M5 F90 R',
	[15159] = 'Acura NSX',
	[15160] = 'Mercedes Benz AMG McLaren SLR',
	[15161] = 'BMW 850',
	[15162] = 'Toyota Mark 2',
	[15163] = 'Honda S2000',
	[15164] = 'BMW M8 F9',
	[15165] = 'BMW M4 G82',
	[15166] = 'Mercedes-Benz S63 AMG',
	[15167] = 'Mercedes-Benz S500',
	[15168] = 'BMW M3 E36',
	[15169] = 'Chevrolet Corvette C8',
	[15170] = 'Ferrari F40',
	[15171] = 'Honda Civic Type-R',
	[15172] = 'Lexus LFA',
	[15173] = 'Porsche 911 992',
	[15174] = 'Shelby Cobra ����� �����',
	[15175] = 'BMW M5 F90 CS',
	[15176] = 'Mercedes-Benz SLS AMG',
	[15177] = 'HUMMER H1',
	[15178] = 'Mercedes-Benz SL65 AMG',
	[15179] = 'Bentley 1928 8 litr',
	[15180] = 'BMW M3 E46',
	[15181] = 'BMW M1 E82',
	[15182] = 'Ferrari LaFerrari',
	[15183] = 'Volkswagen Golf 5 GTI',
	[15184] = 'Toyota Hachiroku AE86',
	[15185] = 'Skoda Octavia VRS',
	[15186] = 'Skoda Octavia ���',
	[15187] = 'Ferrari 599XX',
	[15188] = 'BMW X6M F96',
	[15189] = 'Dodge RAM srt',
	[15190] = 'Mercedes-Benz 280sl',
	[15191] = 'Nissan 370Z',
	[15192] = 'Porsche Taycan Turbo S',
	[15193] = '���� 4320 �������',
	[15194] = 'GAZon Next �',
	[15195] = 'Toyota Camry ���-���-���-���',
	[15196] = 'Ford Focus 3 (���������)',
	[15197] = 'VW Golf 7 2019',
	[15198] = 'Kia Rio (���������)',
	[15199] = 'Mazda 3 MPS (���������)',
	[15200] = 'Skoda Octavia VRS (���������)',
	[15201] = 'Renault logan (���������)',
	[15202] = 'Volvo XC90 (���������)',
	[15203] = 'Alfa Romeo Gulia Quadrifoglio',
	[15204] = 'Audi RS7 C8',
	[15205] = 'Austin Seven 24',
	[15206] = 'BMW M635CSI E24 1986',
	[15207] = 'BMW M5 E28',
	[15208] = 'Gladiator',
	[15209] = 'BMW M3 E92',
	[15210] = 'BMW M5 F10',
	[15211] = 'BMW M6',
	[15212] = 'BMW Z8 E52',
	[15213] = 'Chevrolet Camaro 2017',
	[15214] = 'Chevrolet Suburban',
	[15215] = 'Citro�n DS 23',
	[15216] = 'DMC DeLorean',
	[15217] = 'Dodge Charger SRT HellCat',
	[15218] = 'Hennessey VelociRaptor 6x6',
	[15219] = 'Ford Mustang Shelby',
	[15220] = 'infinity Q50',
	[15221] = 'Jeep Rubicon',
	[15222] = 'Koenigsegg Jesko',
	[15223] = 'Lamborghini Aventador J',
	[15224] = 'Lamborghini Aventador SVJ',
	[15225] = 'Lamborghini Countach',
	[15226] = 'Land Rover Defender',
	[15227] = 'McLaren Senna',
	[15228] = 'Mercedes Benz AMG GTR',
	[15229] = 'Mercedes Benz CLK-GTR',
	[15230] = 'Porche 918 Spyder',
	[15231] = 'Mercedes Benz W221 S320d',
	[15232] = 'Mercedes Benz Unimog U5023',
	[15233] = 'Napier Railton',
	[15234] = 'Gladiator',
	[15235] = 'Noble M600',
	[15236] = 'Pagani Huayra',
	[15237] = 'Porsche 911 Turbo 1975',
	[15238] = 'Quadra V-Tech',
	[15239] = '����',
	[15240] = 'Toyota Land Cruiser 100',
	[15241] = 'Toyota Camry ���-���-���-���',
	[15242] = '��� ������ ����',
	[15243] = '����',
	[15244] = '�������� ����',
	[15245] = '��������',
	[15246] = 'Audi RS4 Avant',
	[15247] = 'Audi RS5 2018',
	[15248] = 'Audi Q8',
	[15249] = 'BMW X7 Facelit',
	[15250] = 'Bugatti Divo',
	[15251] = '������� ���',
	[15252] = 'Ferrari SF90',
	[15253] = 'Dodge Charger (������ 7)',
	[15254] = 'Mazda RX-7 (������ 1)',
	[15255] = 'Mazdaq RX-7 (������ 3)',
	[15256] = 'MMC Lancer Evo (������ 3)',
	[15257] = 'Nissan Skyline GTR (������ 2)',
	[15258] = 'Toyota Supra (������ 1)',
	[15259] = 'Ford GT',
	[15260] = 'Ford Transit TK',
	[15261] = 'Lamborghini Centenario',
	[15262] = 'Land-Rover Range Rover Series I',
	[15263] = 'McLaren 765LT',
	[15264] = 'Mercedes Benz C63 W204 Coupe BE',
	[15265] = 'Mercedes Benz GL63 X166',
	[15266] = 'Mercedes Benz Maybach G650 Landaulet',
	[15267] = 'Volga Gladiator',
	[15268] = 'Mercedes Benz Sprinter TK',
	[15269] = 'Mercedes Benz S63 AMG W223',
	[15270] = 'Mercedes Benz S500 W223',
	[15271] = 'Nissan 400 Fairlady',
	[15272] = 'Saab 9-3',
	[15273] = 'Subaru Impreza WRX',
	[15274] = 'Toyota 4Runner TRD Pro 2019',
	[15275] = 'Toyota Tundra',
	[15276] = 'VW Touareg',
	[15277] = '����� (�������)',
	[15278] = 'Mercedes Benz Sprinter (�������)',
	[15279] = 'Toyota Tundra (������)',
	[15280] = 'Volga Gladiator',
	[15281] = '��� ���������',
}