class UpdateResult
  include CallableClass

  attr_reader :result, :answers

  def initialize(result, answers)
    @result = result
    @answers = answers.to_s.split(",").map { |n|
      s = n.gsub(/\D+/, '')
      s.presence && s.to_i
    }
  end

  def call
    result.seconds = (Time.now.to_f - result.start).round(2)
    result.correct_answers = result.questions.sort_by(&:id).select.with_index { |q, i| q.correct_n == answers[i] }.size

    method = "answer_#{result.correct_answers == result.questions.size ? "" : "in"  }correctly"

    result.send(method)
  end
end
