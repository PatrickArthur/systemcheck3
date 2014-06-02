require 'sinatra'
require 'csv'
require 'pry'
require 'redis'
require 'json'
require 'pg'

require 'sinatra/flash'



def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)


  ensure
    connection.close
  end
end


get '/recipes' do
  query = db_connection do |conn|
    conn.exec('select id, name from recipes;')
  end
  @query2=query.to_a
  erb :'/index'
end


get '/recipes/:id' do
  @recipe=[]
  query = db_connection do |conn|
    conn.exec('SELECT recipes.id,recipes.name,recipes.description,recipes.instructions,ingredients.name as ingredients
      FROM recipes JOIN ingredients ON recipes.id = ingredients.recipe_id ;')
  end
  @query3=query.to_a
  @query3.each do |x|
     if x['id'] == params['id']
       @recipe << x
     end
  end
   erb :'/show'
 end




