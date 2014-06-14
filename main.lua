------ Memory Check Function: Debugging Only

-- local function checkMemory()
--    collectgarbage( "collect" )
--    local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
--    print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
-- end
-- timer.performWithDelay( 3000, checkMemory, 0 )
-- Require the widget library
local widget = require( "widget" )
-- Use the iOS 7 theme for this sample
widget.setTheme( "widget_theme_ios7" )

------- Set App Broad Defaults
display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "fillColor", .145, .145, .145 )
display.setDefault( "anchorX", 0 )
display.setDefault( "anchorY", 0 )
system.activate( "multitouch" )


------- Forward References and Required Libraries
local widget = require( "widget" )
local appData = require ("data2013")
local tableView, scrollview
local buildInfoPanel, loadSelectedPhoto
local thePhoto

  

------- Find and Adjust for taller iPhone5
local deviceHeight = display.contentHeight
local iPhone5 = false

if (display.pixelHeight == 1136) then
	deviceHeight = 568
    iPhone5 = true
end

screen = 
{
    left = display.screenOriginX,
    top = display.screenOriginY + 40, -- account for tabbar
    right = display.contentWidth - display.screenOriginX,
    bottom = deviceHeight - display.screenOriginY
};

------- Shared Variables for Program FLow

local selectedYear, selectedPhoto


------- CREATE MAIN VIEWS (positon and add "touch traps" to prevent errant propogation)

local picture = display.newGroup()
local toolbar = display.newGroup()
local about = display.newGroup()

about = display.newGroup()
about.showY = 0
about.hideY = deviceHeight-30
about.showX = 0
about.hideX = display.contentWidth * -1


local info = display.newGroup()
info.showX = 0
info.hideX = display.contentWidth
info.name = "info"

local menu = display.newGroup()
menu.showX = 0
menu.hideX = display.contentWidth * -1
menu.name = "menu"


menu.x = menu.hideX
info.x = info.hideX
about.x = about.hideX

-- TOUCH TRAPS EVENTS
menu:addEventListener("touch", function() return true end)
menu:addEventListener("tap", function() return true end)

info:addEventListener("touch", function() return true end)
info:addEventListener("tap", function() return true end)

toolbar:addEventListener("touch", function() return true end)
toolbar:addEventListener("tap", function() return true end)

about:addEventListener("touch", function() return true end)
about:addEventListener("tap", function() return true end)

------- BUILD TOOLBAR
local tool1 = display.newGroup( )
local tool1Art = display.newImageRect("art_ui/iconmenu.png", 70, 70 )
local tool1Fill = display.newCircle( 2, 2, 33 )
tool1Fill.alpha = .7
tool1:insert( tool1Fill )
tool1:insert( tool1Art )
toolbar:insert(tool1)
tool1.x = screen.left+20
tool1.link = menu
tool1.name = "menu"


local tool2 = display.newGroup( )
local tool2Art = display.newImageRect("art_ui/iconshare.png", 70, 70 )
local tool2Fill = display.newCircle( 2, 2, 33 )
tool2Fill.alpha = .7
tool2:insert( tool2Fill )
tool2:insert( tool2Art )
toolbar:insert(tool2)
tool2.x = display.contentWidth*0.5 - (tool2.width*0.5)
tool2.link = screenshot
tool2.name = "screenshot"


local tool3 = display.newGroup( )
local tool3Art = display.newImageRect("art_ui/iconmore.png", 70, 70 )
local tool3Fill = display.newCircle( 2, 2, 33 )
tool3Fill.alpha = .7
tool3:insert( tool3Fill )
tool3:insert( tool3Art )
toolbar:insert(tool3)
tool3.x = (screen.right - tool3.width)-20
tool3.link = info
tool3.name = "info"


toolbar.y = screen.bottom

