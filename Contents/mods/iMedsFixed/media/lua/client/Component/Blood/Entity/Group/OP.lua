Events.OnGameBoot.Add(
    function()
        ZCore:getContainer():register(
            require 'Component/Blood/Entity/BloodGroup',
            'imeds.blood.entity.o_i_rh_p',
            {
                {
                    id = BloodGroup.OP,
                    compatibilities = {
                        BloodGroup.ON,
                        BloodGroup.OP,
                    },
                    name = getText('UI_BloodGroup_OP_Name'),
                    description = getText('UI_BloodGroup_OP_Description'),
                    alias = 'OP',
                }
            },
            'imeds.blood.entity.group'
        )
    end
)