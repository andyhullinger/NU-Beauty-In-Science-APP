--calculate the aspect ratio of the device
local aspectRatio = display.pixelHeight / display.pixelWidth
application = {
   content = {
      -- width = aspectRatio > 1.5 and 800 or math.ceil( 1200 / aspectRatio ),
      -- height = aspectRatio < 1.5 and 1200 or math.ceil( 800 * aspectRatio ),
      
      width=320,
      height=480,
      scale = "letterbox",
      xAlign = "left",
      yAlign = "top",
      imageSuffix = {
         ["@2x"] = 1.5,
         ["@3x"] = 2,
      },
   },
}