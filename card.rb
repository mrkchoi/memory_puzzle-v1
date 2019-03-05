

class Card
  attr_reader :displayed, :matched
  attr_accessor :value, :hidden_value

  def initialize
    @value = ' '
    @hidden_value = ' '
    @displayed = false
    @matched = false
  end

  # def print_status
  #   if @displayed
  #     return "card revealed!"
  #   else
  #     return "card hidden!"
  #   end
  # end

  def hide
    if @displayed == true
      @displayed = false
      @value = ' '
    end
  end

  def reveal
    if @displayed == false
      @displayed = true
      @value = @hidden_value
    end
  end

  def match?
    @hidden_value == @value
  end
end


# c = Card.new('T')



