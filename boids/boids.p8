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
  boidgrp={}
  
  add(boidgrp, create_boid(1,50,70))
  add(boidgrp, create_boid(2,50,50))
  add(boidgrp, create_boid(3,60,50))
  add(boidgrp, create_boid(4,50,60))
end

function create_boid(id,x,y)
  boid={}
  boid.id=id
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
    circfill(b.p.x,b.p.y,2,3)
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
  t=zerovec()
  for b in all(boidgrp) do
    if b~=boid then
      t=addvec(b.p,t)
    end
  end
  
  avg=scalardiv(t,#boidgrp-1)
  r=scalardiv(subvec(avg,boid.p),50.0)
  return r
end

function match_velocity(boid)
  pv=zerovec()
  for b in all(boidgrp) do
    if b~=boid then
      pv=addvec(b.v,pv)
    end
  end

  avg=scalardiv(pv,#boidgrp-1)
  r=scalardiv(subvec(avg,boid.v),20.)
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
