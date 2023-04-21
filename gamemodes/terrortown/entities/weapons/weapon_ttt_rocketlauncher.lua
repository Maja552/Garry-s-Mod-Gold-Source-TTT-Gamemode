AddCSLuaFile()

SWEP.HoldType              = "rpg"

if CLIENT then
   SWEP.PrintName          = "rpg_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 85

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "rocketlauncher_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_ak47"
   SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Cone          = 0.022
SWEP.Primary.Ammo          = "RPG_Round"
SWEP.Primary.Caliber       = "new_cs_762"
SWEP.Primary.Sound         = Sound("weapons/rocketfire1.wav")

SWEP.Primary.Damage			= 50
SWEP.Primary.Recoil			= -5
SWEP.Primary.Delay			= 1.5
SWEP.Primary.ClipSize 		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.MaxAmmo		= 5
SWEP.Primary.Automatic		= true

SWEP.Secondary.Delay		= 1
SWEP.Secondary.Automatic	= true

SWEP.HeadshotMultiplier    = 3

SWEP.ReloadTime			= 2
SWEP.UnloadTime			= 2
SWEP.UnloadAnimSpeed	= -.75

SWEP.DeploySpeed         = 2

SWEP.Kind                  = WEAPON_EQUIP
SWEP.WeaponID              = AMMO_RPG

SWEP.AmmoEnt             = "item_ammo_new_762_auto_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/hl1/c_rpg.mdl"
SWEP.WorldModel            = "models/hl1/p_rpg.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.BSPLocked = true

SWEP.TPReloadAnim		= ACT_HL2MP_GESTURE_RELOAD_SMG1

function SWEP:AcceptInput(name, activator)
	if name == "UnlockWeapon" then
		self.BSPLocked = false
		return true
	elseif name == "LockWeapon" then
		self.BSPLocked = true
		return true
	end
 end

function SWEP:InsertSound(sndtype, pos, volume, duration)
	if CLIENT then return end
	sndtype = sndtype or 1
	pos = pos or self.Owner:GetShootPos()
	volume = volume or 600
	duration = duration or 3

	if !IsValid(self.aiSoundEnt) then
		self.aiSoundEnt = ents.Create("ai_sound")
		local ent = self.aiSoundEnt
		ent:SetPos(pos)
		ent:Spawn()
		ent:SetKeyValue("soundtype", sndtype)
		ent:SetKeyValue("volume", volume)
		ent:SetKeyValue("duration", duration)
		ent:Activate()
		SafeRemoveEntityDelayed(ent, duration)
	end
	if IsValid(self.aiSoundEnt) then
		self.aiSoundEnt:SetPos(pos)
		self.aiSoundEnt:Fire("EmitAISound")
	end
end

