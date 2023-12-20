Events.OnGameBoot.Add(
    function()
        ZCore:getContainer():register(
            require 'Component/Blood/Entity/BloodGroup',
            'imeds.blood.entity.b_iii_rh_p',
            {
                {
                    id = BloodGroup.BP,
                    compatibilities = {
                        BloodGroup.ON,
                        BloodGroup.OP,
                        BloodGroup.BN,
                        BloodGroup.BP,
                    },
                    name = getText('UI_BloodGroup_BP_Name'),
                    description = getText('UI_BloodGroup_BP_Description'),
                    alias = 'BP',
                }
            },
            'imeds.blood.entity.group'
        )
    end
)