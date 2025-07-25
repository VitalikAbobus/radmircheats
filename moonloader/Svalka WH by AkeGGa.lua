script_name("wh_svalka")

local imgui = require "mimgui"
local vkeys = require "vkeys"
local ffi = require "ffi"
local inicfg = require "inicfg"
local encoding = require "encoding"

encoding.default = "CP1251"
local u8 = encoding.UTF8

--> Variables
local ivar = {
	window 		= imgui.new.bool(false),
	active 		= imgui.new.bool(false),
	tiph 		= imgui.new.bool(false),
	tsm 		= imgui.new.bool(false),
	zcrist 		= imgui.new.bool(false),
	siph 		= imgui.new.bool(false),
	tonok 		= imgui.new.bool(false),
	svarka 		= imgui.new.bool(false),
	scrist 		= imgui.new.bool(false),
	zapiph 		= imgui.new.bool(false),
	sothp 		= imgui.new.bool(false),
	fcrist 		= imgui.new.bool(false),
	nouappl 	= imgui.new.bool(false),
	nout 		= imgui.new.bool(false),
	rcrist 		= imgui.new.bool(false),
	dvigalo 	= imgui.new.bool(false),
	trapka 		= imgui.new.bool(false),
	telek 		= imgui.new.bool(false),
	gdrub 		= imgui.new.bool(false),
	vazik 		= imgui.new.bool(false),
	sysblock 	= imgui.new.bool(false),
	lobglass 	= imgui.new.bool(false),
	ximia 		= imgui.new.bool(false),
	gdtworub 	= imgui.new.bool(false),
	gitoskut 	= imgui.new.bool(false),
	shpric 		= imgui.new.bool(false),
	gdcherv 	= imgui.new.bool(false),
	sputnik 	= imgui.new.bool(false),
	diski 		= imgui.new.bool(false),
	butalka 	= imgui.new.bool(false),
	gdpatdes 	= imgui.new.bool(false),
	sltelik 	= imgui.new.bool(false),
	gonsiden 	= imgui.new.bool(false),
	ahikspatr 	= imgui.new.bool(false),
	zapcknoutu 	= imgui.new.bool(false),
	oldsiden 	= imgui.new.bool(false),
	otmach 		= imgui.new.bool(false),
	modvolg 	= imgui.new.bool(false),
	crackbank 	= imgui.new.bool(false),
	oldrulamg 	= imgui.new.bool(false),
	metall 		= imgui.new.bool(false),
	modrafik 	= imgui.new.bool(false),
	stanok 		= imgui.new.bool(false),
	rulmersamg 	= imgui.new.bool(false),
	glushak 	= imgui.new.bool(false),
	ceif 		= imgui.new.bool(false),
	key 		= imgui.new.bool(false),
	rulnissgtr 	= imgui.new.bool(false),
	blacksiden 	= imgui.new.bool(false),
	akkum 		= imgui.new.bool(false),
	inst 		= imgui.new.bool(false),
	zapkrulamg 	= imgui.new.bool(false),
	sizetr		= imgui.new.int(1),
	colortx		= imgui.new.int(1),
	colortr		= imgui.new.int(1),
	kek = imgui.new.bool(false)
}

local cfg = inicfg.load({
	whobjects = {
		tiph = false,
		metall = false,
		gdcherv = false,
		tsm = false,
		butalka = false,
		shpric = false,
		gdtworub = false,
		vazik = false,
		dvigalo = false,
		ahikspatr = false,
		nout = false,
		nouappl = false,
		siph = false,
		modrafik = false,
		crackbank = false,
		oldrulamg = false,
		rcrist = false,
		zapiph = false,
		fcrist = false,
		diski = false,
		telek = false,
		rulmersamg = false,
		rulnissgtr = false,
		akkum = false,
		sputnik = false,
		zapkrulamg = false,
		ceif = false,
		key = false,
		trapka = false,
		gonsiden = false,
		sysblock = false,
		stanok = false,
		otmach = false,
		sltelik = false,
		glushak = false,
		oldsiden = false,
		lobglass = false,
		modvolg = false,
		gdrub = false,
		tonok = false,
		ximia = false,
		sothp = false,
		zcrist = false,
		inst = false,
		scrist = false,
		gdpatdes = false,
		zapcknoutu = false,
		gitoskut = false,
		svarka = false,
		blacksiden = false
	},
	settings = {
		cmd = "svalka",
		colortr = 2,
		sizetr = 1,
		cmdact = "activ.svalka",
		colortx = 2
	}
}, "wh na svalku by akegga.ini")

