
function EGUSM.SubscribeUtility:__init()
	-- Expose functions.
	
	self.EventSubscribe = EGUSM.SubscribeUtility.EventSubscribe
	self.NetworkSubscribe = EGUSM.SubscribeUtility.NetworkSubscribe
	self.NetSubscribe = self.NetworkSubscribe
	self.ConsoleSubscribe = EGUSM.SubscribeUtility.ConsoleSubscribe
	
	self.EventUnsubscribe = EGUSM.SubscribeUtility.EventUnsubscribe
	self.NetworkUnsubscribe = EGUSM.SubscribeUtility.NetworkUnsubscribe
	self.NetUnsubscribe = self.NetworkUnsubscribe
	self.ConsoleUnsubscribe = EGUSM.SubscribeUtility.ConsoleUnsubscribe
	
	self.EventUnsubscribeAll = EGUSM.SubscribeUtility.EventUnsubscribeAll
	self.NetworkUnsubscribeAll = EGUSM.SubscribeUtility.NetworkUnsubscribeAll
	self.NetUnsubscribeAll = self.NetworkUnsubscribeAll
	self.ConsoleUnsubscribeAll = EGUSM.SubscribeUtility.ConsoleUnsubscribeAll
	
	self.CheckEvent = EGUSM.SubscribeUtility.CheckEvent
	self.CheckNetworkEvent = EGUSM.SubscribeUtility.CheckNetworkEvent
	self.CheckConsoleEvent = EGUSM.SubscribeUtility.CheckConsoleEvent
	self.CheckSubscriptions = EGUSM.SubscribeUtility.CheckSubscriptions
	
	self.Destroy = EGUSM.SubscribeUtility.Destroy
	self.UnsubscribeAll = self.Destroy
	
	-- layout: table.function.event = event
	-- for example: self.EventSubs.MyFunction.PostTick = event
	self.EventSubs = {}
	self.NetSubs = {}
	self.ConsoleSubs = {}

end

function EGUSM.SubscribeUtility:EventSubscribe(eventName, optionalFunction)
	local functionName = eventName
	if optionalFunction then functionName = optionalFunction end
		if not self.EventSubs[functionName] then 
			self.EventSubs[functionName] = {}
		else
			local e = self.EventSubs[functionName][eventName]
			if e and e.__type == "Event" and IsValid(e) then
				warn("Event subscription denied:  self."..functionName.." is already subscribed to "..eventName)
				return
			end
		end
	local eventSub = Events:Subscribe(eventName , self , self[optionalFunction] or self[eventName])
	self.EventSubs[functionName][eventName] = eventSub
end

function EGUSM.SubscribeUtility:NetworkSubscribe(netName , optionalFunction)
	local functionName = netName
	if optionalFunction then functionName = optionalFunction end
		if not self.NetSubs[functionName] then 
			self.NetSubs[functionName] = {}
		else
			local e = self.NetSubs[functionName][netName]
			if e and e.__type == "Event" and IsValid(e) then
				warn("Network subscription denied:  self."..functionName.." is already subscribed to "..netName)
				return
			else
				e = nil
			end
		end
	local netSub = Network:Subscribe(netName , self , self[optionalFunction] or self[netName])
	self.NetSubs[functionName][netName] = netSub
end

function EGUSM.SubscribeUtility:ConsoleSubscribe(name , optionalFunction)
	local functionName = Name
	if optionalFunction then functionName = optionalFunction end
		if not self.ConsoleSubs[functionName] then 
			self.ConsoleSubs[functionName] = {}
		else
			local e = self.ConsoleSubs[functionName][name]
			if e and e.__type == "Event" and IsValid(e) then
				warn("Event subscription denied:  self."..functionName.." is already subscribed to "..name)
				return
			else
				e = nil
			end
		end
	local eventSub = Console:Subscribe(name , self , self[optionalFunction] or self[name])
	self.ConsoleSubs[functionName][name] = eventSub
end

function EGUSM.SubscribeUtility:EventUnsubscribe(functionName , optionalEvent)
	if	self.EventSubs[functionName] then
		if optionalEvent then
			if self.EventSubs[functionName][optionalEvent] and IsValid(self.EventSubs[functionName][optionalEvent]) then
				Events:Unsubscribe ( self.EventSubs[functionName][optionalEvent] )
				self.EventSubs[functionName][optionalEvent] = nil
			else
				warn("Can't unsubscribe "..functionName..", "..optionalEvent..", probably already unsubscribed")
			end
		else
			for eventKey, eventSub in pairs (self.EventSubs[functionName]) do
				if IsValid(eventSub) then 
					Events:Unsubscribe ( eventSub )
					self.EventSubs[functionName][eventKey] = nil
					self.EventSubs[functionName] = nil
				else
					warn("Can't unsubscribe "..functionName..", "..eventSub..", probably already unsubscribed")
				end
			end
		end
	end
end

function EGUSM.SubscribeUtility:NetworkUnsubscribe(functionName , optionalNetName)
	if	self.NetSubs[functionName] then
		if optionalNetName then
			if self.NetSubs[functionName][optionalNetName] and IsValid(self.NetSubs[functionName][optionalNetName]) then
				Network:Unsubscribe ( self.NetSubs[functionName][optionalNetName] )
				self.NetSubs[functionName][optionalNetName] = nil
			else
				warn("Can't unsubscribe "..functionName..", "..optionalNetName..", probably already unsubscribed")
			end
		else
			for netKey, netSub in pairs (self.NetSubs[functionName]) do
				if IsValid(netSub) then
					Network:Unsubscribe ( netSub )
					self.NetSubs[functionName][netKey] = nil
					self.NetSubs[functionName] = nil
				else
					warn("Can't unsubscribe "..functionName..", "..netSub..", probably already unsubscribed")	
				end
			end
		end
	end