-----add sidewall swipe buttons
local swipeMenuBtn = display.newRect( 0, screen.top, 20, deviceHeight )
swipeMenuBtn.name = "menu"
swipeMenuBtn.isVisible = true
swipeMenuBtn.isHitTestable = true

local swipeInfoBtn = display.newRect( screen.right-20, screen.top, 20, deviceHeight )
swipeInfoBtn.name = "info"
swipeInfoBtn.isVisible = true
swipeInfoBtn.isHitTestable = true


------- START UTILITY FUNCTIONS
local function manageAboutPage(buttonName)
    if (menu.x == menu.hideX or buttonName == "info") then
        transition.moveTo( about, { x=about.showX, time=300, transition=easing.inQuad  } )
    end
    if (menu.x == menu.showX or buttonName == "info") then
        transition.moveTo( about, { x=about.hideX, time=300, transition=easing.inQuad  } )
    end
        print(menu.x, menu.showX, menu.hideX)

end



local function onObjectHide( self, event )
        transition.moveTo( self, { x=self.hideX, time=300, transition=easing.inQuad  } )
    return true
end

local function onObjectShow( self, event )
        local clickedButton = self.name
        manageAboutPage(clickedButton)
        transition.moveTo( self.link, { x=self.link.showX, time=300, transition=easing.inQuad  } )
        transition.to( toolbar, { y=screen.bottom, alpha=0, time=300, transition=easing.inQuad  } )

    return true
end

local function onShowTools( self, event )
        transition.to( toolbar, { y=screen.bottom - (toolbar.height*1.5), time=700, transition=easing.outBack } )
        transition.to( toolbar, { alpha=1, time=200, delay=100, transition=easing.inQuad } )
    return true
end

local function onSwipeScreen( self, event )
    local swipeThreshold = 100
    if ( event.phase == "ended") then
        print (event.x .. startX)
    end

    local startX = event.x
    print (self.name)
    

    if ( event.phase == "ended") then
        print (event.x .. startX)
    end



-- if (self.target.name == "menu") then
--         transition.moveTo( info, { x=info.hideX, time=300, transition=easing.inQuad } )
--         transition.moveTo( menu, { x=menu.showX, time=500, transition=easing.inQuad } )
--         transition.moveTo( about, { x=about.showX, time=500, transition=easing.inQuad } )
--         transition.to( toolbar, { y=screen.bottom, alpha=0, time=100} )
-- end

-- if (self.target.name == "info") then
--         transition.moveTo( menu, { x=menu.hideX, time=300, transition=easing.inQuad } )
--         transition.moveTo( about, { x=about.hideX, time=300, transition=easing.inQuad } )
--         transition.moveTo( info, { x=info.showX, time=500, transition=easing.inQuad } )
-- end

    return true
end


local function launchWebsite (event)
    if (event.target.name == "about-us") then
     system.openURL( "http://scienceinsociety.northwestern.edu/" )
    end
    return true
end



------- BUILD TABLEVIEW FOR MENU FROM SPECIFIC YEAR
local function buildMenu( galleryData )
    -- Handle row rendering
    local function onRowRender( event )
        local phase = event.phase
        local row = event.row
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth
        -- Add icon
         local iconData = galleryData[row.index]
         rowIcon = display.newImage( row, iconData.icon, iconData.w, iconData.h )
         rowIcon.anchorX = 0
         rowIcon.x = 20
         rowIcon.y = rowHeight*.05
    end
    -- Handle touches on the row
    local function onRowTouch( event )
        local phase = event.phase

        if "press" == phase then
            display.getCurrentStage():setFocus( tableview )
        end

        if "release" == phase then
            onObjectHide(menu)
            onObjectShow(tool3)
            display.getCurrentStage():setFocus( nil )
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--need to refactor group memory cleaners into single function
            for j = 1, info.numChildren do   
                info[1]:removeSelf();       
            end

            for k = 1, picture.numChildren do   
               picture[1]:removeSelf();       
            end
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            selectedPhoto = galleryData[event.target.index]
            loadSelectedPhoto(selectedPhoto)
            buildInfoPanel(selectedPhoto)
        end
    end

