
local cs16_main_color = Color(255, 170, 0, 255)
local sb_color_main = cs16_main_color
local sb_color_bg_1 = Color(20, 20, 20, 200)

local ui_button_w = 288
local ui_button_h = 45
local ui_button_hovered_color = Color(255, 170, 0, 30)

function CreateCS16Button(x, y, parent, size_mul, text, text_pos, func_click, func_dclick, func_hover)
	local button = vgui.Create("DButton", parent)
	local bw = ui_button_w * size_mul
	local bh = ui_button_h * size_mul
	button:SetSize(bw, bh)
	button:SetPos(x, y)
	button:SetText("")

	local text_info = {
		text = text,
		--pos = {0, 0},
		pos = {bw / 2, bh / 2},
		font = "cs_menu_start_4",
		color = cs16_main_color,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER
	}
	
	if text_pos == TEXT_ALIGN_LEFT then
		text_info.xalign = text_pos
		text_info.pos = {12 * size_mul, bh / 2}

	elseif text_pos == TEXT_ALIGN_RIGHT then
		text_info.xalign = text_pos
		text_info.pos = {bw - (12 * size_mul), bh / 2}
	end
	
	local hovered = false
	button.Think = function(self)
		if func_hover == nil then return end
		if self:IsHovered() then
			if !hovered then
				hovered = true
				func_hover(self)
			end
		else
			hovered = false
		end
	end

	button.Paint = function(self, w, h)
		local bgcolor = Color(15, 15, 15, 200)
		if self:IsHovered() then
			bgcolor = ui_button_hovered_color
		end
		draw.RoundedBox(0, 0, 0, w, h, bgcolor)
		surface.SetDrawColor(cs16_main_color.r, cs16_main_color.g, cs16_main_color.b, 25)
		surface.DrawLine(0, 0, w, 0)
		surface.DrawLine(0, 0, 0, h)
		surface.DrawLine(w-1, 0, w-1, h)
		surface.DrawLine(0, h-1, w, h-1)

		draw.Text(text_info)
	end
	if func_click then
		button.DoClick = function(self)
			func_click(self)
		end
	end
	if func_dclick then
		button.DoDoubleClick = function(self)
			func_dclick(self)
		end
	end
	return button
end

current_start_menu = "server_info"
firststartmenu = false
pressed_bind = nil


