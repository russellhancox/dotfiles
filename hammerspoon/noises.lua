poppop = hs.noises.new(function(et)
  if et == 3 then
    img = hs.image.imageFromPath(hs.configdir .. '/poppop.jpeg')
    fadelogo.image = img
    fadelogo.image_size = img:size()
    fadelogo:start()
  end
end):start()
