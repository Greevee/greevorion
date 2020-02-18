SectorSpecifics.RichAsteroidsSector_addTemplatesOld = SectorSpecifics.addMoreTemplates
function SectorSpecifics:addMoreTemplates()
    self:RichAsteroidsSector_addTemplatesOld()

    self:addTemplate("sectors/richasteroidfield")
    self:addTemplate("sectors/superrichasteroidfield")
end
