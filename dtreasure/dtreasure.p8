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
world.width=21
world.height=20

function _init()
  create_game()
  create_tiles()
  create_player()
  create_dead()
  create_dead()
  create_dragon()
end

function create_game()
  game={}
  game.bgcolor=0
  game.score=0
  game.state=1
  game.lives=3
end

function animate_object(o)
  o.fcount+=1
  if o.fcount>=o.aframe then
    o.fcount=0
    o.sprite+=1
    if o.sprite>o.maxsprite then
      o.sprite=o.minsprite
    end
  end 
end

function create_player()
  player={}
  player.w,player.h=8,8
  player.xp=128/2-world.xcamoffset
  player.yp=128/2-world.ycamoffset
  player.minsprite=1
  player.maxsprite=3
  player.sprite=player.minsprite
  player.aframe=3
  player.fcount=0
  player.sword=nil
  player.swordpos=0
  player.sowrdrawn=false
end

function create_sword(pos)
  sword={}
  sword.h=8
  sword.w=8
  if pos==1 then
    sword.xp=player.xp+player.w
    sword.yp=player.yp
    sword.sprite=24
  elseif pos==2 then
    sword.xp=player.xp
    sword.yp=player.yp+player.h
    sword.sprite=25
  elseif pos==3 then
    sword.xp=player.xp-player.w
    sword.yp=player.yp
    sword.sprite=26
  elseif pos==4 then
    sword.xp=player.xp
    sword.yp=player.yp-player.h
    sword.sprite=27
  end
    
  return sword
end

function create_dead()
  dead={}
  dead.w,dead.h=8,8
  dead.xp,dead.yp=player.xp,player.yp
  dead.minsprite=20
  dead.maxsprite=23
  dead.sprite=dead.minsprite
  dead.aframe=10
  dead.fcount=0
  dead.cnt=0
end

function create_dragon()
  dragon={}
  dragon.w=32
  dragon.h=16
  dragon.xp=8*15
  dragon.yp=8*15
  dragon.maincolor=1
  dragon.sprite=16
  dragon.fire={}
  dragon.fireprob=100
  dragon.firemax=3
  dragon.hits=0
end

function create_dragon_fire()
  if flr(rnd(dragon.fireprob)) ~=1 then
    return
  end 
   
  if #dragon.fire>=dragon.firemax then
 	  return
  end	

  fire={}
  fire.h=8
  fire.w=8
  fire.fcount=1
  fire.aframe=1
  fire.minsprite=10
  fire.maxsprite=14
  fire.sprite=fire.minsprite
  fire.dist=0
  fire.xp=dragon.xp
  fire.yp=dragon.yp
  fire.plx=player.xp
  fire.ply=player.yp
  calc_fire_pos(fire,1)
  add(dragon.fire,fire)
end


function _draw()
  draw_header()
  draw_world()
  draw_player()
  draw_dragon()
  draw_dragon_fire()
end 

function draw_header()
  cls(game.bgcolor)
  camera(0,0)
  clip()
  print("score:"..game.score.." lives:"..game.lives)
  print("player.x="..player.xp.." player.y="..player.yp)
end

function draw_player()
  camera(world.xcam-world.xcamoffset,world.ycam-world.ycamoffset)
  if game.state==1 then
    spr(player.sprite,player.xp,player.yp)
  elseif game.state==2 then
    spr(dead.sprite,dead.xp,dead.yp)
  end
  
  if player.sword~=nil then
    spr(sword.sprite,sword.xp,sword.yp)
  end
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
  pal(3,dragon.maincolor)
  spr(dragon.sprite,dragon.xp,dragon.yp,4,2)
end

function draw_dragon_fire()
  camera(world.xcam-world.xcamoffset,world.ycam-world.ycamoffset)
  for f in all(dragon.fire) do
    spr(f.sprite,f.xp,f.yp)
  end
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
  game.bgcolor=0 
  local xd=0;yd=0;
  
  local b0,b1,b2,b3=btn(0),btn(1),btn(2),btn(3)
  local b4,b5=btn(4),btn(5)
  
  if b0 then  
    xd=-1
    player.swordpos=3
  end 
  if b1 then 
    xd=1
    player.swordpos=1
  end
  if b2 then 
    yd=-1
    player.swordpos=4
  end
  if b3 then 
    yd=1
    player.swordpos=2
  end
    
  if b5 and game.state==1 then
    player.sword=create_sword(player.swordpos)  
    if not player.sworddrawn then
      check_dragon_hit()
      player.sworddrawn=true
    end   
  else
    player.sworddrawn=false
    player.sword=nil 
  end
    
  if game.state==1 then
    update_world(xd,yd)
  elseif game.state==2 then
    update_player_hit()
  end
  
  update_dragon_fire()
end

function check_dragon_hit()
  if player==nil or player.sword==nil or dragon==nil then
  end
  if intersect(player.sword,dragon) then
    dragon.hits+=1
    game.bgcolor=4
  end
