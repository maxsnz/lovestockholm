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
      if q.correct == answers[i]['option'].to_i
        result.score = result.score + (100-answers[i]['time'].to_i)
      end
      i +=1
    }
    if bonus > 100
      bonus = 0 
    end
    result.score +=bonus || 0 # TODO бонус не начисляется

    method = "answer_correctly" # если все ок
    if (result.seconds > 100 * 10) || (result.seconds < 1) # TODO поменять минимальное время
      method = "answer_reject"
      result.score = 0
    end


    result.send(method)
  end
end
