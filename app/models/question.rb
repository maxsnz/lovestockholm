class Question < ActiveRecord::Base
  # CORRECT_MARK = /^\*\s*/
  has_many :answers
  include HasPreviews

  # validates_presence_of :question, :options
  # validates_format_of :options, with: CORRECT_MARK, multiline: true

  # def options=(v)
  #   write_attribute :options, v.to_s.lines.map(&:strip).reject(&:blank?).join("\n")
  # end

  # def formatted_options
  #   options.lines.map { |line| line.strip.gsub(CORRECT_MARK, '') }
  # end

  # def correct_n
  #   options.lines.map.with_index.find{|line,| line =~ CORRECT_MARK}[1]
  # end

  def as_json(options = {})
    {
      kind: kind,
      picture: picture,
      question: title,
      options: [
        {text: option1, image: picture1},
        {text: option2, image: picture2},
        {text: option3, image: picture3},
        {text: option4, image: picture4}
      ]
    }
    
  end
end
