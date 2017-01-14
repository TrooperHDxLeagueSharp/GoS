if GetObjectName(myHero) ~= "Morgana" then return end

local ver = "0.02"
local MorgQ = {delay = 0.25, speed = 1200, width = 80, range = 1300}

require("Analytics")

Analytics("Troopgana", "trooperhdx")


require("OpenPredict")

require("DamageLib")

local TroopMorg = Menu("Morgana", "Morgana")
TroopMorg("Combo", "Combo")
TroopMorg:Boolean("QComb", "Use Q", true)
TroopMorg:Boolean("WCom", "Use W", true)
TroopMorg:Boolean("RComb", "Use R", true)
TroopMorg:Slider("MinMana", "Min Mana To Combo",50,0,100,1)

TroopMorg:SubMenu("Harass", "Harass", true)
TroopMorg.Harass:Boolean("WHarass", "Use W", true)
TroopMorg.Harass:Slider("MinManaHarass", "Min Mana To Harass",50,0,100,1)

TroopMorg:SubMenu("LaneClear", "LaneClear", true)
TroopMorg.LaneClear:Boolean("Qlc", "Use Q", true)
TroopMorg.LaneClear:Boolean("Wlc", "Use W", true)
TroopMorg.LaneClear:Slider("WMin", "Min Minions To R",9,1,15,1)
TroopMorg.LaneClear:Slider("MinManaLC", "Min Mana To LaneClear",50,0,100,1)

TroopMorg:SubMenu("Misc", "Misc")
TroopMorg:Boolean("UltX", "Auto R on X Enemies", true)
TroopMorg.Misc:Slider("EnemieR", "Min Enemies to Auto R",3,1,6,1)
TroopMorg.Misc:Boolean("Lvlup", "Use Auto Level", true)
TroopMorg.Misc:Boolean("Ig", "Use Auto Ignite", true)
TroopMorg.Misc:Boolean("Ebs", "Use Blackshield", true)

TroopMorg:SubMenu("SkinChanger", "SkinChanger")

local skinMeta = {["Morgana"] = {"Classic", "Blade-Mistress", "Blackthorn", "Ghost-Bridge", "Exiled", "Sinful-Succulence", "Lumar-Wraith", "Bewitchintg", "Victorious"}}
TroopMorg.SkinChanger:DropDown('skin', myHero.charName.. " Skins", 1, skinMeta[myHero.charName], HeroSkinChanger, true)
TroopMorg.SkinChanger.skin.callback = function(model) HeroSkinChanger(myHero, model - 1) print(skinMeta[myHero.charName][model] .." ".. myHero.charName .. " Loaded!") end

TroopMorg:SubMenu("Draw", "Drawings")
TroopMorg.Draw:Boolean("DrawQ", "Draw Q Range", true)
TroopMorg.Draw:Boolean("DrawW", "Draw W Range", true)
TroopMorg.Draw:Boolean("DrawE", "Draw E Range", true)
TroopMorg.Draw:Boolean("DrawR", "Draw R Range", true)

OnTick(function ()
	
	local IgDamage = (50 + (20 * GetLevel(myHero)))
	local RStats = {delay = 0.050, range = 1000, radius = 300, speed = 1500 + GetMoveSpeed(myHero)}
	local GetPercentMana = (GetCurrentMana(myHero) / GetMaxMana(myHero)) * 100
	local target = GetCurrentTarget()
	
	if TroopMorg.Misc.Lvlup:Value() then
		spellorder = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}	
		if GetLevelPoints(myHero) > 0 then
			LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
		end
	end

	if Mode() == "Combo" then
		
		if TroopMorg.Combo.QComb:Value() and Ready(_Q) and ValidTarget(target, 1175) then
				if TroopMorg.Combo.MinMana:Value() <= GetPercentMana then 
					CastSkillShot(target, _Q)	
				end
			end
		

		if TroopMorg.Combo.WComb:Value() and Ready(_W) and ValidTarget(target, 900) then
			if TroopMorg.Combo.MinMana:Value() <= GetPercentMana then
					CastTargetSpell(_W)	
			end
		end
	
		if TroopMorg.Combo.RComb:Value() and Ready(_R) and ValidTarget(target, 400) then
				if TroopMorg.Combo.MinMana:Value() <= GetPercentMana then 
					CastSpell(target, _R)	
			end
		end
	end

	
	if Mode() == "Harass" then
		
		if TroopMorg.Harass.WHarass:Value() and Ready(_W) and ValidTarget(target, 900) then
			if TroopMorg.Harass.MinManaHarass:Value() <= GetPercentMana then
				CastTargetSpell(target, _W)
			end
		end
	
	end

if Mode() == "LaneClear" then
		
		for _, closeminion in pairs(minionManager.objects) do
			if TroopMorg.LaneClear.Qlc:Value() and ValidTarget(closeminion, 1125) then
				if GetPercentMP(myHero) >= TroopMorg.LaneClear.MinManaLC:Value() then
					CastSkillShot(_Q, closeminion)
				end
			end
			

			if TroopMorg.LaneClear.Wlc:Value() and ValidTarget(closeminion, 900) >= TroopMorg.LaneClear.WMin:Value() then
				if GetPercentMP(myHero) >= TroopMorg.LaneClear.MinManaLC:Value() then
					CastSkillShot(_W, closeminion)
				end
			end
		end
		
end


	for _, enemy in pairs(GetEnemyHeroes()) do
			--AutoR
		if TroopMorg.Misc.UltX:Value() and Ready(_R) and ValidTarget(enemy, 1000) and EnemiesAround(enemy, 300) >= TroopMorg.Misc.EnemirR:Value() then
				CastTargetSpell(enemy, _R)
			end	
			--Auto Ignite 
		if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
			if TroopMorg.Misc.Ig:Value() and Ready(SUMMONER_1) and ValidTarget(enemy, 600) then
				if GetCurrentHP(enemy) < IgDamage then
					CastTargetSpell(enemy, SUMMONER_1)
				end
			end
		end
	
		if GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
			if TroopMorg.Misc.Ig:Value() and Ready(SUMMONER_2) and ValidTarget(enemy, 600) then
				if GetCurrentHP(enemy) < IDamage then
					CastTargetSpell(enemy, SUMMONER_2)
				end
			end
		end
	end

end)


OnDraw(function(myHero)
	local pos = GetOrigin(myHero)
	local mpos = GetMousePos()
	if TroopMorg.Draw.DrawQ:Value() then DrawCircle(pos, 1125, 1, 25, GoS.Red) end
	if TroopMorg.Draw.DrawW:Value() then DrawCircle(pos, 900, 1, 25, GoS.Blue) end
	if TroopMorg.Draw.DrawE:Value() then DrawCircle(pos, 600, 1, 25, GoS.Blue) end
	if TroopMorg.Draw.DrawR:Value() then DrawCircle(pos, 600, 1, 25, GoS.Green) end
end)	



print("Well thats my first GoS Script , bugs may occur , have fun! Greetings from Trooper!")