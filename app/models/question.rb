class Question < ActiveRecord::Base
  # CORRECT_MARK = /^\*\s*/
  has_many :answers

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
      # question: question,
      # options: formatted_options
    }
  end
end
