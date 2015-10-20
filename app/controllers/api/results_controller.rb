class Api::ResultsController < Api::BaseController
  def create
    player = Player.find_or_initialize_by(uid: extract_uid)
    player.name = params[:name]
    player.email = params[:email]

    result = BuildResultForPlayer.call(player)

    if result.persisted?
      result.correct_answers = CollectRandomQuestions::LIMIT
      render_result(result)
    elsif result.save
      render_json({id: result.id, questions: result.questions.sort_by(&:id)})
    else
      json = {id: nil, errors: result.errors.as_json}.to_json.gsub(/player\./, '')
      render_json(json, status: 422)
    end
  end

  def update
    result = Result.with_state(Result::PENDING).joins(:player).where(players: {uid: extract_uid}, id: params[:id]).first

    if result
      UpdateResult.call(result, params[:answers])
      render_result(result)
    else
      render_json({error: "not found"}, status: 422)
    end
  end

  def publish
    result = Result.with_state(Result::CORRECT).joins(:player).where(players: {uid: extract_uid}, id: params[:id]).first

    render_json({ok: !!(result && result.publish)})
  end

  def index
    render_results Result.board
  end

  def all
    render_results Result.board
  end

  def winners
    render_json Result.winners.sort_by(&:n)
  end

  private

  def render_result(result)
    render_json({id: result.id, state: result.state, correct_answers: result.correct_answers, seconds: result.seconds})
  end

  def extract_uid
    token = find_or_create_token
    token || logger.warn("Invalid token: #{params.slice(:user_id, :token).inspect}")
    token.presence && token.uid
  end

  def render_results(scope)
    paginated = scope.paginate(page: params[:page])
    results = paginated.each_with_index.map { |r, i| r.as_json(place: paginated.offset + i + 1) }

    render_json({
      results: results,
      total_pages: paginated.total_pages
    })
  end

end