-- Generate the table view
    tableView = widget.newTableView
    {
        top = screen.top,
        left = screen.left,
        width = screen.right-screen.left, 
        height = (screen.bottom-screen.top)-30,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        hideScrollBar = false,
        hideBackground = false,
        noLines = false,
        backgroundColor = {.145, .145, .145, 1},
    }

-- Create galleryNav
    for i = 1, #galleryData do
        local rowHeight = 80
        local rowColor = { default={ 1, 1, 1, 0}, over={ .901, .878, .792, 0.2 } }
        local lineColor = {.07, .06, 0}
        -- Insert the row into the tableView
        tableView:insertRow
        {
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = lineColor,
        }
        menu:insert(tableView)
    end 
end

-- Custom table view cleaner
local function cleanTableView()
    tableView:deleteAllRows( )
    display.remove( tableView )
    tableView = nil
end


-- button bar for selectedYear

local function presentmenu( onbtn )
    menu.sel10.alpha,  menu.sel11.alpha,  menu.sel12.alpha,  menu.sel13.alpha = 0
    transition.to( onbtn, { alpha=1, time=300 } )
end

local function get13( ... )
    selectedYear = appData.gallery13
    presentmenu(menu.sel13)
    cleanTableView()
    buildMenu(selectedYear)
end

local function get12( ... )
    selectedYear = appData.gallery12
    presentmenu(menu.sel12)
    cleanTableView()
    buildMenu(selectedYear)
end

local function get11( ... )
    selectedYear = appData.gallery11
    presentmenu(menu.sel11)
    cleanTableView()
    buildMenu(selectedYear)
end

local function get10( event )
    selectedYear = appData.gallery10
    presentmenu(menu.sel10)
    cleanTableView()
    buildMenu(selectedYear)
end



local btn10=display.newImageRect (menu, "art_ui/off2010.png", 80, 40 )
local sel10=display.newImageRect (menu, "art_ui/on2010.png", 80, 40 )
menu.sel10 = sel10
menu.sel10.alpha=0
btn10.x, sel10.x=screen.left,screen.left

local btn11=display.newImageRect (menu, "art_ui/off2011.png", 80, 40 )
local sel11=display.newImageRect (menu, "art_ui/on2011.png", 80, 40 )
menu.sel11 = sel11
sel11.alpha=0
btn11.x,sel11.x = screen.left+(btn11.width),screen.left+(sel11.width)

local btn12=display.newImageRect (menu, "art_ui/off2012.png", 80, 40 )
local sel12=display.newImageRect (menu, "art_ui/on2012.png", 80, 40 )
menu.sel12 = sel12
sel12.alpha=0

btn12.x,sel12.x = screen.left+(btn12.width*2),screen.left+(sel12.width*2)

local btn13=display.newImageRect (menu, "art_ui/off2013.png", 80, 40 )
local sel13=display.newImageRect (menu, "art_ui/on2013.png", 80, 40 )
menu.sel13 = sel13
sel13.alpha=0

btn13.x,sel13.x = screen.left+(btn13.width*3),screen.left+(sel13.width*3)


btn10:addEventListener("tap",get10 )
btn11:addEventListener("tap",get11 )
btn12:addEventListener("tap",get12 )
btn13:addEventListener("tap",get13 )
------- BUILD SCROLLVIEW FOR INFO VIEW


-- Our ScrollView listener
local function scrollListener( event )
    local phase = event.phase
    local direction = event.direction
    
    if "began" == phase then
        --print( "Began" )
    elseif "moved" == phase then
        --print( "Moved" )
    elseif "ended" == phase then
        --print( "Ended" )
    end
    
    -- If the scrollView has reached it's scroll limit
    if event.limitReached then
        if "up" == direction then
            --print( "Reached Top Limit" )
        elseif "down" == direction then
            --print( "Reached Bottom Limit" )
        elseif "left" == direction then
           -- print( "Reached Left Limit" )
        elseif "right" == direction then
           -- print( "Reached Right Limit" )
        end
    end
            
    return true
