if true then
    print("Chronon disabled for now. -Fool of a Took")
    return
end

if file.Exists("qa_environment.txt", "GAME") then
    MsgC(Color(211, 120, 0), "QA/Dev environment detected — skipping Chronon load.\n")
    return
end

local include 	   = include

print ("Loading Chronon.." .. "\n")
include ("chrononlabs/runtime/systemdispatcher.lua")
