--      Copyright (c) 2022-2023, sophie S. All rights reserved      --
-- Plutonic is a project built for L̶a̶n̶d̶i̶s̶ ̶G̶a̶m̶e̶s̶. (opensrc updated by zachun). --
SWEP.CustomEvents = SWEP.CustomEvents or {};
SWEP.ViewModelPos = Vector(0, 0, 0);
SWEP.ViewModelAngle = Angle(0, 0, 0);
SWEP.BarrelLength = 6;
SWEP.VMDeltaX = 0;
SWEP.VMDeltaY = 0;
SWEP.VMRoll = 0;
SWEP.VMRecoilPos = Vector(0, 0, 0);
SWEP.VMRecoilAng = Angle(0, 0, 0);
SWEP.VMOffsetPos = Vector(0, 0, 0);
SWEP.VMOffsetAng = Angle(0, 0, 0);
SWEP.Primary.FirePower = 1;
SWEP.c_alpha = 0;
SWEP.c_lang = Angle(0, 0, 0);
SWEP.c_lpos = Vector(0, 0, 0);
SWEP.c_oxc = 0;
SWEP.c_oxq = 0;
SWEP.c_oyq = 0;
local math = math;
local render = render;
local reticule = Material("models/weapons/insurgency_sandstorm/ins2_sandstorm/kobra_reticle");
local abs = math.abs;
local min = math.min;
local clamp = math.Clamp;
local sin = math.sin;
local cos = math.cos;
local deg = math.deg;
local Curtime = UnPredictedCurTime;
local Frametime = RealFrameTime;
local Realtime = RealTime;
local vec = Vector;
local lerp = Lerp;
local lerpAngle = LerpAngle;
local lerpVector = LerpVector;
local approach = math.Approach;
local easeOutQuad = Plutonic.Ease.OutQuad;
local easeOutCirc = Plutonic.Ease.OutCirc;
local VECTOR_ZERO = vec(0, 0, 0);
local ANGLE_ZERO = Angle(0, 0, 0);

-- masking feature from ls2
function Plutonic.Framework.Mask(ent)
    render.SetStencilReferenceValue(0)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.ClearStencil()

    render.SetStencilEnable(true)
    render.SetStencilWriteMask(0xF0)
    render.ClearStencilBufferRectangle(0, 0, ScrW(), ScrH(), 0x0F)
    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilTestMask(0x00)
    render.SetStencilFailOperation(STENCIL_INCR)

    ent:DrawModel()

    render.SetStencilTestMask(0xFF)
    render.SetStencilReferenceValue(0x1F)
    render.SetStencilCompareFunction(STENCIL_INCRSAT)
end

function Plutonic.Framework.UnMask()
    render.SetStencilEnable(false)
end

function SWEP:PreDrawViewModel(vm)
    if self.CustomMaterial and not self.CustomMatSetup then
        self:GetOwner():GetViewModel():SetMaterial(self.CustomMaterial);
        self.CustomMatSetup = true;
    end

    if self.scopedIn then return self.scopedIn; end
end

function SWEP:ViewModelDrawn()
    if Plutonic.Framework.Overdraw then return; end
    local vm = self:GetOwner():GetViewModel();
    if not IsValid(vm) then return; end
    
    self.LastVMPos = vm:GetPos()
    self.LastVMAng = vm:GetAngles()
    
    if self.ExtraViewModelRender then
        self:ExtraViewModelRender(vm);
    end

    local drawnNames = {};
    self.EquippedAttachments = self.EquippedAttachments or {};
    self.AttachmentEntCache = self.AttachmentEntCache or {};
    
    for attName, _ in pairs(self.EquippedAttachments) do
        local attData = self.Attachments[attName];
        if not attData then continue; end
        
        self:DrawVMAttachment(attName, vm);
        drawnNames[attName] = true;
        
        -- scope rendering handled here
        if attData.Scope then
            self:DrawVMAttachmentScope(attName);
        end
    end

    for name, csEnt in pairs(self.AttachmentEntCache) do
        if not drawnNames[name] then
            csEnt:Remove();
        end
    end
    
    if self.VMElements then
        for _, elementData in pairs(self.VMElements) do
            self:DrawVMElement(elementData);
        end
    end
end

