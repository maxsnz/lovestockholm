class UpdateResult
  include CallableClass

  attr_reader :result, :answers

  def initialize(result, answers)
    @result = result
    @answers = JSON.parse(answers)
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
    bonus = answers[answers.length - 1]['option'].to_i
    result.score = result.score + bonus if bonus < 101 && bonus > 0

    method = "answer_correctly" # если все ок
    if (result.seconds > 100 * 10) || (result.seconds < 0) # TODO поменять минимальное время
      method = "answer_reject"
      result.score = 0
    end


    result.send(method)
  end
end
