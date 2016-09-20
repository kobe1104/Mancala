class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = Array.new(14) {Array.new}
    @cups.each_with_index.map {|a, i| 4.times {a << :stone} unless i == 6 || i == 13}
    @name1 = name1
    @name2 = name2
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
  end

  def valid_move?(start_pos)
    #cannot start with an empty cup, store or cup out of range
    if start_pos == 6 || start_pos == 13 ||
        start_pos > 13 || start_pos < 0 ||
          @cups[start_pos].size == 0
          raise "Invalid starting cup"
    end
  end

  def make_move(start_pos, current_player_name)
    valid_move?(start_pos)
    stones = @cups[start_pos].size
    @cups[start_pos].clear
    next_pos = start_pos + 1
    current_player_name == @name1 ? avoid = 13 : avoid = 6

    until stones == 0
      unless next_pos == avoid
        @cups[next_pos] << :stone
        stones -= 1
      end

      if next_pos == 13
        next_pos = 0 if stones > 0
      else
        next_pos += 1
      end
    end
    #if it ends at 13 keep it
    unless next_pos == 13
      end_pos = next_pos - 1
    else
      end_pos = next_pos
    end

    render
    next_turn(end_pos)

  end

  def next_turn(ending_cup_idx)
    # helper method to determine what #make_move returns
      #if it ends on your own store, continue
    return :prompt if ending_cup_idx == 13 || ending_cup_idx == 6

    case @cups[ending_cup_idx].size <=> 1
    when 1
      :prompt
      ending_cup_idx
    when 0
      :switch
    end
  end


  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def cups_empty?
    if (@cups[0..5].all? {|a| a.empty?} || @cups[7..12].all? {|a| a.empty?})
      true
    elsif (@cups[0..5].none? {|a| a == []} && @cups[7..12].none? {|a| a == []})
      false
    end
  end

  def winner
    return :draw if @cups[6].size == @cups[13].size
    if @cups[6].size > @cups[13].size
      @name1
    else
      @name2
    end
  end
end
