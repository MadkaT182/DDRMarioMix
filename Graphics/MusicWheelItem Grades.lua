local num = THEME:GetMetric("PlayerStageStats", "NumGradeTiersUsed")
local grades = {}
for i=1,num do grades[ "Grade_Tier"..string.format("%02d",i) ] = i-1 end
grades["Grade_Failed"] = num

local state = 0
return Def.Sprite{
    Texture=THEME:GetPathG("","MusicSelection/Grades"),
    OnCommand=function(s) s:animate(0) end,
    SetGradeCommand=function(s,param)
        state = grades[param.Grade] and (grades[param.Grade] > num and num or grades[param.Grade])
        s:setstate( state ~= nil and state-1 or 5 )
    end,
}