function CreateStartMenu()
    if IsValid(startmenu_frame) then
        startmenu_frame:Remove()
    end

	local client = LocalPlayer()

    local our_team = nil
    if force_model_team then
        our_team = force_model_team
    elseif client.CS16Team then
        our_team = client:CS16Team()
    end

	local scrw = ScrW()
	local scrh = ScrH()
	local size_mul = math.Clamp(scrh / 1080, 0.5, 1.2)

    local start_menu_w = scrw * 0.7
    local start_menu_h = scrh * 0.9
    local bg_color = Color(15, 15, 15, 220)

    local font_info = {
        font = "Verdana",
        extended = false,
        size = 18 * size_mul,
        weight = 700,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    }

    surface.CreateFont("cs_menu_start_2", font_info)
    font_info.size = 38 * size_mul
    font_info.weight = 700
    surface.CreateFont("cs_menu_start_1", font_info)
    font_info.size = 20 * size_mul
    font_info.weight = 700
    surface.CreateFont("cs_menu_start_4", font_info)
    font_info.size = 36 * size_mul
    font_info.weight = 0
    font_info.font = "Arial"
    surface.CreateFont("cs_menu_start_3", font_info)


    startmenu_frame = vgui.Create("DFrame")
    startmenu_frame:SetSize(start_menu_w, start_menu_h)
    startmenu_frame:Center()
    startmenu_frame:SetTitle("")
    startmenu_frame:SetDraggable(false)
    startmenu_frame:ShowCloseButton(false)
    startmenu_frame.Paint = function(self, w, h) end
    startmenu_frame.Think = function(self)
        if input.IsKeyDown(KEY_ESCAPE) then
			self:KillFocus()
			self:Remove()
			gui.HideGameUI()
        end
    end
    
    local up_panel_size = start_menu_h / 8
    local down_panel_size = start_menu_h - up_panel_size - 2

    local up_menu = vgui.Create("DPanel", startmenu_frame)
    up_menu:SetSize(start_menu_w, up_panel_size)
    up_menu:SetPos(0, 0)
    up_menu.DefaultPaint = function(self, w, h)
        draw.RoundedBoxEx(18, 0, 0, w, h, bg_color, true, true, false, false)
    end
    up_menu.Paint = up_menu.DefaultPaint

    local down_menu = vgui.Create("DPanel", startmenu_frame)
    down_menu:SetSize(start_menu_w, down_panel_size)
    down_menu:SetPos(0, up_panel_size + 2)
    down_menu.DefaultPaint = function(self, w, h)
        draw.RoundedBoxEx(18, 0, 0, w, h, bg_color, false, false, true, true)
    end
    down_menu.Paint = down_menu.DefaultPaint

    function startmenu_frame.func_open_select_model()
        current_start_menu = "select_model"
        start_menus[current_start_menu].func(up_menu, down_menu)
    end

    local down_main_content_w = start_menu_w * 0.8
    local down_main_content_x = (start_menu_w - down_main_content_w) / 2
    local down_main_content_y = 94 * size_mul

    start_menus = {
        server_info = {
            func = function(up_menu, down_menu)
            for k,v in pairs(down_menu:GetChildren()) do
                v:Remove()
            end

            up_menu.Paint = function(self, w, h)
                up_menu.DefaultPaint(self, w, h)
                
                draw.Text({
                    text = GetHostName(),
                    pos = {128 * size_mul, h / 2},
                    font = "cs_menu_start_1",
                    color = cs16_main_color,
                    xalign = TEXT_ALIGN_LEFT,
                    yalign = TEXT_ALIGN_CENTER
                })
            end
            
            down_menu.Paint = function(self, w, h)
                down_menu.DefaultPaint(self, w, h)
            end

            -- uncomment to enable enter closing the menu
            /*
            up_menu.Think = function(self)
                if input.LookupBinding("+attack", false) == "ENTER" and input.IsKeyDown(KEY_ENTER) then
                    func_open_select_teams(up_menu, down_menu)
                    return
                end
            end
            */

            local text_info = {
                font = "cs_menu_start_2",
                color = cs16_main_color,
                xalign = TEXT_ALIGN_LEFT,
                yalign = TEXT_ALIGN_TOP
            }

            local sm8 = 8 * size_mul
            local sm16 = 16 * size_mul
            local sm24 = 24 * size_mul
            local last_y = sm8
            local text_size = 19 * size_mul
            local texts = {
                cs16_main_color,
                {"You are playing Counter-Strike v1.6", 0},
                {"Made by Kanade", 0},
                {"Visit the official CS web site @", 0},
                {"www.counter-strike.net", 0},
                {false, 0}, -- website link
                true,
                cs16_main_color,
                {"Use the line below in your console (~) to apply optimal voice-chat settings", 0},
                color_white,
                {"voice_maxgain 4", 0},
                true,
                cs16_main_color,
                {"Server rules:", 0},
                color_white,
                {" - Speak english only", 0},
                {" - Don't do annoying shit or rdm others", 0},
                {" - Have fun", 0},

            }
            for i,v in ipairs(texts) do
                if IsColor(v) then
                    continue
                end
                if istable(v) then
                    v[2] = last_y
                end
                last_y = last_y + text_size
            end

            local margin = 6 * size_mul

            local text_content_h = down_panel_size * 0.6

            local text_content_bg = vgui.Create("DPanel", down_menu)
            text_content_bg:SetSize(down_main_content_w, text_content_h)
            text_content_bg:SetPos(down_main_content_x, down_main_content_y)

            local text_content = vgui.Create("RichText", text_content_bg)
            text_content:Dock(FILL)
            text_content:DockMargin(margin, margin, margin, margin)
            
            for k,v in pairs(texts) do
                if IsColor(v) then
                    text_content:InsertColorChange(v.r, v.g, v.b, v.a)
                    continue
                end
                if istable(v) and isstring(v[1]) then
                    text_content:AppendText(v[1].."\n")
                else
                    text_content:AppendText("\n")
                end
            end
            
            text_content_bg.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
            end

            function text_content.web()
                text_content.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(45, 45, 45, 255))

                    draw.Text({
                        text = "-113",
                        pos = {sm24, sm24},
                        font = "cs_menu_start_3",
                        color = color_white,
                        xalign = TEXT_ALIGN_LEFT,
                        yalign = TEXT_ALIGN_TOP
                    })
                end
            end

            function text_content:PerformLayout()
                self:SetFontInternal("cs_menu_start_2")
            end

            for k,v in pairs(texts) do
                if istable(v) and v[1] == false then
                    local website_link = vgui.Create("DButton", text_content)
                    website_link:SetSize(down_main_content_w, text_size * 1.5)
                    website_link:SetPos(margin - (3 * size_mul), v[2])
                    website_link:SetText("")
                    website_link.double_clicked = false
                    website_link.next_web = 0
                    website_link.Think = function(self)
                        if self.double_clicked and self.next_web < CurTime() then
                            texts = {}
                            website_link.Paint = function() end
                            text_content.web()
                        end
                    end
                    website_link.DoDoubleClick = function(self)
                        if !self.double_clicked then
                            self.next_web = CurTime() + 1.5
                            self.double_clicked = true
                        end
                    end
                    local link_text = "Visit www.Counter-Strike.net"
                    website_link.Paint = function(self, w, h)
                        draw.Text({
                            text = link_text,
                            pos = {0, 0},
                            font = "cs_menu_start_2",
                            color = color_white,
                            xalign = TEXT_ALIGN_LEFT,
                            yalign = TEXT_ALIGN_TOP
                        })
                        if self:IsHovered() then
                            surface.SetDrawColor(255, 255, 255, 255)
                            surface.DrawLine(sm8, sm16, surface.GetTextSize(link_text) + sm8, sm16)
                        end
                    end
                end
            end

            CreateCS16Button(down_main_content_x, text_content_h + ((ui_button_h * 2.5) * size_mul), down_menu, size_mul, "PLAY", TEXT_ALIGN_CENTER, function()
                startmenu_frame:Remove()
            end)
        end}
    }

    start_menus[current_start_menu].func(up_menu, down_menu)

    startmenu_frame:MakePopup()
end

concommand.Add("chooseteam", function()
    current_start_menu = "server_info"
    CreateStartMenu()
end)
