class BuildResultForPlayer
  def self.call(player)
    #(player.persisted? && Result.with_state(Result::PENDING).joins(:player).where(players: {uid: player.uid}).first) ||
    Result.new(player: player, state: Result::PENDING, start: Time.now.to_f, questions: CollectRandomQuestions.call, score: 0)
  end
end
