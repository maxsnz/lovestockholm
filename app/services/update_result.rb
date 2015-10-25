class UpdateResult
  include CallableClass

  attr_reader :result, :answers, :bonus

  def initialize(result, answers, bonus)
    @result = result
    @answers = JSON.parse(answers)
    @bonus = bonus.to_i
  end

  def call
    result.seconds = (Time.now.to_f - result.start).round(2)
    result.score = 0
    i = 0
    result.questions.all.find_each { |q|
      if q.correct == answers[i]['option'] 
        result.score = result.score + (100-answers[i]['time'].to_i)
      end
      i +=1
    }
    bonus = 0 if bonus.to_i > 100
    result.score = result.score + bonus.to_i
    # result.correct_answers = result.questions.sort_by(&:id).select.with_index { |q, i|
    #    q.correct_n == answers[i] 
    # }.size

    method = "answer_correctly" # если все ок
    if (result.seconds > 100 * 10) || (result.seconds < 1)
      method = "answer_reject"
      result.score = 0
    end

    # "answer_#{result.correct_answers == result.questions.size ? "" : "in"  }correctly"

    result.send(method)
  end
end
