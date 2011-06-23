class Searchable
  attr_accessor :title
end

Sunspot.setup(Searchable) do
  text :title
end