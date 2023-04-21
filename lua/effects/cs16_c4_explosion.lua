EFFECT.g_sModelIndexFireball = Material("cs16/zerogxplode")
EFFECT.g_sModelIndexFireball3 = Material("cs16/fexplo")
EFFECT.g_sModelIndexFireball3_2 = Material("cs16/fexplo")
EFFECT.g_sModelIndexFireball2 = Material("cs16/eexplo")
EFFECT.g_sModelIndexSmoke = Material("cs16/steam1")

function EFFECT:Init(data)
	self.Pos = data:GetOrigin()

	self:SetRenderBoundsWS(data:GetOrigin(), self.Pos, Vector(1024, 1024, 1024))

	self.Pos2 = Vector(math.Rand(-512, 512), math.Rand(-512, 512), math.Rand(-10, 10))
	self.Pos3 = Vector(math.Rand(-512, 512), math.Rand(-512, 512), math.Rand(-10, 10))
	self.Pos4 = Vector(math.Rand(-512, 512), math.Rand(-512, 512), math.Rand(-10, 10))
	self.Frame = 0

	local light = DynamicLight(data:GetEntity():EntIndex())
	light.pos = self.Pos
	light.r = 255
	light.g = 100
	light.b = 10
	light.brightness = 3
	light.Decay = 2 ^ 9
	light.Size = 256
	light.DieTime = CurTime() + 0.4
end

function EFFECT:Think()
	self.Frame = self.Frame + FrameTime()

	return self.Frame < 1
end

function EFFECT:Render()
	render.SetMaterial(self.g_sModelIndexFireball3)
	self.g_sModelIndexFireball3:SetInt("$frame", math.Clamp(math.floor(self.Frame * 150), 0, 29))
	render.DrawSprite(self.Pos - Vector(0, 0, 10), 1350 * 0.5, 1350, Color(255, 255, 255, 255))

	render.SetMaterial(self.g_sModelIndexFireball2)
	self.g_sModelIndexFireball2:SetInt("$frame", math.Clamp(math.floor(self.Frame * 150), 0, 24))
	render.DrawSprite(self.Pos + self.Pos2, 1350, 1350, Color(255, 255, 255, 255))

	render.SetMaterial(self.g_sModelIndexFireball3_2)
	self.g_sModelIndexFireball3_2:SetInt("$frame", math.Clamp(math.floor(self.Frame * 150), 0, 29))
	render.DrawSprite(self.Pos + self.Pos3, 1350 * 0.5, 1350, Color(255, 255, 255, 255))

	render.SetMaterial(self.g_sModelIndexFireball)
	self.g_sModelIndexFireball:SetInt("$frame", math.Clamp(math.floor(self.Frame * 17), 0, 14))
	render.DrawSprite(self.Pos + self.Pos4, 1350, 1350, Color(255, 255, 255, 255))
end