class 'BugTest'

function BugTest:__init(); EGUSM.SubscribeUtility.__init(self)	-- because it's so convenient I use it in all my scripts now

	-- start and end positions
	self.startpos = Vector3(-8824.874023, 1479.143799, 12129.068359)
	self.dest = Vector3(14731.871094, 210.950546, -13027.565430)
	
	-- sub necessary stuff
	self:EventSubscribe("PlayerChat")
	self:EventSubscribe("ModuleUnload")
	self:NetworkSubscribe("TeleportToDest")
	self:NetworkSubscribe("StartTest", "TeleportToStart")
end

function BugTest:PlayerChat(args)										-- chat handler
	if args.text == "/test" then
		self:TeleportToStart(args)
	end
end

function BugTest:TeleportToStart(args)
	args.player:SetPosition(self.startpos)										-- teleport to starting position
	Chat:Send(args.player, "Teleported to start position", Color.DeepSkyBlue)	-- print msg
	Network:Send(args.player, "subactivateCalcView")								-- tells client to activate CalcView once LocalPlayer is done teleporting
end

function BugTest:TeleportToDest(data, player)
	player:SetPosition(self.dest)											-- teleport to destination
	Chat:Send(player, "Teleported to destination", Color.White)				-- print msg
end

function BugTest:ModuleUnload()
	self:Destroy()			-- unsub all stuff
	self.startpos = nil
	self.dest = nil
end

BugTest = BugTest()