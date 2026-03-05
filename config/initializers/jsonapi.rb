require 'jsonapi/serializer'

# Force load serializers if autoloading is acting up in this environment
Dir[Rails.root.join('app/serializers/*.rb')].each do |file|
  require_dependency file
end