if not doesFileExist("moonloader/config/wh na svalku by akegga.ini") then
	inicfg.save(cfg, "wh na svalku by akegga.ini")
end

local ig_cmd = imgui.new.char[56](cfg.settings.cmd)
local ig_cmdact = imgui.new.char[56](cfg.settings.cmdact)

--> Other variables
local font = renderCreateFont("Arial", 11, 5)
local screenX, screenY = getScreenResolution()
local tab = "main"

local colors_draw = {
	4294641158,
	4294670598,
	4294441734,
	4278640123,
	4278590715,
	4287563515,
	4278647573,
	4281726305
}

local colors = {
	u8("Красный"),
	u8("Оранжевый"),
	u8("Желтый"),
	u8("Голубой"),
	u8("Синий"),
	u8("Фиолетовый"),
	u8("Зеленый"),
	u8("Мятно-Зеленый")
}

local colors_const_char = imgui.new["const char*"][#colors](colors)

local displayObjects = {
	[10711] = { name = "Золотой рубль", var = ivar.gdrub },
	[10716] = { name = "Отмычка", var = ivar.otmach },
	[10715] = { name = "Системный блок", var = ivar.sysblock },
	[10707] = { name = "Телефон Nokia 3310", var = ivar.tonok },
	[10505] = { name = "Ноутбук", var = ivar.nout },
	[10825] = { name = "Глушитель", var = ivar.glushak },
	[13923] = { name = "Красный кристалл", var = ivar.rcrist },
	[10828] = { name = "Запчасти к ноутбуку", var = ivar.zapcknoutu },
	[10818] = { name = "Бутылка", var = ivar.butalka },
	[13952] = { name = "Лобовое стекло", var = ivar.lobglass },
	[1044] 	= { name = "Металл", var = ivar.metall },
	[10816] = { name = "Тряпка", var = ivar.trapka },
	[10708] = { name = "Телефон Nokia", var = ivar.sothp },
	[10826] = { name = "Сломанный iPhone", var = ivar.siph },
	[13948] = { name = "Химия", var = ivar.ximia },
	[10833] = { name = "Колесо", var = ivar.diski },
	[13922] = { name = "Спутник", var = ivar.sputnik },
	[13929] = { name = "Модель РАФ-2203", var = ivar.modrafik },
	[10819] = { name = "Шприц", var = ivar.shpric },
	[10706] = { name = "Гоночное сиденье", var = ivar.gonsiden },
	[10709] = { name = "Телефон Samsung", var = ivar.tsm },
	[10702] = { name = "Ящик с патронами", var = ivar.ahikspatr },
	[10704] = { name = "Старое сиденье", var = ivar.oldsiden },
	[13928] = { name = "Модель ВАЗ-2109", var = ivar.vazik },
	[13925] = { name = "Зеленый кристалл", var = ivar.zcrist },
	[10710] = { name = "Телефон iPhone", var = ivar.tiph },
	[10509] = { name = "Сломанный телевизор", var = ivar.sltelik },
	[13926] = { name = "Синий кристалл", var = ivar.scrist },
	[13950] = { name = "Старый руль AMG", var = ivar.oldrulamg },
	[10719] = { name = "Руль Nissan GTR", var = ivar.rulnissgtr },
	[10827] = { name = "Запчасти к iPhone", var = ivar.zapiph },
	[10713] = { name = "Золотой червонец", var = ivar.gdcherv },
	[13930] = { name = "Гироскутер", var = ivar.gitoskut },
	[13927] = { name = "Модель \"Волга\"", var = ivar.modvolg },
	[10712] = { name = "Золотые два рубля", var = ivar.gdtworub },
	[10723] = { name = "Ноутбук Apple", var = ivar.nouappl },
	[10703] = { name = "Сломанный", var = ivar.crackbank },
	[13924] = { name = "Фиолетовый кристалл", var = ivar.fcrist },
	[10720] = { name = "Старый сейф", var = ivar.ceif },
	[15411] = { name = "КЛЮЧИ", var = ivar.key },
	[10508] = { name = "Телевизор", var = ivar.telek },
	[10718] = { name = "Руль Mercedes AMG", var = ivar.rulmersamg },
	[10832] = { name = "Сварка", var = ivar.svarka },
	[13949] = { name = "Двигатель", var = ivar.dvigalo },
	[10714] = { name = "Золотые пятьдесят", var = ivar.gdpatdes },
	[10721] = { name = "Станок", var = ivar.stanok },
	[13951] = { name = "Запчасти к рулю AMG", var = ivar.zapkrulamg },
	[10831] = { name = "Инструменты", var = ivar.inst },
	[10834] = { name = "Инструменты", var = ivar.akkum },
	[634] 	= { name = "Инструменты", var = ivar.blacksiden }
}

local ig_objects = {
	["technic"] = {
		["Телефон Samsung"] = "tsm",
		["Телефон Nokia 3310"] = "tonok",
		["Телефон Nokia"] = "sothp",
		["Телефон iPhone"] = "tiph",
		["Ноутбук"] = "nout",
		["Ноутбук Apple"] = "nouappl",
		["Системный блок"] = "sysblock",
		["Гироскутер"] = "gitoskut",
		["Спутник"] = "sputnik",
		["Телевизор"] = "telek"
	},
	["technic_broken"] = {
		["Сломанный iPhone"] = "siph",
		["Сломанный Телевизор"] = "sltelik",
		["Запчасти к ноутбуку"] = "zapcknoutu",
		["Запчасти к iPhone"] = "zapiph"
	},

	["spare-parts"] = {
		["Аккумулятор"] = "akkum",
		["Инструменты"] = "inst",
		["Запчасти к рулю AMG"] = "zapkrulamg",
		["Сварка"] = "svarka",
		["Двигатель"] = "dvigalo",
		["Лобовое стекло"] = "lobglass",
		["Колесо"] = "diski"
	},
	["spare-parts_broken"] = {
		["Гоночное сиденье"] = "gonsiden",
		["Старое сиденье"] = "oldsiden",
		["Черное сиденье"] = "blacksiden"
	},
	["spare-parts_broken2"] = {
		["Старый руль AMG"] = "oldrulamg",
		["Руль Mercedes AMG"] = "rulmersamg",
		["Руль Nissan GTR"] = "rulnissgtr"
	},

	["coins"] = {
		["Золотой Рубль"] = "gdrub",
		["Золотые Два Рубля"] = "gdtworub",
		["Золотой Червонец"] = "gdcherv",
		["Золотые Пятьдесят"] = "gdpatdes"
	},

	["models"] = {
		["Модель Волга"] = "modvolg",
		["Модель РАФ-2203"] = "modrafik",
		["Модель ВАЗ-2109"] = "vazik"
	},

	["trash"] = {
		["Зеленый кристалл"] = "zcrist",
		["Синий кристалл"] = "scrist",
		["Фиолетовый кристалл"] = "fcrist",
		["Красный кристалл"] = "rcrist",
		["Тряпка"] = "trapka",
		["Химия"] = "ximia",
		["Шприц"] = "shpric",
		["Бутылка"] = "butalka",
		["Ящик с патронами"] = "ahikspatr",
		["Отмычка"] = "otmach",
		["Металл"] = "metall",
		["Глушитель"] = "glushak"
	},
	["trash2"] = {
		["Сломанный банкомат"] = "crackbank",
		["Станов"] = "stanok",
		["Старый сейф"] = "ceif",
		["КЛЮЧИ"] = "key"
	}
}

--> Main
function main()
	while not isSampAvailable() do wait(80) end

	loadall()
	sampRegisterChatCommand(cfg.settings.cmd, function()
		ivar.window[0] = not ivar.window[0]
	end)
	sampRegisterChatCommand(cfg.settings.cmdact, function()
		ivar.active[0] = not ivar.active[0]
	end)

	sampAddChatMessage(string.format("[Svalka WH by AkeGGa] {FFFFFF}Загружен. Меню: {35F561}/%s {FFFFFF}или {35F561}CTRL + B. {FFFFFF}Рендер: {35F561}/%s", cfg.settings.cmd, cfg.settings.cmdact), 0x35F561)

	while true do wait(0)
		if isKeyDown(vkeys.VK_CONTROL) and wasKeyPressed(vkeys.VK_B) then
			ivar.window[0] = not ivar.window[0]
		end

		if ivar.active[0] then
			for _, obj in pairs(getAllObjects()) do
				if isObjectOnScreen(obj) then
					local pX, pY, pZ = getCharCoordinates(playerPed)
					local res, oX, oY, oZ = getObjectCoordinates(obj)
					local soX, soY = convert3DCoordsToScreen(oX, oY, oZ)
					local poX, poY = convert3DCoordsToScreen(pX, pY, pZ)
					local model = getObjectModel(obj)

					if res and getDistanceBetweenCoords3d(oX, oY, oZ, pX, pY, pZ) > 1.2 then
						for k, v in pairs(displayObjects) do
							if model == k and v.var[0] then
								local dist = math.floor(getDistanceBetweenCoords3d(oX, oY, oZ, pX, pY, pZ))

								renderDrawLine(poX, poY, soX, soY, ivar.sizetr[0], colors_draw[ ivar.colortr[0] + 1 ])
								renderFontDrawText(font, string.format("%s {FFFFFF}%dm.", v.name, dist), soX, soY, colors_draw[ivar.colortx[0]])
							end
						end
					end
				end
			end
		end
	end
end

--> ImGui
imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(20) .. "\\Verdana.ttf", 14, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	
	style()
end)

