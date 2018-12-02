pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
world={}
world[1 ]={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
world[2 ]={1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[3 ]={1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1 }
world[4 ]={1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1 }
world[5 ]={1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[6 ]={1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1 }
world[7 ]={1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1 }
world[8 ]={1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[9 ]={1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[10]={1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[11]={1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[12]={1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1 }
world[13]={1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[14]={1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1 }
world[15]={1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[16]={1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[17]={1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[18]={1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1 }
world[19]={1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[20]={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
world.xcamoffset=0
world.ycamoffset=14
world.xcam=0
world.ycam=0
world.tiles={}

player={}
player.w=8
player.h=8
player.xp=128/2-world.xcamoffset
player.yp=128/2-world.ycamoffset

function _init()
  create_tiles()
end

function _draw()
  draw_header()
  draw_world()
  draw_player()
end 

function draw_header()
  cls()
  camera(0,0)
  clip()
  print("player.x="..player.xp.." player.y="..player.yp)
  print("camera.x="..world.xcam.." camera.y="..world.ycam)
end

function draw_player()
  camera(world.xcam-world.xcamoffset,world.ycam-world.ycamoffset)
  spr(1,player.xp,player.yp)
end

function draw_world()
  clip(0,world.ycamoffset,128,140)
  camera(world.xcam-world.xcamoffset,world.ycam-world.ycamoffset)
  for t in all(world.tiles) do
    if t.value==1 then
      spr(t.sprite,t.xp,t.yp)
    end
  end
end

function create_tiles()
  for y=1,#world do
    for x=1,#world[y] do
      if world[y][x]==1 then
        xt=((x-1)*8)
        yt=((y-1)*8)
      	 tile={}
      	 tile.h=8
      	 tile.w=8
      	 tile.sprite=0
        tile.xp=xt;tile.yp=yt
        tile.value=world[y][x]
        add(world.tiles,tile)        
      end
    end
  end
end

function intersect(obj1, obj2)
  if obj1.yp>=obj2.yp+obj2.h then
    return false
  elseif obj1.yp+obj1.h<=obj2.yp then
    return false
  elseif obj1.xp>=obj2.xp+obj2.w then
    return false
  elseif obj1.xp+obj1.w<=obj2.xp then
    return false
  end
  return true
end

function player_tile_coll()
  for t in all(world.tiles) do
    if intersect(t,player) then
      return true
    end
  end
  return false
end

function _update() 
  local xd=0;yd=0;
  if (btn(0)) then  
    xd=-1
  end 
  if (btn(1)) then 
    xd=1
  end
  if (btn(2)) then 
    yd=-1
  end
  if (btn(3)) then 
    yd=1
  end

  update_world(xd,yd)
end

function update_world(xd,yd)
  player.xp+=xd
  player.yp+=yd
  if player_tile_coll() then
    player.xp-=xd
    player.yp-=yd
  else
    world.xcam+=xd
    world.ycam+=yd
  end  
end
__gfx__
44444044000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444044000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44044444666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44044444606666060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444044060000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444044660000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
