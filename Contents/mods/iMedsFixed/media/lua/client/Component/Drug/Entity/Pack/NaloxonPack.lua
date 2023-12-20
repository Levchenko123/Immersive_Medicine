NaloxonPack = {
    fullType = 'iMeds.NaloxonPack',
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Pack',
    'imeds.drug.entity.naloxon_pack',
    {
        NaloxonPack
    },
    'imeds.drug.entity.drug.pack'
)