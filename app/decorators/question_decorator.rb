# encoding: UTF-8
class QuestionDecorator < Draper::Decorator
  include LinkToEdit

  def question
    link_to_edit(:question)
  end

  def options
    h.simple_format model.options
  end

  def brand
    model.brand.presence && "✔"
  end
end
