module MetaAttributesControllerMixin
  def set_meta(instance)
    attributes = {}
    if params[:key] && params[:value]
      params[:key].zip(params[:value]).each do |key, value|
        attributes[key] = value
      end
    end
    instance.set_meta_multi(attributes)
  end
end
