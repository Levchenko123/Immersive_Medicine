Events.OnGameBoot.Add(
    function()
        ZCore:getContainer():register(
            require 'Component/Blood/Entity/BloodGroup',
            'imeds.blood.entity.o_i_rh_n',
            {
                {
                    id = BloodGroup.ON,
                    compatibilities = {
                        BloodGroup.ON,
                    },
                    name = getText('UI_BloodGroup_ON_Name'),
                    description = getText('UI_BloodGroup_ON_Description'),
                    alias = 'ON',
                }
            },
            'imeds.blood.entity.group'
        )
    end
)