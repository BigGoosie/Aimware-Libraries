local Render = {};
Render.Outline = function(X, Y, Width, Height, Colour) 
	draw.Color(Colour);
	draw.OutlinedRect(X, Y, X + Width, Y + Height);
end
Render.OutlineRounded = function(X, Y, Width, Height, Radius, Rounding, Colour)
	draw.Color(Colour);
	draw.RoundedRect(X, Y, X + Width, Y + Height, Radius, Rounding[1], Rounding[2], Rounding[3], Rounding[4]);
end

Render.Rectangle = function(X, Y, Width, Height, Colour)
    if (Colour == nil) then Colour = {255, 255, 255, 255}; end

	draw.Color(Colour[1], Colour[2], Colour[3], Colour[4]);
	draw.FilledRect(X, Y, X + Width, Y + Height);
end
Render.RectangleShadow = function(X, Y, Width, Height, Radius, Colour)
    if (Colour == nil) then Colour = {255, 255, 255, 255}; end

	draw.Color(Colour[1], Colour[2], Colour[3], Colour[4]);
	draw.ShadowRect(X, Y, X + Width, Y + Height, Radius);
end
Render.RectangleRounded = function(X, Y, Width, Height, Radius, Rounding, Colour)
    if (Rounding == nil) then Rounding = {5, 5, 5, 5}; end
    if (Colour == nil) then Colour = {255, 255, 255, 255}; end

	draw.Color(Colour[1], Colour[2], Colour[3], Colour[4]);
    draw.RoundedRectFill(X, Y, X + Width, Y + Height, Radius, Rounding[1], Rounding[2], Rounding[3], Rounding[4]);
end

Render.Gradient = function(X, Y, Width, Height, Vertical, ColourStarting, ColourEnding)
	local R, G, B = ColourEnding[1], ColourEnding[2], ColourEnding[3];
	Render.Rectangle(X, Y, Width, Height, ColourStarting);

	if (Vertical == true) then
		for Index = 1, Height do
			local A = Index / Height * 255;
			Render.Rectangle(X, Y + Index, Width, 1, { R, G, B, A });
		end
	else 
		for Index = 1, Width do
			local A = Index / Width * 255;
			Render.Rectangle(X + Index, Y, 1, Height, { R, G, B, A });
		end
	end
end

Render.String = function(X, Y, String, Shadow, Centered, Colour, Font)
    local DrawingFONT = Font;
    local StringSIZE = draw.GetTextSize(String);
    if (Font == nil or DrawingFONT == nil) then DrawingFONT = draw.CreateFont("verdana.ttf", 15, 100); end
    if (Shadow == nil) then Shadow = false; end if (Centered == nil) then Centered = false; end
    if (Colour == nil) then Colour = { 255, 255, 255, 255 }; end
 
    draw.Color(Colour[1], Colour[2], Colour[3], Colour[4]);
    draw.SetFont(DrawingFONT);

    if (Shadow == true and Centered == true) then
        draw.TextShadow(X - (StringSIZE / 2), Y, String);
    end
    if (Shadow == true and Centered == false) then
        draw.TextShadow(X, Y, String); 
    end
    if (Shadow == false and Centered == true) then
        draw.Text(X - (StringSIZE / 2), Y, String); 
    end
    if (Shadow == false and Centered == false) then
        draw.Text(X, Y, String);
    end
end

local Watermark = {
    Title = "Superman's Drawing Library";

    Size = "Dynamic"; -- "Dynamic" is used for making it near the string size; For static you can set the value like 150;
    Font = draw.CreateFont("Verdana", 15, 100);
    Shadow = false;
    Rounded = true;

    Options = { ping = true, server = true };
};

local ScreenWIDTH, ScreenHEIGHT = draw.GetScreenSize();
local Watermark = function()
    if (Watermark.Size == "Dynamic") then
        local Localplayer = entities.GetLocalPlayer();
        local Ping = entities.GetPlayerResources():GetPropInt("m_iPing", Localplayer:GetIndex());
        local String = Watermark.Title;
        if (Watermark.Options["ping"] == true) then String = String .. " | Latency: " .. Ping; end
        if (Watermark.Options["server"] == true) then String = String .. " | Server: " .. engine.GetServerIP(); end

        if (Watermark.Rounded) then
            local StringSIZE = draw.GetTextSize(String);
            local X_Calc = ScreenWIDTH - (StringSIZE) - 5;

            Render.RectangleRounded(X_Calc, 5, StringSIZE + 3, 20, 5, {5, 5, 5, 5}, {15, 15, 15, 255});
            Render.String(X_Calc + 1, 10, String, Watermark.Shadow, false, {255, 255, 255, 255}, Watermark.Font);
        else
            local StringSIZE = draw.GetTextSize(String);
            local X_Calc = ScreenWIDTH - (StringSIZE) + 5;

            Render.Rectangle(X_Calc, 5, StringSIZE + 3, 20, {15, 15, 15, 255});
            Render.String(X_Calc + 1, 10, String, Watermark.Shadow, false, {255, 255, 255, 255}, Watermark.Font);
        end
    else 

    end
end
callbacks.Register("Draw", "Watermark", Watermark);