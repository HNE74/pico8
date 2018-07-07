pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
player={}
worms={}
fruit={}
wormcol=false

function _init()
  init_player()
  init_worms()
  init_fruit()
end

function init_player()
  player.w=8
  player.h=8
  player.x=128/2
  player.y=118
  player.sprite=3
  player.xspeed=0
  player.yspeed=0
  player.score=0
end

function init_fruit()
  fruit.w=8
  fruit.h=8
  fruit.x=-1
  fruit.y=200
  fruit.sprite=-1
  fruit.state=0
  fruit.oldstate=0
  fruit.scnt=0
end

function init_worms()
  y=24
  for i=1,11 do
		  x=rnd(100)+8
		  worm={}
		  worm.w=8
		  worm.h=8
		  worm.x=x
		  worm.y=y
		  worm.sprite=0
		  worm.speed=2
		  add(worms, worm)
		  y+=8
		end
end

function _draw() 
  color(5)
  cls()
  print("score: "..player.score.."  "..fruit.state)
  map(0,0, 0,8, 16,2)
  map(0,0, 0,112, 16,2)  
  spr(player.sprite, player.x, player.y)  
  for w in all(worms) do
    spr(w.sprite, w.x, w.y)  
  end
  if (fruit.x>-1) and (fruit.y>-1) then
    spr(fruit.sprite, fruit.x, fruit.y)
  end
end 

function _update() --called at 30fps
  update_player()
  update_worms()
  update_fruit()
  check_player_worm_coll()
  check_player_fruit_coll()
end

function update_fruit()
  if (fruit.state==1) then
    return
  end
  
  if(fruit.scnt>0) then
    fruit.scnt+=1
    if(fruit.scnt>100) then
      fruit.scnt=0
      position_fruit()
      return
    end
  end
  
  if (fruit.oldstate==2) and (fruit.state==2) then
    return
  end
    
  if (fruit.oldstate==1) and (fruit.state==2) then
    fruit.sprite+=3
    fruit.scnt+=1
    if(fruit.sprite==9) then
      player.score+=10
    elseif(fruit.sprite==10) then
      player.score+=20
    elseif(fruit.sprite==11) then
      player.score+=50
    end
    return
  end
  
  position_fruit()
end

function position_fruit()
  if (fruit.y>110) then
    fruit.y=12
  else
    fruit.y=116
  end
  fruit.x=rnd(110)+4
  fruit.sprite=flr(rnd(3))+6
  fruit.state=1  
end

function update_worms()
  for w in all(worms) do
  		if (w.x+w.speed > 128-w.w) or (w.x+w.speed < 0) then 
  		  w.speed=-w.speed
  	   w.speed+=rnd(2)-1
  	   if (w.speed>3) then
  	     w.speed=3
  	   elseif(w.speed<-3) then
  	     w.speed=-3
  	   end
  		end
  		w.x+=w.speed
  end
end

function update_player()
  player.xspeed=0
  player.yspeed=0
  
  if(btn(0)) then
    player.xspeed=-2
  elseif(btn(1)) then
    player.xspeed=2
  end
  
  if(btn(2)) then
    player.yspeed=-2
  elseif(btn(3)) then
    player.yspeed=2
  end
  
  if(player.x+player.xspeed>0) and (player.x+player.xspeed<128-player.w) then
    player.x+=player.xspeed
  end
  if(player.y+player.yspeed>8) and (player.y+player.yspeed<128-player.h) then
    player.y+=player.yspeed
  end
  
  if(player.xspeed~=0) or (player.yspeed~=0) then
    player.sprite+=1
    if player.sprite>5 then 
      player.sprite=3
    end
  end  
end

function intersect(obj1, obj2)
  if obj1.y>obj2.y+obj2.h then
    return false
  elseif obj1.y+obj1.h<obj2.y then
    return false
  elseif obj1.x>obj2.x+obj2.w then
    return false
  elseif obj1.x+obj1.w<obj2.x then
    return false
  end
  return true
end

function check_player_worm_coll()
  wormcol=false
  for w in all(worms) do
    if(intersect(player, w)) then
      wormcol=true
      break  
    end
  end
end

function check_player_fruit_coll()
  fruit.oldstate=fruit.state  
  if(intersect(player, fruit)) then
    fruit.state=2
  end
