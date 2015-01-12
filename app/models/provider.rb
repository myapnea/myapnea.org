class Provider < User
  after_create set_type



  private

  def set_type
    update_attribute(:type, 'provider')
  end
end
