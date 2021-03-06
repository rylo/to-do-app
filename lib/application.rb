require 'environment'
require 'sinatra/base'
require 'persistence/item_accessor'
require 'presenters/item_presenter'
require 'validators/item_validator'
require 'domain/items'
require 'domain/users'
require 'json'

class Application < Sinatra::Base

  before '*' do
    content_type 'application/json'
  end

  get '/users/:username/items' do
    name = CGI.unescape(params[:username])

    status, body = Domain::Items.fetch_all_for_user(name)
    [status, serialize(body)]
  end

  get '/users/:username/items/incomplete' do
    name = CGI.unescape(params[:username])

    status, body = Domain::Items.fetch_incomplete_for_user(name)
    [status, serialize(body)]
  end

  post '/users' do
    attributes = deserialize(@request.body.read)['user']

    status, body = Domain::Users.create(attributes)
    [status, serialize(body)]
  end

  post '/items' do
    attributes = deserialize(@request.body.read)['item']
    validation_errors = ItemValidator.validate(attributes)
    return [400, serialize({errors: validation_errors})] if validation_errors.any?

    user = Persistence::UserAccessor.find_by_name(attributes['userName'])
    return [404] if user.nil?

    serialized_attributes = deserialize_item_attributes(attributes)
    item_id = Persistence::ItemAccessor.create(serialized_attributes)

    item = Persistence::ItemAccessor.find(item_id)
    [200, present_item(item)]
  end

  put '/items/:id' do
    item_id = params[:id]
    item = Persistence::ItemAccessor.find(item_id)

    return [404] if item.nil?

    attributes = deserialize(@request.body.read)['item']
    serialized_attributes = deserialize_item_attributes(attributes)
    Persistence::ItemAccessor.update(item_id, serialized_attributes)

    item = Persistence::ItemAccessor.find(item_id)
    [200, present_item(item)]
  end

  put '/items/:id/complete' do
    item_id = params[:id]
    item = Persistence::ItemAccessor.find(item_id)

    return [404] if item.nil?

    Persistence::ItemAccessor.update(item_id, {complete: true})

    item = Persistence::ItemAccessor.find(item_id)
    [200, present_item(item)]
  end

  def deserialize(request_body)
    JSON.parse(request_body)
  end

  def serialize(response_body)
    JSON.generate(response_body)
  end

  def deserialize_item_attributes(attributes)
    {
      user_name: attributes['userName'],
      description: attributes['description'],
      due_date: attributes['dueDate'],
      complete: attributes['complete']
    }
  end

  def present_item(item)
    presented_item = Presenters::ItemPresenter.present(item)
    serialize({item: presented_item})
  end

end
