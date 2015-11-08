class Result < ActiveRecord::Base
  attr_accessor :correct_answers

  LIMIT = 15

  self.per_page = 200

  belongs_to :player#, autosave: true
  # belongs_to foreign_key: :n, primary_key: :n #TODO
  has_and_belongs_to_many :questions

  PENDING   = 'pending'
  DONE   = 'done'
  REJECT     = 'reject'

  TRANSITIONS = {
    answer_correctly: [PENDING, DONE],
    answer_reject: [PENDING, REJECT]
  }

  state_machine initial: PENDING do
    TRANSITIONS.each do |event_name, transitions|
      event event_name do
        transition transitions[0] => transitions[1]
      end
    end
  end

  validates_presence_of :questions, :player
  validates_associated :player

  # это не надо проверять
  # validate :ensure_player_has_not_played_already

  # это про победителей
  scope :board, -> { with_state(DONE).order(:score).preload(:player) }
  
  def as_json(options = {})
    {
      name: player.name,
      seconds: seconds,
      date: I18n.l(updated_at, format: :list)
    }.merge(options[:place] ? { place: options[:place] } : { score: score })
  end

  private


  # def ensure_player_has_not_played_already
  #   errors.add(:player_id, :taken) if Result.with_state(PUBLISHED).where(player_id: player_id).exists?
  # end
end
