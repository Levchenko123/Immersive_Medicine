Events.OnGameBoot.Add(
    function()
        ZCore:getContainer():register(
            require 'Component/Blood/Entity/BloodGroup',
            'imeds.blood.entity.a_ii_rh_n',
            {
                {
                    id = BloodGroup.AN,
                    compatibilities = {
                        BloodGroup.ON,
                        BloodGroup.AN,
                    },
                    name = getText('UI_BloodGroup_AN_Name'),
                    description = getText('UI_BloodGroup_AN_Description'),
                    alias = 'AN',
                }
            },
            'imeds.blood.entity.group'
        )
    end
)