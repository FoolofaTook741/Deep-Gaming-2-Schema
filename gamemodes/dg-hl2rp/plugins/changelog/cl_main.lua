local update = "0.71"
local content = [[<font=Impulse-Elements18><font=Impulse-SpecialFont>Deep Gaming 0.71, Espionage is now fully implemented.</font>

<colour=90, 200, 250, 255><font=Impulse-Elements23-Shadow>Combat Changes</font></colour>
Due to recent imbalances various changes have been applied to the server to make it more fair for all players.
A majority of 1-Shot Kill weapons have been severely hindered to prevent an unfair imbalance across the board.
Many sniper rifles have been removed or nerfed, handcannons have gotten significant recoil increases.
To fill this hole, DMRs have been given buffs, and various assault rifles have been given VSO's.
Normal health vials have been given a longer apply time. Enhanced health vials have been given a shorter apply time.
Every ballistic weapon that is not a handcannon, revolver, or shotgun has received an increase in damage.
A new ammo type Heavy Rifle Ammo has been added to the game.
Broken Pulse weapons cannot be repaired anymore.
Toggle Raise has been nerfed.
Weapons now draw on backs (not for CTA due to oversized models).

<colour=90, 200, 250, 255><font=Impulse-Elements23-Shadow>Combine Changes</font></colour>
The Transhuman Forces have been given new turrets and other equipment to use in battle. These smart turrets target variousn attackers and can be used in many situations.
Alternatively, the Metro Police's manhack has been giving a new targeting algorithm. Although untested, in concept, it should limit civilian casualties and focus more on rebels.
A new system via the F6 PDA, sterilized credits, has been added for the MPF. They can use these to purchase various gear.
These credits are persistent across server restarts.

<colour=90, 200, 250, 255><font=Impulse-Elements23-Shadow>Pharmaceuticals</font></colour>
Various pharmaceutical elements have been place into the game and can be accessed by C.W. Commerce.
These various drugs have different effects, and give a whole new economy to the underappreciated C.W. Medics.
Although entirely illegal, these drugs can be used to heighten capabilities of various rebels or civilians looking to take a risk.
Pill bottles can be obtained via the pill bottle machine item in the F4 menu, it requires electricity.
The chance to have a negative effect from drugs is reduced with a higher skill level.
Medical supplies can be purchased from the BMD or found from looting.

<colour=90, 200, 250, 255><font=Impulse-Elements23-Shadow>Pre-War Caches</font></colour>
A concept initially drafted by EvO, booile, and other Nighthaven members. These containers around the OZ sectors contain various rebel equipment items.
These raids require a C4 Charge to enact, and can be done without moderation approval. All member counts are handled in game.
This opens a new avenue of engagement between the CTA and the Rebels.
Alongside this change, the drill has been increased in price. Drills can be obtained in an alternative method via the PWC raids.

<colour=90, 200, 250, 255><font=Impulse-Elements23-Shadow>Ghost Tools</font></colour>
GHOST units now have access to motion sensors and various equipment to use utility against their enemies.

<colour=90, 200, 250, 255><font=Impulse-Elements23-Shadow>Ghost Tools</font></colour>
Languages have been added to the game. There are 8 learnable languages.
Languages are persistent and save across server restarts.
Only people who understand your language can see what you say when you type /german for example.
Speaking in foreign languages is currently illegal, so you have a large risk doing it in public...
Language textbooks can be obtained by looting, from the OCA, from the fisherman, and various otherways.

<colour=90, 200, 250, 255><font=Impulse-Elements23-Shadow>Minor Changes</font></colour>
Switch
Players no longer spawn with a physgun or toolgun, you can use /gettools to get them.
Loyalists and players spawn with their outfits as restricted. Due to a current bug they will not load on the initial spawn.
The OCA can now sell axes, pickaxes, and weapons directly to people when they get a permit.
A new tab containing character data has been added. It will be expanded upon.
Wiremod has been removed. Alternative methods for signs and radios are available in the F4 menu.
Portable jammers are now available. They are not visible but you emit sounds if you have one equipped.
Command Ping has been fixed by Zachun.
JW Vendors have been fully updated.
C.W. Maintenance have been given vehicle repair kits.
STs and PTs can be named. Concept credit to Manny Pardo.
A new manhunt system has been implemented. Combine Command can mark an 'anti-citizen one' for capture. If captured they will become a stalker.
I.C.T. units are immune from tear gas.
A Time Selector has been added to handle Combine blacklists.
O.C.A. Models correlate to your existing model.
Evidence Lockers and loot now drops as confiscation.
Items for loyalist outfits and citizen outfits have been created.
Fixes have been made for deployable ammo crates.
Various skins have been added to APF.
A new model has been added for MACE Ordinal.
i2 GHOST BOLs should be working.
Squad Custom Orders and Squad disbanding should now be working.
Deployable Ammo Boxes should now give Rifle ammo.
AR2 ammo can be crafted with energy cores and bullet casings.
Faction leaders should now be able to autonomously enact JW without admins.
A rifle suppressor has been added for the M4A1.
The Grease Belt is now compatible with the Browning Automatic Rifle and MG-42.
The Primary Skill feature is not in the game yet, but it will be a huge addition.

Various changes and bug fixes are unlisted. A majority are unlisted because I'm a lazy fuck.

<colour=90, 200, 250, 255><font=Impulse-Elements23-Shadow>Overall Bug Fixes and Improvements</font></colour>
Various bugs have been repaired. New bugs will arise, report the im the dev discussion channels.
Many various features will go unlisted as I've not written everything down, so explore and find them when you play.

And new content has been added to the content pack, use /content in the chat to find the link.
</font>]]

local show = true

net.Receive("impulseNewUpdateMessage", function()

	show = true
end)

function PLUGIN:ShowMenuModalMessage()
	if not show then
		return
	end

	local x = vgui.Create("impulseUpdateMessage")
	x:SetContent(string.Replace(content, "#SteamName", LocalPlayer():SteamName()))
end
