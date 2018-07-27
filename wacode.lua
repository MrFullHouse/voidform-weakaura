-- Insanity Bar -- By Twintop - Illidan-US, 2016/07/28
function(event,time,type,_,sourceGUID,sourcename,_,_,destGUID,destname,_,_,spellid,spellname,_,_,_,_,_,_,_,spellcritical,_,_,_,spellmultistrike)
    local CurrentTime = GetTime();
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        
        WA_Voidform_Total_Stacks = WA_Voidform_Total_Stacks or 0;
       
        if sourceGUID == UnitGUID("player") then
            
            if spellid == 194249 then
                
                if type == "SPELL_AURA_APPLIED" then -- Entered Voidform
                    
                    WA_Voidform_Previous_Stack_Time = CurrentTime;
                    WA_Voidform_Start_Time = CurrentTime;
                    WA_Voidform_Total_Stacks = 1;
                    
                elseif type == "SPELL_AURA_APPLIED_DOSE" then -- New Voidform Stack
                    
                    WA_Voidform_Previous_Stack_Time = CurrentTime;
                    WA_Voidform_Total_Stacks = WA_Voidform_Total_Stacks + 1;
                    
                    
                elseif type == "SPELL_AURA_REMOVED" then -- Exited Voidform
                    if WA_Insanity_Bar_Voidform_Summary == true then
                        print("Voidform Info:");
                        print("--------------------------");
                        print(string.format("Voidform Duration: %.2f seconds", (CurrentTime-WA_Voidform_Start_Time)));
                        print(string.format("Voidform Stacks: %.0f", WA_Voidform_Total_Stacks));                        
                        print(string.format("Final Drain: %.0f stacks; %.1f / sec", WA_Voidform_Drain_Stacks, WA_Voidform_Current_Drain_Rate));
                    end
                    
                    WA_Voidform_VoidTorrent_Start = nil;
                    WA_Voidform_Dispersion_Start = nil;
                    WA_Voidform_Drain_Stacks = 0;
                    WA_Voidform_Start_Time = nil;
                    WA_Voidform_Total_Stacks = 0;
                    WA_Voidform_VoidTorrent_Stacks = 0;
                    WA_Voidform_Dispersion_Stacks = 0;
                    
                end
                
            elseif spellid == 205065 then
                
                if type == "SPELL_AURA_APPLIED" then -- Started channeling Void Torrent
                    
                    WA_Voidform_VoidTorrent_Start = CurrentTime;
                    
                elseif type == "SPELL_AURA_REMOVED" and WA_Voidform_VoidTorrent_Start ~= nil then -- Stopped channeling Void Torrent
                    
                    WA_Voidform_VoidTorrent_Start = nil;
                    
                end
                
            elseif spellid == 47585 then
                
                if type == "SPELL_AURA_APPLIED" then -- Started channeling Dispersion
                    
                    WA_Voidform_Dispersion_Start = CurrentTime;
                    
                elseif type == "SPELL_AURA_REMOVED" and WA_Voidform_Dispersion_Start ~= nil then -- Stopped channeling Dispersion
                    
                    WA_Voidform_Dispersion_Start = nil;
                    
                end
                
            elseif spellid == 212570 then
                
                if type == "SPELL_AURA_APPLIED" then -- Gain Surrender to Madness
                    
                    WA_Voidform_S2M_Activated = true;
                    WA_Voidform_S2M_Start = CurrentTime;
                    
                elseif type == "SPELL_AURA_REMOVED" then -- Lose Surrender to Madness
                    
                    WA_Voidform_S2M_Activated = false;
                    
                end
                
            end
            
        elseif destGUID == UnitGUID("player") and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") and WA_Voidform_S2M_Activated == true then
            
            WA_Voidform_S2M_Activated = false;
            
            if WA_Insanity_Bar_S2M_Wilhelm == true then
                PlaySoundFile("Interface\\AddOns\\WeakAuras\\PowerAurasMedia\\Sounds\\wilhelm.ogg", "Master");
            end
            
            if WA_Insanity_Bar_S2M_Summary == true then
                print("Surrender to Madness Info:");
                print("--------------------------");
                print(string.format("S2M Duration: %.2f seconds", (CurrentTime-WA_Voidform_S2M_Start)));
                print(string.format("Voidform Duration: %.2f seconds", (CurrentTime-WA_Voidform_Start_Time)));
                
                if WA_Voidform_Total_Stacks > 100 then
                    print(string.format("Voidform Stacks: 100 (+%.0f)", (WA_Voidform_Total_Stacks-100)));
                else
                    print(string.format("Voidform Stacks: %.0f", WA_Voidform_Total_Stacks));
                end
                
                print(string.format("Dispersion Stacks: %.0f", WA_Voidform_Dispersion_Stacks));
                print(string.format("Void Torrent Stacks: %.0f", WA_Voidform_VoidTorrent_Stacks));
                print(string.format("Final Drain: %.0f stacks; %.1f / sec", WA_Voidform_Drain_Stacks, WA_Voidform_Current_Drain_Rate));
            end
            
            WA_Voidform_S2M_Start = nil;
            WA_Voidform_VoidTorrent_Start = nil;
            WA_Voidform_Dispersion_Start = nil;
            WA_Voidform_Drain_Stacks = 0;
            WA_Voidform_Start_Time = nil;
            WA_Voidform_Total_Stacks = 0;
            WA_Voidform_VoidTorrent_Stacks = 0;
            WA_Voidform_Dispersion_Stacks = 0;
            
        end
        
    end 
end
