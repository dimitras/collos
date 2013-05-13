namespace :ncbi_taxonomy do

  desc "Downloads the NCBI taxonomy from the interwebz"
  task :download do
    unless File.exists? "#{Rails.root}/tmp/taxdmp.zip"
      system("wget -O #{Rails.root}/tmp/taxdmp.zip ftp://anonymous@ftp.ncbi.nih.gov/pub/taxonomy/taxdmp.zip")
      system("unzip -d #{Rails.root}/tmp/ncbi #{Rails.root}/tmp/taxdmp.zip")
    end
  end

  desc "Loads the NCBI taxonomy into the DB"
  task :load => [:environment, :download] do
    require 'sequel'
    c = ActiveRecord::Base.connection_config
    DB = Sequel.connect("postgres://#{c[:username]}:#{c[:password]}@localhost/#{c[:database]}")
    T = DB[:taxons]
    TN = DB[:taxon_names]
    # load the nodes.dmp table
    cols = %w{ ncbi_id parent_ncbi_id rank }.map{|x| x.to_sym }
    count = 0
    records = []
    print "Inserting Taxon nodes ..."
    conn = Taxon.connection
    File.open("#{Rails.root}/tmp/ncbi/nodes.dmp").each do |l|
      if count < 1000
        e = l.chomp.split(/\|/).map {|x| x.strip }
        records << [e[0].to_i, e[1].to_i, e[2]]
        count += 1
      else
        T.import(cols,records)
        print "."
        count = 0
        records = []
      end
    end
    T.import(cols,records)
    puts " finished."

    puts "Updating parent taxon information"
    DB.execute("UPDATE taxons t set parent_taxon_id = (select tt.id from taxons tt where t.parent_ncbi_id = tt.ncbi_id limit 1)")

    print "Inserting TaxonName nodes ..."
    cols = [:ncbi_taxon_id,:name,:name_class]
    count = 0
    records = []
    File.open("#{Rails.root}/tmp/ncbi/names.dmp").each do |l|
      if count < 1000
        e = l.chomp.split(/\|/).map {|x| x.strip }
        records << [e[0].to_i, e[1],e[3]]
        count += 1
      else
        TN.import(cols,records)
        print "."
        records = []
        count = 0
      end
    end
    TN.import(cols,records)
    puts " finished."

    puts "Updating TaxonName entries with FK to Taxon"
    DB.execute("UPDATE taxon_names tn set taxon_id = (select t.id from taxons t where t.ncbi_id = tn.ncbi_taxon_id limit 1)")
  end
end
