--
--                                  @*x/||x8
--                                   %8%n&v]`Ic
--                                     *)   }``W
--                                     *>&  1``n
--                                  &@ tI1/^`"@
--                                 &11\]"``^v
--                                M"`````,[&@@@@@
--                            &#cv(`:[/];"`````^r%
--                        @z);^`^;}"~}"........;&
--                 @WM##n~;+"`^^^.<[}}+,`'''`:tB
--                 #*xj<;).`i"``"l}}}}}}}%@B
--                 j^'..`+..,}}}}}}}}}}}(
--                  /,'.'...I}}}}}}}}}}}r
--                    @Muj/x*c"`'';}}}}}n
--                           !..'!}}}}}}x
--                          r`^;[}}}}}}}t                        @|M
--                         8{}}}}}}}}}}}{&                       B?>|@
--                         \}}}}}}}}}}}}})W                      x}?'<
--                        v}}}}}}}}}}}}}}}}/v#&%B  @@          Bj}}:.`
--                        :,}}}}}}}}}}}}}}}}}}}}}}}{{{1)(|/jnzr{}+"..-
--                        :.;}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}]l,;_c
--                        (.:}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}t
--                      &r_^']}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}+*
--                   Mt-I,,,^`[}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"W
--               *\+;,,,,,,,,",}}}}}}}}}}}]??]]}}}}}}}}}}}}}}}]""*
--             c;,,,,:;+{rW8BBB!+}}}}}}}}}>,:;!}}}}}}}}}}}}-"^`"l\%
--             W:,,,?@         n'+}}}}}}}?:,,,:[}}}}}}}}}}}:.,,,+|f@
--              /,,,i8          ,"}}}}}}|vnrrrrt}}}}}}}}}}}"`,,,:1|\v@
--               xI,,;rB%%B     [:}}}}{u        c(}}}}}}}}},`,,,,;}||/8
--                @fl]trrrrr    *}}}}}t           &vf(}}}}}]`:,,,,,?||t
--                  @*rrrrrx    *}}}}})@              &/}}}}-nxj\{[)|||xc#
--                     Mrrrv    v}}}}}c                 u}}}}}}r   8t|||||8
--                      8nr*    x}}}}n                   j}}}}}v    Bj|||?t
--                        &B    r}}}\                    %}}}}>%     &_]}:u
--                              j}}}z                    _"~l`1    Bx<,,,;B
--                              njxt@                @z}"....!   z[;;;;:;}
--                           %MvnnnnM               *~"^^^``iB  B*xrrrffrrB
--                         Wunnnnnnn*             &cnnnnnnnv   @*z*****zz#
--                        &MWWWWWWMWB            WMWWWWWWMWB
------------------------------------------------------------------------------------------------------
-- AUTHOR: Badonn the Deer
-- LICENSE: MIT
-- REFERENCES: N/A
-- Did this code help you write your own mod? Consider donating to me at https://ko-fi.com/badonnthedeer!
-- I'm in financial need and every little bit helps!!
--
-- Have a problem or question? Reach me on Discord: badonn
------------------------------------------------------------------------------------------------------

local SafehouseHighlight = {};

-- C:\Program Files (x86)\Steam\steamapps\workshop\content\108600\

-- C:\Users\[user]\Zomboid\mods
-- C:\Users\[user]\Zomboid\Logs

SafehouseHighlight.highlighted = false;

SafehouseHighlight.getSafeHouseByLocation = function(objX, objY)
    local safehouseList = SafeHouse.getSafehouseList()
    for i= 0, safehouseList:size() - 1
    do
        local safehouse = safehouseList:get(i);
        if (objX >= safehouse:getX() and objX < safehouse:getX2() and objY >= safehouse:getY() and objY < safehouse:getY2())
        then
            return safehouse
        end
    end
    return nil
end


SafehouseHighlight.playerPartOfSafehouse = function(player, safehouse)
    local playerObj = getSpecificPlayer(player);
    if playerObj ~= nil
    then
        local playerSafehouse = safehouse:alreadyHaveSafehouse(playerObj);
        if playerSafehouse ~= nil
        then
            if playerSafehouse == safehouse
            then
                return true
            end
        end
        return false
    end
end


SafehouseHighlight.toggle = function(player, safehouse)
    SafehouseHighlight.highlighted = not SafehouseHighlight.highlighted;
    if SafehouseHighlight.playerPartOfSafehouse(player, safehouse)
    then
        for x = safehouse:getX(), safehouse:getX2() -1 do
            for y = safehouse:getY(), safehouse:getY2() -1 do
                local square = getCell():getGridSquare(x, y, 0)
                if square ~= nil
                then
                    square:getFloor():setHighlighted(SafehouseHighlight.highlighted, false);
                end
            end
        end
    end
end


SafehouseHighlight.addContextOption = function(player, context, worldobjects, test)
    for _,x in ipairs(worldobjects)
    do
        local square = x:getSquare();
        local highlighted;
        if square ~= nil then
            local safehouse = SafehouseHighlight.getSafeHouseByLocation(square:getX(), square:getY())
            if safehouse ~= nil
            then
                highlighted = x:isHighlighted();
                context:addOptionOnTop(getText("ContextMenu_SM_ToggleSafehouseHighlight"), player,  function() SafehouseHighlight.toggle(player, safehouse) end);
                break
            end
        end
    end
end


Events.OnFillWorldObjectContextMenu.Add(SafehouseHighlight.addContextOption);