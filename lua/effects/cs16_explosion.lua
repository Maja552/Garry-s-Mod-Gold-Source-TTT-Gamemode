EFFECT.g_sModelIndexFireball3 = Material("cs16/fexplo")
EFFECT.g_sModelIndexFireball2 = Material("cs16/eexplo")
EFFECT.g_sModelIndexSmoke = Material("cs16/steam1")

function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	local tracedata = {}
	local m_pTrace
	tracedata.start = self.Pos
	tracedata.endpos = self.Pos + Vector(0, 0, -32)
	tracedata.filter = self
	tracedata.mask = MASK_SOLID
	m_pTrace = util.TraceLine(tracedata)

	if m_pTrace.Fraction != 1 then
		self.Pos = m_pTrace.HitPos + (m_pTrace.HitNormal * (100 - 24) * 0.6)
	end

	self.Pos2 = Vector(math.Rand(-64, 64), math.Rand(-64, 64), math.Rand(30, 35))
	self.Frame = 0

	local light = DynamicLight( data:GetEntity():EntIndex() )
	light.pos = self.Pos
	light.r = 255
	light.g = 100
	light.b = 10
	light.brightness = 3
	light.Decay = 2 ^ 9
	light.Size = 300
	light.DieTime = CurTime() + 1
end

function EFFECT:Think()
	self.Frame = self.Frame + FrameTime()

	return self.Frame < 1
end

function EFFECT:Render()
	render.SetMaterial(self.g_sModelIndexFireball3)
	self.g_sModelIndexFireball3:SetInt("$frame", math.Clamp(math.floor(self.Frame * 30), 0, 29))
	render.DrawSprite(self.Pos + Vector(0, 0, 20), 160, 320, Color(255, 255, 255, 255))

	render.SetMaterial(self.g_sModelIndexFireball2)
	self.g_sModelIndexFireball2:SetInt("$frame", math.Clamp(math.floor(self.Frame * 30), 0, 24))
	render.DrawSprite(self.Pos + self.Pos2, 300, 300, Color(255, 255, 255, 255))
end