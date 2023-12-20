Events.OnGameBoot.Add(
    function()
        ZCore:getContainer():register(
            require 'Component/Blood/Entity/BloodGroup',
            'imeds.blood.entity.a_ii_rh_p',
            {
                {
                    id = BloodGroup.AP,
                    compatibilities = {
                        BloodGroup.ON,
                        BloodGroup.OP,
                        BloodGroup.AN,
                        BloodGroup.AP,
                    },
                    name = getText('UI_BloodGroup_AP_Name'),
                    description = getText('UI_BloodGroup_AP_Description'),
                    alias = 'AP',
                }
            },
            'imeds.blood.entity.group'
        )
    end
)