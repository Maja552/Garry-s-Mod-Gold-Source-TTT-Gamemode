AddCSLuaFile()

SWEP.HoldType              = "slam"

if CLIENT then
   SWEP.PrintName          = "svest_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "svest_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_svest"
   SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.ViewModel  = Model("models/hl1/c_satchel_radio.mdl")
SWEP.WorldModel = Model("models/cs/p_c4.mdl")

SWEP.Primary.Delay			= 1
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.MaxAmmo		= 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "svest_ammo"
SWEP.Primary.Caliber        = "new_cs_45"

SWEP.Secondary.Delay		= .5
SWEP.Secondary.Automatic	= true

SWEP.Kind      = WEAPON_EQUIP
SWEP.CanBuy    = {ROLE_TRAITOR}
SWEP.WeaponID  = AMMO_SVEST

SWEP.UseHands  = true

SWEP.ExplosionSounds = {
	Sound("hl1/weapons/explode3.wav"),
	Sound("hl1/weapons/explode4.wav"),
	Sound("hl1/weapons/explode5.wav")
}

SWEP.IsExploding = false
SWEP.NextExplosion = 0

function SWEP:Think()
	if self.IsExploding and self.NextExplosion < CurTime() then
		self:Explode()
	end
end

function SWEP:Explode()
	if SERVER then
		self.Owner:EmitSound(self.ExplosionSounds[math.random(1,3)], 400, 100, 1, CHAN_ITEM)
		util.BlastDamage(self, self.Owner, self.Owner:GetPos() + Vector(0,0,40), 180, 90)
	end

	local explosion = EffectData()
	explosion:SetOrigin(self:GetPos() + Vector(0,0,70))
	explosion:SetScale(33)
	explosion:SetFlags(1)

	util.Effect("hl1_explosion", explosion)
	util.Effect("hl1_explosionsmoke", explosion)


	if SERVER then
		if self.Owner:Alive() then
			self.Owner:Kill()
		end
		self:Remove()
	end
end

function SWEP:PrimaryAttack()
	if self.IsExploding == false then
		self.IsExploding = true
		self.NextExplosion = CurTime() + 1.45

		if SERVER then
			self.Owner:EmitSound("gsttt/habib.wav", 50, 100, 0.6)
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		self:PrimaryAttack()
	end
end

