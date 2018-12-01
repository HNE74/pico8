pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- position of the viewers eye
eyex=0
eyey=-40
eyez=-10

lines={}
objs={}
player={}
game={}

function _init()
  init_lines()
  init_objs()
  init_player()
  game.state=0
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

function init_player()
  player.x=64
  player.y=100
  player.z=-1
  player.lsp=0
  player.rsp=1
  player.msp=2
  player.spd=1
end

-- defines surface lines
function init_lines()
  zpos=100
  for i=1,10 do
    l={}
    l.xl=-64
    l.xr=64
    l.y=90
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
  cls(game.state)
  color(3)
  print("pseudo 3d demo")
  print("   by noltisoft (c) 2018")
  color(4)
  print("use arrow and button keys")
  print("to change user perspective")
  draw_surface()
  draw_obstacles()
  draw_player()
end

function draw_player()
  spr(player.lsp,player.x-12,player.y)
  spr(player.rsp,player.x+4,player.y)
  spr(player.msp,player.x-4,player.y)
end

function draw_surface()
  for l in all(lines) do
    left=to_screen_coord(l.xl,l.y,l.z)
    right=to_screen_coord(l.xr,l.y,l.z)
    line(0,left[2],127,right[2],1)    
  end
end

function draw_obstacles()
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
    line.z+=player.spd
    if(line.z>0) line.z-=500
  end
  for o in all(objs) do
    o.z+=player.spd
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
  
  if player.msp==2 then
    player.msp=3
  else
    player.msp=2
  end
  
  if (btn(0)) and player.x>20 then
    player.x-=2
  end
  if (btn(1)) and player.x<108 then
    player.x+=2
  end
  
  if (btn(2)) and player.spd<11 then
    player.spd+=1
  elseif (btn(3)) and player.spd>1 then
    player.spd-=1
  end
  
  if chk_player_objs_coll() then
    game.state=1 
  else
    game.state=0
  end
end

function chk_player_objs_coll()
  for o in all(objs) do
    dst=calc_player_dist(o)
    printh(o.z.."-".. dst)
    if dst<5 then 
      return true
    end
  end
  
  return false 
end

function calc_player_dist(obj)
  xd=abs((obj.x-player.x)/10*(obj.x-player.x)/10)
  yd=abs((obj.y-player.y)/10*(obj.y-player.y)/10)
  zd=abs((obj.z-player.z)/10*(obj.z-player.z)/10)
  sum=xd+yd+zd
  dist=sqrt(sum)
  printh(obj.x.." * "..player.x.." = "..xd)
  printh(obj.y.." * "..player.y.." = "..yd)
  printh(obj.z.." * "..player.z.." = "..zd)
  printh(sum)
  printh(dist)
  return dist
end
__gfx__
00000000000000000055550000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000555555005555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000666666000006666666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
066666666666666066aaaa6666888866000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666aaaaaa668888886000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666000000000066666aaaa6666888866000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66000000000000660666666006666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000066660000666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
