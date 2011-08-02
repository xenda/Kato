require 'csv'

CSV.foreach("ganadores.csv", :headers => true) do |row|
      fields = *row.fields
      fields = fields.map &:strip
      document_type, document_number, middle_name, last_name, name = fields
      # puts document_number
      Client.create(:document_number => document_number, :document_type => document_type, :middle_name => middle_name, :last_name => last_name, :name => name)
end