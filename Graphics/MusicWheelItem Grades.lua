local num = THEME:GetMetric("PlayerStageStats", "NumGradeTiersUsed")
local grades = {}
for i=1,num do grades[ "Grade_Tier"..string.format("%02d",i) ] = i-1 end
grades["Grade_Failed"] = num

local state
return Def.Sprite{
    Texture=THEME:GetPathG("","MusicSelection/Grades"),
    OnCommand=function(s) s:animate(0) end,
    SetGradeCommand=function(s,param)
        state = grades[param.Grade]
        s:setstate( state ~= nil and state or 5 )
    end,
}