function SWEP:DrawVMAttachment(attID, vm)
    if not vm then
        vm = self:GetOwner():GetViewModel()
    end
    
    local attData = self.Attachments[attID]
    if not attData then return end

    if attData.PlayerParent then
        vm = self:GetOwner()
    end

    -- csmodel creating if not exist
    if not IsValid(attData._CSModel) then
        attData._CSModel = ClientsideModel(attData.Cosmetic.Model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
        attData._CSModel:SetParent(vm)
        attData._CSModel:SetNoDraw(true)

        if attData.Cosmetic.Scale then
            if attData.Cosmetic.BoneScale then
                attData._CSModel:ManipulateBoneScale(0, Vector(attData.Cosmetic.Scale, attData.Cosmetic.Scale, attData.Cosmetic.Scale));
            else
                attData._CSModel:SetModelScale(attData.Cosmetic.Scale)
            end
        end
        
        if attData.Cosmetic.BoneMerge then
            attData._CSModel:AddEffects(EF_BONEMERGE)
        end
    end

    local att = attData._CSModel
    local c = attData.Cosmetic
    
    local pos, ang
    if c.Bone then
        local bone = vm:LookupBone(c.Bone)
        if not bone then return end

        local m = vm:GetBoneMatrix(bone)
        if not m then return end

        pos, ang = m:GetTranslation(), m:GetAngles()
    elseif c.Attachment then
        local attc = vm:LookupAttachment(c.Attachment)
        if not attc then return end

        local data = vm:GetAttachment(attc)
        if not data then return end

        pos, ang = data.Pos, data.Ang
    else
        pos, ang = vm:GetPos(), vm:GetAngles()
    end

    -- positions offset
    att:SetPos(pos + ang:Forward() * c.Pos.x + ang:Right() * c.Pos.y + ang:Up() * c.Pos.z)
    ang:RotateAroundAxis(ang:Up(), c.Ang.y)
    ang:RotateAroundAxis(ang:Right(), c.Ang.p)
    ang:RotateAroundAxis(ang:Forward(), c.Ang.r)
    att:SetAngles(ang)
    
    if attData.RenderOverride then
        attData.RenderOverride(self, vm, att)
    else
        att:DrawModel()
    end
    
    if attData.Reticule and attData.Behavior == "1x_Sight" then
        if not attData.Reticule.NoMask then
            Plutonic.Framework.Mask(att)
            self:DrawVMAttachmentCrosshair(attID)
            Plutonic.Framework.UnMask()
        else
            self:DrawVMAttachmentCrosshair(attID)
        end
    end
end

-- crosshair :D
function SWEP:DrawVMAttachmentCrosshair(attID)
    local attData = self.Attachments[attID]
    local mdl = attData._CSModel

    if not IsValid(mdl) then return end
    local retData = attData.Reticule or {}

    local rotation = retData.RotationAngle or 0

    local p, a = mdl:GetPos(), mdl:GetAngles()
    a:RotateAroundAxis(a:Up(), rotation)

    if retData.Pos then
        p = p + a:Forward() * retData.Pos.x
        p = p + a:Right() * retData.Pos.y
        p = p + a:Up() * retData.Pos.z
    end

    local ret = retData.Material or reticule
    local col = retData.Color or color_white
    local size = retData.Size or 32

    render.SetMaterial(ret)
    render.DrawQuadEasy(p, a:Forward(), size, size, col, a.r - 180)
end

-- ADDED: Scope RT rendering ported directly from LS2, we should probably not remove LS2 atm since I was too lazy to properly port it
-- TODO: Make use of the existant plutonic rt things instead of LS2
function SWEP:DrawVMAttachmentScope(attID)
    local attData = self.Attachments[attID]
    if not attData then return end

    local scope = attData.Scope
    local ply = self:GetOwner()
    local vm = ply:GetViewModel()

    local att = attData._CSModel
    if not IsValid(att) then return end

    local c = {
        origin = ply:EyePos(),
        angles = ply:EyeAngles(),
        fov = scope.FOV or 12.5,
        x = 0,
        y = 0,
        w = ScrW(),
        h = ScrH(),
        drawviewmodel = false,
        drawhud = false,
        aspectratio = 1
    }

    if scope.RTOffset then
        c.drawviewmodel = true

        local attPos = self.LastVMPos or vm:GetPos()
        local attAng = self.LastVMAng or vm:GetAngles()

        if Plutonic.Interpolation and Plutonic.Interpolation.VectorBezierCurve then
            attPos, attAng = Plutonic.Framework.RotateAroundPoint(attPos, attAng, Vector(0,0,0), scope.RTOffset, scope.RTOffsetAng or Angle())
        else
            attPos = attPos + attAng:Forward() * scope.RTOffset.x + attAng:Right() * scope.RTOffset.y + attAng:Up() * scope.RTOffset.z
            if scope.RTOffsetAng then
                attAng:RotateAroundAxis(attAng:Up(), scope.RTOffsetAng.y)
                attAng:RotateAroundAxis(attAng:Right(), scope.RTOffsetAng.p)
                attAng:RotateAroundAxis(attAng:Forward(), scope.RTOffsetAng.r)
            end
        end

        c.origin = attPos
        c.angles = attAng
    end

    render.PushRenderTarget(Plutonic.RenderTarget or longsword and longsword.rt or GetRenderTarget("Plutonic_ScopeRT", ScrW(), ScrH()))
    render.OverrideAlphaWriteEnable(true, true)

    cam.Start2D()
    render.Clear(255, 255, 255, 0, true)
    render.RenderView(c)
    cam.End2D()

    draw.NoTexture()
    render.PopRenderTarget()
    render.OverrideAlphaWriteEnable(false, false)

    if attData.Scope.SubMaterial then
        att:SetSubMaterial(attData.Scope.SubMaterial, "!ls_rendertargetmaterial")
    end
end

function SWEP:DrawVMElement(data)
    local vm = self:GetOwner():GetViewModel()
    if not IsValid(vm) then
        return
    end

    if not IsValid(data._CSModel) then
        local cs = ClientsideModel(data.Model, RENDERGROUP_VIEWMODEL)
        data._CSModel = cs

        cs:SetParent(vm)
        cs:SetNoDraw(true)

        if data.BoneMerge then
            cs:AddEffects(EF_BONEMERGE)
        end

        if data.Scale then
            if data.BoneScale then
                cs:ManipulateBoneScale(0, Vector(data.Scale, data.Scale, data.Scale));
            else
                cs:SetModelScale(data.Scale)
            end
        end
    end

    if data.ShouldDraw and not data.ShouldDraw(self) then return end
    
    local cs = data._CSModel

    local bone = vm:LookupBone(data.Bone)
    local pos, ang
    if bone then
        local m = vm:GetBoneMatrix(bone)
        if m then
            pos, ang = m:GetTranslation(), m:GetAngles()
        else
            pos, ang = vm:GetPos(), vm:GetAngles()
        end
    else
        pos, ang = vm:GetPos(), vm:GetAngles()
    end

    cs:SetPos(pos + ang:Forward() * data.Pos.x + ang:Right() * data.Pos.y + ang:Up() * data.Pos.z)
    ang:RotateAroundAxis(ang:Up(), data.Ang.y)
    ang:RotateAroundAxis(ang:Right(), data.Ang.p)
    ang:RotateAroundAxis(ang:Forward(), data.Ang.r)
    cs:SetAngles(ang)
    cs:DrawModel()
end

concommand.Add(
    "plutonic_client_debug_attachments",
    function()
        local lp = LocalPlayer();
        local wep = lp:GetActiveWeapon();
        print("Dumping Weapon.Attachments:");
        PrintTable(wep.Attachments);
        print("\nDumping Weapon.AttachmentEntCache:");
        PrintTable(wep.AttachmentEntCache);
        print("\nDumping Weapon.EquippedAttachments:");
        PrintTable(wep.EquippedAttachments);
    end
);

function SWEP:OnSprintStateChanged(sprinting)
    self.VMSprint = not sprinting and Plutonic.Ease.OutQuad(self.VMSprint or 0) or Plutonic.Ease.InQuad(self.VMSprint or 0);
end

function SWEP:PostRender()
	self:DoWallLeanThink();
	local dx = self.VMDeltaX or 0;
	local dy = self.VMDeltaY or 0;
	local oxc_a = min(abs(dx) / 8, 1);
	local oxc = easeOutQuad(oxc_a) * clamp(dx / -4, -.5, .5);
	self.c_oxc = lerp(Frametime() * 8, self.c_oxc or 0, oxc);
	local oxq_a = min(abs(dx) / 16, 1);
	local oxq = easeOutCirc(1 - oxq_a) * clamp(dx / 16, -.5, .5); -- Plutonic.Ease.OutQuad(min(abs(self.VMDeltaX) / 8, 1)) * clamp(self.VMDeltaX, -8, 8)
	self.c_oxq = lerp(Frametime() * 12, self.c_oxq or 0, oxq);
	local oyq_a = min(abs(dy) / 1, 1);
	local oyq = easeOutQuad(oyq_a) * clamp(dy, -1, 1);
	self.c_oyq = lerp(Frametime() * 8, self.c_oyq or 0, oyq);
	self.Ironsights = self:GetIronsights();
	self._sprinting = self._sprinting or false;
	local sprinting = self:IsSprinting();
	if sprinting ~= self._sprinting then
		self._sprinting = sprinting;
		if self.OnSprintStateChanged then
			self:OnSprintStateChanged(sprinting);
		end
	end

	self.VMSprint = lerp(Frametime() * 4, self.VMSprint or 0, sprinting and 1 or 0);
	self.VMIronsights = approach(self.VMIronsights or 0, self:GetIronsights() and 1 or 0, FrameTime() * 1.7);
	local tr = util.TraceLine(
		{
			start = self:GetOwner():GetShootPos(),
			endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 32,
			filter = self:GetOwner()
		}
	);

	self.VMBlocked = self.VMBlocked or 0;
	self.VMBlocked = lerp(Frametime() * 13, self.VMBlocked, tr.Hit and tr.Fraction or 1);
	local isIronsights = self:GetIronsights();
	local isDuck = (self:GetOwner():KeyDown(IN_DUCK) or self:GetOwner():Crouching()) and not isIronsights;
	self.VMCrouch = approach(self.VMCrouch, isDuck and 1 or 0, Frametime() * 2.5);
	self.VMBobCycle = lerp(Frametime() * 6, self.VMBobCycle or 0, Plutonic.Framework.IsMoving() and 1 or 0);
	local l = self:IsSprinting() and 1 or 0;
	lerpSpeed = lerp(Frametime() * 5, lerpSpeed, l);
	local onvel = self:GetOwner():GetVelocity();
	local uvel = onvel.z;
	local vel = clamp(uvel / 80, -34, 34);
	self.VMVel = self.VMVel or 0;
	self.VMVel = Lerp(Frametime() * 5, self.VMVel, vel);
	local ft = Frametime();
	local ftM = self.SwaySpeed or 11;
	self.VMDeltaX = lerp(ft * ftM, self.VMDeltaX or 0, 0);
	self.VMDeltaY = lerp(ft * ftM, self.VMDeltaY or 0, 0);
	self.VMDeltaXWeighted = approach(self.VMDeltaXWeighted or 0, 0, ft * 32);
	self.VMDeltaYWeighted = approach(self.VMDeltaYWeighted or 0, 0, ft * 32);
	self.VMRecoilAmt = self.VMRecoilAmt or 0;
	self.VMRecoilAmt = lerp(ft * 2, self.VMRecoilAmt, 0);
	local alpha = isIronsights and Plutonic.Ease.OutExpo(self.VMIronsights) or Plutonic.Ease.InSine(self.VMIronsights);
	self.c_alpha = lerp(FrameTime() * 8, self.c_alpha or 0, alpha);
	if self.LoweredPos then
		local t = self:IsSprinting() and Plutonic.Ease.OutQuad(self.VMSprint or 0) or Plutonic.Ease.InQuad(self.VMSprint or 0);
		local loweredPos = Plutonic.Interpolation.VectorBezierCurve(t, VECTOR_ZERO, self.LoweredMidPos, self.LoweredPos);
		local loweredAng = Plutonic.Interpolation.AngleBezierCurve(t, ANGLE_ZERO, self.LoweredMidAng, self.LoweredAng);
		self.c_lpos = lerpVector(Frametime() * 16, self.c_lpos or VECTOR_ZERO, loweredPos);
		self.c_lang = lerpAngle(Frametime() * 16, self.c_lang or ANGLE_ZERO, loweredAng);
	end
end

Plutonic.Hooks.Add(
	"PostRender",
	function()
		local me = LocalPlayer();
		if not IsValid(me) then return; end
		local wep = me:GetActiveWeapon();
		if not IsValid(wep) then return; end
		if not wep.IsPlutonic then return; end
		wep:PostRender();
	end
);

function Plutonic.Framework.IsMoving()
	return LocalPlayer():GetVelocity():Length2DSqr() > 40 ^ 2;
end

function SWEP:IsMoving()
	return self:GetOwner():GetVelocity():Length2DSqr() > 40 ^ 2;
end

function SWEP:IsDucked()
	local isIronsights = self:GetIronsights();

	return (self:GetOwner():KeyDown(IN_DUCK) or self:GetOwner():Crouching()) and not isIronsights;
end

SWEP.CrouchPos = Vector(.7, -0, -.4);
SWEP.CrouchAng = Angle(0, 0, -0);
function SWEP:DoCrouch(pos, ang)
	self.VMCrouch = self.VMCrouch or 0;
	local alpha;
	if self:IsDucked() then
		alpha = Plutonic.Ease.OutQuad(self.VMCrouch);
	else
		alpha = Plutonic.Ease.InQuad(self.VMCrouch);
	end
	--pos = pos + ang:Right() * self.CrouchPos.x * alpha
	--pos = pos + ang:Forward() * self.CrouchPos.y * alpha
	--pos = pos + ang:Up() * self.CrouchPos.z * alpha
	--ang:RotateAroundAxis(ang:Right(), self.CrouchAng.p * alpha)
	--ang:RotateAroundAxis(ang:Forward(), self.CrouchAng.r * alpha)
	--ang:RotateAroundAxis(ang:Up(), self.CrouchAng.y * alpha)

	return Plutonic.Framework.RotateAroundPoint(pos, ang, Vector(-9, -2, -3), self.CrouchPos * -alpha, self.CrouchAng * -alpha);
end

function SWEP:DoBlocked(pos, ang)
	if self:GetOwner() ~= LocalPlayer() then return pos, ang; end
	self.VMBlocked = self.VMBlocked or 1;
	local bl = -(self.VMBlocked - 1);

	return Plutonic.Framework.RotateAroundPoint(pos, ang, self.PointOrigin or Vector(0, 0, 0), Vector(bl * -11, bl * -1, -bl * 7), Angle(bl * 23, bl * -12, bl * 12));
end

SWEP.IronsightsMiddlePos = Vector(-3, -2, -1.6);
SWEP.IronsightsMiddleAng = Angle(3, 9, 4);
function SWEP:DoIronsights(pos, ang)
	self.VMIronsights = self.VMIronsights or 0;
	self.VMRattle = self.VMRattle or 0;
	PLUTONIC_SEED8 = PLUTONIC_SEED8 or math.random(1000000, 9999999);
	PLUTONIC_SEED9 = PLUTONIC_SEED9 or math.random(1000000, 9999999);
	-- Idle
	if self:GetIronsights() then
		ang:RotateAroundAxis(VECTOR_RIGHT, cos(Curtime() * .5) * 0.05);
		ang:RotateAroundAxis(VECTOR_UP, sin(Curtime() * 1) * 0.05);
	end

	local tome = self.VMRecoilSeed or 0;
	tome = tome + CurTime();
	ang:RotateAroundAxis(ang:Forward(), sin((tome * 8) * ((1 / self.Primary.Delay) / 4)) * (self.VMRecoilAmt or 0) * 24);
	-- fire bump
	self.lastshot = self.lastshot or 0;
	local ls = self.lastshot;
	local timeSince = math.min((ls + 1) - Curtime(), 1);
	local fireBump = Plutonic.Ease.InElastic(math.Clamp(timeSince, 0, 1));
	pos = pos + ang:Forward() * fireBump * -.4;
	local alpha = self.c_alpha or 0;
	local ironsightPos = Plutonic.Interpolation.VectorBezierCurve(alpha, VECTOR_ZERO, self.IronsightsMiddlePos, self.IronsightsPos);
	local ironsightAng = Plutonic.Interpolation.AngleBezierCurve(alpha, ANGLE_ZERO, self.IronsightsMiddleAng, self.IronsightsAng);
	pos = pos + ang:Up() * ironsightPos.z * alpha;
	pos = pos + ang:Right() * ironsightPos.x * alpha;
	pos = pos + ang:Forward() * ironsightPos.y * alpha;
	ang:RotateAroundAxis(ang:Right(), ironsightAng.p * alpha);
	ang:RotateAroundAxis(ang:Up(), ironsightAng.y * alpha);
	ang:RotateAroundAxis(ang:Forward(), ironsightAng.r * alpha);

	return pos, ang;
end

function SWEP:DoIdle(pos, ang)
	self.VMIdle = self.VMIdle or 0;
	local rt = Realtime();
	local breath2 = cos(rt * .625) * 1.6;

	return Plutonic.Framework.RotateAroundPoint(pos, ang, Vector(-1, -2, -3), Vector(0, breath2 * -.35, 0) * (1 - self.VMIronsights), Angle(breath2, 0, 0) * (1 - self.VMIronsights));
end

SWEP.LoweredMidPos = Vector(4, -3, 0.4);
SWEP.LoweredMidAng = Angle(-6, 7, -5);
function SWEP:ShouldDoSprint()
	return self.VMSprint and math.Round(self.VMSprint, 4) > 0;
end

function SWEP:DoSprint(pos, ang)
	if self.CustomSprint then return self:CustomSprint(pos, ang); end
	if not self.LoweredPos then return pos, ang; end
	local loweredPos = self.c_lpos or self.LoweredPos;
	local loweredAng = self.c_lang or self.LoweredAng;
	ang:RotateAroundAxis(ang:Right(), loweredAng.p);
	ang:RotateAroundAxis(ang:Up(), loweredAng.y);
	ang:RotateAroundAxis(ang:Forward(), loweredAng.r);
	pos = pos + ang:Up() * loweredPos.z;
	pos = pos + ang:Right() * loweredPos.x;
	pos = pos + ang:Forward() * loweredPos.y;

	return pos, ang;
end

lerpSpeed = 0;
local WalkingTime = 0;
function SWEP:DoWalkBob(pos, ang)
	if self.DoCustomWalkBob then return self:DoCustomWalkBob(pos, ang); end
	local rt = Realtime();
	if self:GetOwner():GetVelocity():Length2DSqr() > 60 ^ 2 then
		WalkingTime = WalkingTime + FrameTime() * 2;
	end

	local mv = clamp(self:GetOwner():GetVelocity():Length2D() / 200, 0, 1);
	if self:GetIronsights() then
		mv = mv * 0.25;
	end

	local pos0, ang0 = pos + Vector(), ang + Angle();
	do
		local modif = 1;
		if self.UseSprintSequence then
			modif = 0.1;
		end

		if not self.LoweredPos then
			modif = 0.7;
		end

		local sn0 = sin(rt * 12.6) * mv;
		local cs0 = cos(rt * 12.6) * mv;
		local d = -sin(rt * 25.2);
		local ب = sin(rt * 25.2) * cos(rt * 6.3) * -5.6;
		pos0, ang0 = Plutonic.Framework.RotateAroundPoint(pos, ang, Vector(-9, -2, -3), Vector(d * -.1, sn0 * -.6, -(abs(cs0) * .7145) - 0.2) * modif, Angle(d * -1 + (abs(sn0) * -.8), sn0 * -2.8, ب) * modif);
	end

	local pos1, ang1 = pos + Vector(), ang + Angle();
	do
		local sn1 = sin(rt * 8.4) * mv;
		local sn2 = sin(rt * 4.2);
		local sz3 = cos(rt * 8.4) * cos(rt * 12.6) * .079;
		local cs2 = abs(cos(rt * 4.2));
		local ب = sin(rt * 25.2) * cos(rt * 6.3) * (3 * mv);
		pos1, ang1 = Plutonic.Framework.RotateAroundPoint(pos, ang, Vector(-9, -2, -3), Vector(-0, sn1 * -.39 + (sn2 * -1.2 * mv), sz3 * mv - (mv * .5)), Angle((cs2 * 2.75 * mv) + (cs2 * -3.39 * mv), sn2 * -5.2 * mv, ب));
	end

	local interp = Plutonic.Ease.InOutQuart(self.VMSprint);
	pos, ang = lerpVector(interp, pos1, pos0), lerpAngle(interp, ang1, ang0);
	if not self:IsSprinting() then
		ang:RotateAroundAxis(ang:Forward(), cos(rt * 16.8) * mv * .1);
	end

	return pos, ang;
end

-- THINK FOR WALL LEANING OUT
function SWEP:DoWallLeanThink()
	-- how far to left
	local left = 0;
	-- how far to right
	local right = 0;
	-- trace to left
	local tr = util.TraceLine(
		{
			start = self:GetOwner():GetPos(),
			endpos = self:GetOwner():GetPos() + self:GetOwner():GetRight() * -32 + self:GetOwner():GetForward() * 12 + Vector(0, 0, 48),
			filter = self:GetOwner()
		}
	);

	-- if we hit something
	if tr.Hit then
		-- add to left
		left = left + 1;
	end

	-- trace to right
	tr = util.TraceLine(
		{
			start = self:GetOwner():EyePos(),
			endpos = self:GetOwner():EyePos() + self:GetOwner():GetRight() * 32 + self:GetOwner():GetForward() * 12 + Vector(0, 0, 48),
			filter = self:GetOwner()
		}
	);

	-- if we hit something
	if tr.Hit then
		-- add to right
		right = right + 1;
	end
	--self.VMWallLean = Lerp(FrameTime() * 6.4, self.VMWallLean or 0, left - right)
end

function SWEP:ViewmodelThink()
	local flip = Plutonic.Framework.GetControl_Bool("vm_flip_lefty", true);
	self.ViewModelFlip = flip;
end

function SWEP:GetViewModelPosition(pos, ang)
	if self.PreGetViewModelPosition then
		pos, ang = self:PreGetViewModelPosition(pos, ang);
	end

	self.centeredMode = self.centeredMode or GetConVar("plutonic_centered");
	if self.centeredMode and self.centeredMode:GetBool() then
		self.VMCenter = self.VMCenter or 0;
		if not self:GetIronsights() then
			self.VMCenter = Lerp(FrameTime() * 4, self.VMCenter, 1);
		else
			self.VMCenter = Lerp(FrameTime() * 4, self.VMCenter, 0);
		end

		local cpos, cang = self.CenteredPos * self.VMCenter, self.CenteredAng * self.VMCenter;
		pos = pos + (cpos.y * ang:Forward());
		pos = pos + (cpos.x * ang:Right());
		pos = pos + (cpos.z * ang:Up());
		ang:RotateAroundAxis(ang:Right(), cang.p);
		ang:RotateAroundAxis(ang:Up(), cang.y);
		ang:RotateAroundAxis(ang:Forward(), cang.r);
	end

	local ft = Frametime();
	local ovel = self:GetOwner():GetVelocity();
	local move = vec(ovel.x, ovel.y, 0);
	local movement = move:LengthSqr();
	local movepercent = clamp(movement / self:GetOwner():GetRunSpeed() ^ 2, 0, 1);
	local vel = move:GetNormalized();
	local rd = self:GetOwner():GetRight():Dot(vel);
	local isIronsights = self:GetIronsights();
	self.VMSwayIronTransform = self.VMSwayIronTransform or 0;
	self.VMSwayIronTransform = approach(self.VMSwayIronTransform, isIronsights and 1 or 0.1, ft * 2);
	local brl = self.BarrelLength * 1;
	--local xsa = 1 - clamp(abs(Curtime()-self.VMDeltaXT) * .7, 0, 1)
	local xva = self.VMDeltaX; --(Plutonic.Ease.InElastic(xsa)) * self.VMDeltaX
	--self.xsa = xsa
	--self.xva = xva
	pos, ang = self:DoIronsights(pos, ang);
	pos, ang = self:DoSprint(pos, ang);
	local swayXv = -(xva * .25);
	local swayXa = -xva * 1;
	if isIronsights then
		rd = rd / 2;
	end

	self.VMRoll = lerp(ft * 3, self.VMRoll, rd * movepercent);
	local degRoll = deg(self.VMRoll) / 3;
	degRoll = degRoll + ((self.VMWallLean or 0) * 24.4);
	local degPitch = lerp(Plutonic.Ease.OutQuint(min(abs(degRoll / 8), 1)), 0, cos(math.rad(degRoll * 2)));
	local flip = Plutonic.Framework.GetControl_Bool("vm_flip_lefty", false);
	if flip then
		swayXv = swayXv * -1;
		swayXa = swayXa * -1;
		degRoll = degRoll * -1;
	end

	local att = self:GetAttachment(self:LookupAttachment(self.MuzzleFlashAttachment or "muzzle"));
	local xsn;
	if att then
		att.Pos = att.Pos - (att.Ang:Forward() * brl);
		xsn = self:WorldToLocal(att.Pos);
	else
		xsn = Vector(0, 0, 0);
	end

	local oxc = (self.c_oxc or 0) * 8;
	local oxq = (self.c_oxq or 0) * 8;
	local oyq = self.c_oyq or 0;
	local offsetPos = Vector(0, oxc * -.8 - oxq * 1 - degRoll * .0625, oyq * .25 - abs(degRoll) * .0925 + (abs(oxq) * -.1 + abs(oxc) * .07)); --[[FORWARD]] --[[RIGHT]] --oxq * -.05, --[[UP]] --oyq * -.05
	local offsetAng = Angle(-oyq + degPitch, oxq - (oxc * 2.164), (oxq * -2.4) - degRoll + (oxc * 1.1));
	local yofof = lerp(self.VMIronsights, -3, 0);
	pos, ang = Plutonic.Framework.RotateAroundPoint(pos, ang, Vector(9, -2.5, yofof), offsetPos, offsetAng);
	self.PointOrigin = xsn;
	pos, ang = self:DoCrouch(pos, ang);
	pos, ang = self:DoBlocked(pos, ang);
	pos, ang = self:DoIdle(pos, ang);
	if self.ViewModelOffsetAng then
		local offsetang = self.ViewModelOffsetAng;
		ang:RotateAroundAxis(ang:Right(), offsetang.p);
		ang:RotateAroundAxis(ang:Up(), offsetang.y);
		ang:RotateAroundAxis(ang:Forward(), offsetang.r);
	end

	if self.ViewModelOffset then
		local offset = self.ViewModelOffset;
		pos = pos + (ang:Right() * offset.x);
		pos = pos + (ang:Forward() * offset.y);
		pos = pos + (ang:Up() * offset.z);
	end

	self.VMRecoilAng = self.VMRecoilAng or Angle(0, 0, 0)
	self.VMRecoilPos = self.VMRecoilPos or Vector(0, 0, 0)

	ang:RotateAroundAxis(ang:Right(), self.VMRecoilAng.p)
	ang:RotateAroundAxis(ang:Up(), self.VMRecoilAng.y)
	ang:RotateAroundAxis(ang:Forward(), self.VMRecoilAng.r)
	pos = pos + (ang:Right() * self.VMRecoilPos.x)
	pos = pos + (ang:Forward() * self.VMRecoilPos.y)
	pos = pos + (ang:Up() * self.VMRecoilPos.z)
	self.VMRecoilPos = lerpVector(ft * 2, self.VMRecoilPos, VECTOR_ZERO)
	self.VMRecoilAng = lerpAngle(ft * 2, self.VMRecoilAng, ANGLE_ZERO)
	pos, ang = Plutonic.Framework.RotateAroundPoint(LocalToWorld(VECTOR_ZERO, ANGLE_ZERO, pos, ang), ang, VECTOR_ZERO, VECTOR_ZERO, -LocalPlayer():GetViewPunchAngles() - ANGLE_ZERO);
	att = self:GetAttachment(self:LookupAttachment(self.MuzzleFlashAttachment or "muzzle"));
	xsn = VECTOR_ZERO;
	if att then
		att.Pos = att.Pos - (att.Ang:Forward() * brl);
		xsn = self:WorldToLocal(att.Pos);
	else
		xsn = Vector(0, 0, 0);
	end

	self.PointOrigin = xsn;
	pos, ang = self:DoWalkBob(pos, ang);
	pos = pos + (Vector(0, 0, 1) * ang:Forward()) * -1 * (1 - self.VMIronsights);

	return pos, ang;
end

Plutonic.GetViewModelPosition = SWEP.GetViewModelPosition;
Plutonic.DoIronSights = SWEP.DoIronSights;
Plutonic.DoWallLeanThink = SWEP.DoWallLeanThink;
Plutonic.DoSprint = SWEP.DoSprint;
Plutonic.DoCrouch = SWEP.DoCrouch;
Plutonic.DoBlocked = SWEP.DoBlocked;
Plutonic.DoIdle = SWEP.DoIdle;
Plutonic.DoWalkBob = SWEP.DoWalkBob;
Plutonic.DoIronsights = SWEP.DoIronsights;
Plutonic.PostRender = SWEP.PostRender;
function SWEP:DrawHoloSight(vm_pos, vm_ang, att)
	print("[Plutonic] DrawHoloSight is deprecated!");
end

Plutonic.Hooks.Add("PostDrawPlayerHands", function() end);
function SWEP:ProceduralRecoil(force)
	self.lastshot = CurTime();
	if self:GetIronsights() then
		force = force * 0.08;
	end

	force = force;

	-- Initialize BlowbackPos and BlowbackAngle if they don't exist
	self.BlowbackPos = self.BlowbackPos or Vector(0, 0, 0)
	self.BlowbackAngle = self.BlowbackAngle or Angle(0, 0, 0)
	local rPos = self.BlowbackPos + Vector();
	local rAng = self.BlowbackAngle + Angle();
	local pitchKnock = math.Rand(1.1, 3.2) * force;
	rAng:RotateAroundAxis(rAng:Right(), -pitchKnock);
	rPos = rPos - (rAng:Up() * (pitchKnock / 2));
	local yawKnock = math.Rand(-0.6, 0.6) * force;
	rAng:RotateAroundAxis(rAng:Up(), yawKnock);
	rPos = rPos + (rAng:Right() * (yawKnock / 2));
	local rollKnock = math.Rand(-2, 2) * force;
	rAng:RotateAroundAxis(rAng:Forward(), rollKnock);
	rPos = rPos + (rAng:Right() * (rollKnock / 2));
	rPos = rPos - (rAng:Forward() * math.Rand(4, 6)) * force;
	self.VMRecoil = (self.VMRecoil or Vector()) + rPos;
	self.VMRecoilAng = (self.VMRecoilAng or Angle()) + rAng;
	self.VMRecoilAmt = force * (self:GetIronsights() and 1 or .01);
	self.VMRecoilSeed = math.Rand(1000000, 9999999);
end

SWEP.CAM_ReloadAlp = 0;
SWEP.CAM_ReloadAct = 0;
function SWEP:CalcView(ply, pos, ang, fov)
	if not Plutonic.Framework.GetControl_Bool("use_anim_cam", true) then return; end
	if self:GetReloading() then
		local vm = self:GetOwner():GetViewModel();
		local n_ang = nil;
		-- aim
		if not self.GetReloadAnimation then
			local aim = vm:GetAttachment(self.ReloadAttach or 2);
			if aim then
				n_ang = (aim.Pos - pos):Angle();
			end
		else
			n_ang = self:GetReloadAnimation(pos, ang, self.CAM_ReloadAlp);
		end

		self.CAM_ReloadAlp = Lerp(Frametime(), self.CAM_ReloadAlp, self.ReloadProceduralCameraFrac or .1);

		return pos, lerpAngle(self.CAM_ReloadAlp * ((vm:SequenceDuration() - (Curtime() - self.CAM_ReloadAct)) / vm:SequenceDuration()), ang, n_ang), fov;
	else
		self.CAM_ReloadAlp = 0;
		self.CAM_ReloadAct = Curtime();

		return pos, ang, fov;
	end
end