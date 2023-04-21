function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local dir = data:GetNormal()
	local hitgroup = data:GetMagnitude()
	local amount = data:GetScale() + math.random(0, 100)

	local emitter = ParticleEmitter(pos)
	local arc = 0.05
	local speedCopy = amount
	
	dir:Normalize()
	for i = 1, 100 do
		local dirCopy = dir
		dirCopy.z = dirCopy.z - arc
		dirCopy:Normalize()
		arc = arc - 0.005
		
		local particle = emitter:Add("particle3", pos)
		particle:SetCollide(true)
		particle:SetVelocity((dirCopy * speedCopy) + VectorRand() * 2)
		particle:SetGravity(Vector(0, 0, -800))
		particle:SetDieTime(2)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(1)
		particle:SetEndSize(1)
		particle:SetColor(150 * math.Rand(0.7, 1), 0, 0)

		speedCopy = speedCopy - 0.00001
	end

	arc = 0.075
	local num = 0
	for i = 1, (amount/5) do
		local dirCopy = dir
		dirCopy.z = dirCopy.z - arc
		dirCopy:Normalize()
		arc = arc - 0.005
		
		num = math.Rand(0, 1)
		speedCopy = amount * num
		num = num * 1.7
		
		local particle = emitter:Add("particle3", pos)
		particle:SetCollide(true)
		particle:SetVelocity((dirCopy * num) * speedCopy)
		particle:SetAirResistance(100)
		particle:SetGravity(Vector(0, 0, -800))
		particle:SetDieTime(3)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(1)
		particle:SetEndSize(1)
		particle:SetColor(150 * math.Rand(0.7, 1), 0, 0)

		for i = 1, 2 do
			local dirCopy = dir
			dirCopy.z = dirCopy.z - arc
			dirCopy:Normalize()

			local particle = emitter:Add("particle3", pos + Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)))
			particle:SetCollide(true)
			particle:SetVelocity((dirCopy * num) * speedCopy)
			particle:SetAirResistance(100)
			particle:SetGravity(Vector(0, 0, -800))
			particle:SetDieTime(3)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(1)
			particle:SetEndSize(1)
			particle:SetColor(100, 0, 0)
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end