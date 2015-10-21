class Api::PlayersController < Api::BaseController
  def create
    player = Player.find_or_initialize_by(uid: extract_uid)
    player.name = params[:name]
    player.picture = params[:picture]

    if player.persisted?
      render_json({token: :token, status: 'authorized'})
    elsif player.save
      render_json({token: :token, status: 'success'})
    else
      json = {id: nil, errors: player.errors.as_json}.to_json.gsub(/player\./, '')
      render_json(json, status: 422)
    end

    #TODO
    # result = BuildResultForPlayer.call(player)

    # if result.persisted?
    #   result.correct_answers = CollectRandomQuestions::LIMIT
    #   render_result(result)
    # elsif result.save
    #   render_json({id: result.id, questions: result.questions.sort_by(&:id)})
    # else
    #   json = {id: nil, errors: result.errors.as_json}.to_json.gsub(/player\./, '')
    #   render_json(json, status: 422)
    # end
  end

  def extract_uid
    token = find_or_create_token
    token || logger.warn("Invalid token: #{params.slice(:user_id, :token).inspect}")
    token.presence && token.uid
  end

end