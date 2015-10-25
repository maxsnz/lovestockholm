class CollectRandomQuestions
  SIMPLE = 7
  IMAGES = 1
  ORDER  = 1

  def self.call
    questions = Question.all

    simple = questions.where(kind: 'simple').all.shuffle
    images = questions.where(kind: 'images').all.shuffle
    order = questions.where(kind: 'order').all.shuffle

    # not_brand = questions.reject(&:brand?).shuffle
    # brand = questions.select(&:brand?).shuffle

    (simple.take(SIMPLE) + images.take(IMAGES) + order.take(ORDER)).shuffle
  end
end
