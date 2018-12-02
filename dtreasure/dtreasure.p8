pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
world={}
world[1 ]={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
world[2 ]={1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[3 ]={1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1 }
world[4 ]={1,0,2,0,3,0,4,0,5,0,0,0,0,0,0,0,0,1,0,0,1 }
world[5 ]={1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }
world[6 ]={1,0,6,0,7,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1 }
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
dragon={}
game={}

function _init()
  create_game()
  create_tiles()
  create_player()
  create_dragon()
end

function create_game()
  game.score=0
end

function animate_player()
  player.fcount+=1
  if player.fcount>=player.aframe then
    player.fcount=0
    player.sprite+=1
    if player.sprite>3 then
      player.sprite=1
    end
  end 
end

function create_player()
  player.w=8
  player.h=8
  player.xp=128/2-world.xcamoffset
  player.yp=128/2-world.ycamoffset
  player.sprite=1
  player.aframe=3
  player.fcount=0
  player.animate=animate_player
end

function create_dragon()
  dragon.w=32
  dragon.h=16
  dragon.xp=8*15
  dragon.yp=8*15
  dragon.sprite=16
end

function _draw()
  draw_header()
  draw_world()
  draw_player()
  draw_dragon()
end 

function draw_header()
  cls()
  camera(0,0)
  clip()
  print("score:"..game.score)
  print("player.x="..player.xp.." player.y="..player.yp)
end

function draw_player()
  camera(world.xcam-world.xcamoffset,world.ycam-world.ycamoffset)
  spr(player.sprite,player.xp,player.yp)
end

function draw_world()
  clip(0,world.ycamoffset,128,140)
  camera(world.xcam-world.xcamoffset,world.ycam-world.ycamoffset)
  for t in all(world.tiles) do
    if t.value~=0 then
      spr(t.sprite,t.xp,t.yp)
    end
  end
end

function draw_dragon()
  camera(world.xcam-world.xcamoffset,world.ycam-world.ycamoffset)
  spr(dragon.sprite,dragon.xp,dragon.yp,4,2)
end

function create_tiles()
  for y=1,#world do
    for x=1,#world[y] do
      if world[y][x]~=0 then
        xt=((x-1)*8)
        yt=((y-1)*8)
      	 tile={}
      	 tile.h=8
      	 tile.w=8
      	 tile.sprite=fetch_tile_sprite(x,y)
        tile.xp=xt;tile.yp=yt
        tile.value=world[y][x]
        add(world.tiles,tile)        
      end
    end
  end
end

function fetch_tile_sprite(x,y)
  if world[y][x]==1 then
    return 0
  elseif world[y][x]==2 then
    return 4
  elseif world[y][x]==3 then
    return 5
  elseif world[y][x]==4 then
    return 6
  elseif world[y][x]==5 then
    return 7
  elseif world[y][x]==6 then
    return 8
  elseif world[y][x]==7 then
    return 9
  end
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
  tilecol=player_tile_coll()
  dtouch=intersect(player,dragon)
  if (tilecol~=nil and tilecol.value==1) or dtouch==true then
    player.xp-=xd
    player.yp-=yd
  else
    if tilecol~=nil and tilecol.value>=2 and tilecol.value<=7 then
      take_item(tilecol)
    end  
 
    world.xcam+=xd
    world.ycam+=yd
    if xd~=0 or yd~=0 then
      player.animate()
    else
      player.sprite=1
    end
  end  
end

function take_item(tile)
  if tile.value==2 then
    game.score+=5
  elseif tile.value==3 then
    game.score+=10
  elseif tile.value==4 then
    game.score+=15
  elseif tile.value==5 then
    game.score+=20
  elseif tile.value==6 then
    game.score+=50
  elseif tile.value==7 then
    game.score+=100
  end    
  tile.value=0
  tile.sprite=nil
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
    if t.value>0 and intersect(t,player) then
      return t
    end
  end
  return nil
end

__gfx__
44444044000990000009900000099000000ee000000330000000a000000ff0000aaaaaa0a00aa00a008880000099900000aaa000007770000000000000000000
4444404400099000000990000009900000eee80000333b00004a9a4400f00f000aaaaaa0a00aa00a00008008000090090000a00a000070070000000000000000
000000000066660060666600006666060eeeee80033333b0044a9a940f0000f009aaaaa0aa0aa0aa008888080099990900aaaa0a007777070000000000000000
44044444666666666666666666666666eeeeee88333333bb4499a9440f0000f0009aaa00aaaaaaaa8888888099999990aaaaaaa0777777700000000000000000
44044444606666060066660660666600eeeeee88333333bb444444440f0000f00009a0002a2aa2a28008880090099900a00aaa00700777000000000000000000
000000000060060000600600006006000eeee88003333bb04444440400f00f000009a00022222222008008080090090900aa0a0a007707070000000000000000
4444404406000060060006600660006000ee88000033bb0044444404000cc0000009a00002222220008000880090009900a000aa007000770000000000000000
4444404466000066660000000000006600088000000bb00004444400000cc000009aaa0000222200008800000099000000aa0000007700000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030300033000000000000033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00380830330033000000000333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00e83e83333330033000000333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333333333333330000003330b33000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
033333bb3bb3b3333330003300033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33767bb3bbbbbb3b33330000000b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7663333333bbbbbbb333300000033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333003333333333bbb33300000b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030000333333333333bbb330000b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000033333333333333b3300b33000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000333303333333333bb3bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000033300003333330033333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003333000033330000000333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099930000999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
70000000770077707770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707007007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000707007007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707007007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000777077707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc00ccc0ccc0ccc00cc0ccc00cc0ccc0c0c00000000000c00cc0ccc0ccc0ccc0ccc0ccc00cc000c0ccc0ccc00cc00cc0ccc000c0000000000000000000000000
c0c00c00c0c0c000c0000c00c0c0c0c0c0c00c0000000c00c0000c000c00c0c0c000c0c0c0c00c00c0c00c00c000c0c0c0c00c00000000000000000000000000
c0c00c00cc00cc00c0000c00c0c0cc00ccc0000000000c00c0000c000c00cc00cc00ccc0c0c00c00ccc00c00c000c0c0ccc00c00000000000000000000000000
c0c00c00c0c0c000c0000c00c0c0c0c000c00c0000000c00c0c00c000c00c0c0c000c000c0c00c00c0000c00c000c0c0c0c00c00000000000000000000000000
ccc0ccc0c0c0ccc00cc00c00cc00c0c0ccc000000000c000ccc0ccc00c00c0c0ccc0c000cc00c000c000ccc00cc0cc00ccc0c000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000ee0eee0eee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000e0000e000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000e0000e000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000e0e00e000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e00eee0eee00e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee00eee0eee0eee0eee00ee0e0e0eee0eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e00e00e0e0e000e0e0e000e0e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e00e00ee00ee00eee0eee0e0e0ee00ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e00e00e0e0e000e0e000e0e0e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee00e00e0e0eee0e0e0ee000ee0e0e0eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee0e000eee00ee0eee0eee0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e000e000e000e000e000e000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee00e000ee00e000ee00ee00e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e000e000e000e000e000e000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee0eee0eee00ee0eee0eee0eee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee0eee0eee00ee0eee0eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee0e0e0e0e0e000e0e0eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e0eee0eee0e000eee0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e0e0e0e000e000e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e0e0e0e0000ee0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee00ee0eee0e0e0ee000ee0eee0ee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e0e000e000e0e0e0e0e0e000e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee0eee0ee00e0e0e0e0e0e00ee0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e00000e0e000e0e0e0e0e0e000e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e000ee00eee00ee0eee0ee00eee0eee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ee00ee0eee00ee0e000e000ee00eee0eee00ee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e000e000e0e0e0e0e000e000e0e0e000eee0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee0e000ee00e0e0e000e000e0e0ee00e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00e0e000e0e0e0e0e000e000e0e0e000e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee000ee0e0e0ee00eee0eee0eee0eee0e0e0ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ee0e0e0eee0eee0eee0e0e0ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e000e0e0e0e0e000e0e0e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee0e0e0ee00ee00ee00e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00e0e0e0e0e0e000e0e0e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee000ee0e0e0e000e0e00ee0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000077077000000770077707770777077700770707077707770000000000000000000000000000000000000000000000000000000000000000000000000
07000000700070700000707007007070700070707000707070707000000000000000000000000000000000000000000000000000000000000000000000000000
00700000700070700000707007007700770077707770707077007700000000000000000000000000000000000000000000000000000000000000000000000000
07000000700070700000707007007070700070700070707070707000000000000000000000000000000000000000000000000000000000000000000000000000
70000000077077700000777007007070777070707700077070707770000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00c00cc0ccc0ccc0ccc0ccc0ccc00cc000c0ccc0ccc00cc00cc0ccc000c0cc00ccc0ccc0ccc0ccc00cc0c0c0ccc0ccc000c00000000000000000000000000000
0c00c0000c000c00c0c0c000c0c0c0c00c00c0c00c00c000c0c0c0c00c00c0c00c00c0c0c000c0c0c000c0c0c0c0c0000c000000000000000000000000000000
0c00c0000c000c00cc00cc00ccc0c0c00c00ccc00c00c000c0c0ccc00c00c0c00c00cc00cc00ccc0ccc0c0c0cc00cc000c000000000000000000000000000000
0c00c0c00c000c00c0c0c000c000c0c00c00c0000c00c000c0c0c0c00c00c0c00c00c0c0c000c0c000c0c0c0c0c0c0000c000000000000000000000000000000
c000ccc0ccc00c00c0c0ccc0c000cc00c000c000ccc00cc0cc00ccc0c000ccc00c00c0c0ccc0c0c0cc000cc0c0c0ccc0c0000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000770077707770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707007007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000707007007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707007007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000777077707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc00ccc0ccc0ccc00cc0ccc00cc0ccc0c0c00000000000c00cc0ccc0ccc0ccc0ccc0ccc00cc000c0ccc0ccc00cc00cc0ccc000c0cc00ccc0ccc0ccc0ccc00cc0
c0c00c00c0c0c000c0000c00c0c0c0c0c0c00c0000000c00c0000c000c00c0c0c000c0c0c0c00c00c0c00c00c000c0c0c0c00c00c0c00c00c0c0c000c0c0c000
c0c00c00cc00cc00c0000c00c0c0cc00ccc0000000000c00c0000c000c00cc00cc00ccc0c0c00c00ccc00c00c000c0c0ccc00c00c0c00c00cc00cc00ccc0ccc0
c0c00c00c0c0c000c0000c00c0c0c0c000c00c0000000c00c0c00c000c00c0c0c000c000c0c00c00c0000c00c000c0c0c0c00c00c0c00c00c0c0c000c0c000c0
ccc0ccc0c0c0ccc00cc00c00cc00c0c0ccc000000000c000ccc0ccc00c00c0c0ccc0c000cc00c000c000ccc00cc0cc00ccc0c000ccc00c00c0c0ccc0c0c0cc00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0ccc0ccc000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0cc00cc000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cc0c0c0ccc0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000077077707070777000007700777077707770777007707070777077700000000000000000000000000000000000000000000000000000000000000000
07000000700070707070700000007070070070707000707070007070707070000000000000000000000000000000000000000000000000000000000000000000
00700000777077707070770000007070070077007700777077707070770077000000000000000000000000000000000000000000000000000000000000000000
07000000007070707770700000007070070070707000707000707070707070000000000000000000000000000000000000000000000000000000000000000000
70000000770070700700777000007770070070707770707077000770707077700000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06606660606066606600000066006660666066606660066060606660666000006660666000000000000000000000000000000000000000000000000000000000
60006060606060006060000060600600606060006060600060606060600000006060606000000000000000000000000000000000000000000000000000000000
66606660606066006060000060600600660066006660666060606600660000006660666000000000000000000000000000000000000000000000000000000000
00606060666060006060000060600600606060006060006060606060600000006000606000000000000000000000000000000000000000000000000000000000
66006060060066606660000066600600606066606060660006606060666006006000666000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000770077707770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707007007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000707007007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707007007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000777077707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc00ccc0ccc0ccc00cc0ccc00cc0ccc0c0c00000000000c00cc0ccc0ccc0ccc0ccc0ccc00cc000c0ccc0ccc00cc00cc0ccc000c0cc00ccc0ccc0ccc0ccc00cc0
c0c00c00c0c0c000c0000c00c0c0c0c0c0c00c0000000c00c0000c000c00c0c0c000c0c0c0c00c00c0c00c00c000c0c0c0c00c00c0c00c00c0c0c000c0c0c000
c0c00c00cc00cc00c0000c00c0c0cc00ccc0000000000c00c0000c000c00cc00cc00ccc0c0c00c00ccc00c00c000c0c0ccc00c00c0c00c00cc00cc00ccc0ccc0
c0c00c00c0c0c000c0000c00c0c0c0c000c00c0000000c00c0c00c000c00c0c0c000c000c0c00c00c0000c00c000c0c0c0c00c00c0c00c00c0c0c000c0c000c0
ccc0ccc0c0c0ccc00cc00c00cc00c0c0ccc000000000c000ccc0ccc00c00c0c0ccc0c000cc00c000c000ccc00cc0cc00ccc0c000ccc00c00c0c0ccc0c0c0cc00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0ccc0ccc000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0cc00cc000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cc0c0c0ccc0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66006660666066606660066060606660666000006660666000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600600606060006060600060606060600000006060606000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600600660066006660666060606600660000006660666000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600600606060006060006060606060600000006000606000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600600606066606060660006606060666006006000666000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
