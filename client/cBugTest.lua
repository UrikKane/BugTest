class 'BugTest'

function BugTest:__init(); EGUSM.SubscribeUtility.__init(self)	-- because it's so convenient I use it in all my scripts now

	-- sub stuff
	self:NetworkSubscribe("subactivateCalcView")
	self:EventSubscribe("ModuleUnload")
	self:EventSubscribe("KeyUp")
end

function BugTest:KeyUp(args)											-- key handler
	if args.key == string.byte("J") then
		args.player = LocalPlayer
		Network:Send("StartTest", args)
	end
end

function BugTest:subactivateCalcView()
	if not self.EventSubs.activateCalcView then self:EventSubscribe("PostTick", "activateCalcView") end
end

function BugTest:activateCalcView()
	if LocalPlayer:IsTeleporting() == false and LocalPlayer:GetLinearVelocity() ~= Vector3.Zero then	-- makes sure we're done teleporting / loading
		self:EventUnsubscribe("activateCalcView")
		self.camangle = LocalPlayer:GetAngle()
		self.campos = LocalPlayer:GetPosition()
		DelayedFunction( function() self:EventSubscribe("CalcView") Chat:Print("Activated CalcView", Color.Green) end , 2 )		-- activates CalcView 2 seconds later
		DelayedFunction( function() Network:Send("TeleportToDest") end , 4 )													-- tells server to teleport us 4 seconds later
		DelayedFunction( function() self:EventUnsubscribe("CalcView") Chat:Print("Deactivated CalcView", Color.Red) end , 5 )	-- deactivates CalcView 5 seconds later
	end
end

function BugTest:CalcView()

Camera:SetPosition(self.campos)		-- just maiking sure camera stays where it was
Camera:SetAngle(self.camangle)		-- just maiking sure camera stays where it was

return false	-- returning false, making LocalPlayer invisible / inactive
end

function BugTest:ModuleUnload()

self:Destroy()		-- unsub all stuff
self.campos = nil
self.camangle = nil

end

BugTest = BugTest()