local t = Def.ActorFrame {
	LoadActor("selector")..{
		InitCommand=function(s)
			s:xy(SCREEN_CENTER_X+170,SCREEN_CENTER_Y):addx( SCREEN_RIGHT/2 ):decelerate(0.6):addx( -SCREEN_RIGHT/2 )
		end,
		OffCommand=function(s) s:accelerate(0.6):addx( SCREEN_RIGHT/2 ) end
	};
}

t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		Texture=THEME:GetPathG("Global/Header","Under"),
		OnCommand=function(s) s:xy( 0,48 ):halign(0):zoom(1.1):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 ) end,
		OffCommand=function(s) s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end
	},
	
	Def.BitmapText{
		Font="_title",
		Text=THEME:GetString("ScreenSelectMusic","HeaderText"),
		OnCommand=function(s) s:xy( 23,43 ):halign(0):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 ) end,
		OffCommand=function(s) s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end
	},

	Def.ActorProxy{
		BeginCommand=function(s)
			if SCREENMAN:GetTopScreen() then
				s:SetTarget( SCREENMAN:GetTopScreen():GetChild("Banner") )
			end
			s:xy( 160,114 ):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 )
		end,
		OffCommand=function(s) s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end
	}
}

local buttonitems = {"ChooseSong","Mush","Difficulty","Song"}
local shownow = 1

t[#t+1] = Def.Actor{
	HideOrShowMessageCommand=function(s)
		shownow = shownow + 1
		if shownow > #buttonitems then shownow = 1 end
		MESSAGEMAN:Broadcast("HideRest")
	end,
};

local mtng = Def.ActorFrame{}
for i,v in ipairs(buttonitems) do
	mtng[#mtng+1] = Def.Sprite{
	Texture=THEME:GetPathG("Global/Button",v),
	OnCommand=function(s)
		s:y(0)
		s:diffusealpha( shownow == i and 1 or 0 )
		:sleep(3):queuemessage("HideOrShow")
	end,
	HideRestMessageCommand=function(s)
		s:stoptweening():linear(0.4):diffusealpha( shownow == i and 1 or 0 ):sleep(3):queuemessage("HideOrShow")
	end,
	}
end

t[#t+1] = Def.ActorFrame{
    OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+180):addy( SCREEN_RIGHT/2 ):decelerate(0.6):addy( -SCREEN_RIGHT/2 ) end,
    OffCommand=function(s) s:accelerate(0.6):addy(300) end,
    Def.Quad{
        OnCommand=function(s) s:zoomto(SCREEN_WIDTH,100):y(30):diffuse( color("#00000099") ) end
	},
	mtng
};

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT):diffuse( Alpha(Color.Black,0) )
	end,
	OffCommand=function(s) s:sleep(0.6):linear(1):diffusealpha(1) end,
}


return t;