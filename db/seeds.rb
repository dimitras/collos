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
plate = OntologyTerm.where(
            name: "microtiter plate",
            accession: "obo:OBI_0000192",
            definition: "A microtiter_plate is a flat plate with multiple wells used as small test tubes.",
            ontology_id: obi.id
        ).first_or_create()
tube =  OntologyTerm.where(
            name: "test tube",
            accession: "obo:OBI_0000836",
            definition: "A test tube is a device consisting of a glass or plastic tubing, open at the top, usually with a rounded U-shaped bottom which has the function to contain material",
            ontology_id: obi.id
        ).first_or_create()

# SampleCharacteristic OntologyTerm
# gender
s = OntologyTerm.where(name: "male",
        accession: 'obo:PATO_0000384',
        definition: 'A biological sex quality inhering in an individual or a population whose sex organs contain only male gametes.',
        ontology_id: obi.id
    ).first_or_create()
s = OntologyTerm.where(name: "female",
        accession: 'obo:PATO_0000383',
        definition: 'A biological sex quality inhering in an individual or a population that only produces gametes that can be fertilised by male gametes.',
        ontology_id: obi.id
    ).first_or_create()

s = OntologyTerm.where(name: 'hermaphrodite',
        accession: 'obo:PATO_0001340',
        definition: 'A biological sex quality inhering in an organism or a population with both male and female sexual organs in one individual.',
        ontology_id: obi.id
    ).first_or_create()

# ContainerType
[
    {
        name: '96 well plate',
        x_dimension: 12,
        y_dimension: 8,
        x_coord_labels: 'numbers',
        y_coord_labels: 'letters',
        type_id: plate.id
    },
    {
        name: '384 well plate',
        x_dimension: 24,
        y_dimension: 16,
        x_coord_labels: 'numbers',
        y_coord_labels: 'letters',
        type_id: plate.id
    },
    {
        name: '1.5 mL tube',
        x_dimension: 1,
        y_dimension: 1,
        type_id: tube.id
    },
    {
        name: '15 mL tube',
        x_dimension: 1,
        y_dimension: 1,
        type_id: tube.id
    }
].each do |ct|
    ContainerType.where(ct).first_or_create()
end

