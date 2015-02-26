class Ticket

  attr_accessor :user_id, :survey_id

  def initialize(user_id, survey_id)
    @user_id = user_id
    @survey_id = survey_id
  end

  def user
    User.find_by_id(@user_id)
  end

  def survey
    Survey.find_by_id(@survey_id)
  end

end
