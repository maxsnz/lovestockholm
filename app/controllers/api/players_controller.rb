class Api::PlayersController < Api::BaseController
  def create
    player = Player.find_or_initialize_by(uid: extract_uid)
    player.name = params[:name]
    player.picture = params[:picture]


    if player.persisted?
      limit = count_limit(player)
      render_json({token: :token, status: 'authorized', limit: limit})
    elsif player.save
      render_json({token: :token, status: 'success', limit: 15})
    else
      json = {id: nil, errors: player.errors.as_json}.to_json.gsub(/player\./, '')
      render_json(json, status: 422)
    end
  end

  def index
    render_players Player.all
  end

  def render_players(scope)
    paginated = scope.order(score: :desc).paginate(page: params[:page])
    players = paginated.each_with_index.map { |r, i| r.as_json(place: paginated.offset + i + 1) }

    render_json({
      players: players,
      total_pages: paginated.total_pages
    })
  end

  def count_limit(player)
    Result::LIMIT - Result.where("created_at >= ?", Time.zone.now.beginning_of_day).where(player:player).where(state:'done').length
  end  

  def show
    id = params[:id]
    player =  Player.where(uid: params[:id])[0]
    limit = count_limit(player)
    place =  Player.all.order(score: :desc).index(player) + 1
    render_json({score: player.score, picture: player.picture, name: player.name, place: place, limit: limit})
  end

  def extract_uid
    token = find_or_create_token
    token || logger.warn("Invalid token: #{params.slice(:user_id, :token).inspect}")
    token.presence && token.uid
  end

end