end


-- Our Custom function to crop new art into the scrollview
buildInfoPanel = function(currentPhoto) 

    -- Create the ScrollView
    local maskfix = 50

    scrollView = widget.newScrollView
    {

        top = 0,
        left = 0,
        width = display.contentWidth,
        height = deviceHeight,
        topPadding = currentPhoto.thmH + 20,
        bottomPadding = 30,
        hideBackground = true,
        horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
        listener = scrollListener,
    }

    --build up the graphics

    local bkgd = display.newRect( info, 0, 0, display.contentWidth, deviceHeight )
    bkgd:setFillColor( .145,.145,.145 )

    local thumb = display.newImageRect(info, currentPhoto.image, 320, currentPhoto.thmH)
   

    local infotext = display.newImageRect(currentPhoto.text, currentPhoto.txtW, currentPhoto.txtH)
    
        scrollView:insert( infotext )
        info:insert(scrollView)

    local mask = graphics.newMask( "art_ui/thumbmask.png")

    scrollView:setMask (mask)

        if (not iPhone5 ) then
                scrollView.maskY = currentPhoto.thmH-50
            else
                scrollView.maskY = currentPhoto.thmH-100
            end
    
    local fade = display.newImageRect(info, "art_ui/infofade.png", 320, 27)
    fade.y=screen.bottom-27
end
------ END SCROLLVIEW


--------- PINCH ZOOM DETAIL VIEW

loadSelectedPhoto = function(thePhoto)


-- START DETAIL PINCH ZOOM ----------------------------------------------------------------
local photo = display.newImageRect(picture, thePhoto.image, thePhoto.imgW, thePhoto.imgH )
picture.xScale, picture.yScale, picture.x, picture.y = 1, 1, 0, 0


local scaleAdjust =(deviceHeight/thePhoto.imgH )
picture.xScale, picture.yScale = scaleAdjust, scaleAdjust
picture.x = thePhoto.imgX * -1

 
local function calculateDelta( previousTouches, event )
 
        local id,touch = next( previousTouches )
        if event.id == id then
                id,touch = next( previousTouches, id )
                assert( id ~= event.id )
        end
 
        local dx = touch.x - event.x
        local dy = touch.y - event.y
        return dx, dy
        
end
 
local function calculateCenter( previousTouches, event )
 
        local id,touch = next( previousTouches )
        if event.id == id then
                id,touch = next( previousTouches, id )
                assert( id ~= event.id )
        end
 
        local cx = math.floor( ( touch.x + event.x ) * 0.5 )
        local cy = math.floor( ( touch.y + event.y ) * 0.5 )
        return cx, cy
    
end