end

function EGUSM.SubscribeUtility:ConsoleUnsubscribe(functionName , optionalEvent)
	if	self.ConsoleSubs[functionName] then
		if optionalEvent then
			if self.ConsoleSubs[functionName][optionalEvent] and IsValid(self.ConsoleSubs[functionName][optionalEvent]) then
				Console:Unsubscribe ( self.ConsoleSubs[functionName][optionalEvent] )
				self.ConsoleSubs[functionName][optionalEvent] = nil
			else
				warn("Can't unsubscribe "..functionName..", "..optionalEvent..", probably already unsubscribed")
			end
		else
			for eventKey, eventSub in pairs (self.ConsoleSubs[functionName]) do
				if IsValid(eventSub) then 
					Console:Unsubscribe ( eventSub )
					self.ConsoleSubs[functionName][eventKey] = nil
					self.ConsoleSubs[functionName] = nil
				else
					warn("Can't unsubscribe "..functionName..", "..eventSub..", probably already unsubscribed")
				end
			end
		end
	end
end

function EGUSM.SubscribeUtility:EventUnsubscribeAll()
	for functionName,_ in pairs (self.EventSubs) do
			for eventKey, eventSub in pairs (self.EventSubs[functionName]) do
				if IsValid(eventSub) then Events:Unsubscribe ( eventSub ) end
				self.EventSubs[functionName][eventKey] = nil
			end
		self.EventSubs[functionName] = nil
	end
	self.EventSubs = {}	
end

function EGUSM.SubscribeUtility:NetworkUnsubscribeAll()
	for functionName,_ in pairs (self.NetSubs) do
			for netKey, netSub in pairs (self.NetSubs[functionName]) do
				if IsValid(netSub) then Network:Unsubscribe ( netSub ) end
				self.NetSubs[functionName][netKey] = nil
			end
		self.NetSubs[functionName] = nil
	end
	self.NetSubs = {}		
end

function EGUSM.SubscribeUtility:ConsoleUnsubscribeAll()
	for functionName,_ in pairs (self.ConsoleSubs) do
			for eventKey, eventSub in pairs (self.ConsoleSubs[functionName]) do
				if IsValid(eventSub) then Events:Unsubscribe ( eventSub ) end
				self.ConsoleSubs[functionName][eventKey] = nil
			end
		self.ConsoleSubs[functionName] = nil
	end
	self.ConsoleSubs = {}	
end

function EGUSM.SubscribeUtility:CheckEvent(functionName, optionalEvent)
	if	self.EventSubs[functionName] then
		if optionalEvent then
			local e = self.EventSubs[functionName][optionalEvent]
			if e and e.__type == "Event" and IsValid(e) then
				return true
			end
		else
			local e = self.EventSubs[functionName][functionName]
			if e and e.__type == "Event" and IsValid(e) then
				return true
			end
		end
	end
	return false
end

function EGUSM.SubscribeUtility:CheckNetworkEvent(functionName, optionalNetName)
	if	self.NetSubs[functionName] then
		if optionalNetName then
			local e = self.NetSubs[functionName][optionalNetName]
			if e and e.__type == "Event" and IsValid(e) then
				return true
			end
		else
			local e = self.NetSubs[functionName][functionName]
			if e and e.__type == "Event" and IsValid(e) then
				return true
			end
		end
	end
	return false
end

function EGUSM.SubscribeUtility:CheckConsoleEvent(functionName, optionalEvent)
	if	self.ConsoleSubs[functionName] then
		if optionalEvent then
			local e = self.ConsoleSubs[functionName][optionalEvent]
			if e and e.__type == "Event" and IsValid(e) then
				return true
			end
		else
			local e = self.ConsoleSubs[functionName][functionName]
			if e and e.__type == "Event" and IsValid(e) then
				return true
			end
		end
	end
	return false
end

function EGUSM.SubscribeUtility:CheckSubscriptions()
print("active subscriptions :")
	for functionName,_ in pairs (self.EventSubs) do
		for eventKey, eventSub in pairs (self.EventSubs[functionName]) do
			local msg = tostring(eventSub).."  =  "..eventKey..",  self."..functionName
			print(msg)
		end
	end
	for functionName,_ in pairs (self.NetSubs) do
		for netKey, netSub in pairs (self.NetSubs[functionName]) do
			local msg = "Network "..tostring(netSub).."  =  "..netKey..",  self."..functionName
			print(msg)
		end
	end
	for functionName,_ in pairs (self.ConsoleSubs) do
		for eventKey, eventSub in pairs (self.ConsoleSubs[functionName]) do
			local msg = "Console "..tostring(eventSub).."  =  "..eventKey..",  self."..functionName
			print(msg)
		end
	end
end

function EGUSM.SubscribeUtility:Destroy()
	self:EventUnsubscribeAll()
	self:NetworkUnsubscribeAll()
	self:ConsoleUnsubscribeAll()
end