end
__gfx__
000000000000000000000000000cc000000cc000000cc00000000000000000bb0000044400707777777077777770777700000000000000000000000000000000
00000000000000000000000000acca00c0acca0c00acca00000bbb0000000bbb0000044007707007007070077000700700000000000000000000000000000000
8000880000000000008000080cccccc00cccccc00cccccc000bbbaa00000bb0000000a9077707007007070077000700700000000000000000000000000000000
880888808888888808880088cccaaccc0ccaacc0cccaaccc0bbbbbaa0000b00000000a9000707007777070077770700700000000000000000000000000000000
088800888888888888080880c0cccc0c00cccc0000cccc000bbbbbba000888000000aa9000707007700070070070700700000000000000000000000000000000
00800008000000008008880000cccc0000cccc0000cccc000bbbbbbb008888800009a99000707007700070070070700700000000000000000000000000000000
00000000000000000000800000c00c0000c00c0000c00c0000bbbbb0008888800a99a90000707007700070070070700700000000000000000000000000000000
0000000000000000000000000cc00cc000cc0cc00cc0cc00000bbb000008880000aaa00000707777777077777770777700000000000000000000000000000000
40404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88888888888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8888eee8888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888822228888228222888882282888222288888
888eee888ee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555556565655565656565655565655555655565656565565556556555777555c55555555555555555555555555555555555555555555
5555555555555555555555555666565556665666566556655555566656665665556555655665555555cc55555555555555555555555555555555555555555555
55555555555555555555555556555655565655565655565655555556565556565565556556555777555c55555555555555555555555555555555555555555555
555555555555555555555555565556665656566656665656557556655655565656665565566655555ccc55555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555eee5ee55ee55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555e555e5e5e5e5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555ee55e5e5e5e5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555e555e5e5e5e5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555eee5e5e5eee5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555eee5ee55ee5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555e555e5e5e5e555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555ee55e5e5e5e555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555e555e5e5e5e555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555eee5e5e5eee555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5eee5ee55ee555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5e555e5e5e5e55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5ee55e5e5e5e55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5e555e5e5e5e55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5eee5e5e5eee55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5eee5e5e5ee555ee5eee5eee55ee5ee5555556665665566656665666556656665566566655755566566656665665555555555566566656665666557555555555
5e555e5e5e5e5e5555e555e55e5e5e5e555555655656556556555656565556555655556557555656565655655565555555555656565655655556555755555555
5ee55e5e5e5e5e5555e555e55e5e5e5e555555655656556556655665566656655655556557555656566555655565555555555656566555655666555755555555
5e555e5e5e5e5e5555e555e55e5e5e5e555555655656556556555656555656555655556557555656565655655565557555555656565655655655555755555555
5e5555ee5e5e55ee55e55eee5ee55e5e555556665656556556665656566556665566556555755665566656655666575555555665566656655666557555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555eee5eee55555566566656665665555556565755556656665666566655555656555555665666566656665555565655555eee5e5e5eee5ee555555555
5555555555e55e55555556565656556555655555565655755656565655655556555556565575565656565565555655555656555555e55e5e5e555e5e55555555
5555555555e55ee5555556565665556555655555566655575656566555655666555556665777565656655565566655555666555555e55eee5ee55e5e55555555
5555555555e55e55555556565656556555655555555655755656565655655655555555565575565656565565565555555656555555e55e5e5e555e5e55555555
555555555eee5e55555556655666566556665575566657555665566656655666557556665555566556665665566655755656555555e55e5e5eee5e5e55555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555eee5eee5eee5e5e5eee5ee555555ccc5ccc5c5555cc5ccc5555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5e5555e55e5e5e5e5e5e55555c555c5c5c555c555c555555555555555555555555555555555555555555555555555555555555555555
55555555555555555ee55ee555e55e5e5ee55e5e55555cc55ccc5c555ccc5cc55555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5e5555e55e5e5e5e5e5e55555c555c5c5c55555c5c555555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5eee55e555ee5e5e5e5e55555c555c5c5ccc5cc55ccc5555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555eee5e5555ee5eee5eee5eee55555566566656665665555556565555556656665666566555555656555755665666566656665555565655555eee5e5e
555555555e555e555e555e5555e55e55555556565656556555655555565655755656565655655565555556565575565656565565555655555656555555e55e5e
555555555ee55e555eee5ee555e55ee5555556565665556555655555566657775656566555655565555556665755565656655565566655555666555555e55eee
555555555e555e55555e5e5555e55e55555556565656556555655555555655755656565655655565555556565575565656565565565555555556555555e55e5e
555555555eee5eee5ee55eee5eee5e55555556655666566556665575566655555665566656655666557556565557566556665665566655755666555555e55e5e
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555eee5eee5eee5e5e5eee5ee555555ccc5ccc5c5555cc5ccc5555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5e5555e55e5e5e5e5e5e55555c555c5c5c555c555c555555555555555555555555555555555555555555555555555555555555555555
55555555555555555ee55ee555e55e5e5ee55e5e55555cc55ccc5c555ccc5cc55555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5e5555e55e5e5e5e5e5e55555c555c5c5c55555c5c555555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5eee55e555ee5e5e5e5e55555c555c5c5ccc5cc55ccc5555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555eee5e5555ee5eee5eee5eee55555566566656665665555556565755556656665666566655555656555555665666566656665555565655555eee5e5e
555555555e555e555e555e5555e55e55555556565656556555655555565655755656565655655556555556565575565656565565555655555656555555e55e5e
555555555ee55e555eee5ee555e55ee5555556565665556555655555556555575656566555655666555555655777565656655565566655555656555555e55eee
555555555e555e55555e5e5555e55e55555556565656556555655555565655755656565655655655555556565575565656565565565555555666555555e55e5e
555555555eee5eee5ee55eee5eee5e55555556655666566556665575565657555665566656655666557556565555566556665665566655755666555555e55e5e
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555eee5eee5eee5e5e5eee5ee555555ccc5ccc5c5555cc5ccc5555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5e5555e55e5e5e5e5e5e55555c555c5c5c555c555c555555555555555555555555555555555555555555555555555555555555555555
55555555555555555ee55ee555e55e5e5ee55e5e55555cc55ccc5c555ccc5cc55555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5e5555e55e5e5e5e5e5e55555c555c5c5c55555c5c555555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5eee55e555ee5e5e5e5e55555c555c5c5ccc5cc55ccc5555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555eee5e5555ee5eee5eee5eee55555566566656665665555556565555556656665666566555555656555755665666566656665555565655555eee5e5e
555555555e555e555e555e5555e55e55555556565656556555655555565655755656565655655565555556565575565656565565555655555656555555e55e5e
555555555ee55e555eee5ee555e55ee5555556565665556555655555556557775656566555655565555556565755565656655565566655555565555555e55eee
555555555e555e55555e5e5555e55e55555556565656556555655555565655755656565655655565555556665575565656565565565555555656555555e55e5e
555555555eee5eee5ee55eee5eee5e55555556655666566556665575565655555665566656655666557556665557566556665665566655755656555555e55e5e
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555eee5eee5eee5e5e5eee5ee555555ccc5ccc5c5555cc5ccc5555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5e5555e55e5e5e5e5e5e55555c555c5c5c555c555c555555555555555555555555555555555555555555555555555555555555555555
55555555555555555ee55ee555e55e5e5ee55e5e55555cc55ccc5c555ccc5cc55555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5e5555e55e5e5e5e5e5e55555c555c5c5c55555c5c555555555555555555555555555555555555555555555555555555555555555555
55555555555555555e5e5eee55e555ee5e5e5e5e55555c555c5c5ccc5cc55ccc5555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555eee5ee55ee5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555e555e5e5e5e555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555ee55e5e5e5e555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555e555e5e5e5e555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555eee5e5e5eee555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555eee5eee5eee5e5e5eee5ee555555ccc5ccc5c5c5ccc5555555555555555555555555555555555555555555555555555555555555555555555555555
555555555e5e5e5555e55e5e5e5e5e5e555555c55c5c5c5c5c555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555ee55ee555e55e5e5ee55e5e555555c55cc55c5c5cc55555555555555555555555555555555555555555555555555555555555555555555555555555
555555555e5e5e5555e55e5e5e5e5e5e555555c55c5c5c5c5c555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555e5e5eee55e555ee5e5e5e5e555555c55c5c55cc5ccc5555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5eee5ee55ee555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5e555e5e5e5e55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5ee55e5e5e5e55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5e555e5e5e5e55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5eee5e5e5eee55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5eee5e5e5ee555ee5eee5eee55ee5ee5555555665656566655665656555556665655566656565666566655555656556656665666555555665566565556555575
5e555e5e5e5e5e5555e555e55e5e5e5e555556555656565556555656555556565655565656565655565655555656565656565666555556555656565556555755
5ee55e5e5e5e5e5555e555e55e5e5e5e555556555666566556555665555556665655566656665665566555555656565656655656555556555656565556555755
5e555e5e5e5e5e5555e555e55e5e5e5e555556555656565556555656555556555655565655565655565655555666565656565656555556555656565556555755
5e5555ee5e5e55ee55e55eee5ee55e5e555555665656566655665656566656555666565656665666565656665666566556565656566655665665566656665575
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
8fff88ff8f8f8fff8ff8888888ff88ff8f8f8ff88fff888888888888888888888888888888888888888888888282822282228882822282288222822288866688
88f88f8f8f8f8f888f8f88888f888f8f8f8f8f8f88f8888888888888888888888888888888888888188888888282828888828828828288288282888288888888
88f88f8f8ff88ff88f8f88888f888f8f8f8f8f8f88f8888888888888888888888888888888888881718888888222822282228828822288288222822288822288
88f88f8f8f8f8f888f8f88888f888f8f8f8f8f8f88f8888888888888888888888888888888888881771888888882888282888828828288288882828888888888
88f88ff88f8f8fff8f8f888888ff8ff888ff8f8f88f8888888888888888888888888888888888881777188888882822282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888881777718888888888888888888888888888888888888888888

__map__
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
