PgSearch.multisearch_options = {
    using: {
        tsearch: {
            :dictionary => "english",
            prefix: true,
            any_word: true,
            tsvector_column: 'tsv_content'
        }
    }
}
