namespace :db do

    desc "Rebuild the DB, model annotation and ER diagram"

    task :rebuild => [:environment,'db:drop','db:create','db:migrate'] do
        `railroady -t -j  --show-belongs_to -M > models.dot`
        `dot -T png -o models.png models.dot`
        `annotate`
    end
end
