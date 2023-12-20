Events.OnGameBoot.Add(
    function()
        ZCore:getContainer():register(
            require 'Component/Blood/Entity/BloodGroup',
            'imeds.blood.entity.ab_iv_rh_p',
            {
                {
                    id = BloodGroup.ABP,
                    compatibilities = {
                        BloodGroup.ON,
                        BloodGroup.OP,
                        BloodGroup.AN,
                        BloodGroup.AP,
                        BloodGroup.BN,
                        BloodGroup.BP,
                        BloodGroup.ABN,
                        BloodGroup.ABP,
                    },
                    name = getText('UI_BloodGroup_ABP_Name'),
                    description = getText('UI_BloodGroup_ABP_Description'),
                    alias = 'ABP',
                }
            },
            'imeds.blood.entity.group'
        )
    end
)