end


function update_dragon_fire()
  create_dragon_fire()
  for f in all(dragon.fire) do 
    animate_object(f)
    f.dist+=1
    calc_fire_pos(f,2)
    if f.xp<=0 or f.xp>=world.width*8-8 or 
       f.yp<=0 or f.yp>=world.height*8-8 then  
      del(dragon.fire,f)
      return
    end
  end
end

function update_player_hit()
  dead.cnt+=1
  if dead.cnt >=40 then
    game.state=1
    return
  end
  animate_object(dead)
end

function update_world(xd,yd)
  player.xp+=xd
  player.yp+=yd
  tilecol=player_tile_coll()
  player_fire_coll()
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
      animate_object(player)
    else
      player.sprite=player.minsprite
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
  if obj1==nil or obj2==nil or
     obj1.xp==nil or obj2.yp==nill or
     obj1.yp==nil or obj2.yp==nil or
     obj1.w==nil or obj2.w==nil or
     obj1.h==nil or obj2.h== nil then
    return false
  end 
     
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

function player_fire_coll()
  for f in all(dragon.fire) do
    if intersect(player,f) then
      game.lives-=1
      game.state=2
      create_dead()
      del(dragon.fire,f)
    end   
  end
end

function player_tile_coll()
  for t in all(world.tiles) do
    if t.value>0 and intersect(t,player) then
      return t
    end
  end
  return nil
end

function calc_fire_pos(fire,speed)
  local dx,dy=fire.plx-dragon.xp,fire.ply-dragon.yp
  local d=speed/sqrt(dx*dx+dy*dy)
  fire.xp+=dx*d
  fire.yp+=dy*d
end


