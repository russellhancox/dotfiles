local poppop = hs.noises.new(function(et)
  if et == 3 then
    img = hs.image.imageFromPath(hs.configdir .. '/poppop.jpeg')
    fadelogo.image = img
    fadelogo.image_size = img:size()
    fadelogo:start()
  end
  if et == 1 then
    hs.eventtap.scrollWheel({0, -10}, {})
  end
end):start()
