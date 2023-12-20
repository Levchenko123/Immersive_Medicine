HemoStopPack = {
    fullType = 'iMeds.HemoStopPack',
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Pack',
    'imeds.drug.entity.hemo_stop_pack',
    {
        HemoStopPack
    },
    'imeds.drug.entity.drug.pack'
)