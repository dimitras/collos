# Taxon
[
    {
        ncbi_id: 9606,
        scientific_name: "Homo sapiens",
        common_name: "human"
    },
    {
        ncbi_id: 10090,
        scientific_name: "Mus musculus",
        common_name: "house mouse"
    },

    {
        ncbi_id: 4932,
        scientific_name: "Saccharomyces cerevisiae",
        common_name: "baker's yeast"
    },

    {
        ncbi_id:  7955,
        scientific_name: "Danio rerio",
        common_name: "zebrafish"
    },

].each do |t|
    Taxon.where(t).first_or_create()
end

# Ontology
obi = Ontology.where(
    name: "Ontology for Biomedical Investigations",
    prefix: "OBI",
    release: "2012-07-01",
    uri: "http://purl.bioontology.org/ontology/OBI",
    description: "OBI is an ontology of investigations, the protocols and instrumentation used, the material used, the data generated and the types of analysis performed on it."
    ).first_or_create()

nci = Ontology.where(
    name: "National Cancer Institute Thesaurus ",
    prefix: "NCIT",
    release: "13.05d",
    uri: "http://purl.bioontology.org/ontology/NCIT",
    description: "A vocabulary for clinical care, translational and basic research, and public information and administrative activities."
    ).first_or_create()

# OntologieTerm

# containers
container = OntologyTerm.where(
            name: "container",
            accession: "obo:OBI_0000967",
            definition: "A device that can be used to restrict the location of material entities over time",
            ontology_id: obi.id
    ).first_or_create()
plate = OntologyTerm.where(
            name: "microtiter plate",
            accession: "obo:OBI_0000192",
            definition: "A microtiter_plate is a flat plate with multiple wells used as small test tubes.",
            ontology_id: obi.id
        ).first_or_create()
plate.parent = container
plate.save
tube =  OntologyTerm.where(
            name: "test tube",
            accession: "obo:OBI_0000836",
            definition: "A test tube is a device consisting of a glass or plastic tubing, open at the top, usually with a rounded U-shaped bottom which has the function to contain material",
            ontology_id: obi.id
        ).first_or_create()
tube.parent = container
tube.save

freezer =  OntologyTerm.where(
            name: "freezer",
            accession: "C84327",
            definition: "A refrigerated cabinet or room for preserving materials at or below 32F (0C).",
            ontology_id: nci.id
        ).first_or_create()
freezer.parent = container
freezer.save

box = OntologyTerm.where(
            name: "box",
            accession: "C43178",
            definition: "A square or rectangular vessel, usually made of cardboard or plastic.",
            ontology_id: nci.id
        ).first_or_create()
box.parent = container
box.save

bag = OntologyTerm.where(
            name: "bag",
            accession: "C43167",
            definition: "A sac or pouch.",
            ontology_id: nci.id
        ).first_or_create()
bag.parent = container
bag.save


# SampleCharacteristic OntologyTerm
# gender
gender = OntologyTerm.where(name: "biological sex",
        accession: 'obo:PATO_0000047',
        definition: 'An organismal quality inhering in a bearer by virtue of the bearer\'s ability to undergo sexual reproduction in order to differentiate the individuals or types involved.',
        ontology_id: obi.id
    ).first_or_create()
s = OntologyTerm.where(name: "male",
        accession: 'obo:PATO_0000384',
        definition: 'A biological sex quality inhering in an individual or a population whose sex organs contain only male gametes.',
        ontology_id: obi.id
    ).first_or_create()
s.parent = gender
s.save
s = OntologyTerm.where(name: "female",
        accession: 'obo:PATO_0000383',
        definition: 'A biological sex quality inhering in an individual or a population that only produces gametes that can be fertilised by male gametes.',
        ontology_id: obi.id
    ).first_or_create()
s.parent = gender
s.save

s = OntologyTerm.where(name: 'hermaphrodite',
        accession: 'obo:PATO_0001340',
        definition: 'A biological sex quality inhering in an organism or a population with both male and female sexual organs in one individual.',
        ontology_id: obi.id
    ).first_or_create()
s.parent = gender
s.save

# ContainerType
[
    {
        name: '96 well plate',
        x_dimension: 12,
        y_dimension: 8,
        x_coord_labels: 'number',
        y_coord_labels: 'letter',
        type_id: plate.id,
        can_have_children: false
    },
    {
        name: '384 well plate',
        x_dimension: 24,
        y_dimension: 16,
        x_coord_labels: 'number',
        y_coord_labels: 'letter',
        type_id: plate.id,
        can_have_children: false
    },
    {
        name: '1.5 mL tube',
        x_dimension: 1,
        y_dimension: 1,
        type_id: tube.id,
        can_have_children: false
    },
    {
        name: '15 mL tube',
        x_dimension: 1,
        y_dimension: 1,
        type_id: tube.id,
        can_have_children: false
    },
    {
        name: '-80 freezer',
        x_dimension: 1,
        y_dimension: 4,
        type_id: freezer.id
    },
    {
        name: 'freezer box',
        x_dimension: 10,
        y_dimension: 5,
        type_id: box.id
    }
].each do |ct|
    ContainerType.where(ct).first_or_create()
end