function SWEP:WeaponSound(snd, lvl, pitch)
	snd = snd or self.Primary.Sound or self.PrimarySounds[math.random(1, #self.PrimarySounds)]
	lvl = lvl or 100
	pitch = pitch or 100
	self:EmitSound(snd, lvl, pitch, 1)
	if lvl >= 100 then
		self:InsertSound(1, self.Owner:GetShootPos(), 600, 3)
	end
end

SWEP.SetAmmo2 = false

function SWEP:Deploy()
	if !self.SetAmmo2 then
		self.Owner:SetAmmo(1, "RPG_Round")
		self.SetAmmo2 = true
	end

   return self.BaseClass.Deploy(self)
end

function SWEP:rgAmmo()
	return self:Ammo1()
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "iPlayEmptySound")
	self:NetworkVar("Bool", 1, "InZoom")
	self:NetworkVar("Bool", 2, "BlockAutoReload")
	self:NetworkVar("Float", 0, "WeaponIdleTime")
	self:NetworkVar("Float", 1, "ReloadTime")
	self:NetworkVar("Float", 10, "UnloadTime")
	self:NetworkVar("Int", 0, "InAttack")
	self:SpecialDT()
end

function SWEP:SpecialDT()
	self:NetworkVar("Entity", 0, "RocketEntity")
	self:NetworkVar("Entity", 1, "SpotEntity")
end

function SWEP:DefReload(anim, fDelay)
	anim = anim or ACT_VM_RELOAD
	fDelay = fDelay or self.ReloadTime
	if self.Owner:IsNPC() then
		self:DefaultReload(ACT_VM_RELOAD)
		self:SetClip1(self:Clip1() + self.Primary.ClipSize)
		return
	end
	if self:GetReloadTime() >= CurTime() or self:rgAmmo() <= 0 or self:Clip1() >= self.Primary.ClipSize then return end
	if self.Owner.HL1ReloadSpeed then fDelay = fDelay / self.Owner.HL1ReloadSpeed end
	self:SetReloadTime(CurTime() + fDelay)
	self:SendWeaponAnim(anim)
	if self.Owner.HL1ReloadSpeed then self.Owner:GetViewModel():SetPlaybackRate(1 * self.Owner.HL1ReloadSpeed) end
	self.Owner:SetAnimation(PLAYER_RELOAD)
	self:SetWeaponIdleTime(CurTime() + 3)
	self:SetBlockAutoReload(false)
	return true
end

function SWEP:Reload()
	if self:Clip1() >= 1 or self:rgAmmo() <= 0 then
		return
	end
	
	self:SetNextPrimaryFire(CurTime() + .5)
	
	if self:IsRocketActive() && self:IsSpotActive() then
		return
	end
	
	if self:IsSpotActive() then
		if SERVER then self:GetSpotEntity():Suspend(2.1) end
		self:SetNextSecondaryFire(CurTime() + 2.1)
	end
	
	local iResult
	
	if self:Clip1() == 0 then
		iResult = self:DefReload()
	end

	if iResult then
		self:SetWeaponIdleTime(CurTime() + math.Rand(10, 15))
	end
end

function SWEP:IsSpotActive()
	local spotEnt = self:GetSpotEntity()
	return spotEnt && IsValid(spotEnt) && spotEnt.GetDrawLaser && spotEnt:GetDrawLaser()
end

function SWEP:IsRocketActive()
	local rocketEnt = self:GetRocketEntity()
	return IsValid(rocketEnt) && !rocketEnt.didHit
end

function SWEP:Holster(wep)
	if self:IsRocketActive() && self:IsSpotActive() then
		return false
	end
	self:SetReloadTime(0)
	local spotEnt = self:GetSpotEntity()
	if IsFirstTimePredicted() and IsValid(spotEnt) then
		spotEnt:SetNoDraw(true)
	end
	return true
end

function SWEP:OnRemove()
	local spotEnt = self:GetSpotEntity()
	if SERVER and IsValid(spotEnt) then
		spotEnt:Remove()
	end
end

function SWEP:OnDrop()
	self:OnRemove()
end

function SWEP:SendRecoil(angle)
	if !self.GoldSrcRecoil or self.Owner:IsNPC() then return end
	if angle == 1 then angle = Angle(self.Secondary.Recoil + math.Rand(self.Secondary.RecoilRandom[1], self.Secondary.RecoilRandom[2]), 0, 0) end
	angle = angle or Angle(self.Primary.Recoil + math.Rand(self.Primary.RecoilRandom[1], self.Primary.RecoilRandom[2]), 0, 0)
	if self.CrouchAccuracyMul and self.Owner:OnGround() and self.Owner:Crouching() then
		angle = angle * self.CrouchAccuracyMul
	end
	if game.SinglePlayer() and SERVER then
		net.Start("HL1punchangle")
		net.WriteEntity(self.Owner)
		net.WriteAngle(angle)
		net.Send(self.Owner)
	end
	if CLIENT then
		if IsFirstTimePredicted() then
			self.Owner.punchangle = angle
		end
	else
		self.Owner.punchangle = angle
	end
end

function SWEP:TakeClipPrimary(num)
	num = num or 1

	if self.Owner:IsNPC() then
		if self.Primary.ClipSize > -1 then
			self:TakePrimaryAmmo(num)
		end
		return
	end

	self:TakePrimaryAmmo(num)
end



function SWEP:PlayEmptySound()
end

function SWEP:PrimaryAttack()
	if CLIENT or !self:CanPrimaryAttack() then return end

	if self:Clip1() > 0 then		
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:WeaponSound()
		
		self.Owner:EmitSound("gsttt/rocketfire2.wav")

		local ang = self.Owner:GetAimVector():Angle()
		local vecSrc = self.Owner:GetShootPos() + ang:Forward() * 16 + ang:Right() * 8 - ang:Up() * 8

		if SERVER then
			self:SetRocketEntity(ents.Create("ttt_hl1_rpg_rocket"))
			local pRocket = self:GetRocketEntity()
			if IsValid(pRocket) then
				pRocket:SetPos(vecSrc)
				pRocket:SetAngles(ang)
				pRocket:Spawn()
				pRocket.pLauncher = self
				--pRocket.pLauncher.m_cActiveRockets = m_cActiveRockets + 1
				pRocket:SetOwner(self.Owner)
				pRocket:SetLocalVelocity(pRocket:GetVelocity() + self.Owner:GetForward() * self.Owner:GetVelocity():Dot(self.Owner:GetForward()))
			end
		end
		
		self:SendRecoil()
		self:TakeClipPrimary()
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetWeaponIdleTime(CurTime() + 1.5)
	else
		self:PlayEmptySound()
	end
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsNPC() and self:GetNextPrimaryFire() > CurTime() then return false end
	if self:GetReloadTime() >= CurTime() then return false end
	return true
end

function SWEP:SecondaryAttack()
	if !self:CanPrimaryAttack() then return end
	
	local spotEnt = self:GetSpotEntity()
	if !IsValid(spotEnt) then
		self:UpdateSpot()
	elseif IsFirstTimePredicted() then
		if spotEnt:GetDrawLaser() then
			spotEnt:SetDrawLaser(false)
		else
			spotEnt:SetDrawLaser(true)
			spotEnt:SetPos(self.Owner:GetEyeTrace().HitPos)
		end
	end
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:UpdateSpot()
	if !IsValid(self:GetSpotEntity()) then
		if SERVER then self:SetSpotEntity(ents.Create("ent_hl1_laser_spot")) end
		local spotEnt = self:GetSpotEntity()
		if IsValid(spotEnt) then
			spotEnt:SetPos(self.Owner:GetEyeTrace().HitPos)
			spotEnt:SetOwner(self.Owner)
			spotEnt:Spawn()
			spotEnt:SetDrawLaser(true)
		end
	end
	if SERVER and IsValid(self:GetSpotEntity()) and self:GetSpotEntity():GetDrawLaser() then
		self:GetSpotEntity():SetNoDraw(false)
		self:GetSpotEntity():SetPos(self.Owner:GetEyeTrace().HitPos)
	end
end

function SWEP:SpecialThink()
	self:UpdateSpot()
	self:ResetEmptySound()
end

function SWEP:WeaponIdle()
	local iAnim
	local flRand = util.SharedRandom("flRand", 0, 1)
	if flRand <= 0.75 || self:IsSpotActive() then
		if self:Clip1() <= 0 then
			iAnim = ACT_RPG_IDLE_UNLOADED
		else
			iAnim = ACT_VM_IDLE
		end
	else
		if self:Clip1() <= 0 then
			iAnim = ACT_RPG_FIDGET_UNLOADED
		else
			iAnim = ACT_VM_FIDGET
		end
	end
	self:SendWeaponAnim(iAnim)
	self:SetWeaponIdleTime(CurTime() + 6)
end

function SWEP:ResetEmptySound()
	if self:GetiPlayEmptySound() or self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) then return end
	self:SetiPlayEmptySound(true)
