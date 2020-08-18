local sPlayer = Var "Player"

local TNSFrames = {
	TapNoteScore_W1 = 0,
	TapNoteScore_W2 = 1,
	TapNoteScore_W3 = 2,
	TapNoteScore_W4 = 3,
	TapNoteScore_W5 = 4,
	TapNoteScore_Miss = 5
}

return Def.ActorFrame {
    -- InitCommand=function(self) self:visible(false) end,
	Def.Sprite{
		Name="Judgment",
		Texture="Judgment Normal",
		InitCommand=function(self) self:pause() end,
        OnCommand=function(self) self:xy( 13, 29 ) end,
        ResetCommand=function(self) self:finishtweening():stopeffect():visible(false) end
	},
    JudgmentMessageCommand=function(self, params)
        if params.Player ~= sPlayer then return end
		if params.HoldNoteScore then return end
        if string.find(params.TapNoteScore, "Mine") then return end
        
        local Judg = self:GetChild("Judgment")
        self:playcommand("Reset")
        
        Judg:visible(true)
        Judg:setstate( TNSFrames[params.TapNoteScore]  )
		Judg:diffusealpha(1):zoom(.5):linear(.267):zoom(.4):sleep(.1):diffusealpha(0)
	end
}
