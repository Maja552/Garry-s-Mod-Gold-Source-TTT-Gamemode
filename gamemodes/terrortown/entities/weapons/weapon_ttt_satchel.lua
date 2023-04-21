AddCSLuaFile()

SWEP.HoldType              = "slam"

if CLIENT then
   SWEP.PrintName          = "satchel_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "satchel_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_satchel"
   SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.ThrowEntity		= "ttt_monster_satchel"

SWEP.Primary.Delay			= 1
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.MaxAmmo		   = 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			   = "Satchel"
SWEP.Primary.Caliber       = "new_cs_45"

SWEP.Secondary.Delay		   = .5
SWEP.Secondary.Automatic	= true

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_TRAITOR}
SWEP.WeaponID              = AMMO_SATCHEL

SWEP.UseHands              = true

SWEP.CModelSatchel      = Model("models/hl1/c_satchel.mdl")
SWEP.CModelRadio        = Model("models/hl1/c_satchel_radio.mdl")
SWEP.VModelSatchel      = Model("models/v_satchel.mdl")
SWEP.VModelRadio		= Model("models/v_satchel_radio.mdl")

SWEP.ModelSatchelView	= SWEP.CModelSatchel
SWEP.ModelRadioView		= SWEP.CModelRadio

SWEP.EntModel			= Model("models/w_satchel.mdl")
SWEP.PlayerModel		= Model("models/hl1/p_satchel.mdl")

SWEP.ViewModel			= SWEP.ModelSatchelView
SWEP.WorldModel	   = SWEP.PlayerModel

function SWEP:Think()
   if SERVER and self:GetNextPrimaryFire() < CurTime() and self:GetInAttack() == 2 then
      self:Remove()
      return
   end
   self.BaseClass:Think()
end

function SWEP:rgAmmo()
	if !IsValid(self.Owner) then return -1 end
   return self:Ammo1()
end

function SWEP:TakeClipPrimary(num)
	num = num or 1

	if self.Owner:IsNPC() then
		if self.Primary.ClipSize > -1 then
			self:TakePrimaryAmmo(num)
		end
		return
	end

	if self.Primary.ClipSize > -1 then
		if !cvars.Bool("hl1_sv_unlimitedclip") then
			self:TakePrimaryAmmo(num)
		end
	else
		if !cvars.Bool("hl1_sv_unlimitedammo") then
			self:TakePrimaryAmmo(num)
		end
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "iPlayEmptySound")
	self:NetworkVar("Bool", 1, "InZoom")
	self:NetworkVar("Bool", 2, "BlockAutoReload")
	self:NetworkVar("Float", 0, "WeaponIdleTime")
	self:NetworkVar("Float", 1, "ReloadTime")
	self:NetworkVar("Float", 10, "UnloadTime")
	self:NetworkVar("Int", 0, "InAttack")
end

function SWEP:SpecialDeploy()
	if self:GetInAttack() == 1 then
		self.ViewModel = self.ModelRadioView
	else
		self.ViewModel = self.ModelSatchelView
	end
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Holster(wep)
	if SERVER and self:rgAmmo() <= 0 and self:GetInAttack() != 1 then
		self.Owner = self:GetOwner()
		self.Owner:StripWeapon(self:GetClass())
		return true
	end
	if self:GetInAttack() == 2 then return false end
	return true
end

function SWEP:PrimaryAttack()
	if self:GetInAttack() == 0 then
		self:Throw()
	elseif self:GetInAttack() == 1 then
		self.Owner:GetViewModel():SendViewModelMatchingSequence(3)
		local sphere = ents.FindInSphere(self.Owner:GetPos(), 4096)
		for _, ent in pairs(sphere) do
			if IsValid(ent) and ent:GetClass() == self.ThrowEntity and ent:GetOwner() == self.Owner then
				ent:Detonate()
			end
		end
		self:SetInAttack(2)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
		self:SetWeaponIdleTime(CurTime() + self.Primary.Delay)
	else
		-- we're reloading, don't allow fire
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:Throw()
	if self:rgAmmo() > 0 then
		local vecSrc = self.Owner:WorldSpaceCenter()
		local ang = self.Owner:GetAimVector():Angle()		
		local vecThrow = ang:Forward() * 274 + self.Owner:GetVelocity()
		
		if SERVER then
			local pSatchel = ents.Create(self.ThrowEntity)
			if IsValid(pSatchel) then
				pSatchel:SetPos(vecSrc)
				pSatchel:SetOwner(self.Owner)
				pSatchel:SetVelocity(vecThrow)
				pSatchel:SetLocalAngularVelocity(Angle(0,400,0))
				pSatchel:Spawn()
			end
		end
		
		self.ViewModel = self.ModelRadioView
		local vm = self.Owner:GetViewModel()
		vm:SetWeaponModel(self.ViewModel, self)
		
		self.Owner:GetViewModel():SendViewModelMatchingSequence(self:LookupSequence("draw"))
		
		self.Owner:SetAnimation(PLAYER_ATTACK1)	
		
		self:SetInAttack(1)
		self:TakeClipPrimary()
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	end
end

function SWEP:WeaponIdle()
	if self:GetInAttack() == 2 then
		self.ViewModel = self.ModelSatchelView
		local vm = self.Owner:GetViewModel()
		vm:SetWeaponModel(self.ViewModel, self)
		self:SetInAttack(0)
		if self:rgAmmo() <= 0 then
			self:RetireWeapon()
			return
		end
		self.Owner:GetViewModel():SendViewModelMatchingSequence(self:LookupSequence("draw"))
		self:SetNextPrimaryFire(CurTime() + .5)
		self:SetNextSecondaryFire(CurTime() + .5)
	else
		self:SendWeaponAnim(ACT_VM_FIDGET)		
	end
	self:SetWeaponIdleTime(CurTime() + math.Rand(10, 15))
end

function SWEP:OnRemove()
	if !game.SinglePlayer() and SERVER then
		local pFind = ents.FindByClass(self.ThrowEntity)
		for _, pSatchel in pairs(pFind) do
			if pSatchel and IsValid(pSatchel) and pSatchel:GetOwner() == self.Owner then
				pSatchel:Deactivate()
			end
		end
	end
end

if SERVER then return end

function SWEP:ViewModelHide(pos, ang, vm)
	return IsValid(vm) and vm:GetModel() == self.ModelSatchelView and self:GetInAttack() != 1 and pos - ang:Forward() * 40 or pos
end