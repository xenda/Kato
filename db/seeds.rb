# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
require 'csv'

CSV.foreach("base2.csv", :headers => true) do |row|
      fields = *row.fields
      fields = fields.map &:strip
      document_type, document_number, middle_name, last_name, name = fields
      # puts document_number
      Client.create(:document_number => document_number, :document_type => document_type, :middle_name => middle_name, :last_name => last_name, :name => name)
      # Client.connection.execute("insert into clients (document_number, document_type, middle_name, last_name, name) values ('#{document_number}','#{document_type}','#{middle_name}','#{last_name}','#{name}')")
end
