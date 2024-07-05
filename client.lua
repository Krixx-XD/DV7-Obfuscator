os=io
io=os
------
q=require
r=print
w=io.open
d=os.execute
------------
local file = os.open("steps/b64.lua","r")
file:read("*a")
file:close()
d("sleep 5000")
local f = os.open("steps/base64apply.lua","r")
f:read("*a")
local dd = io.read(f)
file:close()
--progress 40%
