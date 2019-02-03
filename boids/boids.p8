pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- **********************
-- *** initialization ***
-- **********************
function _init()
  init_boids()
end

function init_boids()
  xmin=10
  xmax=118
  ymin=10
  ymax=118
  bcv=10.0
  
  vlimit=2.0
  dlimit=2.0
  dcorrmag=5.0
  
  boidgrp={}  
  add(boidgrp, create_boid(1,10,70,3))
  add(boidgrp, create_boid(2,10,10,4))
  add(boidgrp, create_boid(3,20,15,5))
  add(boidgrp, create_boid(4,5,5,6))
  add(boidgrp, create_boid(4,5,18,7))
end

function create_boid(id,x,y,cl)
  boid={}
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

-- *************************
-- *** drawing on screen ***
-- *************************
function _draw()
  cls()
  draw_boids()
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
  for b in all(boidgrp) do
    local v1=fly_center(b)
    local v2=match_velocity(b)
    
    b.d=addvec(b.v,v1)
    b.d=addvec(b.d,v2)
    
    limit_velocity(b)
    
    local v3=keep_distance(b)
    b.d=addvec(b.d,v3)
    
    local v4=bound_position(b)
    b.d=addvec(b.d,v4)
  end
  
  for b in all(boidgrp) do
    b.v=b.d
    b.p=addvec(b.p,b.v)    
    print_boid(b)
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
        dc=subvec(dc,dst)
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
