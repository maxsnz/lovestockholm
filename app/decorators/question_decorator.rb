# encoding: UTF-8
class QuestionDecorator < Draper::Decorator
  include LinkToEdit

  def question
    link_to_edit(:question)
  end

end
