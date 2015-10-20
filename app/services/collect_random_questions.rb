class CollectRandomQuestions
  LIMIT = 6
  BRAND = 2

  def self.call
    questions = Question.all

    not_brand = questions.reject(&:brand?).shuffle
    brand = questions.select(&:brand?).shuffle

    (not_brand.take(LIMIT - BRAND) + brand.take(BRAND)).shuffle
  end
end
