class Snowman
  SNOWMAN_IMG ||= './imgs/snowman.ascii-art'
  SNOWMAN_MELTED_BOTTOM_IMG ||= './imgs/snowman_melted_bottom.ascii-art'
  DIFFICULTY_LEVELS ||= {
    easy: 1,
    medium: 2,
    hard: 4,
    impossible: 8
  }

  def initialize(difficulty:)
    @num_lines_to_remove = DIFFICULTY_LEVELS[difficulty]
    @snowman = File.readlines(SNOWMAN_IMG)
    @snowman_melted_bottom = File.readlines(SNOWMAN_MELTED_BOTTOM_IMG)
  end

  def melt!
    @num_lines_to_remove.times {
      @snowman.pop()
      @snowman.unshift('')
    }
  end

  def melting?
    @snowman.reject(&:empty?).length < 20
  end

  def melted?
    @snowman.reject(&:empty?).length < 5
  end

  def render(stripped: false)
    renderable_snowman = melting? ? @snowman + @snowman_melted_bottom : @snowman.join('') + "\n\n"
    renderable_snowman.reject!(&:empty?) if stripped
    puts(renderable_snowman)
  end
end