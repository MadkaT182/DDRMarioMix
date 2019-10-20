local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{Texture="SongItem"}

t[#t+1] = Def.BitmapText{
    Font="_sys1",
    OnCommand=function(s)
        s:halign(0):xy(-130,-2):maxwidth(190):zoomy(1.1)
    end,
    SetMessageCommand=function(s,param)
        if param.Song then
            s:settext( param.Song:GetDisplayMainTitle() )
        end
    end,
}

return t;