__gfx__
44444044000990000009900000099000000ee000000cc0000000a000000ff0000aaaaaa0a00aa00a008880000099900000aaa000007770000000000000000000
4444404400099000000990000009900000eee80000cccd00004a9a4400f00f000aaaaaa0a00aa00a00008008000090090000a00a000070070000000000000000
000000000066660060666600006666060eeeee800cccccd0044a9a940f0000f009aaaaa0aa0aa0aa008888080099990900aaaa0a007777070000000000000000
44044444666666666666666666666666eeeeee88ccccccdd4499a9440f0000f0009aaa00aaaaaaaa8888888099999990aaaaaaa0777777700000000000000000
44044444606666060066660660666600eeeeee88ccccccdd444444440f0000f00009a0002a2aa2a28008880090099900a00aaa00700777000000000000000000
000000000060060000600600006006000eeee8800ccccdd04444440400f00f000009a00022222222008008080090090900aa0a0a007707070000000000000000
4444404406000060060006600660006000ee880000ccdd0044444404000bb0000009a00002222220008000880090009900a000aa007000770000000000000000
4444404466000066660000000000006600088000000cd00004444400000bb000009aaa0000222200008800000099000000aa0000007700000000000000000000
00000000000000000000000000000000000990000000000000000000000000000000000000066000000000000006600000000000000000000000000000000000
00000000000000000000000000000000000980000009000000000000000000000000000000888800000000000006600000000000000000000000000000000000
0003030003300000000000003330000000a8a80000a8a8a000000000000000000800000000066000000000800006600000000000000000000000000000000000
00380830330033000000000333330000a88a9889080a980000000000000000006866666600066000666666860006600000000000000000000000000000000000
00e83e8333333003300000033333300080a9aa0a80a90aa0000a0000000000006866666600066000666666860006600000000000000000000000000000000000
00333333333333330000003330b3300000900a0000000a0909900a00000000000800000000066000000000800006600000000000000000000000000000000000
033333bb3bb3b3333330003300033000080000a0080800a008080080000000000000000000066000000000000088880000000000000000000000000000000000
33767bb3bbbbbb3b33330000000b3000aa000099aa000a99a0000a90000000000000000000066000000000000006600000000000000000000000000000000000
7663333333bbbbbbb333300000033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333003333333333bbb33300000b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030000333333333333bbb330000b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000033333333333333b3300b33000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000333303333333333bb3bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000033300003333330033333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003333000033330000000333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099930000999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88888888888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8888eee8888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888822228888228222888882282888222288888
888eee888ee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555656566656665665566656665575557555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555656565556565656565556565755555755555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555666566556665656566556655755555755555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555656565556565656565556565755555755555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
56665656566656565666566656565575557555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555888885555555555555555555555555555555555555555555555555555555
5ccc55555c5c55555555556656665666566655555566556655665666566655555555887885555555555555555555555555555555555555555555555555555555
5c5555c55c5c55555555565556565666565555555655565556565656565555555555888785555555555555555555555555555555555555555555555555555555
5cc55555555555555555565556665656566555555666565556565665566555555555888785555555555555555555555555555555555555555555555555555555
5c5555c5555555555555565656565656565555555556565556565656565555555555888785555555555555555555555555555555555555555555555555555555
5ccc5555555555755575566656565656566655755665556656655656566655755575887885555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5ccc5ccc55555c5c55555c5c55555555566656555666565656665666555556565666555555555c5c55555ccc5c555ccc5c5c5ccc5ccc55555c5c55555c5c5555
5c555c5c55555c5c5ccc5c5c55555555565656555656565656555656555556565656555555555c5c55555c5c5c555c5c5c5c5c555c5c55555c5c5ccc5c5c5555
5cc55cc5555555c5555555555555555556665655566656665665566555555565566655555555555555555ccc5c555ccc5ccc5cc55cc555555ccc555555555555
5c555c5c55555c5c5ccc55555555555556555655565655565655565655555656565555555555555555555c555c555c5c555c5c555c5c5555555c5ccc55555555
5ccc5c5c55c55c5c555555555575557556555666565656665666565655755656565555755575555555555c555ccc5c5c5ccc5ccc5c5c55c55ccc555555555575
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555666565556665656566656665575557555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555656565556565656565556565755555755555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555666565556665666566556655755555755555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555655565556565556565556565755555755555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
56665655566656565666566656565575557555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
56655555565655665666566655555656556656665655566555555656556656665666556656665666556656665666555556565566566656555665555556565566
56565555565656555656566655555656565656565655565655555656565556565666565656555655565556555565555556565656565656555656555556565655
56565555556556555666565657775656565656655655565655555565565556665656565656655665566656655565555556565656566556555656555556665655
56565555565656555656565655555666565656565655565655555656565556565656565656555655555656555565557556665656565656555656555555565655
56665575565655665656565655555666566556565666566655755656556656565656566556555655566556665565575556665665565656665666557556665566
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55665666566656665666566655555666565556665656566656665555565656665555566656555666565656665666555556565666557555555555555555555555
56555656565655655565565555555656565556565656565556565555565656565555565656555656565656555656555556565656555755555555555555555555
56665666566555655565566555555666565556665666566556655555556556665555566656555666566656655665555556665666555755555555555555555555
55565655565655655565565555755655565556565556565556565555565656555575565556555656555656555656555555565655555755555555555555555555
56655655565656665565566657555655566656565666566656565575565656555755565556665656566656665656557556665655557555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555656556656665655566555755575555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555656565656565655565657555557555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555656565656655655565657555557555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555666565656565655565657555557555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
56665666566556565666566655755575555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
56655555565655665666566655665666566655665666566655555cc55ccc5ccc55555cc55c5c5ccc557555555555555555555555555555555555555555555555
565655555656565556565666565656555655565556555565555555c5555c5c5c555555c55c5c5c5c555755555555555555555555555555555555555555555555
565655555666565556665656565656655665566656655565555555c55ccc5ccc555555c55ccc5c5c555755555555555555555555555555555555555555555555
565655555556565556565656565656555655555656555565557555c55c555c5c557555c5555c5c5c555755555555555555555555555555555555555555555555
56665575566655665656565656655655565556655666556557555ccc5ccc5ccc57555ccc555c5ccc557555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
56655555565655665666566655555656556656665655566555555656556656665666556656665666556656665666555556565566566656555665555556565566
56565555565656555656566655555656565656565655565655555656565556565666565656555655565556555565555556565656565656555656555556565655
56565555556556555666565657775656565656655655565655555565565556665656565656655665566656655565555556565656566556555656555556665655
56565555565656555656565655555666565656565655565655555656565556565656565656555655555656555565557556665656565656555656555555565655
56665575565655665656565655555666566556565666566655755656556656565656566556555655566556665565575556665665565656665666557556665566
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5b55557556565566566656555665555556665666565556665566557555555ee555ee555555555555555555555555555555555555555555555555555555555555
5b55575556565656565656555656555555655565565556555655555755555e5e5e5e555555555555555555555555555555555555555555555555555555555555
5b55575556565656566556555656555555655565565556655666555755555e5e5e5e555555555555555555555555555555555555555555555555555555555555
5b55575556665656565656555656555555655565565556555556555755555e5e5e5e555555555555555555555555555555555555555555555555555555555555
5bbb557556665665565656665666557555655666566656665665557555555eee5ee5555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5666555555555ccc55555eee5e5e5eee5ee555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5655555757775c5c555555e55e5e5e555e5e55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5665577755555c5c555555e55eee5ee55e5e55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822282828882822282228222888888888888888888888888888888888888888882288222822282228882822282288222822288866688
82888828828282888888828282828828888288828282888888888888888888888888888888888888888888288882828282888828828288288282888288888888
82888828828282288888822282228828822282228221888888888888888888888888888888888888888888288222822282228828822288288222822288822288
82888828828282888888828288828828828882888817188888888888888888888888888888888888888888288288828288828828828288288882828888888888
82228222828282228888822288828288822282228817718888888888888888888888888888888888888882228222822282228288822282228882822288822288
88888888888888888888888888888888888888888817771888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
