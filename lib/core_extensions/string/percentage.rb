# A bit of spicy monkey patching
class String
  def percentage?
    /\A[-+]?\d+\z/ =~ self && to_i >= 0 && to_i <= 100
  end
end
 