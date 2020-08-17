local t = Def.ActorFrame {}

t[#t+1] = Def.Sprite {
	BeginCommand=function(self)
		local Song = GAMESTATE:GetCurrentSong();
		self:LoadFromSongBanner(Song);
	end;
	OnCommand=function(self)
		self:scaletoclipped(278,100):xy(SCREEN_CENTER_X,113)
	end
}

local labels =  {
	"marvelous",
	"perfect",
	"great",
	"good",
	"miss"
}

for k,v in pairs( labels ) do
	t[#t+1] = LoadActor(THEME:GetPathG("eval",v))..{
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-48 + (30 * (k-1)))
		end
	}
end

t[#t+1] = LoadActor(THEME:GetPathG("score","label"))..{
	OnCommand=function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+107)
	end
}
t[#t+1] = LoadActor(THEME:GetPathG("maxcombo","label"))..{
	OnCommand=function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+142):zoom(.845)
	end
}

-- TODO: Remake this file completely.
t[#t+1] = LoadActor("Stats")

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT):diffuse( Alpha(Color.Black,0) )
	end,
	OffCommand=function(s)
		s:linear(1):diffusealpha(1)
	end,
}

return t