-- create a table listener object for the bkgd image
function picture:touch( event )
 
        local phase = event.phase
        local eventTime = event.time
        local previousTouches = self.previousTouches
        
        if not self.xScaleStart then
                self.xScaleStart, self.yScaleStart = self.xScale, self.yScale
        end
 
        local numTotalTouches = 1
        if previousTouches then
                -- add in total from previousTouches, subtract one if event is already in the array
                numTotalTouches = numTotalTouches + self.numPreviousTouches
                if previousTouches[event.id] then
                        numTotalTouches = numTotalTouches - 1
                end
        end
 
        if "began" == phase then
                -- Very first "began" event
                if not self.isFocus then
                        -- Subsequent touch events will target button even if they are outside the contentBounds of button
                        display.getCurrentStage():setFocus( self )
                        self.isFocus = true
                        
                        -- Store initial position
                        self.x0 = event.x - self.x
                        self.y0 = event.y - self.y
 
                        previousTouches = {}
                        self.previousTouches = previousTouches
                        self.numPreviousTouches = 0
                        self.firstTouch = event
                        
                elseif not self.distance then
                        local dx,dy
                        local cx,cy
 
                        if previousTouches and numTotalTouches >= 2 then
                                dx,dy = calculateDelta( previousTouches, event )
                                cx,cy = calculateCenter( previousTouches, event )
                        end
 
                        -- initialize to distance between two touches FIXXX
                        if dx and dy then
                                local d = math.sqrt( dx*dx + dy*dy )
                                if d > 0 then
                                        self.distance = d
                                        self.xScaleOriginal = self.xScale

                                        self.yScaleOriginal = self.yScale
                                        
                                        self.x0 = cx - self.x
                                        self.y0 = cy - self.y
                        
                                end
                        end
                        
                end
 
                if not previousTouches[event.id] then
                        self.numPreviousTouches = self.numPreviousTouches + 1
                end
                previousTouches[event.id] = event
 
        elseif self.isFocus then
                if "moved" == phase then
                    print(picture.x)
                        if self.distance then
                                local dx,dy
                                local cx,cy
                                if previousTouches and numTotalTouches == 2 then
                                        dx,dy = calculateDelta( previousTouches, event )
                                        cx,cy = calculateCenter( previousTouches, event )
                                end
 
                                if dx and dy then
                                        local newDistance = math.sqrt( dx*dx + dy*dy )
                                        local scale = newDistance / self.distance
 ---XXX tweaking scale minimum
 if ( scale > 0 and self.xScaleOriginal * scale <= 4 and self.xScaleOriginal * scale >= scaleAdjust) then
        self.xScale = self.xScaleOriginal * scale
        self.yScale = self.yScaleOriginal * scale
        
        self.x = cx - ( self.x0 * scale )
        if self.x > 0 then
                self.x = 0
        elseif (self.x + self.width * self.xScale) < display.contentWidth then
                self.x = display.contentWidth - self.width * self.xScale
        end
        
        self.y = cy - ( self.y0 * scale )
        if self.y > 0 then
                self.y = 0
        elseif (self.y + self.height * self.yScale) < display.contentHeight then
                self.y = display.contentHeight - self.height * self.yScale
        end
end
                                end
                        else
                                if event.id == self.firstTouch.id then
                                        -- don't move unless this is the first touch id.
                                        -- Make object move (we subtract self.x0, self.y0 so that moves are
                                        -- relative to initial grab point, rather than object "snapping").
self.x = event.x - self.x0
if self.x > 0 then
        self.x = 0
elseif (self.x + self.width * self.xScale) < display.contentWidth then
        self.x = display.contentWidth - self.width * self.xScale
end
 
self.y = event.y - self.y0
if self.y > 0 then
        self.y = 0
elseif (self.y + self.height * self.yScale) < deviceHeight then
        self.y = deviceHeight - self.height * self.yScale
end





                                end
                        end
                        
                        if event.id == self.firstTouch.id then
                                self.firstTouch = event
                        end
 
                        if not previousTouches[event.id] then
                                self.numPreviousTouches = self.numPreviousTouches + 1
                        end
                        previousTouches[event.id] = event
 
                elseif "ended" == phase or "cancelled" == phase then
                        --check for taps
                        local dx = math.abs( event.xStart - event.x )
                        local dy = math.abs( event.yStart - event.y )
                        if eventTime - previousTouches[event.id].time < 150 and dx < 10 and dy < 10 then
                               if not self.tapTime then
