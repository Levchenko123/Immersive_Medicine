Events.OnGameBoot.Add(
    function()
        ZCore:getContainer():register(
            require 'Component/Blood/Entity/BloodGroup',
            'imeds.blood.entity.ab_iv_rh_n',
            {
                {
                    id = BloodGroup.ABN,
                    compatibilities = {
                        BloodGroup.ON,
                        BloodGroup.BN,
                        BloodGroup.AN,
                        BloodGroup.ABN,
                    },
                    name = getText('UI_BloodGroup_ABN_Name'),
                    description = getText('UI_BloodGroup_ABN_Description'),
                    alias = 'ABN',
                }
            },
            'imeds.blood.entity.group'
        )
    end
)