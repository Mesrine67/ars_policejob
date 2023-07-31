local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil

if not ESX then return end

function toggleClothes(toggle, clothes)
    if toggle then
        utils.debug("Putting on clothes")

        local playerData = ESX.GetPlayerData()
        local playerPed = cache.ped
        local jobGrade = playerData.job.grade

        utils.debug("Job Grade " .. jobGrade)

        if Config.ClothingScript and Config.ClothingScript ~= 'core' then
            local model = exports['illenium-appearance']:getPedModel(playerPed)

            if model == 'mp_m_freemode_01' then
                data = clothes.male[jobGrade] or clothes.male[1]
            elseif model == 'mp_f_freemode_01' then
                data = clothes.female[jobGrade] or clothes.female[1]
            end

            utils.debug("Using " .. Config.ClothingScript)

            exports[Config.ClothingScript]:setPedProps(playerPed, {
                {
                    component_id = 0,
                    texture = data['helmet_2'],
                    drawable = data['helmet_1']
                },
            })

            exports[Config.ClothingScript]:setPedComponents(playerPed, {
                {
                    component_id = 1,
                    texture = data['mask_2'],
                    drawable = data['mask_1']
                },
                {
                    component_id = 3,
                    texture = 0,
                    drawable = data['arms']
                },
                {
                    component_id = 8,
                    texture = data['tshirt_2'],
                    drawable = data['tshirt_1']
                },
                {
                    component_id = 11,
                    texture = data['torso_2'],
                    drawable = data['torso_1']
                },
                {
                    component_id = 9,
                    texture = data['bproof_2'],
                    drawable = data['bproof_1']
                },
                {
                    component_id = 10,
                    texture = data['decals_2'],
                    drawable = data['decals_1']
                },
                {
                    component_id = 7,
                    texture = data['chain_2'],
                    drawable = data['chain_1']
                },
                {
                    component_id = 4,
                    texture = data['pants_2'],
                    drawable = data['pants_1']
                },
                {
                    component_id = 6,
                    texture = data['shoes_2'],
                    drawable = data['shoes_1']
                },
                {
                    component_id = 5,
                    texture = data['bag_color'],
                    drawable = data['bag']
                },
            })
        elseif Config.ClothingScript == 'core' then
            utils.debug("Using " .. Config.ClothingScript)
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                local gender = skin.sex

                if gender == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, clothes.male[jobGrade] or clothes.male[1])
                else
                    TriggerEvent('skinchanger:loadClothes', skin, clothes.female[jobGrade] or clothes.female[1])
                end
            end)
        end
    else
        utils.debug("Putting civil clothes")

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    end
end

function getPlayerJobGrade()
    local playerData = ESX.GetPlayerData()
    local jobGrade = playerData.job.grade

    return jobGrade
end

function hasJob(jobs)
    local playerData = ESX.GetPlayerData()

    if type(jobs) == "table" then
        for index, jobName in pairs(jobs) do
            if playerData.job.name == jobName then return true end
        end
    else
        return playerData.job.name == jobs
    end

    return false
end

RegisterCommand("prop", function()
    local props = exports[Config.ClothingScript]:getPedProps(cache.ped)
    print(json.encode(props, { indent = true }))
end)
