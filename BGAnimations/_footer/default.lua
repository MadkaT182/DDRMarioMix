local t = Def.ActorFrame {};

t[#t+1] = Def.Quad {
	Name= "footer",
	InitCommand= function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM-36)
		self:SetWidth(SCREEN_WIDTH)
		self:SetHeight(72)
		self:diffuse(color("#000000"))
		self:diffusealpha(0.5)
	end
};

return t;