local submenus = { "Настройка", "Техника", "Запчасти", "Монеты", "Модели", "Хлам" }

local mainFrame = imgui.OnFrame(function() return ivar.window[0] and not isPauseMenuActive() end, function(self)
	imgui.SetNextWindowPos(imgui.ImVec2(screenX / 2, screenY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(557, 340), imgui.Cond.FirstUseEver)
	imgui.Begin("meow", ivar.window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoTitleBar)
	
	for i = 1, #submenus do
		local name = submenus[i]
		if imgui.ButtonActivated(tab == name, u8(name), imgui.ImVec2(85.0, 20.0)) then
			tab = name
		end
		imgui.SameLine(nil, name == "Настройки" and 15 or 5)
	end
	
	imgui.NewLine()
	
	imgui.BeginChild("#tabs", imgui.ImVec2(640, 300), true)
	if tab == "Техника" then
		imgui.Columns(2, "nullptr", false)
		imgui.SetColumnWidth(-1, 190)
		draw_set_objects("technic")

		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 180)
		draw_set_objects("technic_broken")
		imgui.Columns(1)
	elseif tab == "Запчасти" then
		imgui.Columns(2, "nullptr", false)
		imgui.SetColumnWidth(-1, 190)
		draw_set_objects("spare-parts")

		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 180)
		draw_set_objects("spare-parts_broken")

		imgui.Dummy(imgui.ImVec2(0, 20))
		draw_set_objects("spare-parts_broken2")
		imgui.Columns(1)
	elseif tab == "Монеты" then
		draw_set_objects("coins")
	elseif tab == "Модели" then
		draw_set_objects("models")
	elseif tab == "Хлам" then
		imgui.Columns(2, "nullptr", false)
		imgui.SetColumnWidth(-1, 210)
		draw_set_objects("trash")

		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 180)
		draw_set_objects("trash2")
		imgui.Columns(1)
	else
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize("Статус рендера:").x) * 0.33)
		imgui.Text(u8"Статус рендера:")
		imgui.SameLine()

		local clr = ivar.active[0] and imgui.ImVec4(0.10, 0.90, 0.00, 1.00) or imgui.ImVec4(0.90, 0.00, 0.00, 1.00)
		imgui.TextColored(clr, ivar.active[0] and u8"Активен" or u8"Выключен")

		imgui.PushItemWidth(100)
		if imgui.InputInt(u8"Толщина Трейсера", ivar.sizetr, 0, 0) then
			cfg.settings.sizetr = ivar.sizetr[0]
			inicfg.save(cfg, "wh na svalku by akegga.ini")
		end
		imgui.PopItemWidth()

		imgui.Spacing()

		imgui.PushItemWidth(150)
		if imgui.Combo(u8"Цвет Трейсера", ivar.colortr, colors_const_char, #colors) then
			cfg.settings.colortr = ivar.colortr[0]
			inicfg.save(cfg, "wh na svalku by akegga.ini")
		end
		imgui.Spacing()
		if imgui.Combo(u8"Цвет Текста", ivar.colortx, colors_const_char, #colors) then
			cfg.settings.colortx = ivar.colortx[0]
			inicfg.save(cfg, "wh na svalku by akegga.ini")
		end
		imgui.PopItemWidth()

		imgui.Spacing()

		imgui.PushItemWidth(100)
		if imgui.InputText(u8"Команда \"Меню\" (без \"/\")", ig_cmd, ffi.sizeof(ig_cmd)) then
			sampUnregisterChatCommand(cfg.settings.cmd)
			sampRegisterChatCommand(ffi.string(ig_cmd), function()
				ivar.window[0] = not ivar.window[0]
			end)
			cfg.settings.cmd = ffi.string(ig_cmd)
			inicfg.save(cfg, "wh na svalku by akegga.ini")
		end
		imgui.Spacing()
		if imgui.InputText(u8"Команда \"Рендер\" (без \"/\")", ig_cmdact, ffi.sizeof(ig_cmdact)) then
			sampUnregisterChatCommand(cfg.settings.cmdact)
			sampRegisterChatCommand(ffi.string(ig_cmdact), function()
				ivar.active[0] = not ivar.active[0]
			end)
			cfg.settings.cmdact = ffi.string(ig_cmdact)
			inicfg.save(cfg, "wh na svalku by akegga.ini")
		end
		imgui.PopItemWidth()
	end

	imgui.End()
end)

--> Helpful functions
function loadall()
	ivar.akkum[0] 		= cfg.whobjects.akkum
	ivar.inst[0] 		= cfg.whobjects.inst
	ivar.zapkrulamg[0] 	= cfg.whobjects.zapkrulamg
	ivar.blacksiden[0] 	= cfg.whobjects.blacksiden
	ivar.vazik[0] 		= cfg.whobjects.vazik
	ivar.tiph[0] 		= cfg.whobjects.tiph
	ivar.tsm[0] 		= cfg.whobjects.tsm
	ivar.zcrist[0] 		= cfg.whobjects.zcrist
	ivar.siph[0] 		= cfg.whobjects.siph
	ivar.tonok[0] 		= cfg.whobjects.tonok
	ivar.svarka[0] 		= cfg.whobjects.svarka
	ivar.scrist[0] 		= cfg.whobjects.scrist
	ivar.zapiph[0] 		= cfg.whobjects.zapiph
	ivar.sothp[0] 		= cfg.whobjects.sothp
	ivar.fcrist[0] 		= cfg.whobjects.fcrist
	ivar.nouappl[0] 	= cfg.whobjects.nouappl
	ivar.nout[0] 		= cfg.whobjects.nout
	ivar.rcrist[0] 		= cfg.whobjects.rcrist
	ivar.dvigalo[0] 	= cfg.whobjects.dvigalo
	ivar.trapka[0] 		= cfg.whobjects.trapka
	ivar.telek[0] 		= cfg.whobjects.telek
	ivar.gdrub[0] 		= cfg.whobjects.gdrub
	ivar.sysblock[0] 	= cfg.whobjects.sysblock
	ivar.lobglass[0] 	= cfg.whobjects.lobglass
	ivar.ximia[0] 		= cfg.whobjects.ximia
	ivar.gdtworub[0] 	= cfg.whobjects.gdtworub
	ivar.gitoskut[0] 	= cfg.whobjects.gitoskut
	ivar.shpric[0] 		= cfg.whobjects.shpric
	ivar.gdcherv[0] 	= cfg.whobjects.gdcherv
	ivar.sputnik[0] 	= cfg.whobjects.sputnik
	ivar.diski[0] 		= cfg.whobjects.diski
	ivar.butalka[0] 	= cfg.whobjects.butalka
	ivar.gdpatdes[0] 	= cfg.whobjects.gdpatdes
	ivar.sltelik[0] 	= cfg.whobjects.sltelik
	ivar.gonsiden[0] 	= cfg.whobjects.gonsiden
	ivar.ahikspatr[0] 	= cfg.whobjects.ahikspatr
	ivar.zapcknoutu[0] 	= cfg.whobjects.zapcknoutu
	ivar.oldsiden[0] 	= cfg.whobjects.oldsiden
	ivar.otmach[0] 		= cfg.whobjects.otmach
	ivar.modvolg[0] 	= cfg.whobjects.modvolg
	ivar.crackbank[0] 	= cfg.whobjects.crackbank
	ivar.oldrulamg[0] 	= cfg.whobjects.oldrulamg
	ivar.metall[0] 		= cfg.whobjects.metall
	ivar.modrafik[0] 	= cfg.whobjects.modrafik
	ivar.stanok[0] 		= cfg.whobjects.stanok
	ivar.rulmersamg[0] 	= cfg.whobjects.rulmersamg
	ivar.glushak[0] 	= cfg.whobjects.glushak
	ivar.ceif[0] 		= cfg.whobjects.ceif
	ivar.key[0] 		= cfg.whobjects.key
	ivar.rulnissgtr[0] 	= cfg.whobjects.rulnissgtr
	ivar.sizetr[0] 		= cfg.settings.sizetr
	ivar.colortx[0] 	= cfg.settings.colortx
	ivar.colortr[0] 	= cfg.settings.colortr
end

function draw_set_objects(name)
	for k, v in pairs(ig_objects[name]) do
		if imgui.Checkbox(u8(k), ivar[v]) then
			cfg.whobjects[v] = ivar[v][0]
			inicfg.save(cfg, "wh na svalku by akegga.ini")
		end
	end
end

function imgui.ButtonActivated(activated, ...)
    if activated then
        imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.CheckMark])
            imgui.Button(...)
        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()
    else
        return imgui.Button(...)
    end
