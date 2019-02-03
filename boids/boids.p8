pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- **********************
-- *** initialization ***
-- **********************
function _init()
  btncnt=0
  init_boids()
end

function init_boids()
  xmin=10
  xmax=118
  ymin=10
  ymax=118
  bcv=10.0
  
  vlimit=2.5
  dlimit=1
  dcorrmag=5.0
  
  boidgrp={} 
  add(boidgrp, create_boid(1,10,70,11))
  add(boidgrp, create_boid(2,10,10,11))
  add(boidgrp, create_boid(3,20,15,11))
  add(boidgrp, create_boid(4,5,5,11))
  add(boidgrp, create_boid(5,25,18,11))     
  add(boidgrp, create_boid(6,35,28,11))     
  add(boidgrp, create_boid(7,55,38,11))     
  add(boidgrp, create_boid(8,56,80,11))     
  add(boidgrp, create_boid(9,67,28,11))     

end

function create_boid(id,x,y,cl)
  local boid={}
  boid.id=id
  boid.cl=cl
  boid.p={} -- position
  boid.p.x=x
  boid.p.y=y
  boid.v={} -- velocity
  boid.v.x=0
  boid.v.y=0
  boid.d={} -- velocity change
  boid.d.x=0
  boid.d.y=0
  return boid
end

function create_target(x,y,cl)
  target={}
  target.p={}
  target.p.x,target.p.y=x,y
  target.cl=cl
end

function create_obstacle(x,y,cl)
  obstacle={}
  obstacle.p={}
  obstacle.p.x,obstacle.p.y=x,y
  obstacle.cl=cl
end


-- *************************
-- *** drawing on screen ***
-- *************************
function _draw()
  cls()
  color(4)
  print("     ◆◆◆ b o i d s ◆◆◆")
  draw_boids()
  if target~=nil then
    circfill(target.p.x,target.p.y,2,target.cl)
  end
  if obstacle~=nil then
    circfill(obstacle.p.x,obstacle.p.y,2,obstacle.cl)
  end
  color(12)
  print("x,y to toggle target/obstacle",10,118)
end 

function draw_boids()
  color(3)
  for b in all(boidgrp) do
    circfill(b.p.x,b.p.y,2,b.cl)
  end
end

-- **********************
-- *** update objects ***
-- **********************
function _update()
	 handle_buttons()

  for b in all(boidgrp) do
    print_boid(b)  
  end

  for b in all(boidgrp) do
    local v1=fly_center(b)
    local v2=match_velocity(b)
    local v5=nil
    if target~=nil then
      v5=chase_target(b)
    end
    if obstacle~=nil then
      v6=avoid_obstacle(b)
    end
    
    b.d=addvec(b.v,v1)
    b.d=addvec(b.d,v2)
    
    if target~=nil then
      b.d=addvec(b.d,v5)
    end
    if obstacle~=nil then
      b.d=addvec(b.d,v6)
    end
    
    limit_velocity(b)
    
    local v3=keep_distance(b)
    b.d=addvec(b.d,v3)
    
    local v4=bound_position(b)
    b.d=addvec(b.d,v4)
  end
  
  for b in all(boidgrp) do
    b.v=b.d
    b.p=addvec(b.p,b.v)    
  end
end

function handle_buttons()
  if btn(4) then
    if target==nil then
      local x=flr(rnd(xmax-xmin))+xmin
      local y=flr(rnd(ymax-ymin))+ymin
      create_target(x,y,8)
    else
      target=nil
    end
    wait(100)
  end

  if btn(5) then
    if obstacle==nil then
      local x=flr(rnd(xmax-xmin))+xmin
      local y=flr(rnd(ymax-ymin))+ymin
      create_obstacle(x,y,13)
    else
      obstacle=nil
    end
    wait(100)
  end

end

-- ******************
-- *** boid rules ***
-- ******************
function fly_center(boid)
  local t=zerovec()
  for b in all(boidgrp) do
    if b~=boid then
      t=addvec(b.p,t)
    end
  end
  
  local avg=scalardiv(t,#boidgrp-1)
  local r=scalardiv(subvec(avg,boid.p),50.0)
  return r
end

function match_velocity(boid)
  local pv=zerovec()
  for b in all(boidgrp) do
    if b~=boid then
      pv=addvec(b.v,pv)
    end
  end

  local avg=scalardiv(pv,#boidgrp-1)
  local r=scalardiv(subvec(avg,boid.v),20.)
  return r
end

function keep_distance(boid)
  local dc=zerovec()
  for b in all(boidgrp) do
    if b~=boid then
      local dst=subvec(boid.p,b.p)
      dst=scalarmul(dst,dlimit)
      if magnitude(dst)<dcorrmag then
        dc=subvec(dst,dc)
      end
    end
  end
  return dc
end

function bound_position(boid)
  local cv=zerovec()
  if boid.p.x<xmin then
    cv.x=10
  elseif boid.p.x>xmax then
    cv.x=-10
  end

  if boid.p.y<ymin then
    cv.y=10
  elseif boid.p.y>ymax then
    cv.y=-10
  end
  return cv
end

function limit_velocity(boid)
  vel=magnitude(boid.v)
  if vel>vlimit then
    boid.d=scalarmul(scalardiv(boid.v,vel),vlimit)
  end
end

function chase_target(boid)
  local r=scalardiv(subvec(target.p,boid.p),100.0)
  return r
end

function avoid_obstacle(boid)
  local dist=scalardiv(subvec(boid.p,obstacle.p),100.0)
  local mag=magnitude(dist)
  local direction=scalardiv(dist,mag)
  local absvel=1.5-mag
  if absvel<0 then
    absvel=0
  else
    absvel=absvel^2/3
  end
  local r=scalarmul(direction,absvel)
  return r
end

-- ********************
-- *** calculations ***
-- ******************** 
function addvec(v1,v2)
  local r={}
  r.x,r.y=0,0
  r.x=v1.x+v2.x
  r.y=v1.y+v2.y
  return r
end

function subvec(v1,v2)
  local r={}
  r.x,r.y=0,0
  r.x=v1.x-v2.x
  r.y=v1.y-v2.y
  return r
end

function scalardiv(v,s)
  local r={}
  r.x,r.y=0,0
  r.x=v.x/s
  r.y=v.y/s
  return r
end

function scalarmul(v,s)
  local r={}
  r.x,r.y=0,0
  r.x=v.x*s
  r.y=v.y*s
  return r
end

function magnitude(v)
  r=sqrt(v.x^2+v.y^2)
  return r
end

function zerovec()
  local v={}
  v.x,v.y=0,0
  return v
end

-- *****************
-- *** debuging  ***
-- *****************
function wait(t)
  local cnt=0
  while cnt<t do
    cnt+=1 
    cnt2=0
    while cnt2<1000 do
      cnt2+=1
    end
  end
end

function print_boid(b)
  printh("---"..b.id)
  printh("pos:"..b.p.x..","..b.p.y)
  printh("vel:"..b.v.x..","..b.v.y)
  printh("vdf:"..b.d.x..","..b.d.y)
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
