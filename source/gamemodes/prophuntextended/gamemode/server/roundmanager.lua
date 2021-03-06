--[[
	The MIT License (MIT)
	
	Copyright (c) 2015-2018 Xaymar

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
--]]

local roundManagerDef = {}
roundManagerDef.__index = roundManagerDef

function roundManagerDef:__construct()
	self.State = nil
	self.NextState = nil
end

function roundManagerDef:GetState()
	return self.State
end

function roundManagerDef:GetNextState()
	return self.NextState
end

function roundManagerDef:SetState(state)
	self.NextState = state
end

function roundManagerDef:Tick(...) 
	if (self.State != nil) then
		if (self.State.Tick != nil) then
			self.State:Tick(...)
		end
	end
	
	-- Advance States
	if (self.NextState != self.State) then
		-- Call OnLeave(NewState)
		if (self.State != nil) then
			if (self.State.OnLeave != nil) then
				self.State:OnLeave(self.NextState)
			end
			
			-- Run Hook
			hook.Run("RoundManagerLeaveState", self.State.Name)			
		end
		
		-- Call OnEnter(OldState)
		if (self.NextState != nil) then		
			if (self.NextState.OnEnter != nil) then
				self.NextState:OnEnter(self.State)
			end
			
			-- Run Hook
			hook.Run("RoundManagerEnterState", self.NextState.Name)
		end
		
		-- Set State
		self.State = self.NextState
	end
end

function roundManager(initialState)
	local obj = {}
	obj.__index = obj
	setmetatable(obj, roundManagerDef)
	obj:__construct()
	obj:SetState(initialState)	
	return obj
end
