DrugCreator = {}

function DrugCreator.OnCreateDrug(_item)
    local drugData = ZCore:getContainer():get('imeds.drug.storage.drug_storage'):getByFullType(_item:getFullType())

    _item:getModData().drug = {
        fullType = drugData:getFullType(),
        dosageForms = drugData:getDosageForms(),
        singleDose = drugData:getSingleDose(),
    }
end

function DrugCreator.OnCreateSyringe(_item)
    _item:getModData().syringe = {
        maxVolume = 5,
        volume = 0,
        drug = nil,
        isClean = true,
        isInfected = false,
    }
end


function DrugCreator.OnCreateNeedle(_item)
    _item:getModData().needle = {
        isClean = true,
        isInfected = false,
    }
end