end

function style()
	imgui.SwitchContext()
    
	local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
 
	style.WindowRounding 		= 5
	style.ChildRounding 		= 5
	style.FrameRounding 		= 5
	style.PopupRounding 		= 5
	style.ScrollbarRounding 	= 5
	style.GrabRounding 			= 5
	style.TabRounding 			= 5
	style.WindowTitleAlign 		= ImVec2(0.5, 0.5)
	style.ButtonTextAlign 		= ImVec2(0.5, 0.5)
	style.SelectableTextAlign 	= ImVec2(0.5, 0.5)

    colors[clr.Text]                    = ImVec4(0.95, 0.96, 0.98, 1.00)
    colors[clr.TextDisabled]            = ImVec4(0.36, 0.42, 0.47, 1.00)
    colors[clr.WindowBg]                = ImVec4(0.11, 0.15, 0.17, 1.00)
	colors[clr.ChildBg]           		= ImVec4(0.15, 0.18, 0.22, 1.00)
    colors[clr.PopupBg]                 = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.Border]                  = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.BorderShadow]            = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]                 = ImVec4(0.20, 0.25, 0.29, 1.00)
    colors[clr.FrameBgHovered]          = ImVec4(0.12, 0.20, 0.28, 1.00)
    colors[clr.FrameBgActive]           = ImVec4(0.09, 0.12, 0.14, 1.00)
    colors[clr.TitleBg]                 = ImVec4(0.09, 0.12, 0.14, 0.65)
    colors[clr.TitleBgCollapsed]        = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.TitleBgActive]           = ImVec4(0.08, 0.10, 0.12, 1.00)
    colors[clr.ScrollbarBg]             = ImVec4(0.02, 0.02, 0.02, 0.39)
    colors[clr.ScrollbarGrab]           = ImVec4(0.20, 0.25, 0.29, 1.00)
    colors[clr.ScrollbarGrabHovered]    = ImVec4(0.18, 0.22, 0.25, 1.00)
    colors[clr.ScrollbarGrabActive]     = ImVec4(0.09, 0.21, 0.31, 1.00)
    colors[clr.Button]                  = ImVec4(0.20, 0.25, 0.29, 1.00)
    colors[clr.ButtonHovered]           = ImVec4(0.52, 0.20, 0.92, 1.00)
    colors[clr.ButtonActive]            = ImVec4(0.60, 0.20, 1.00, 1.00)
    colors[clr.CheckMark]               = ImVec4(0.52, 0.20, 0.92, 1.00)
    colors[clr.SliderGrab]              = ImVec4(0.52, 0.20, 0.92, 1.00)
    colors[clr.SliderGrabActive]        = ImVec4(0.60, 0.20, 1.00, 1.00)
    colors[clr.ResizeGrip]              = ImVec4(0.26, 0.59, 0.98, 0.25)
    colors[clr.ResizeGripHovered]       = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.ResizeGripActive]        = ImVec4(0.06, 0.05, 0.07, 1.00)
end