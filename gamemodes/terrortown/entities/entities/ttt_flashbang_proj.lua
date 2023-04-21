
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/cs/w_flashbang.mdl")


AccessorFunc(ENT, "radius", "Radius", FORCE_NUMBER)

function ENT:Initialize()
   if not self:GetRadius() then self:SetRadius(20) end

   if SERVER then
      self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
      self.Entity:SetSolid(SOLID_VPHYSICS)
      self.Entity:PhysicsInit(SOLID_VPHYSICS)
      self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
      self.Entity:DrawShadow(false)
   end

   return self.BaseClass.Initialize(self)
end

function ENT:IsPlayerLooking(ply)
   local aimvec = ply:GetAimVector()
   local yes = (aimvec:Dot((self:GetPos() - ply:GetPos() + Vector(70)):GetNormalized()))
   --print(ply, yes, aimvec)
   return yes > 0.2
end

function ENT:TracesToPlayer(ply)
   local endposition = ply:GetPos() + Vector(0,0,40)
   local filters = {self}

   for k,v in pairs(player.GetAll()) do
      if v != ply then
         table.ForceInsert(filters, v)
      end
   end

   local traces = {
      {start = self:GetPos(), endpos = endposition, filter = filters},
      {start = self:GetPos() + Vector(0,0,25), endpos = endposition, filter = filters},
      {start = self:GetPos() + Vector(0,0,50), endpos = endposition, filter = filters},
      {start = self:GetPos() + Vector(0,30,15), endpos = endposition, filter = filters},
      {start = self:GetPos() + Vector(30,0,15), endpos = endposition, filter = filters},
   }

   for k,v in pairs(traces) do
      local tr = util.TraceLine(v)
      --print(ply, tr.Entity, tr.Hit)
      if tr.Entity == ply then
         return true
      end
   end
   return false
end

function ENT:Explode()
   if SERVER then
      self.Entity:EmitSound("Weapon_CS_Flashbang.Explode")

      for _, pl in pairs(player.GetAll()) do
         if self:TracesToPlayer(pl) and (pl:GetPos():Distance(self:GetPos()) < 100 or self:IsPlayerLooking(pl)) then
            local dist = pl:GetShootPos():Distance(self:GetPos())  
            local endtime = 5000 / dist
            if endtime > 8 then
               endtime = 8
            else
               if endtime < 1 then
                  endtime = 0
               end
            end
            simpendtime = math.floor(endtime)
            tenthendtime = math.floor((endtime - simpendtime) * 10)
            net.Start("ttt_flashbang_effect")
               net.WriteInt(CurTime() + endtime, 16)
            net.Send(pl)
         end
      end
   else
      local light = DynamicLight(self:EntIndex())
      light.Pos = self.Entity:GetPos()
      light.r = 255
      light.g = 255
      light.b = 255
      light.Brightness = 5
      light.Size = 512
      light.Decay = 1000
      light.DieTime = CurTime() + 0.1
   end

   if SERVER then
      self:Remove()
   end
end

if CLIENT then
   ttt_fbe = 0

   net.Receive("ttt_flashbang_effect", function()
      ttt_fbe = net.ReadInt(16)
   end)

   function FlashEffect()
      if ttt_fbe > CurTime() then
         local Alpha
         if ttt_fbe - CurTime() > 7 then
            Alpha = 255
         else
            local FlashAlpha = 1 - (CurTime() - ttt_fbe + 7) / 7
            Alpha = FlashAlpha * 255
         end

         DrawMotionBlur(1, 0.7, 0.3)

         surface.SetDrawColor(255, 255, 255, math.Round(Alpha))
         surface.DrawRect(0, 0, surface.ScreenWidth(), surface.ScreenHeight())
      end
   end
   hook.Add("DrawOverlay", "FlashEffect", FlashEffect)
else
   util.AddNetworkString("ttt_flashbang_effect")
end
