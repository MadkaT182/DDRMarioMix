local t = Def.ActorFrame{}

t[#t+1] = Def.ActorFrame{
    InitCommand=function(self) self:zoom(0):sleep(0.3) end,
	OnCommand=function(self)
		self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-150 )
		:bounceend( 0.2 ):zoom(1)
    end,
    OffCommand=function(self)
        self:sleep(0.2):bouncebegin(0.2):zoom(0)
    end,
	Def.Sprite{ Texture=THEME:GetPathG("","WarningBottom") },
	
	Def.Sprite{
		Texture=THEME:GetPathG("","WarningLabel"),
		OnCommand=function(self) self:y( -30 ) end
	},

	Def.BitmapText{
		Font="_sys1",
		Text="Slot A saving...",
		OnCommand=function(s) s:y( 24 ) end,
	},
}

t[#t+1] = Def.ActorFrame{
    InitCommand=function(self) self:zoom(0):sleep(0.3) end,
	OnCommand=function(self)
		self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y+150 )
		:sleep(0.2):bounceend( 0.2 ):zoom(1)
    end,
    OffCommand=function(self)
        self:bouncebegin(0.2):zoom(0)
    end,

	Def.Sprite{ Texture=THEME:GetPathG("","WarningBottom") },
	
	Def.Sprite{
		Texture=THEME:GetPathG("","WarningLabel"),
		OnCommand=function(self) self:y( -30 ) end
	},

	Def.BitmapText{
		Font="_sys1",
		Text="Do not close the game.",
		OnCommand=function(s) s:y( 24 ):wrapwidthpixels(240):zoom(0.8) end,
	},
}

t[#t+1] = Def.Actor {
	BeginCommand=function(self)
        if SCREENMAN:GetTopScreen():HaveProfileToSave() then
            self:sleep(2)
        end
		self:queuecommand("Load")
	end,
	LoadCommand=function() SCREENMAN:GetTopScreen():Continue() end
}

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT):diffuse( Alpha(Color.Black,1) ):linear(0.4):diffusealpha(0)
	end,
	OffCommand=function(s)
		s:sleep(0.6):linear(1):diffusealpha(1)
	end,
}

return t