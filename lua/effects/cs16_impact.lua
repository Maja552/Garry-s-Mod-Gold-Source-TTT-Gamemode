function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter(pos)
	local diff = LocalPlayer():GetShootPos():Distance(pos)
	local size = math.Clamp(diff / 450, 0, 4)

	if size < 1 then emitter:Finish() return end
	
	for i = 1, 6 do
		local particle = emitter:Add("particle2", pos + Vector(0, 0, 5))
		particle:SetVelocity(VectorRand() * 64)
		particle:SetVelocityScale(2)
		particle:SetGravity(Vector(0, 0, -1000))
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(size)
		particle:SetEndSize(size)
		particle:SetColor(0, 0, 0)
		particle:SetLighting(false)
		particle:SetThinkFunction(function(p)
			local diff = LocalPlayer():GetShootPos():Distance(p:GetPos())

			local size = math.Clamp(diff / 450, 0, 4)
			p:SetStartSize(size)
			p:SetEndSize(size)
			p:SetNextThink(CurTime() + .1)
		end)
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end