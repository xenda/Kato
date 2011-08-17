# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
require 'csv'
x = 0
CSV.foreach("mundosueldo.csv", :headers => true) do |row|
      fields = *row.fields
      fields = fields.map &:strip
      document_number = fields.first
      # puts document_number
      x +=1
      puts "#{x} - #{document_number}"
      unless Client.find_by_document_number(document_number) 
      	
      	#Client.create(:document_number => document_number, :document_type => document_type, :middle_name => "", :last_name => "", :name => "")
      	Client.connection.execute("INSERT INTO clients (document_number, document_type) VALUES ('#{document_number}','L')")
      	puts "Inserting #{document_number}"
      	# logger.info "#{x} - #{document_number}"
      	# say "#{x} - #{document_number}"
      end
      # Client.connection.execute("insert into clients (document_number, document_type, middle_name, last_name, name) values ('#{document_number}','#{document_type}','#{middle_name}','#{last_name}','#{name}')")
end
