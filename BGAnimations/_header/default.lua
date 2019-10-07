local t = Def.ActorFrame {};

t[#t+1] = Def.Quad {
	Name= "fix",
	InitCommand= function(self)
		self:xy(SCREEN_LEFT+14,SCREEN_TOP+48)
		self:SetWidth(28)
		self:SetHeight(8)
		self:diffuse(color("#FFFFFF"))
	end
};

t[#t+1] = LoadActor("bg")..{
	OnCommand=cmd(x,SCREEN_LEFT+180;y,SCREEN_TOP+48);
};

return t;