# Taxon

taxons = Taxon.create(
    [
        {
            ncbi_id: 9606,
            scientifif_name: "Homo sapiens",
            common_name: "human"
        },
        {
            ncbi_id: 10090,
            scientifif_name: "Mus musculus",
            common_name: "house mouse"
        },

        {
            ncbi_id: 4932,
            scientifif_name: "Saccharomyces cerevisiae",
            common_name: "baker's yeast"
        },

        {
            ncbi_id:  7955,
            scientifif_name: "Danio rerio",
            common_name: "zebrafish"
        },

    ]
)

# Ontology
obi = Ontology.create(
    name: "Ontology for Biomedical Investigations",
    prefix: "OBI",
    release: "2012-07-01",
    uri: "http://purl.bioontology.org/ontology/OBI",
    description: "OBI is an ontology of investigations, the protocols and instrumentation used, the material used, the data generated and the types of analysis performed on it."
    )
nci = Ontology.create(
    name: "National Cancer Institute Thesaurus ",
    prefix: "NCIT",
    release: "13.05d",
    uri: "http://purl.bioontology.org/ontology/NCIT",
    description: "A vocabulary for clinical care, translational and basic research, and public information and administrative activities."
    )

# OntologieTerm

# containers
plate = OntologyTerm.create(
            name: "microtiter plate",
            accession: "obo:OBI_0000192",
            definition: "A microtiter_plate is a flat plate with multiple wells used as small test tubes.",
            ontology: obi)

tube =  OntologyTerm.create(
            name: "test tube",
            accession: "obo:OBI_0000836",
            definition: "A test tube is a device consisting of a glass or plastic tubing, open at the top, usually with a rounded U-shaped bottom which has the function to contain material",
            ontology: obi)
# sample characteristics
# gender
# ContainerType
container_types = ContainerTypes
