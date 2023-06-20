require "kemal"

charmander = { id: "1", name: "Charmander", type: "fire" }
bulbasaur = { id: "2", name: "Bulbasaur", type: "Grass" }
squirtle = { id: "3", name: "Squirtle", type: "Water" }

pokemons = [charmander, bulbasaur, squirtle]
# pokemons = [1, 2, 3]

get "/" do
  pokemons.to_json
end

get "/:id" do |env|
  pokemonId = env.params.url["id"]

  pokemon = pokemons.find { |pokemon| pokemon[:id] === pokemonId }
  pokemon.to_json
end

post "/" do|env|
  pokemonName = env.params.json["name"].as(String)
  pokemonType = env.params.json["type"].as(String)

  pokemon = { id: "#{pokemons.size + 1}", name: pokemonName, type: pokemonType }

  pokemons.push(pokemon)

  pokemon.to_json
end

put "/:id" do |env|
  pokemonId = env.params.url["id"].as(String)
  pokemonName = env.params.json["name"].as(String)
  pokemonType = env.params.json["type"].as(String)

  pokemon = { id: pokemonId, name: pokemonName, type: pokemonType }

  pokemonIndex = pokemons.bsearch_index { |pokemon, i| pokemon[:id] === pokemonId }

  if pokemonIndex != nil
      pokemons[pokemonIndex.as(Int32)] = pokemon
     else 
      pokemons.push(pokemon)
   end 


  pokemon.to_json
end

delete "/:id" do |env|
  pokemonId = env.params.url["id"].as(String)
  pokemonIndex = pokemons.bsearch_index { |pokemon, i| pokemon[:id] === pokemonId }

  if pokemonIndex != nil
      pokemons.delete_at(pokemonIndex.as(Int32)).to_json
   end 
end

Kemal.run
