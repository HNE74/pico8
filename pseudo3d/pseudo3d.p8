pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- position of the viewers eye
eyex=0
eyey=-20
eyez=-50

lines={}
objs={}

function _init()
  init_lines()
  init_objs()
end

-- defines rectangles as objects
function init_objs()
  zp=-800
  for i=1,10 do
    ob={}
    ob.x=-300+flr(rnd(600))
    ob.y=120
    ob.w=40
    ob.h=100
    ob.clr=1+flr(rnd(14))
    ob.z=zp
    zp+=70
    add(objs,ob)
  end
end

-- defines surface lines
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

-- draws lines for the ground surface
-- and objects based on their 3d
-- coordinates transformed to screen
-- coordinates
function _draw()
  cls()
  color(3)
  print("pseudo 3d demo")
  color(4)
  print("use arrow and button keys")
  print("to change user eye coordinates")
  color(15)
  print("eye coordinates x:"..eyex.." y:"..eyey.." z:".. eyez)
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

-- transforms 3 dimensional coordinates
-- to 2 dimensional screen coordinates
function to_screen_coord(x,y,z)
  result={}
  xp=eyez*(x-eyex)/(eyez+z)+eyex
  yp=eyez*(y-eyey)/(eyez+z)+eyey
  add(result,xp+64)
  add(result,yp+64)
  return result
end

-- updates objects and surface line
-- 3 dimensional coordinates
function _update()
  for line in all(lines) do
    line.z+=10
    if(line.z>0) line.z-=500
  end
  for o in all(objs) do
    o.z+=10
    if(o.z>0) then
      -- send object to back
      o.z-=800
      o.x=-300+flr(rnd(600))
      o.clr=1+flr(rnd(14))
      
      -- reorder object list
      newobjs={}
      add(newobjs,o)
      for i=1,#objs-1 do
        add(newobjs,objs[i])
      end
      objs=newobjs
    end
  end
  
  -- allow user change of eye
  -- coordinates
  if (btn(0)) eyex+=1
  if (btn(1)) eyex-=1
  if (btn(2)) eyey+=1
  if (btn(3)) eyey-=1
  if (btn(4)) eyez+=1
  if (btn(5)) eyez-=1

end
