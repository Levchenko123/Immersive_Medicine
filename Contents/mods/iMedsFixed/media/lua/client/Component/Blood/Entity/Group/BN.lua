Events.OnGameBoot.Add(
    function()
        ZCore:getContainer():register(
            require 'Component/Blood/Entity/BloodGroup',
            'imeds.blood.entity.b_iii_rh_n',
            {
                {
                    id = BloodGroup.BN,
                    compatibilities = {
                        BloodGroup.ON,
                        BloodGroup.BN,
                    },
                    name = getText('UI_BloodGroup_BN_Name'),
                    description = getText('UI_BloodGroup_BN_Description'),
                    alias = 'BN',
                }
            },
            'imeds.blood.entity.group'
        )
    end
)