require 'presenters/item_presenter'
require 'presenters/user_presenter'
require 'sequel/model'
require 'sinatra/base'
require 'json'

class Application < Sinatra::Base

  get '/users/:username/items' do
    name = CGI.unescape(params[:username])
    user = Persistence::UserAccessor.find_by_name(name)

    return [404] if user.nil?

    items = Persistence::ItemAccessor.all(name)
    [200, present_items(items)]
  end

  get '/users/:username/items/incomplete' do
    name = CGI.unescape(params[:username])
    user = Persistence::UserAccessor.find_by_name(name)

    return [404] if user.nil?

    items = Persistence::ItemAccessor.incomplete(name)
    [200, present_items(items)]
  end

  post '/users' do
    attributes = JSON.parse(@request.body.read)['user']

    if !(attributes.keys == ['name'])
      error_response = JSON.generate({
        error: 'name required'
      })
      return [400, error_response]
    end

    user_id = Persistence::UserAccessor.create(attributes)
    user = Persistence::UserAccessor.find(user_id)
    [200, present_user(user)]
  end

  post '/items' do
    attributes = JSON.parse(@request.body.read)['item']
    user = Persistence::UserAccessor.find_by_name(attributes['userName'])

    return [404] if user.nil?

    serialized_attributes = serialize_item_attributes(attributes)
    item_id = Persistence::ItemAccessor.create(serialized_attributes)

    item = Persistence::ItemAccessor.find(item_id)
    [200, present_item(item)]
  end

  put '/items/:id' do
    item_id = params[:id]
    item = Persistence::ItemAccessor.find(item_id)

    return [404] if item.nil?

    attributes = JSON.parse(@request.body.read)['item']
    serialized_attributes = serialize_item_attributes(attributes)
    Persistence::ItemAccessor.update(item_id, serialized_attributes)

    item = Persistence::ItemAccessor.find(item_id)
    [200, present_item(item)]
  end

  put '/items/:id/complete' do
    item_id = params[:id]
    item = Persistence::ItemAccessor.find(item_id)

    return [404] if item.nil?

    attributes = JSON.parse(@request.body.read)['item']
    Persistence::ItemAccessor.update(item_id, {complete: true})

    item = Persistence::ItemAccessor.find(item_id)
    [200, present_item(item)]
  end

  def serialize_item_attributes(attributes)
    {
      user_name: attributes['userName'],
      description: attributes['description'],
      due_date: attributes['dueDate'],
      complete: attributes['complete']
    }
  end

  def present_user(user)
    presented_user = Presenters::UserPresenter.present(user)
    JSON.generate({user: presented_user})
  end

  def present_items(items)
    presented_items = items.map do |item|
      Presenters::ItemPresenter.present(item)
    end

    JSON.generate({items: presented_items})
  end

  def present_item(item)
    presented_item = Presenters::ItemPresenter.present(item)
    JSON.generate({item: presented_item})
  end

  class << self
    def initialize!
      initialize_database_connection!

      require 'persistence/user_accessor'
      require 'persistence/item_accessor'
    end

    private

    def initialize_database_connection!
      database_configuration = Configuration.database_configuration
      Persistence::DatabaseManager.set_configuration(database_configuration)
      database = Sequel.connect(Persistence::DatabaseManager.url(:test))
      Sequel::Model.db = database
    end
  end

end