-- single tap call toolbar overlay here
                                     onShowTools()
                               end
                        end
                
                        --
                        if previousTouches[event.id] then
                                self.numPreviousTouches = self.numPreviousTouches - 1
                                previousTouches[event.id] = nil
                        end
 
                        if self.numPreviousTouches == 1 then
                                -- must be at least 2 touches remaining to pinch/zoom
                                self.distance = nil
                                -- reset initial position
                                local id,touch = next( previousTouches )
                                self.x0 = touch.x - self.x
                                self.y0 = touch.y - self.y
                                self.firstTouch = touch
 
                        elseif self.numPreviousTouches == 0 then
                                -- previousTouches is empty so no more fingers are touching the screen
                                -- Allow touch events to be sent normally to the objects they "hit"
                                display.getCurrentStage():setFocus( nil )
                                self.isFocus = false
                                self.distance = nil
                                self.xScaleOriginal = nil
                                self.yScaleOriginal = nil
 
                                -- reset array
                                self.previousTouches = nil
                                self.numPreviousTouches = nil
                        end
                end
        end
 
        return true
end
------- END DETAIL VIEW
end

------- END PINCH ZOOM

------- SCREENSHOT CODE
local function takeScreenShot( self, event )
    local forSale = selectedPhoto.buy
    print(forSale)
    --play shutter click and hide toolbar from screengrab
    local shutterSFX = audio.loadSound( "art_ui/click_sound.wav" )
    audio.play( shutterSFX )
    toolbar.alpha=0

    -- store and save the screengram
    local cap = display.captureScreen( true )
    local saveOptions = {
        filename = "BeautyOfScience.jpg",
        baseDir = system.TemporaryDirectory,
        isFullResolution = true,
        }
        display.save( cap, saveOptions)
        cap:removeSelf()
        cap = nil;
        saveOptions = nil

    -- Handler that gets notified when the alert closes
    local function alertComplete( event )
        if "clicked" == event.action then
            local i = event.index
            if 1 == i then
            -- Do nothing; dialog will simply dismiss
                 print ("cancel")

            elseif 3 == i then
                 system.openURL(forSale)
            elseif 2 == i then
             -- post to fbook
                print ("facebook")
                local canFB = native.canShowPopup("social", "facebook")

                native.showPopup( "social", {
                  service = "facebook",
                  message = "I'm getting a closer look at the hidden beauty in my world with Science in Society's Scientific Images Contest app.",
                  image = {
                      filename = "BeautyOfScience.jpg",
                      baseDir = system.TemporaryDirectory,
                  },
                   url = { 
                      "http://scienceinsociety.northwestern.edu",
                  }
                })
                end
            end
        end
   

    --alert success and turn toolbar back on
    toolbar.alpha=1

    if (forSale) then
        local alert = native.showAlert(  "huh", "The image was saved to your Camera Roll. Would you also like to share it on facebook", { "Cancel", "Share", "Buy A Print"}, alertComplete )
    else
        local alert = native.showAlert( "Success!", "The image was saved to your Camera Roll. Would you also like to share it on facebook", { "Cancel", "Share"}, alertComplete )
    end
end
---------



--assign event listeners
tool1.tap = onObjectShow
tool3.tap = onObjectShow
tool1:addEventListener( "tap", tool1 )
tool3:addEventListener( "tap", tool3 )
tool2.tap = takeScreenShot
tool2:addEventListener( "tap", tool2 )
info.tap = onObjectHide
info:addEventListener( "tap", info )
picture:addEventListener( "touch", picture )

--activate sidewall buttons to simulate drawer
swipeMenuBtn.touch = onSwipeScreen
swipeInfoBtn.touch = onSwipeScreen
swipeMenuBtn:addEventListener( "touch", swipeMenuBtn )
swipeInfoBtn:addEventListener( "touch", swipeInfoBtn )
swipeMenuBtn:addEventListener("tap", function() return true end)
swipeInfoBtn:addEventListener("tap", function() return true end)

------- BUILD ABOUT POPUP
local aboutbkgd = display.newRect( about, 0, 0, display.contentWidth, deviceHeight )
    aboutbkgd:setFillColor( .145,.145,.145 )

