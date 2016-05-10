# frozen_string_literal: true

class Ticket

  attr_accessor :user_id, :answer_session_id

  def initialize(user_id, answer_session_id)
    @user_id = user_id
    @answer_session_id = answer_session_id
  end

  def user
    User.find_by_id(@user_id)
  end

  def answer_session
    AnswerSession.find_by_id(@answer_session_id)
  end

  def survey
    self.answer_session.survey
  end

end
