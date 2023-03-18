RegisterNetEvent('cr_Etrack_1252151275_SETCULL')
AddEventHandler('cr_Etrack_1252151275_SETCULL', function(netId, set)
    exports["CR-Common"]:GetServer.SetEntityCullingDistance(netId, set)
end)