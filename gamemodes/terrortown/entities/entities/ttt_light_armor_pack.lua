---- Health dispenser

AddCSLuaFile()

if CLIENT then
   -- this entity can be DNA-sampled so we need some display info
   ENT.Icon = "vgui/ttt/icon_armor_pack"
   ENT.PrintName = "light_armor_pack_name"

   local GetPTranslation = LANG.GetParamTranslation

   ENT.TargetIDHint = {
      name = "light_armor_pack_name",
      hint = "light_armor_pack_hint",
      fmt  = function(ent, txt)
                return GetPTranslation(txt,
                                       { usekey = Key("+use", "USE"),
                                         num    = ent:GetPacksLeft() or 0 })
             end
   };

end

ENT.Type = "anim"
ENT.Model = Model("models/cs16/items/w_kevlar.mdl")

ENT.CanHavePrints = true


AccessorFuncDT(ENT, "PacksLeft", "PacksLeft")

AccessorFunc(ENT, "Placer", "Placer")

function ENT:SetupDataTables()
   self:DTVar("Int", 0, "PacksLeft")
end

function ENT:Initialize()
   self:SetModel(self.Model)

   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_VPHYSICS)

   if SERVER then
      self:SetMaxHealth(200)

      local phys = self:GetPhysicsObject()
      if IsValid(phys) then
         phys:SetMass(100)
      end

      self:SetUseType(SIMPLE_USE)
   end

   self:SetHealth(200)
   self:SetPacksLeft(3)
   self:SetPlacer(nil)
   self.NextHeal = 0
   self.fingerprints = {}
end

function ENT:TakeFromStorage(amount)
   -- if we only have 5 healthpts in store, that is the amount we heal
   amount = math.min(amount, self:GetPacksLeft())
   self:SetPacksLeft(math.max(0, self:GetPacksLeft() - amount))
   return amount
end

function ENT:Use(ply)
   if IsValid(ply) and ply:IsPlayer() and ply:IsActive() and !ply.has_light_armor and !ply:IsDetective() then
      ply.has_light_armor = true
      ply:EmitSound("cstrike/items/tr_kevlar.wav")

      self:SetPacksLeft(self:GetPacksLeft() - 1)

      if self:GetPacksLeft() < 1 then
         self:Remove()
      end
   end
end

if SERVER then
   local ttt_damage_own_healthstation = CreateConVar("ttt_damage_own_healthstation", "0")
   function ENT:OnTakeDamage(dmginfo)
      if dmginfo:GetAttacker() == self:GetPlacer() and not ttt_damage_own_healthstation:GetBool() then return end
   
      self:TakePhysicsDamage(dmginfo)
      self:SetHealth(self:Health() - dmginfo:GetDamage())

      local att = dmginfo:GetAttacker()
      local placer = self:GetPlacer()
      if IsPlayer(att) then
         DamageLog(Format("DMG: \t %s [%s] damaged light armor pack [%s] for %d dmg", att:Nick(), att:GetRoleString(),  (IsPlayer(placer) and placer:Nick() or "<disconnected>"), dmginfo:GetDamage()))
      end

      if self:Health() < 0 then
         self:Remove()

         util.EquipmentDestroyed(self:GetPos())
      end
   end
end
