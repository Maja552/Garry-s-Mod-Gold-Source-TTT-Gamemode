EFFECT.g_sModelIndexBloodSpray = Material("cs16/bloodspray")

function EFFECT:Init(data)
	self.Size = math.Clamp(math.min(data:GetScale() * 2, 255) / 10, 3, 16)
	self.Rotate = math.random(0, 360)
	self.Pos = data:GetOrigin()
	self.Frame = 0
end

function EFFECT:Think()
	self.Frame = self.Frame + FrameTime()

	return self.Frame < 0.25
end

function EFFECT:Render()
	render.SetMaterial(self.g_sModelIndexBloodSpray)
	self.g_sModelIndexBloodSpray:SetInt("$frame", math.Clamp(math.floor(self.Frame * 40), 0, 9))
	render.DrawQuadEasy(self.Pos, -EyeAngles():Forward(), self.Size, self.Size, Color(255, 0, 0, 255), self.Rotate)
end
