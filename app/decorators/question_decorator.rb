# encoding: UTF-8
class QuestionDecorator < Draper::Decorator
  include LinkToEdit

  def picture
    if model.picture.length > 0
      h.image_tag model.picture
    end
  end


end
