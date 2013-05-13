namespace :db do

    desc "Annotate the models with table strucutre and create an ER diagram"
    task :annotate do
        `railroady -t -j  -M |grep -v Version > models.dot`
        `dot -T png -o models.png models.dot`
        `annotate`
    end

    desc "Rebuild the DB, model annotation and ER diagram"
    task :rebuild => [:environment,'db:drop','db:create','db:migrate', 'db:annotate'] do

    end
end
