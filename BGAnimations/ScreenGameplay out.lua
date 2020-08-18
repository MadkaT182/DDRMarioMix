return Def.ActorFrame{
    OnCommand=function(s)
        s:sleep(3)
    end,

    Def.Sprite{
        Texture=THEME:GetPathG("","CloudNote"),
        StartTransitioningCommand=function(self)
            self:zoom( 60 ):diffuse(Color.Black):MaskSource()
            :xy( SCREEN_CENTER_X+130, SCREEN_CENTER_Y-340 ):sleep(0.8)
            :linear(0.2):zoom(0):xy( SCREEN_CENTER_X, SCREEN_CENTER_Y )
        end
    },
    
    Def.Quad{
        InitCommand=function(self)
            self:sleep(0.8):zoomto( SCREEN_WIDTH, SCREEN_HEIGHT ):diffuse(Color.Black)
            :align(0,0):MaskDest()
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("","Gameplay/Cleared"),
        StartTransitioningCommand=function(self)
            self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y )
            self:diffusealpha(0):sleep(1.4):diffusealpha(1)
        end
    }
}