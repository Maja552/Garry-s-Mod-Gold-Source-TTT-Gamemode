EFFECT.g_sModelIndexSmoke = Material("cs16/steam1")

function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Frame = 0
	self.SmokeZ = 0

	self:SetRenderBoundsWS(data:GetOrigin(), self.Pos, Vector(1024, 1024, 1024))
end

function EFFECT:Think()
	self.Frame = self.Frame + FrameTime()

	return self.Frame < 2
end

function EFFECT:Render()
	if !self.SmokeNextChange or CurTime() >= self.SmokeNextChange then	
		self.SmokeZ = self.SmokeZ + 50
		self.SmokeNextChange = CurTime() + 1
	end
	
	render.SetMaterial(self.g_sModelIndexSmoke)
	self.g_sModelIndexSmoke:SetInt("$frame", math.Clamp(math.floor(self.Frame * 8), 0, 15))
	render.DrawSprite(self.Pos + Vector(0, 0, self.SmokeZ), 1500, 1500, Color(0, 0, 0, 255))
end