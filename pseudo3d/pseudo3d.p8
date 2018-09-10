pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
gr_eyex=0
gr_eyey=-20
gr_eyez=-50

lines={}

function _init()
  init_lines()
end

function init_lines()
  zpos=100
  for i=1,10 do
    l={}
    l.xl=-64
    l.xr=64
    l.y=100
    l.z=zpos
    add(lines,l)
    zpos-=50
  end
end

function _draw()
  cls()
  for l in all(lines) do
    left=to_screen_coord(l.xl,l.y,l.z)
    right=to_screen_coord(l.xr,l.y,l.z)
    line(0,left[2],127,right[2])   
  end
end

function to_screen_coord(x,y,z)
  result={}
  xp=gr_eyez*(x-gr_eyex)/(gr_eyez+z)+gr_eyex
  yp=gr_eyez*(y-gr_eyey)/(gr_eyez+z)+gr_eyey
  add(result,xp+64)
  add(result,yp+64)
  printh(xp)
  printh(yp)
  return result
end

function _update()
  for line in all(lines) do
    line.z+=10
    if(line.z>0) line.z-=500
  end
end
