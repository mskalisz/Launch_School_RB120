=begin
Complete this program so that it produces the expected output:

class Book
  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

Expected output:

The author of "Snow Crash" is Neil Stephenson.
book = "Snow Crash", by Neil Stephenson.
=end

class Book
  attr_accessor :author, :title

  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

=begin
Add the following code to the class (between lines 1 and 2 will be fine):

attr_reader :author, :title

Discussion
If you try to run the original code, you'll see something like this:

x.rb:13:in `<main>': undefined method `title' for #<Book:0x007f8504842930> (NoMethodError)

Hmm... title is undefined at line 13 where we are attempting to retrieve the book title by calling the title
method. So, you add:

attr_reader :title

to the class definition. You run your code again, and this time get:

x.rb:15:in `<main>': undefined method `author' for #<Book:0x007fac948565b8> (NoMethodError)

It looks like we also need a getter for @author:

attr_reader :author, :title

The code will now run as expected.

Further Exploration
What are the differences between attr_reader, attr_writer, and attr_accessor? Why did we use attr_reader 
instead of one of the other two? Would it be okay to use one of the others? Why or why not?

Instead of attr_reader, suppose you had added the following methods to this class:

def title
  @title
end

def author
  @author
end

Would this change the behavior of the class in any way? If so, how? If not, why not? Can you think of any 
advantages of this code?
=end