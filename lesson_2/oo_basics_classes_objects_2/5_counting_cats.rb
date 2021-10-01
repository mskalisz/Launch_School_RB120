=begin
Using the following code, create a class named Cat that tracks the number of times a new Cat object is 
instantiated. The total number of Cat instances should be printed when ::total is invoked.

kitty1 = Cat.new
kitty2 = Cat.new

Cat.total

Expected output:

2
=end

class Cat
  @@number = 0

  def initialize
    @@number += 1
  end

  def self.total
    p @@number
  end
end

kitty1 = Cat.new
kitty2 = Cat.new

Cat.total