---adding about scrollview
local aboutscrollView = widget.newScrollView
    {
        top = 0,
        left = 0,
        width = display.contentWidth,
        height = deviceHeight-30,
        topPadding = 50,
        bottomPadding = 0,
        hideBackground = true,
        horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
        listener = scrollListener,
        name = aboutScroller,
    }

local abouttext = display.newImageRect("art_ui/abouttext.png", 320, 700 )

local aboutCTA = display.newRect( 20, 610, 280, 100 )
aboutCTA.name = "about-us"
aboutCTA:setFillColor( 255, 0, 0, .3 )

aboutCTA.isVisible = false
aboutCTA.isHitTestable = true
aboutCTA:addEventListener("tap",launchWebsite)


aboutscrollView:insert( abouttext )
aboutscrollView:insert( aboutCTA )
about:insert(aboutscrollView)

local abouttab = display.newImageRect(about, "art_ui/about.png", 320, 30 )
local aboutclose = display.newImageRect(about, "art_ui/iconclose.png", 30, 30 )
aboutclose.x = display.contentWidth - 30
aboutclose.alpha = 0
about.y = deviceHeight - 30

------ END about scrollview Add About popup listener functions
local function showAbout(event)

  transition.to( about, {time=500, y=about.showY, transition=easing.inoutQuad} )
  transition.to( aboutclose, {time=500, alpha=1} )
    return true
end

local function hideAbout(event)

  transition.to( about, {time=300, y=about.hideY, transition=easing.outQuad} )
  transition.to( aboutclose, {time=500, alpha=0} )
  aboutscrollView:scrollToPosition{y = 50, time = 10}
  return true
end



abouttab:addEventListener("tap", showAbout)
aboutclose:addEventListener("tap", hideAbout)






--- intro Animation
local function anim()



local intro = display.newGroup( )
--trap touches
intro:addEventListener("touch", function() return true end)
intro:addEventListener("tap", function() return true end)

--
local purpleFill = display.newRect( intro, 0, 0, display.contentWidth, deviceHeight )
purpleFill:setFillColor( .196, .094, .305 )

local nulogo = display.newImageRect( intro, "art_ui/nulogo.png", 320, 189)
local sislogo = display.newImageRect( intro, "art_ui/sislogo.png", 320, 189)
local tagline = display.newImageRect( intro, "art_ui/tagline.png", 320, 217)

nulogo.y = 130
sislogo.y = 300 
sislogo.alpha, tagline.alpha = 0,0

transition.to( purpleFill, { delay=200, time=500, alpha=.4} )
transition.to( nulogo, { delay=500, time=1000, y=244, transition=easing.inBack } )
transition.to( nulogo, { delay=1100, time=500, alpha=0 } )
transition.to( sislogo, { delay=1500, time=700, alpha=1, y=244, transition=easing.outQuad } )
transition.to( tagline, { delay=1000, time=2000, alpha=1, transition=easing.outQuad } )



local function killIntro(  )
    intro:removeSelf( )
    intro:removeEventListener("touch", function() return true end)
    intro:removeEventListener("tap", function() return true end)
    nulogo,sislogo,tagline = nil
    -- push menu into view first time
    --howMenu()

    transition.moveTo( tool1.link, { x=tool1.link.showX, time=500, transition=easing.inOutQuad } )
    transition.moveTo( about, { x=about.showX, time=500, transition=easing.inOutQuad } )


end

transition.to( intro, { delay=5000, time=500, alpha=0, onComplete=killIntro} )

end


---- App Initalization

local introPics = {5,8,11,10,9}
math.randomseed( os.time() )
local introSelect = math.random(table.getn(introPics))
selectedYear = appData.gallery13
selectedPhoto = selectedYear[introPics[introSelect]]

---- App Kickoff

menu.sel13.alpha=1
buildMenu(selectedYear)
buildInfoPanel(selectedPhoto)
loadSelectedPhoto(selectedPhoto)
about:toFront()
anim()

