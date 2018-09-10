pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
eyex=0
eyey=-20
eyez=-50

lines={}
objs={}

function _init()
  init_lines()
  init_objs()
end

function init_objs()
  zp=-800
  for i=1,10 do
    ob={}
    ob.x=-200+flr(rnd(400))
    ob.y=120
    ob.w=40
    ob.h=100
    ob.clr=1+flr(rnd(14))
    ob.z=zp
    zp+=70
    add(objs,ob)
  end
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
  
  if (btn(1)) then
    exex+=5
    printh("u")
  end
  if (btn(2)) then 
    exex-=5
    printh("d")
  end 
end

function _draw()
  cls()
  for l in all(lines) do
    left=to_screen_coord(l.xl,l.y,l.z)
    right=to_screen_coord(l.xr,l.y,l.z)
    line(0,left[2],127,right[2],1)    
  end
  for o in all(objs) do
    topleft=to_screen_coord(o.x-o.w/2,o.y-o.h/2,o.z)
    btmright=to_screen_coord(o.x+o.w/2,o.y+o.h/2,o.z)
    rectfill(topleft[1],topleft[2],btmright[1],btmright[2],o.clr)
  end
end

function to_screen_coord(x,y,z)
  result={}
  xp=eyez*(x-eyex)/(eyez+z)+eyex
  yp=eyez*(y-eyey)/(eyez+z)+eyey
  add(result,xp+64)
  add(result,yp+64)
  return result
end

function _update()
  for line in all(lines) do
    line.z+=10
    if(line.z>0) line.z-=500
  end
  for o in all(objs) do
    o.z+=10
    if(o.z>0) then
      o.z-=800
      o.x=-200+flr(rnd(400))
      o.clr=1+flr(rnd(14))
    end
  end
  
  if (btn(0)) eyex+=1
  if (btn(1)) eyex-=1
  if (btn(2)) eyey+=1
  if (btn(3)) eyey-=1
  if (btn(4)) eyez+=1
  if (btn(5)) eyez-=1

end
