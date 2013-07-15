
namespace :taxon do
    usage =  "Usage:\nrake taxon:create NCBI_ID=1234 SCI_NAME='Foobus bartis' COM_NAME='foobar'"

    desc "Create a new taxon. #{usage}"
    task :create => :environment do

        if not (
            ENV.has_key?('NCBI_ID' ) or
            ENV.has_key?('SCI_NAME' ) or
            ENV.has_key?('COM_NAME' )
            )
            raise Exception.new("Derp, not enough args. #{usage}")
        end
        ncbi_id  = ENV['NCBI_ID']
        sci_name = ENV['SCI_NAME']
        com_name = ENV['COM_NAME']

        Taxon.create(ncbi_id: ncbi_id.to_i, scientific_name: sci_name, common_name: com_name)
    end

    desc "List the first 100 taxon that are in the database. Optional arg 'PAGE', e.g. rake taxon:list PAGE=3"
    task :list => :environment do
        pg = ENV['PAGE'] || 1
        Taxon.page(pg).per_page(100).each do |t|
            puts "[#{t.ncbi_id}] #{t.scientific_name} (#{t.common_name})"
        end
    end

    desc "Destory a Taxon. Usage: rake taxon:destroy NCBI_ID=1234"
    task :destroy => :environment do
        if not ENV.has_key? 'NCBI_ID'
            raise Exception.new("ERROR: Need NCBI_ID. Usage:\nrake taxon:remove NCBI_ID=1234")
        end
        t = Taxon.find_by_ncbi_id(ENV['NCBI_ID'])
        if t
            t.destroy
        else
            raise Exception.new("ERROR: Taxon with NCBI_ID=#{ENV['NCBI_ID']} not found.")
        end
    end
end