end

function SWEP:ReloadPreEnd()
end

function SWEP:ReloadEnd()
end


function SWEP:Think()	
	if game.SinglePlayer() and CLIENT then return end
	
	if SERVER then
		local PMpunchangle = self.Owner.punchangle
		if PMpunchangle and PMpunchangle != Angle() then
			HL1_DropPunchAngle(FrameTime(), PMpunchangle)
		end
	end	
	
	self:SpecialThink()

	local reload = self:GetReloadTime()
	if reload > 0 then
		if reload <= CurTime() then
			self:SetReloadTime(0)
			self:ReloadPreEnd()
			if cvars.Bool("hl1_sv_unlimitedammo") then
				self:SetClip1(self.Primary.ClipSize)
			else
				local clip = self:Clip1()
				self:SetClip1(math.min((self:Ammo1() + clip), self.Primary.ClipSize))
				self.Owner:RemoveAmmo(self.Primary.ClipSize - clip, self.Primary.Ammo)
			end
			self:ReloadEnd()
		else
			return
		end
	end
	
	if self.AutoReload and !self:GetBlockAutoReload() and IsValid(self.Owner) and self.Owner:Alive() and self:Clip1() <= 0 and self:rgAmmo() > 0 and self:GetNextPrimaryFire() <= CurTime() and self.Primary.ClipSize > 0 then
		self:Reload()
	end
	
	local unload = self:GetUnloadTime()
	if unload > 0 and unload <= CurTime() then
		self:SetBlockAutoReload(true)
		local clip = self:Clip1()
		self:SetClip1(0)
		if SERVER then self.Owner:GiveAmmo(clip, self.Primary.Ammo, true) end
		self:SetUnloadTime(0)
		self:WeaponIdle(true)
	end
	
	local idle = self:GetWeaponIdleTime()
	if idle > 0 and idle <= CurTime() then
		self:WeaponIdle()
	end
end
