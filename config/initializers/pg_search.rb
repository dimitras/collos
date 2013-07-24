PgSearch.multisearch_options = {
    using: {
        tsearch: {
            prefix: true,
            any_word: true,
            tsvector_column: 'tsv_content'
        }
    }
}
