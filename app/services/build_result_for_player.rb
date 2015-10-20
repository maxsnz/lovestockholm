class BuildResultForPlayer
  def self.call(player)
    (player.persisted? && Result.with_state(Result::CORRECT).joins(:player).where(players: {uid: player.uid}).first) ||
      Result.new(player: player, start: Time.now.to_f, questions: CollectRandomQuestions.call)
  end
end
