## Example 1
```
class Person
  attr_reader :name
  
  def set_name
    @name = 'Bob'
  end
end

bob = Person.new
p bob.name
```

What is output and why? What does this demonstrate about instance variables that differentiates them from local variables?

This code outputs `nil`. This is because the instance variable name is not initialized correctly. `attr_reader` is read only. `set_name` could be a writer method, but would be called by `bob.set_name`, and so when we try to access it with `bob.name` it is still considered uninitialized. Uninitialized instance variables always return `nil` when we try to access them through the getter method. When we try to access an uninitialised local variable it will raise an error.

### Answer re-do
This code outputs `nil`. On `line 11` a new object `bob` is initialized by calling the `::new` method on the class `Person`. Within the method we have getter method `name` initialized by the method accessor `attr_reader` and an instance method `set_name`. There are no instance variables defined within `Person` and so `line 12` outputs `nil` when we attempt to invoke `name` on the variable `bob`. This is because we are trying to access an uninitialized instance variable. Uninitialized instance variables always return `nil` when we try to access them through a getter method while an uninitialized local variable would raise an error. The state of the object is encapsulated by the instance variables. The state of an object is the colllection of all of its instance variables and the values it references. Instance methods can access instance variables. Instance variables exists as long as the object exists. Once the Object is destroyed then the instance variable perishes along with it.

## Example 2
What is output and why? What does this demonstrate about instance variables?

```
module Swimmable
  def enable_swimming
    @can_swim = true
  end
end

class Dog
  include Swimmable

  def swim
    "swimming!" if @can_swim
  end
end

teddy = Dog.new
p teddy.swim
```

This code outputs `nil`. On `line 40` a local variable `teddy` is instantiated to a new object by calling the `::new` class method on the class `Dog`. There are no instance variables defined within `Dog` and so `line 41` outputs `nil` when we attempt to invoke `swim` on the variable `teddy`, even with the `Swimmable` module mixed in. This is because we are trying to access an uninitialized instance variable. Uninitialized instance variables always return `nil` when we try to access them through a getter method while an uninitialized local variable would raise an error. The state of the object is encapsulated by the instance variables. The state of an object is the colllection of all of its instance variables and the values it references. Instance methods can access instance variables. Instance variables exists as long as the object exists. Once the Object is destroyed then the instance variable perishes along with it.

### Answer re-do
In Ruby uninitialized instance variables always return `nil` when we try to access them through a getter method. When we try to access an uninitialised local variable it will raise an error.

In `line 40` a local variable `teddy` is instantiated to a new object by calling the `::new class` method on the class `Dog`. There are no instance variables defined within `Dog` and so `line 41` outputs `nil` when we attempt to invoke `swim` on the variable `teddy`, even with the `Swimmable` module mixed in. This is because we are trying to access an uninitialized instance variable.

## Example 3

What is output and why? What does this demonstrate about constant scope? What does self refer to in each of the 3 methods above?

```
module Describable
  def describe_shape
    "I am a #{self.class} and have #{self.class::SIDES} sides."
  end
end

class Shape
  include Describable

  def self.sides
    self::SIDES
  end

  def sides
    self.class::SIDES
  end
end

class Quadrilateral < Shape
  SIDES = 4
end

class Square < Quadrilateral; end

p Square.sides # 4
p Square.new.sides # 4
p Square.new.describe_shape # 4
```
This code outputs `4`, then `4`, then `"I am a Square and I have 4 sides"`. 

This demonstrate that constants have a lexical scope. When Ruby looks for a constant, it first looks for the constant in the class which references it and then looks up the inheritance hierarchy when it cannot find it. 

On `line 58` `self` refers to whatever class is discribed

### Answer re-do
When Ruby looks for a constant it first looks for the constant in the class which references it and then looks up the inheritance hierarchy when it cannot find it. This is because the constants in Ruby have a lexical scope.

On `line 80` we are invoking the class method `sides` on the class `Square` this will print the integer `4`. This is because Ruby first looks for the class method in the method lookup path of the `Square` class eventually finding it in the `Shape` class and then resolves the expression `self::SIDES` which is the same as `Square::SIDES`. Ruby looks for `SIDES` in the method lookup path and finds it in the `Quadilateral` class.

On `line 81` the `sides` instance method is called on the new instance of the `Square` which, again, outputs the integer `4`. Ruby looks for the method in the method lookup path and finds the `sides` instance method in the `Shape` class. The last expression within the method is `self.class::SIDES` which equates to `Square.new.class::SIDES`. As before the value referenced by `SIDES` is 4.

On `line 82`, we invoke the `describe_shape` instance method on a new `Square` object. Since the `SIDES` constant is referenced within this method without a qualifying namespace, Ruby checks the method lookup path, to see if it defines the constant. Since it finds it, in the superclass `Quadrilateral` Ruby outputs "I am a Square and I have 4 sides".

## Example 4
What is output? Is this what we would expect when using AnimalClass#+? If not, how could we adjust the implementation of AnimalClass#+ to be more in line with what we'd expect the method to return?

```
class AnimalClass
  attr_accessor :name, :animals

  def initialize(name)
    @name = name
    @animals = []
  end

  def <<(animal)
    animals << animal
  end

  def +(other_class)
    animals + other_class.animals
  end
end

class Animal
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

mammals = AnimalClass.new('Mammals')
mammals << Animal.new('Human')
mammals << Animal.new('Dog')
mammals << Animal.new('Cat')

birds = AnimalClass.new('Birds')
birds << Animal.new('Eagle')
birds << Animal.new('Blue Jay')
birds << Animal.new('Penguin')

some_animal_classes = mammals + birds

p some_animal_classes
```
This code outputs an one array of Animal objects, when the expected output would be an animal class with an animals array as an instance variable. We could adjust the code as such:
```
  def +(other_class)
    combined = AnimalClass.new("Combined Animals")
    combined.animals =  animals + other_class.animals
  end
```
By doing this we are initializing a local variable `combined` to the return value of intantiating an instance of `AnimalClass`. We are invoke the `AnimalClass#animal=(name)` setter method on the object to the set the value of `@animals` instance variable to the return value of the expression `animals + combined.animals` . Since `combined` is the last evaluated expression within the method, the object referenced by `combined` is returned when the `AnimalClass#+` method is invoked.

## Example 5
We expect the code above to output ”Spartacus weighs 45 lbs and is 24 inches tall.” Why does our change_info method not work as expected?
```
class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def change_info(n, h, w)
    name = n
    height = h
    weight = w
  end

  def info
    "#{name} weighs #{weight} and is #{height} tall."
  end
end


sparky = GoodDog.new('Spartacus', '12 inches', '10 lbs')
sparky.change_info('Spartacus', '24 inches', '45 lbs')
puts sparky.info
# => Spartacus weighs 10 lbs and is 12 inches tall.
```

In the above code, we define an instance method `change_info` that tries to use the `name=`, `height=`, and `weight=` setter methods to reassign the values of each respective variable. However, because we are not using the keyword `self` within the instance method, Ruby assumes that we are instead initializing a local variable name, to which we assign the string object passed as argument.

When we call `change_info` on the GoodDog object `sparky` and pass the strings as arguments, these strings are assigned to local variables within the method and the instance variables remains pointing to their respective strings (ie `name` `height` and `weight` remain pointed to `'Spartacus'`, `'12 inches'`, and `'10 lbs'`). 

We need to use `self` to explicitly call the `name=` setter method in the `change_info` method as below:

```
def change_info(n, h, w)
  self.name = n
  self.height = h
  self.weight = w  
end
```

### Answer re-do
Within the `change_info` method definition we are not calling the setter methods `name=, height= and weight=` instead we are initializing the local variables `name, height and weight` and setting them to the arguments passed in during the `change_info` method invocation. So, the value referenced by the instance variables are not reassigned. Inorder to fix the issue we will have to call the setter methods using the `self` keyword which represents the current object. This is done as follows.

def change_info(n, h, w)
  self.name = n
  self.height = h
  self.weight = w
end

Here the `self` keyword references the calling object. Hence the setter methods are invoked with the required parameters are passed in as arguments. `Line 178` now outputs "Spartacus weighs 45 lbs and is 24 inches tall."

## Example 6
In the code above, we hope to output 'BOB' on line 224. Instead, we raise an error. Why? How could we adjust this code to output 'BOB'?
```
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def change_name
    name = name.upcase
  end
end

bob = Person.new('Bob')
p bob.name
bob.change_name
p bob.name
```

`line 224` raises an error because within the `change_name` method definition we are not calling the setter method `name=`. Instead, we are initializing the local variable `name` and setting it to the return value of `name.upcase`, which is `nil`. So, the value referenced by the instance variable `@name` is not reassigned. In order to fix this, we will have to call the setter methods using the `self` keyword which represents the current object. This is done as follows.

def change_name
  self.name = name.upcase
end

Here the `self` keyword references the calling object and the setter method is invoked. `Line 224` now outputs "BOB"

### Answer re-do
In `line 224` we are invoking the instance method `name` on the instance of the class `Person`. This raises an error. This is because within the method `change_name`, we have the experssion `name = name.upcase` where we are initialializing a new local variable name instead of calling the setter method `#name=`. In order to fix this code we have to call the setter method `name=(argument)` by invoking the setter method on the `self` keyword as `self.name = name.upcase`. This reassign the instance variable `@name` to `"BOB"`.
```
def change_name
  self.name = name.upcase
end
```
After the above modification the `line 16` will output `"BOB"`.

## Example 7
What does the code above output, and why? What does this demonstrate about class variables, and why we should avoid using class variables when working with inheritance?
```
class Vehicle
  @@wheels = 4

  def self.wheels
    @@wheels
  end
end

p Vehicle.wheels                             

class Motorcycle < Vehicle
  @@wheels = 2
end

p Motorcycle.wheels                           
p Vehicle.wheels                              

class Car < Vehicle; end

p Vehicle.wheels
p Motorcycle.wheels                           
p Car.wheels 
```

`line 255` outputs 4, and then the rest of the code outputs `2`. This is because on `line 248` we initialize a class variable `@@wheels` and assign it to the integer `4`. On `line 258` we reassign the class variable `@@wheels` to the integer `2`. Just one copy of the class variable exists for the Class and all of its instances. Reassigning the class variable at any point in the class hierarchy will change the value referenced by the class variable for the rest of the program, and so by reassigning `@@wheels` on `line 258` we also change its value in the superclass `Vehicle` on `line 248`. This behavior is unexpected, and because of this we should avoid working with class variables when working with inheritance.

### Answer re-do
Class variables are accessible from within the instance methods. Class variable are defined at the class level and is available to all the instances of the class . Just one copy of the class variable exists for the Class and all of its instances. Hence reassigning the class variable at any point in the class hierarchy will change the value referenced by the class variable for the rest of the program irreversibly. Due to this reason utilizing class variables can cause unexpected behaviour and due to this Rubyists tend to stay away from it.

Hence we get the following output

`line 9` will output the integer `4` because in `line 2` the class variable `@@wheels` is intialized to the integer `4`

`line 15` will output the integer `2` because in `line 12` the class variable `@@wheels` is reassigned to the integer `2`

the same copy of the class variables remains for the rest of the program hence `lines 15, 16, 20, 21, 22` all output the integer `2`

## Example 8
What is output and why? What does this demonstrate about super?
```
class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class GoodDog < Animal
  def initialize(color)
    super
    @color = color
  end
end

bruno = GoodDog.new("brown")       
p bruno
```
`line 303` outputs a GoodDog object, with instance variables `@name="brown"` and `@color="brown"`. `super` is a keyword used in Ruby to invoke a method with the same name within the method lookup path. When we invoke a method which has a `super` keyword, Ruby looks in the method lookup path to find another method with the same name. Ruby invokes the method when it finds it. By default `super` will pass all the arguments passed into the calling method to the other method with the same name, which is why both `@name` and `@color` are assigned to the string `"brown"` in this example. The `super` keyword can also take arguments so if we want to avoid `super` passing all of the arguments passed into the calling method, we can call the `super` keyword with a parenthesis such as `super()`

### Answer re-do
`line 17` outputs the object referenced by the local variable `bruno` which is an instance of the `GoodDog` class instantiated on `line 16`. The state of the object has two instance variables `@name` and `@color`. This is because within the constructor method initialize within the `GoodDog` class we have the `super` keyword which looks for the first occurance of the method with the same in the superclasses and invokes it. In this case it invokes the `initialize` method from the `Animal` class and passes all the arguments passed in to the constructor method in the `GoodDog` class. Thereby two instance variables `@name = brown` and `@color = brown` are initialized.

This example demponstrates the following about the `super` keyword:

`Super` is a keyword used by Ruby to invoke a method with the same name within the method lookup path. When we invoke a method which has a `super` keyword, Ruby looks in the method lookup path to find another method with the same name. Ruby invokes the method when it finds it.

The `super` keywords can also take arguments. But by default it will pass all the arguments passed into the calling method to the other method with the same name. In order to avoid this we can call the `super` keyword with a parenthesis such as `super()`.

## Example 9
What is output and why? What does this demonstrate about super?
```
class Animal
  def initialize
  end
end

class Bear < Animal
  def initialize(color)
    super
    @color = color
  end
end

bear = Bear.new("black")
```
This code raises an `ArgumentError` because it expecting 0 arguments to `initialize` on `line 320`. When we invoke a method which has a `super` keyword, Ruby looks in the method lookup path to find another method with the same name. Ruby invokes the method when it finds it. By default it will pass all the arguments passed into the calling method to the other method with the same name, and so when we use `super` on `line 326`, Ruby attempts to pass `color` as an argument, resulting in the `ArgumentError`. In order to avoid this we can call the `super` keyword with a parenthesis such as `super()`.

### Answer re-do
`Line 13` raises an `ArgumentError` this is because during the instantiation of a new instance of the class `Bear` we are passing in an argument `"black"`. Within the constructor method in the `Bear` class we have a `super` keyword at `line 8`. `Super` keyword looks for a method with the same name in the method lookup path and then invokes it. When `super` keyword is used without parentheses it will pass all the arguments passed to the enclosing method to the method it was looking for. Here the `super` keyword finds a similar method in the `Animal` class which does not take any arguments. Hence when super passes an argument to it an `ArgumentError` is raised. This can be fixed by calling the `super` keyword with a parantheses as follows.
```
class Animal
  def initialize
  end
end

class Bear < Animal
  def initialize(color)
    super()
    @color = color
  end
end

bear = Bear.new("black")  
```
Now the code executes without any error.

## Example 10
What is the method lookup path used when invoking #walk on good_dog?

module Walkable
  def walk
    "I'm walking."
  end
end

module Swimmable
  def swim
    "I'm swimming."
  end
end

module Climbable
  def climb
    "I'm climbing."
  end
end

module Danceable
  def dance
    "I'm dancing."
  end
end

class Animal
  include Walkable

  def speak
    "I'm an animal, and I speak!"
  end
end

module GoodAnimals
  include Climbable

  class GoodDog < Animal
    include Swimmable
    include Danceable
  end

  class GoodCat < Animal; end
end

good_dog = GoodAnimals::GoodDog.new
p good_dog.walk

The method lookup path is: [GoodAnimals::GoodDog, Danceable, Swimmable, Animal, Walkable]

## Example 11
What is output and why? How does this code demonstrate polymorphism?
```
class Animal
  def eat
    puts "I eat."
  end
end

class Fish < Animal
  def eat
    puts "I eat plankton."
  end
end

class Dog < Animal
  def eat
     puts "I eat kibble."
  end
end

def feed_animal(animal)
  animal.eat
end

array_of_animals = [Animal.new, Fish.new, Dog.new]
array_of_animals.each do |animal|
  feed_animal(animal)
end
```
This code outputs: `I eat. I eat plankton. I eat kibble.`
This demonstrates polymorphism through inheritance. We define a more general eats method in the superclass Animal that is available to to all Animal objects. In the `Fish` subclass, we override this method to implement a process that's more specific to the `Fish` type. Similarly, in the `Dog` subclass, we override `Animal#eats` for a more specific implementation. Because we have defined more specific types of eats, we can work with all the different types of objects in the same way, even though the implementations may be different. This is shown when we create three objects one from the `Animal`class, the `Fish`class, and the `Dog` class, and place them together in an array. We are able to iterate over each object in the array and pass them into the `feed_animal` method, eventually invoking the `eats` method on all of them despite the fact that they are all objects of a different type.

This example of is the essence of accessing different implementations through a common interface (in this case, the client code `eats`). When we call `eats` on an instance of the `Animal` class, the `Animal#eats `method is invoked, and we see the appropriate output `'I eat'`. When we call `eats` on an instance of the `Fish` class, the `Fish#eats `method is invoked, and we see the appropriate output `'I eat plankton'`. Finally, we invoke `eats` on an instance of the `Dog` class, the `Dog#eats `method is invoked, and we see the appropriate output `'I eat kibble'`.

The above code works because the block `animal.eats` only really cares that each element in the array has an `eats` method that is called with no arguments, which is the case here. The interface (`eats`) is the same for all the objects, despite their different implementations.

### Answer re-do
This code outputs, `"I eat"`, `"I eat plankton."`, and `"I eat kibble."`

This is an example of polymporhism through inheritance in which objects of different types can respond to the same method invocation simply by overriding a method from the superclass.

In this example we define a `Animal` class with a `eat` method. We also define a `Fish` class and `Dog` class that both subclass from `Animal` where they override the `eat` method that they inherit, and implement their own specialized verson of this method.

Even though every object in the `array_of_animals` array is a different object type, each with their own implementation of the `eat` method, the client code only cares that the objects can respond to the same `eat` method invocation.

## Example 12
We raise an error in the code above. Why? What do kitty and bud represent in relation to our Person object?
```
class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end
end

class Pet
  def jump
    puts "I'm jumping!"
  end
end

class Cat < Pet; end

class Bulldog < Pet; end

bob = Person.new("Robert")

kitty = Cat.new
bud = Bulldog.new

bob.pets << kitty
bob.pets << bud                     

bob.pets.jump
```
This code raises a `NoMethodError` because we are attempting to call `jump` on an array of objects. On `line 473` we initialize a `Person` object referenced by the local variable `bob` whose state has 2 instance variables `@name` and `@pets`. On `line 475` and `line 476` we initialize a `Cat` and `Bulldog` object respectively, referenced by the local variables `kitty` and `bud`. Both `Cat` and `Bulldog` inherit from the superclass `Pet`. On `line 478` and `line 478` we use the shovel operator to add the `kitty` and `bud` objects into the `@pets` instance variable. So, when we attempt to call `jump` on `bob.pets` on line `481`, we are attempting to call `jump` on an instance of the `Person` class, however `jump` is a method of the `Pet` class, hence the `NoMethodError`.

### Answer re-do
On `line 28` the `pets` getter method returns an `Array` object with elements as the objects of the `Cat` and `Bulldog` class. Since `Array` class does not have a `jump` instance method defined we get an error when we call the `jump` method on the return value of the `pets` getter method being called on the object referenced by `bob`. In order to fix this issue we will have to call the `jump` instance method on each if the elements of the array as follows

`bob.pets.each {|pet| pet.jump}`
now the code executes properly and outputs `"I'm jumping!"` and `"I'm jumping!"` on two seperate lines.

## Example 13
What is output and why?
```
class Animal
  def initialize(name)
    @name = name
  end
end

class Dog < Animal
  def initialize(name); end

  def dog_name
    "bark! bark! #{@name} bark! bark!"
  end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name
```
The output from `line 509` is `"bark! bark!  bark! bark!"`. This is because of the `Dog`'s class `initialize` method on line `501`. The `Dog` class inherits from the superclass `Animal` but then overrides `Animal`'s intitialize method with its own. However, `Dog`'s initialize method does not instantiate any intstance variables and therefore returns nil, which is why we see the output above. Uninitialized instance variables always return `nil` when we try to access them through a getter method. We can either delete the `initialize` method from the `Dog` class, allowing `Dog` to inherit the `initialize` method from its superclass `Animal`, or, we can use the keyword super:
```
def initialize(name) 
  super
end
```

### Answer re-do
Uninitialized instance variables always return `nil` when we try to access them through a getter method.

In the above example within the `Dog` class there is a constructor method initialize which overrides the constructor method from the `Animal` class. Within the method definiton of the initialize method in `line 501` there are no instance variables defined. Uninitialized instance variables always return `nil` when we try to access them. In `line 509` the `dog_name` instance method is called on the object referenced by the local variable `teddy`. Within the method definition of `dog_name` from `line 503 - 505` we are trying to interpolate an uninitialised instance variable `@name` this will evaluate to an empty string `""` as `nil` evaluates to an empty string when interpolated. Due to this the expression in `line 509` outputs `"bark! bark!  bark! bark!"`

## Example 14
In the code above, we want to compare whether the two objects have the same name. Line 11 currently returns false. How could we return true on line 11? 

Further, since al.name == alex.name returns true, does this mean the String objects referenced by al and alex's @name instance variables are the same object? How could we prove our case?

```
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

al = Person.new('Alexander')
alex = Person.new('Alexander')
p al == alex # => true
```
`line 539` currently returns `false` because we are comparing the two objects themselves, not their names. In order to compare the names have have `line 539` return true, we can change the code to the following:
`al.name == alex.name`
However, the String objects referenced by al and alex's @name instance variables are not the same object, as demonstrated if we use the `#object_id` method to compare the two strings:
p al.name.object_id # returns 60
p alex.name.object_id # returns 80

### Answer re-do
The `line 11` currently outputs `false` because it is comparing two objects of the same class. Each objects are unique though they may have the same state.

In order to make `line 11` output `true` we can modify the code as follows by providing a custom `#==` instance method as follows:
```
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def ==(other)
    name == other.name
  end
end

al = Person.new('Alexander')
alex = Person.new('Alexander')
p al == alex # => true
```
Now in line 15 we are comparing the states of the two objects which have the same value and hence it returns true.

since `al.name == alex.name` returns true, This does not mean the String objects referenced by al and alex's `@name` instance variables are the same object. Though they are objects of the same class they are two different objects in memory space. This can be proved by calling the `object_id` method on them as follows
```
p al.name.object_id
p alex.name.object_id
```
we notice that they both have different object id's.

## Example 15
What is output on `lines 593, 594, and 595` and why?
```
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "My name is #{name.upcase!}."
  end
end

bob = Person.new('Bob')
puts bob.name
puts bob
puts bob.name
```
The output of the code from `lines 593-595` is: 
```
Bob
My name is BOB.
BOB
```
On `line 592`, we assign local variable `bob` to the object created by calling the `::new` class method on the `Person` class. The `#initialize` method initializes a new `Person` object, which it does by assigning the instance variable `@name` to the person's name specified by the argument.
`line 593` outputs the instance variable assigned to local variable `bob`, hence printing `"Bob"`. On the next line, `line 594`, `puts` works by calling `#to_s` to convert the code to a string so that it can output the code, and so the `to_s` method is called on the person object that was created on `line 192` which returns the string `"My name is #{name.upcase!}."`. The `upcase!` method modifies the string that it is called on, and so the string assigned to the instance variable `name` is modified to `BOB`, hence the output. On `line 595`, we output instance variable assigned to local variable `bob`, hence printing the manipulated `"BOB"`.

### Answer re-do
On `line 13` a local variable `bob` is initialized to the instance of the `Person` object by calling the `::new` class method on it. The `::new` method takes an argument String `"Bob"`. This is then assigned to the instance variable `@name`.On `lines 8 - 10` a custom `to_s` instance method is defined and within the method definition we have an expression `name.upcase!`. Here we are invoking the getter method `name` and calling a destructive method `upcase!` on it which will permanently modify the object referenced by `@name`. Also `puts` method invocation by default invokes the `to_s` method on the arguments passed to it. Hence on `line 15` the `to_s` custom instance method is invoked and it prints out `"My name is BOB."`. Now the value refereneced by `@name` is modified permanently. Hence `line 16` prints `"BOB"`. If we dont want this behaviour then we can call a non destructive method as follows

```
def to_s
  "My name is #{name.upcase}."
end
```
## Example 16
Why is it generally safer to invoke a setter method (if available) vs. referencing the instance variable directly when trying to set an instance variable within the class? Give an example.
```
class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def >(other)
    grade > other.grade
  end

  protected

  attr_reader :grade
end

bob = Student.new("Bob", 80)
riaz = Student.new("Riaz", 90)
p riaz > bob # => true
p riaz.grade # => NoMethodError
```
It is better to invoke a setter method because the getter/setter methods are much easier to reference if we ever need to retrieve or modify the state of the object as we can make changes in just one place. In addition, it will be easier to make the methods private or protected if necessary and encapsulate the code

```
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
  
  def change_name
    self.name = name.upcase
  end
end

bob = Person.new('Bob')
p bob.name 
bob.change_name
p bob.name
```
It is safer to invoke a setter method than to explicitly call an instance variable because we can expose sensitve data or might accidentaly modify the value it references.

```
class Student

  def initialize(name, score)
    @name = name
    @score = score
  end

  def get_grades
    puts "#{name} has the grade #{finding_rank}"
  end

  private
  attr_reader :name, :score

  def finding_rank
    answer = case score
              when 85..100 then "Merit"
              when 80..84 then "Distinction"
              when 59..79 then "Pass"
              else
                "Fail"
             end
    answer            
  end

end

bob = Student.new("Bob", 85)
bob.get_grades
```
here we are encapsulating the score attained by the student and instead we are just showing the desired output

## Example 17 - custom setter method
Give an example of when it would make sense to manually write a custom getter method vs. using attr_reader.

It would make sense to manually write a custom getter method if you want a getter method to say something specific.
```
class Person
  def initialize(name)
    @name = name
  end

  def name
    puts "Hi, my name is #{@name}"
  end
end

marts = Person.new("Martha")
marts.name
```

### Answer re-do
Give an example of when it would make sense to manually write a custom getter method vs. using attr_reader.
```
class Student
  def initialize(name)
    @name = name
  end

  def name
    puts "Hi my name is #{@name.capitalize}"
  end
end

Student.new("martha").name
```
Creating a getter method using the attr_reader can be an easier way of defining setter methods. How ever if you want to manipulate the return value of the getter method or influence what it does then we will have to define a custom getter method. This will give us the added flexibility required. In the above example calling the getter method name will output "Hi my name is Martha".

## Example 18
What can executing Triangle.sides return? What can executing Triangle.new.sides return? What does this demonstrate about class variables
```
class Shape
  @@sides = nil

  def self.sides
    @@sides
  end

  def sides
    @@sides
  end
end

class Triangle < Shape
  def initialize
    @@sides = 3
  end
end

class Quadrilateral < Shape
  def initialize
    @@sides = 4
  end
end

Triangle.sides
Triangle.new.sides
```

Executing `Triangle.sides` returns `nil`. Executing `Triangle.new.sides` returns the integer `3`. This demonstrates  that class variables are available to all subclasses via inheritance and are scoped at the class level. Class variables are defined at the class level and is available to all the instances of the class. Just one copy of the class variable exists for the Class and all of its instances. Reassigning the class variable at any point in the class hierarchy will change the value referenced by the class variable for the rest of the program irreversibly. This means that if a subclass changes the class variable then the value referenced would have changed to the new value when we try to access the class variable through a superclass. 

### Answer re-do
`line 25` returns `nil` and `line 26` returns the integer `3`.

On `line 25` when we invoke the `sides` class method on the object `Triangle`, Ruby looks in the method lookup path for any class method with the name `sides`. It finds it in the `Shape` class. At this point the value referenced by the class variable `@@sides` within the `Shape` class is `nil`. Ruby resolves `@@sides` to be `nil` and so `line 25` returns `nil`. On `line 26` the `sides` instance method is called on the object of the `Triangle` class. Within the object the `@@sides` instance variable is referencing the integer `3`. When Ruby looks for another method within the method lookup path it finds sides in the `Shape` class and returns integer `3`.

## Example 19 - attr_* for every instance variable
What is the attr_accessor method, and why wouldn’t we want to just add attr_accessor methods for every instance variable in our class? Give an example.

Because setter and getter methods are so commonplace, Ruby gives us a built-in short hand to create them: `attr_accessor`. This method takes a symbol as an argument, which is used to create the method name for both the getter and the setter methods. This is nice because we can now replace long and cumbersome method definitions with a single line.

If you have attributes that you do not want modified from outside the class, you can create a getter method without a setter method for them by using the shorthand `attr_reader`. Further, if you want to be able to modify an attribute without necessarily being able to view it outside the class (such as for sensitive information like a a social security number or password), you can create a setter without a getter by using the `attr_writer` shorthand.
```
class Person
  attr_reader :name
  attr_writer :secret
  attr_accessor :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def introduce
    puts "Hi, my name is #{name}!"  # we can access @name through a getter
  end
  
  def have_a_birthday
    self.age += 1                   # we can change @age through a setter
  end
end

john = Person.new('John', 30)

# We can access @name through a getter, but cannot change it through a setter
john.introduce                      # => Hi, my name is John!
john.name                           # => 'John'
john.name = 'Johnny'                # => NoMethodError

# We can assign @secret through a setter, but cannot access it through a getter
john.secret = 'afraid of clowns'    # Appends 'afraid of clowns' to @secret
john                                # => #<Person:0x0000561b2b42ac88 @age=30, @name="John", @secret="afraid of clowns">
john.secret                         # => NoMethodError

# We can both access and reassign @age because it has both a getter and a setter
john.age                            # => 30
john.have_a_birthday
john.age                            # => 31
```

### Answer re-do
The accessor methods are used to access and set the state of the object to read, set and update the values referenced by the instance variables.

The accessor methods takes symbols as arguments which it uses to create getter and setter methods.

`attr_reader` are getter methods which are read-only which is used to access and expose the value referenced by the instance variables.

`attr_writer` methods are used to define setter methods without having to define a setter method. These are write only methods used to set or update the state of the object.

Adding the `attr_accessor` method to every instance variable in the class will make the data referenced by the instance variable to be accessed from outside of the class. Hence we will be able to acess the value referenced by the instance variables and also and modify them permanently
```
class Student
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end
end

student = Student.new("Bob", 30)
p student.name # "Bob"
p student.age  # 30

student.name = "Mike"
student.age = 50

p student.name # "Mike"
p student.age  # 50
```
In the above example we able to access and change the state of the object from outside of the class.

## Example 20
What is the difference between states and behaviors?
Behaviors are defined by methods. States are defined by instance variables

### Answer re-do
Objects encapsulate the state. Classes define the attributes of the behavior of the objects. The instance variables track the state of the object. The state of the Object is unique to the object. The behaviors or the methods are what the objects can do. The instance methods can access the instance variable

Classes are basic oulines of what an object is made of. Classes define the attributes and the behaviors of its objects. Common behaviors are grouped within a class.
```
class Person
  def initialize(name)
    @name = name
  end

  def name
    @name
  end
end

bob = Person.name("Bob")
bob.name
```
In the above example the object refenced by bob encapsulates the state `@name = "Bob"`

The state of the object is exposed by the instance method/behavior name when it is called on the object in `line 12`

## Example 21
What is the difference between instance methods and class methods?

Instance methods are the behaviors or functionality available to all instances of that class. They are defined within the classes from which the objects are derived from. Instance variables can be accessed and exposed by the instance methods. Class methods are called on the class itself. Scoped at the class level, are not available to any instances of the class. We do not have to instantiate any objects to invoke a class method, since they pertain to the class as a whole. They cannot access instance variables. They are used when we need behaviours/methods that are not related to any objects.

### Answer re-do

Instance methods are called on the instances of the class. Instance methods are the behaviours or functionality available to the objects. They are encapsulated in the Classes from which the objects are derived from. Instance variables can be accessed by the instance methods.They are defined as follows
```
class Person
  def	instance_method
    "From the instance method"
  end
end

p Person.new.instance_method
# => "From the instance method"
```
Class methods are methods which are called on the class itself. They scoped at the class level and are not available to any instances of the class. They cannot access instance variables. While defining the class methods we chain the method name to the self keyword as shown in the example below.
```
class Person
  def self.class_method
    "I am from within the class method"
  end
end

Person.class_method # invoking the class method
```

## Example 22 
What are collaborator objects, and what is the purpose of using them in OOP? Give an example of how we would work with one.

A collaborator object is an object that is stored as a state (i.e. within an instance variable) within another object. The are called collaborators because they work in conjunction with the class they are associated with. Collaborator objects are usually custom objects (i.e. defined by programmer and not built into Ruby). Collaborator objects represent the connections between various actors in the program.
For example, a Deck is a class representing a collection of Card objects
```
class Deck
  attr_accessor :cards
  
  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        cards << Card.new(suit, value)
      end
    end
    
    cards.shuffle!
  end
  
  def deal_one_card
    cards.pop
  end
end

class Card
  SUITS = %w(Hearts Clubs Diamonds Spades)
  VALUES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
  
  attr_accessor :suit, :value
  
  def initialize(suit, value)
    @suit = suit
    @value = value
  end
  
  def to_s
    "The #{value} of #{suit}"
  end
end

deck = Deck.new

hand = []

5.times { hand << deck.deal_one_card }
  
hand.each { |card| puts card }
  # => The 10 of Diamonds
  # => The Queen of Clubs
  # => The 10 of Spades
  # => The Jack of Clubs
  # => The 8 of Diamonds
  # (cards are randomly selected, output may differ)
```
In the above code, we define our Deck class to work with the collaborator object Card. When a new Deck instance is initialized, the Deck class relies on the Card class constants SUITS and VALUES to generate a new 52 card deck.

### Answer re-do
Collaborator objects are usually custom objects that are assigned to the state of another object. This way we can form associations between the two objects. Thereby making the methods of the collaborator object available to the other object. Collaborator objects are objects that are stored as state within another object. For example:
```
class Person
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_pet(obj)
    pets << obj
  end

  def display_owner_with_pets
    puts "#{name} pets are:"
    puts pets
  end
end

class Pet
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end
end

bob = Person.new("Bob")
kitty = Pet.new("Kitty")
doggy = Pet.new("Doggy")

# p bob

bob.add_pet(kitty)
bob.add_pet(doggy)

# p bob

puts bob.display_owner_with_pets
```
Resources:
https://launchschool.com/lessons/dfff5f6b/assignments/4228f149

Objects that are stored as state within another object are also called "collaborator objects". We call such objects collaborators because they work in conjunction (or in collaboration) with the class they are associated with. For instance, bob has a collaborator object stored in the @pet variable. When we need that BullDog object to perform some action (i.e. we want to access some behavior of @pet), then we can iterate through bob and call the method on the object stored in @pet, such as speak or fetch.

When we work with collaborator objects, they are usually custom objects (e.g. defined by the programmer and not inherited from the Ruby core library); @pet is an example of a custom object. Yet, collaborator objects aren't strictly custom objects. Even the string object stored in @name within bob in the code above is technically a collaborator object.

Collaborator objects play an important role in object oriented design, since they also represent the connections between various actors in your program.

When working on an object oriented program be sure to consider what collaborators your classes will have and if those associations make sense, both from a technical standpoint and in terms of modeling the problem your program aims to solve.

## Example 23 
How and why would we implement a fake operator in a custom class? Give an example.
We can use fake operators in custom classes to define them for our custom classes to change their default behavior
```
# custom defined == method
class Student
  attr_reader :name, :id

  def initialize(name, id)
    @name = name
    @id = id
  end

  def ==(other_student)
    id == other_student.id
  end
end

joe_1 = Student.new('Joe', 12345)
joe_2 = Student.new('Joe', 12345)

joe_1 == joe_2                          # => true
```
In the above code, we define the class Student such that it's instances exhibit the attributes name and id. Then we initialize two Student objects and assign identical values to both attributes. However, Student also has a custom == method defined which overrides the inherited behavior from BasicObject. In this case, we are using Integer#== to compare the id values from two instances of Student. joe_1 and joe_2 have identical id values, so the Student#== method will return true.

### Answer re-do
```
class Person
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def ==(other)
    name == other.name
  end
end

oscar = Person.new("Oscar")
marts = Person.new("Martha")

p oscar == marts # => false
```

Many operators in Ruby are originally methods. Because of Ruby's syntactical sugar we are able to read them in a more natural way. Since these are methods we can override their implementation in our custom class. In the above example defining the `==` intance method in the custom class `Person` overriddes the implementation of the method `==` given by Ruby. This makes it a fake operator. Hence in `line 15` we are comparing the value referenced by the instance variable `@name` in the objects `oscar` and `marts`. `Line 15` can also be re-written as `oscar.==(marts)`. This will return and print false.

## Example 24 
What are the use cases for self in Ruby, and how does self change based on the scope it is used in? Provide examples.

The `self` keyword is an explicit caller. The `self` keyword represents the class or the object of a class depending upon the scope where it is used. `self` is a reserved keyword in Ruby that acts as a variable. This variable always points to the object that "owns" the currently executing code. `self` is a way of being explicit about what our program is referencing and what our intentions are as far as behavior (such as with setter methods vs local variable initialization). Anytime we have a method that does not have an explicit calling object, Ruby will provide an implicit `self`. For this reason, it is important to understand what `self` is referencing on any given level of code. `self` changes depending on the scope that it is used in.
```
class Person
  attr_reader :name

  def initialize
    @name = name
  end

  def self.scientific_name        # explicit self, self represents the class, making this a class method
    'homo sapiens'
  end

  def introduce
    puts "Hi! My name is #{name}"   # implied self.name, self is the object
  end
end
```

Inside of an instance method, `self` points to the object that calls the method. Therefore, we can assume that within an instance method `self` will always reference an object that is an instance of that particular class.

```
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def change_name(new_name)
    self.name = new_name
  end
end

bill = Person.new('William')
bill.name                       # => 'William'
bill.change_name('Bill')
bill.name                       # => 'Bill'
```
In the above example, we are using `self` to explicitly call the `name=` setter method. This works because `self` references the calling object for the method `change_name`, in this case the Person object bill. When the code executes then, we really see `bill.name=('Bill')`, which tells Ruby that we are calling the setter method for the instance variable `@name` rather than initializing local variable `@name`.

The success of this can be demonstrated when we use the getter method name with `bill` and the return value has indeed changed from `'William'` to `'Bill'`.

Within a class method, the calling object is the class itself, therefore `self` will reference the class that calls the method, rather than an instance of that class. This is similar behavior to `self` within an instance method. Because a class in Ruby is really just another kind of object, we've just changed the calling object `self` should reference, not the behavior of `self` itself.
```
class Thing
  def self.calling_object
    self
  end
end

Thing.calling_object          # => Thing
```
Within a class definition, `self` will reference the class (or module) that's in the process of being defined.Because `self` within the class definition references the class itself, we can use this to differentiate class methods from instance methods.
```
class Person
  def initialize(name)
    @name = name
  end

  # instance method
  def introduce
    puts "Hi! My name is #{@name}"
  end

  # class method, because `self` references Person
  def self.scientific_name
    puts 'homo sapiens'
  end
end

Person.scientific_name        # => homo sapiens

joe = Person.new('Joe')
joe.scientific_name           # => NoMethodError
```
In the above code, we define the Person class method `::scientific_name`. This is distinguished from an instance method by the use of `self` in the method name. Because `self` within a class definition references the class itself (in this case `Person`), we are telling Ruby explicitly that the calling object for the `scientific_name` method should be a class object. In this case, the class `Person`.

When you mix in methods from modules using include, `self` within those methods will reference the instance that calls the method, just like they would if they were instance methods defined within the class. This allows the mixin to interact with the class it has been mixed into.
```
module Reflection
  def calling_object
    self
  end
end

class Thing
  include Reflection
end

something = Thing.new
something.calling_object
# => #<Thing:0x000055c97b9f6678>
```
In the above code we define the method `calling_object` within the `Reflection` module. This module is then mixed into the `Thing` class. Because `calling_object` will now be treated as an instance method of that class, `self` within it will reference the object that calls the method. In this case, that's the instance `something`.

Ruby still provides a reference for `self` if you utilize it outside the scope of any class. It points to `main`, which is an instance of `Object`.

puts self.inspect     # => main

## Example 25 
What does the below code demonstrate about how instance variables are scoped?
```
class Person
  def initialize(n)
    @name = n
  end

  def get_name
    @name
  end
end

bob = Person.new('bob')
joe = Person.new('joe')

puts bob.inspect # => #<Person:0x000055e79be5dea8 @name="bob">
puts joe.inspect # => #<Person:0x000055e79be5de58 @name="joe">

p bob.get_name # => "bob"
```
This demonstrates that instance variables are scoped at the object level. They are available throughout the instance of the object. This basically means that for any given object, you can access an instance variable within an instance method without passing it in, even if it was initialized outside of that particular instance method.

### Answer re-do
Instance variables are variables which start with the @ (example: @instance_variable) and are scoped at the object level. The instance variables keep track of the state of the object. The state of an object is the collection of all of its instance variables and the values it references. Instance methods can access instance variables, that is it exposes the value referenced by the instance variable. Instance variables exists as long as the object exists. Once the Object is destroyed then the instance variable perishes along with it.

On `line 1176` the object `bob` has a state `@name = 'bob'` and on `line 1177` the object `joe` has the state `@name = "joe"`. This demonstrates that though both the objects are created from the same class `Person` their states are unique to the respective objects.

## Example 26
How do class inheritance and mixing in modules affect instance variable scope? Give an example.
Instance variables are scoped at the object level, and keep track of the state of an object.  A typical class inheritance is where a subclass inherits its behaviors from a superclass. The subclass is the derived class and the superclass is the base class. The superclass has a larger reusability and the subclass has an extended or refined implementation. This reduces complexity of the code and makes it reusable. Class inheritance exhibits an "Is - A" relationship. Eg. The Dog is a mammal. Subclasses can inherit instance variables from superclasses
```
class Pet
  def initialize(name)
    @name = name
  end
end

class Cat < Pet
  def initialize(name, personality)
    super(name) 
    @personality = personality
  end
end

felix = Cat.new('Felix', 'playful')
# => #<Cat:0x000055e2ac7e4908 @name="Felix", @personality="playful">
```
Multiple inheritance is acheived by mixin in modules. The inheritance achieved through mixing in modules are known as Interface Inheritance. The behaviors from one or more modules are mixed in using the include method and passing in the name of the module as an argument to it. The modules group common methods and classes within them. This is known as namespacing. Interface inheritance exhibit a "has - a" relationship. Eg. The Dog has a behaviour(.i.e, a method). Instance variables can be inherited via mixin modules, however modules cannot inherit, nor can they create or instantiate objects. So, in order to create objects we use class inheritance

module Swimmable
  def swim
    "I can swim!!!"
  end
end

class Human
  include Swimmable
end

class Dog
  include Swimmable
end

puts Human.new.swim
puts Dog.new.swim

## Example 27
How does encapsulation relate to the public interface of a class?
Ruby enables us to hide the behavior and its implementation by making it not visible to the rest of the code in order to reduce dependencies and to prevent the data from being exposed to unwanted parts of the code through encapsulation. Encapsulation describes how we can separate and hide away different pieces of functionality, making them unavailable to the rest of the code base. It is essentially a form of data protection that defines boundaries within a given application.  It is acheived through the use of Method Access Control or access modifiers which determines if the methods are public, private or protected. In Ruby all the instance methods are public by default unless we implement method access control.

### Answer re-do
Ruby creates objects and exposes the interfaces to interact with those objects. Due to this it is possible that the data could be unintentionally modified. Also this can also increase the dependencies between different objects. Ruby enables us to hide the behavior and its implementation by making it not visible to the rest of the code in order to reduce dependencies and to prevent the data from being exposed to unwanted parts of the code. This is known as Encapsulation and this is acheived through the use of Method Access Control or access modifiers which determines if the methods are public, private or protected. I ruby all the instance methods are public by default unless we implement method access control. The exception being the constructor method initialize which is always private.

Example
```
class Student
  attr_reader :name

  def initialize(name, age)
    @name = name
    @age = age
  end

  def student_age
    age
  end

  private

  attr_reader :age
end

bob = Student.new("Bob", 19)

p bob.name         # => "Bob"
p bob.student_age  # => 19
p bob.age          # => NoMethodError
```
The above example we have hidden the implementation details of the instance method age from being accessed from outside of the class. This was acheive by the use of the private method which is an access modifier. Hence the instance method age can only accessed from the within the Student class.

## Example 28
What is output and why? How could we output a message of our choice instead?
```
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age  = a * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky
```
This code outputs a `GoodDog` object because local variable `sparky` is assigned to the object created by calling the `::new` class method on the `GoodDog` class. In order to output a message, we could implement a `to_s` method:

```
  def to_s
    "Woof! My name is #{self.name} and I am #{self.age} in doggo years!"
  end
```
### Answer re-do

`Line 13` outputs the object referenced by the local variable `sparky` initialized in `line 12`. The object output consists of the object encoding id and the class name. This is output because when the object is passed as an argument to the puts method it automatically calls the default to_s instance method on the argument and prints it. In order to override the default output we can define our own custom implementation of the to_s method as shown below.
```
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age  = a * DOG_YEARS
  end

  def to_s
    "I am #{name} and I am #{age} years old."
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky
```
Now `line 17` outputs `"I am Sparky and I am 28 years old."`

How is the output above different than the output of the code below, and why?
```
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    @name = n
    @age  = a * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
p sparky
```
The object assigned to local variable `sparky` in the first example consists of the object encoding id and the class name. We access the `name` and `age` instance variables via the `attr_accessor`. In the second example, the object assigned to the local variable `sparky` consists of the object encoding id, the class name, ans instance variables `@name` and `@age` with their respective assigned values, becuase they are instantiated in the `initialize` method.

### Answer re-do
In this code the instance variables `@name` and `@age` are initialized within the constructor method `initialize`. Whereas previously the `attr_accessor` methods initialized them. The values referenced by the instance variables `@name `and `@age` are set directly to them. Whereas before they are assigned to the instance variables using the getter methods `name` and `age`.

## Example 29
When does accidental method overriding occur, and why? Give an example.

Accidental method overriding may occur when subclass overrides a more generic method implementation from a superclass with a different more specific behavior by implementing a method of the same name.

In Ruby, custom classes inherit from the `Object` class, which has many built in methods as part of the Ruby language. All of the methods that are available to the class `Object` are available to all the custom classes as they subclass from the `Object` class. All subclasses can create it own custom implementation for any of the methods provided by the `Object` class through method overriding by inheritance. As a general rule of thumb the return value of these fake instance methods should behave in a simillar way to the original instance methods. When we accidentally define an instance method in our custom class with the same name as that of the methods in the Object class accidental method overriding occurs.
```
class WhoAmI
  def is_a?(object)
    object
  end
end

identify = WhoAmI.new
answer = identify.is_a?(Integer) ? "true" : "false"
puts answer # => true
```
In the above example within the `WhoAmI` class we have a custom implementation for the `is_a?` instance method returns the object that was passed in as an argument durring the method invocation. In `line 8` the expression `identify.is_a?(Integer)` evaluates to `true`. This is because the `is_a?` instance method from the `WhoAmI` class overrides the default `is_a?` in the `Object` class and so `line 9` outputs `true`.

## Example 30
How is Method Access Control implemented in Ruby? Provide examples of when we would use public, protected, and private access modifiers.

Public Methods
By default all the instance methods within the class are public methods apart from the constructor method initialize which is a private method. Public methods can be accessed from within the class and also from outside of the class. If one knows the class name or the object name then we can access these methods.

Private Methods
Private methods are methods that are accessible within the class but is not available outside of the class to the rest of the program. They are available to one instance of the class at any given time.
```
class Person
  def money_available
    "You have £#{account_balance} in your account"
  end

  private

  def account_balance
    5000
  end
end

Person.new.money_available
```
Protected Methods
Protected methods are available within the class and all of its subclasses. They act as public methods when called within the class and as private methods outside of the class hiearchy. For practical purposes, this means that they can be invoked by all objects within a certain class, but only from within the class. This differs from private methods in that a private method can only be called by the singular instance within the class. They can be used to compare two objects.

```
class Student
  def initialize(grade)
    @grade = grade
  end

  def >(other)
    grade > other.grade
  end

  protected

  attr_reader :grade
end

bob = Student.new(80)
john = Student.new(90)

p bob > john # => false
p john > bob # => true
```

### Answer re-do
In Ruby the method access control is implemented by the use of public, private and the protected access modifiers. Encapsulation is acheived by using the method access modifiers.

public methods:
By default all the instance methods within the class are public methods, apart from the constructor method initialize which is a private method. Public methods can be accessed from within the class and also from outside of the class. If one knows the object name and the getter method name then we can access these methods.
```
class Person
  def say_hello
    puts "Hello!"
  end
end

Person.new.say_hello # => "Hello!"
```
In the above example the instance method `say_hello` is defined within the class `Person`. Since this is a public method it can be visible from outside of the class. Therefore `line 7` prints `"Hello!"`.

private methods
Private methods are methods that are accessible within the class but is not available outside of the class to the rest of the program. They are available to one instance of the class at any given time. Private methods are used to hide the implementation details of methods and facilitating encapsulation.
```
class Person
  def money_available
    puts "You have £#{account_balance} in your account"
  end

  private

  def account_balance
    5000
  end
end

bob = Person.new
bob.money_available # => "You have £5000 in your account"
bob.account_balance # => NoMethodError
```
The instance method `account_balance` is made private by calling the private method in `line 6` . Unless otherwise stated anything that comes after this line within the class is a private method. `Line 15` raises an error because the private instance method `account_balance` is not available outside of the class `Person`.

protected methods
The protected methods are available within the class and all of its subclasses. They act as public methods when called within the class and as private methods outside of the class hiearchy. They can be used to compare two objects.
```
class Student
  def initialize(grade)
    @grade = grade
  end

  def >(other)
    grade > other.grade
  end

  protected

  attr_reader :grade
end

bob = Student.new(80)
john = Student.new(90)

p bob > john # => false
p john > bob # => true
```
In the above example the protected method `grade` acts as a private method outside of the class hierarchy and acts as a public method. Due to this they are available to multiple instance of the same class.

## Example 31
Describe the distinction between modules and classes.

Classes are basic oulines of what an object is made of. Classes define the attributes and the behaviours of its objects. Common behaviours are grouped within a class. All classes are part of a namespace in Ruby. Objects are created from a class.
```
class Person
	def initialize(name)
    @name = name
  end

  def speak
    puts "Hi! How are you?"
  end
end

bob = Person.new("Bob")
bob.speak #=> "Hi! How are you?"
```
A subclass inherits the behaviours from a superclass. The subclass is the derived class and the super class is the base class. The superclass has a larger reusability and the subclass has an extended or refined implementation. This reduces complexity of the code and makes it reusable. Inheritance displays Is - A relationship.
```
class Mammal # superclass
end

class Dog < Mammal # subclass
end
```
Modules are used as containers for housing methods that may be relevant to multiple classes. The collection of the methods within the module can be used in other classes through mixins. Unlike classes modules do not have any instances. Modules cannot inherit unlike the classes, and modules cannot create objects.

In Ruby multiple inheritance is acheived by mixin modules. The inheritance achieved through mixing in modules are known as Interface Inheritance. The behaviour from a module is mixed in using the include method and passing in the name of the module as an argument to it. The modules group common methods, constants and classes within. This is known as namespacing. Interface inheritance have a has - a relationship. Eg. The Dog has a behaviour(.i.e, a method).
```
module Swimmable
  def swim
    puts "I can swim!!!"
  end
end

class Human
  include Swimmable
end

class Dog
  include Swimmable
end

Human.new.swim
Dog.new.swim
```

## Example 32
What is polymorphism and how can we implement polymorphism in Ruby? Provide examples.

Polymorphism occurs when objects of different types respond to the method invocation with the same name. It helps in reducing dependencies.

Polymorphism through Inheritance
When the subclass inherits behavior from one of its superclass because it could not find the method in the subclass then polymorphism occurs. This type of polymorphism is known as Polymorphism through Inheritance as we are inhering the behaviors. Since method overriding is also a type of inheritance this is also Polymorphism through Inheritance.

Can work in 2 ways:
1. A specific instance of a subclass inherits a more generic method implementation from a superclass.
2. A subclass overrides a more generic method implementation from a superclass with a different more specific behavior by implementing a method of the same name.
```
class Animal
  def eats
    puts "feeds on other living things"
  end
end

class Carnivore < Animal
  def eats
    puts "feeds on meat"
  end
end

class Herbivore < Animal
  def eats
    puts "feeds on plants"
  end
end

class Omnivore < Animal; end

lion = Carnivore.new
rabbit = Herbivore.new
person = Omnivore.new

animals = [lion, rabbit, person]
animals.each { |animal| animal.eats }
  # => feeds on meat
  # => feeds on plants
  # => feeds on other living things
```

In the code above, we define a more general `eats` method in the superclass `Animal` that is available to to all `Animal`objects. In the `Carnivore` subclass, we override this method to implement a process that's more specific to the `Carnivore` type. Similarly, in the `Herbivore` subclass, we override `Animal#eats` for a more specific implementation. However, in the `Omnivore` subclass, no more specific implementation is needed, so we allow it to inherit the generic implementation from `Animal`.

Because we have defined more specific types of `eats`, we can work with all the different types of objects in the same way, even though the implementations may be different. This is shown when we create three objects, `lion` from the `Carnivore` class, `rabbit` from the `Herbivore` class, and `person` from the `Omnivore` class, and place them together in an array. We are able to iterate over each object in the array and invoke the `eats` method on all of them despite the fact that they are all objects of a different type.

This example of is the essence of accessing different implementations through a common interface (in this case, the client code eats). When we call eats on lion, the Carnivore#eats method is invoked, and we see the appropriate output 'feeds on meat'. When we call eats on rabbit the Herbivore#eats method is invoked, and again we see the appropriate output 'feeds on plants'. Finally, we invoke eats on person and the inherited Animal#eats method is called, which gives us the more generic output of 'feeds on other living things'.

The above code works because the block `animal.eats` only really cares that each element in the array has an `eats` method that is called with no arguments, which is the case here. The interface (`eats`) is the same for all the objects, despite their different implementations.

Polymorphism can also be exhibited when mixing in a module. When we mix a module into a class using `include`, all the behaviors declared in the module are available to the class and its objects. This is known as interface inheritance. Two distinct classes that include the same module can also be said to exhibit polymorphism, as both instances can access the same interface (defined by the module).
```
module Swimmable
  def swim
    "I'm swimming"
  end
end

class Dog
  include Swimmable
end

class Fish
  include Swimmable
end

class Cat; end

fido = Dog.new
felix = Cat.new
nemo = Fish.new

# both the Dog and Fish object can access the included `swim` method (polymorphism)
fido.swim           # => "I'm swimming"
nemo.swim           # => "I'm swimming"

# but the Cat object cannot (it's not included)
felix.swim          # => NoMethodError
```

Polymorphism through Duck Typing
Duck typing occurs when different unrelated types of objects both respond to the same method name. Here, we want to see that an object has a particular behavior rather than if it is a certain class/type. Polymorphism through duck typing means that different types of objects can have different methods of various implementations, all with the same interface (name + arguments), despite not inheriting these methods.

We can tell when duck typing is in play because it deals with a number of objects that share a common interface, even though they have no relationship via class or module. Duck typing focuses on what an object can do rather than what an object is.

```
class SportsGame
  def play(attendees)
    attendees.each do |attendee|
      attendee.participate
    end
  end
end

class Player
  def participate
    play_game
  end
  
  def play_game
    puts "He shoots... HE SCORES!!"
  end
end

class Coach
  def participate
    coach_players
  end
  
  def coach_players
    puts "Hustle! Hustle! Hustle!"
  end
end

class Referee
  def participate
    make_calls
  end
  
  def make_calls
    puts "Foul! Safe! Foul!"
  end
end

class Cheerleader
  def participate
    cheer_on_team
  end
  
  def cheer_on_team
    puts "Go team go!"
  end
end

the_game = SportsGame.new

the_game.play([Player.new, Coach.new, Referee.new, Cheerleader.new])
  # => He shoots... HE SCORES!! (result of Player#participate)
  # => Hustle! Hustle! Hustle!  (result of Coach#participate)
  # => Foul! Safe! Foul!        (result of Referee#participate)
  # => Go team go!              (result of Cheerleader#participate)
```
Demonstrates polymorphism through duck typing because although there is no inheritance, we have a selection of participant type classes (`Player`, `Coach`, `Referee`, `Cheerleader`) which all provide a `participate` method that takes 0 arguments. Since each different object responds to the same method call, we can say this is polymorphism.

First we define our `SportsGame` class with instance variables such that we can pass along the specific data that each participant type object needs to implement their version of `participate`. We pass the `SportsGame#play` instance method one argument, an array of these duck typed "participant" objects. Within `SportsGame#play` we invoke `participate` on each participant object, leading to the appropriate output for each participant.

### Answer re-do
Polymorphism occurs when objects of different types respond to the method invocation with the same name. It helps in reducing dependencies. Polymorphism are broadly classed into two types:
Polymorphism through inheritance
Polymorphism through Duck Typing
When the subclass inherits behaviour from one of its superclass because it could not find the method in the subclass then polymorphism occurs. This type of polymorphism is known as Polymorphism through Inheritance as we are inhering the behaviors.
```
class Vehicle
  def accelerate
    puts "Increase speed by 5 miles an hour!"
  end
end

class Car < Vehicle
end

class Motorbike < Vehicle
  def accelerate
    puts "Increase speed by 10 miles an hour!"
  end
end

car = Car.new
car.accelerate # Polymorphism through inheritance from the superclass

bike = Motorbike.new
bike.accelerate # Polymorphism through inheritance due to method overriding
```
In the above example we can see that the classes `Car` and `Motorbike` both inherit from the class `Vehicle`. In `line 16` and `line 20` we are instantiating two objects from their respective classes referenced by the local variable `car` and `bike`. In `line 16` the `accelerate` instance method is invoked on the object referenced by `car`. This outputs "Increase speed by 5 miles an hour!". This is because Ruby looks for the method with the same name in the method lookup path and it finds it in the `Vehicle` class and invokes it.

In `line 20` the `accelerate` instance method is invoked on the object referenced by `bike`. This outputs "Increase speed by 10 miles an hour!". The `accelerate` method in the `Motorbike` class overrides the one in the `Vehicle` class. Since method overriding is a form of inheritance this phenomenon is also known as Polymorphism by inheritance.

When object of unrelated classes respond to the invocation of the instance method with the same name then this is known as Polymorphism through Duck Typing.
```
class Car
  def accelerate
    puts "Increase speed by 5 miles an hour!"
  end
end

class Motorbike
  def accelerate
    puts "Increase speed by 10 miles an hour!"
  end
end

vehicle = [Car.new, Motorbike.new]
vehicle.each { |object| object.accelerate }
# Output
# => Increase speed by 5 miles an hour!
# => Increase speed by 10 miles an hour!
```
In the above example the `Car` and `Motorbike` are two unrelated classes. Both of them have their own implementation of the instance method `accelerate`. Hence in `line 14` when the objects created from both the classes are passed in as arguments to the each method invocation. They both respond to the `accelerate` instance method invocation with their own implementation. This is an example of Polymorphism through Duck Typing.

## Example 33 
What is encapsulation and why is it important in Ruby? Give an example
Encapsulation describes how we can separate and hide away different pieces of functionality, making them unavailable to the rest of the code base. It is essentially a form of data protection that defines boundaries within a given application.
In Ruby, encapsulation is achieved through creating objects and exposing certain methods to interact with them. That is, Ruby allows us to create objects that separate out the interface (methods you call on them) from the implementation (what code the methods actually execute). This allows us as programmers to think on a new level of abstraction.
Not only does encapsulation let us hide the internal representation of an object from the outside, we want to make sure we only expose the methods and properties that users of the object need. Method access control is employed to ensure that we expose only these necessary properties and methods through the public interface of a class. Anything else that deals only with the internal implementation can be hidden as a private method.
```
class Person
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def has_a_birthday
    # call private setter method to increment @age within the class
    self.age += 1
  end
  
  def how_old
    # call private getter method for desired output / protect sensitive information
    puts "I am #{age - 3} years old"
  end
  
  def introduce
    # call private getter method to format @name correctly
    puts "Hi my name is #{name.capitalize}"
  end
  
  private
  attr_reader :name
  attr_accessor :age
end

sally = Person.new('sally', 65)

sally.introduce           # => Hi, my name is Sally
sally.has_a_birthday      # => increments @age
sally.how_old             # => I am 63 years old
```
In the above example, we can call the method `#has_a_birthday` which increments the `@age` of a `Person` object appropriately. The setter for `age` is private so that this data is not changed in a way that doesn't make sense for a `Person` object. Further, we can use the public `introduce` method to ensure that we have the correct formatting for the `@name` attribute. This calls the private getter method `name` and formats the return value in the way we want.

We can protect sensitive information by ensuring that it remains within the class. Here, when we call `how_old` on a `Person` object, it will tell a little white lie, however we are getting data that looks like it pertains to `@age`.

The point of encapsulation is that we get the results we expect from the public interface. As long as this is the case, implementation details don't matter and they can stay encapsulated within the class.

### Answer re-do
Ruby creates objects and exposes the interfaces to interact with those objects and so it is possible that the data could be unintentionally modified. Also this can also increase the dependencies between different objects. Ruby enables us to hide the behaviour and its implementation by making it not visible to the rest of the code in order to reduce dependencies and to prevent the data from being exposed to unwanted parts of the code. This is known as Encapsulation and this is acheived through the use of Method Access Control or access modifiers which determines if the methods are public, private or protected. All public instance methods are accessible from outside of the class if the method name is known. In ruby all the instance methods are public by default unless we implement method access control. The exception being the constructor method initialize which is always private.

note: All the attributes within the class are encapsulated by default. In order to overcome this the getter methods are defined to access them.
```
class Student
  attr_reader :name

  def initialize(name, age)
    @name = name
    @age = age
  end

  def student_age
    age
  end

  private

  attr_reader :age
end

bob = Student.new("Bob", 19)

p bob.name         # => "Bob"
p bob.student_age  # => 19
p bob.age          # => NoMethodError
```
The above example we have hidden the implementation details of the instance method `age` from being accessed from outside of the class. This was acheived by the use of the private method which is an access modifier. Hence the instance method `age` can only accessed from the within the Student class.

## Example 34
What is returned/output in the code? Why did it make more sense to use a module as a mixin vs. defining a parent class and using class inheritance?
```
module Walkable
  def walk
    "#{name} #{gait} forward"
  end
end

class Person
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Cat
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

mike = Person.new("Mike")
p mike.walk

kitty = Cat.new("Kitty")
p kitty.walk
```
This code outputs and returns: `"Mike strolls forward"` on `line 1823` then `"Kitty saunters forward"` on `line 1826`. This code makes sense as a mixin module, as the classes have a "has-a" relationship with a walk, rather than an "is-a" relationship; it is a common behavior that can be shared amongst classes. 

### Answer re-do
On `line 40` the `walk` instance method is invoked on the local variable `mike` referencing the instance of the class `Person` it ouputs and returns `"Mike strolls forward"`

On `line 43` the `walk` instance method is invoked on the local variable `kitty` referencing the instance of the class `Cat` it ouputs and returns `"Kitty saunters forward".`

It makes sense to use a module `Walkable` to mixin the instance method `walk` in the both the classes. This is because both the classes have their own unique state with the `@name` instance variable referencing different values and they also have their own implementation of the private instance method `gait` which is interpolated in the string within the `walk` instance method. If we were to inherit `walk` from the superclass then we will not be able to manipulate the instance method in a simillar fashion.

## Example 35
What is Object Oriented Programming, and why was it created? What are the benefits of OOP, and examples of problems it solves?
OOP was created to reduce dependencies. Programmers wanted to created a way to section of certain areas of code and to work and manipulate them without affecting the rest of the code. This helps us to think in a more abstract fasion about the code currently written. It was created to keep the code DRY (Don't Repeat Yourself). That is it helps in preventing duplication of the code. We are able to build applications at a faster pace due to large code reusability from pre-written code. OOP also makes it easier to manage the complexity of the software and easier to conceptualize objects as real life objects.

## Example 36
What is the relationship between classes and objects in Ruby?
Classes are basic oulines of what an object is made of. Classes define the attributes and the behaviors of its objects. Classes group common behaviors. Anything that has a value can be considered an object. Basically, things like numbers, strings, arrays, classes, and modules. Methods, blocks, and variables are not objects. Objects are instances of a class and they encapsulate the state of the object. Objects are created from classes (which are also another type of Object). Simply: Class = a blueprint Object = something built from that blueprint

### Answer re-do
Classes are basic oulines of what an object is made of. Classes define the attributes and the behaviors of its objects. Common behaviors are grouped within a class. A class can have many objects
```
class Person
	def initialize(name)
    @name = name
  end
end
```
Objects are instances of a class and they encapsulate the state of the object. Objects are instantiated by calling the `::new` class method on the class.
```
class Person
  def initialize(name)
    @name = name
  end
end

marts = Person.new("Martha")
```
On `line 7` we are instantiating a new object of the `Person` class and it encapsulates the state `@name = "Martha"`

## Example 37
When should we use class inheritance vs. interface inheritance?
Inheritance reduces dependencies and increases code resusability. We can use inheritance to extract common behaviors to a superclass. This helps us to keep the logic in one place. All the methods inherited from a superclass is available to its subclass. This is a great way to model concepts that are naturally hiearchical. A subclass inherits the behaviors from a superclass. The subclass is the derived class and the super class is the base class. The superclass has a larger reusability and the subclass has an extended or refined implementation. This reduces complexity of the code and makes it reusable. Class Inheritance displays "is - a" relationship. This is in conrast to interface inheritance, which has a "has - a" relationship. multiple inheritance is acheived by mixin modules. The inheritance achieved through mixing in modules are known as Interface Inheritance. We mix in a behavior from a module using the include method and passing in the name of the module as an argument to it. Modules are used as containers for grouping common methods and namespacing. Grouping simillar or related classes within a module is known as namespacing. Modules are useful for grouping common methods from classes that are not related hierarchially.

class vs interface(mix-in) inheritance:
- If multiple inheritance is needed, use Interface inheritance as subclasses inherit from only one superclass.
- Modules cannot inherit. Modules cannot create objects. So, in order to create objects we use class inheritance
- Modules have a "has-a" relationship: used for namespacing and grouping commom behaviors to be shared.
- Classes have a "is-a" relationship: it is useful for creating objects.

### Answer re-do
- If we need multiple inheritance then we use Interface inheritance as subclasses inherit from only one superclass.
- Modules cannot inherit and also modules cannot create objects so in order to create objects we need to use class inheritance.
- modules have a has-a relationship and they are used for namespacing and grouping commom behaviors to be shared.
- Classes have a is-a relationship hence it is useful for creating objects.
A subclass inherits the behaviours from a superclass. The subclass is the derived class and the super class is the base class. The superclass has a larger reusability and the subclass has an extended or refined implementation. This reduces complexity of the code and makes it reusable. Class Inheritance displays is - a relationship.
```
class Mammal # superclass
end

class Dog < Mammal # subclass
end
```
In Ruby multiple inheritance is acheived by mixin modules. The inheritance achieved through mixing in modules are known as Interface Inheritance. The behaviour from a module is mixed in using the include method and passing in the name of the module as an argument to it. The modules group common methods and classes within. This is known as namespacing. Interface inheritance have a has - a relationship. Eg. The Dog has a behaviour(.i.e, a method).
```
module Swimmable
  def swim
    "I can swim!!!"
  end
end

class Human
  include Swimmable
end

class Dog
  include Swimmable
end

puts Human.new.swim
puts Dog.new.swim
```

## Example 38
If we use == to compare the individual Cat objects in the code above, will the return value be true? Why or why not? What does this demonstrate about classes and objects in Ruby, as well as the == method?
```
class Cat
end

whiskers = Cat.new
ginger = Cat.new
paws = Cat.new

p whiskers == ginger
p paws == ginger
```
`lines 1919 and 1920` return false. The `==` method has a special syntax to make it look like a normal operator that is part of Ruby's syntactical sugar. It is not, however, an operator, but an instance method. We can, therefore, assume that the value used for comparison of each calling instance is determined by its class. The original `==` is defined in `BasicObject`, from which all other class in Ruby descend. Therefore, all classes have a `==` method available to them. By default, the `==` method will check to see if the two objects being compared are the same object in memory. 

In the above code, we define the class `Cat` and initialize 3 `Cat` objects on `lines 1915-1917` and assign local variables to the returned objects, each with their own object encoding id. When we invoke the `==` method on the object referenced by `whiskers` on `line 1919`, the implementation of `==` is still that of `BasicObject`. `==` is comparing the two objects to see if they are the same object in memory. `whiskers` and `ginger` reference two separate objects with different object encoding ids so `==` returns `false`.

### Answer re-do
`Lines 8 and 9` will return and output `false` because in each line we are comparing two objects from the same class which are unique and they have their own encoding id. This shows that in Ruby all the objects are unique and they have their own state even if they are created from the same class. Also we can infer from this that the `==` method compares the value and when the values are the same then it evaluates to `true` else it will return `false`.

## Example 39
Describe the inheritance structure in the code, and identify all the superclasses.
```
class Thing
end

class AnotherThing < Thing
end

class SomethingElse < AnotherThing
end
```
This is an example of class inheritance. `Thing` is the overarching superclass, with `AnotherThing` as its subclass. All the methods inherited from a `Thing` are available to `AnotherThing`. Further, `AnotherThing` is a superclass to `SomethingElse`, so `SomethingElse` will inherit all methods from `AnotherThing`, and will therefore have access to all methods in `Thing` due to the hirearchy. Therefore, `Thing` would also be considered a superclass to `SomethingElse`.

### Answer re-do
This is an example of class inheritance where the subclasses inherit from the superclass. The subclass `SomethingElse` inherits from the superclass `AnotherThing`. `AnotherThing` subclass inherits from the superclass `Thing`. `Thing` does not have any explicit superclass.

## Example 40
What is the method lookup path that Ruby will use as a result of the call to the fly method? Explain how we can verify this.
```
module Flight
  def fly; end
end

module Aquatic
  def swim; end
end

module Migratory
  def migrate; end
end

class Animal
end

class Bird < Animal
end

class Penguin < Bird
  include Aquatic
  include Migratory
end

pingu = Penguin.new
pingu.fly
```
Ruby will use the following method lookup path: `[Penguin, Migratory, Aquatic, Bird, Animal, Object, Kernel, BasicObject]`. It will not find the method `fly` and so it will raise a `NoMethodError`. We can verify this by calling `#ancestors` on the `Penguin` class.

### Answer re-do
The order in which Ruby inspects different classes when a method is invoked is known as the method lookup path. This can be determined by calling the `#ancestors` method on the class under question.

On `line 25` the instance method fly is invoked on the object referenced by `pingu` which is created from the `Penguin` class. Now Ruby will look for `fly` within the method lookup path of the class `Penguin` if it cannot find it within the `Penguin` class. It will first look in the mixed in modules in an ascending order i.e in `Migration` and then followed by `Aquatic`. Since it cant find `fly` in either of them and there are no more modules mixin taking place Ruby with look in the class inheritance hierarchy. Since `Penguin` inherits from the superclass `Bird` it will look inside of it and doesnt find it. Hence `line 25` will raise a `NoMethodError`.

This can be verified by calling the ancestors mehtod on the object's class to get the method lookup path.
```
p pingu.class.ancestors
# => [Penguin, Migratory, Aquatic, Bird, Animal, Object, PP::ObjectMixin, Kernel, BasicObject]
```

## Example 41
What does this code output and why?
```
class Animal
  def initialize(name)
    @name = name
  end

  def speak
    puts sound
  end

  def sound
    "#{@name} says "
  end
end

class Cow < Animal
  def sound
    super + "moooooooooooo!"
  end
end

daisy = Cow.new("Daisy")
daisy.speak
```
This code outputs `"Daisy says moooooooooooo!"` and returns `nil`. On `line 2011` local variable `daisy` is assigned to the object created by calling the `::new` class method on the `Cow` class. `daisy` has a state `@name = 'Daisy'`. On `line 2012` we call the `speak` method on the object referenced by local variable `daisy`. According to the method lookup path, Ruby looks in `Cow` for the speak method and, without finding it, looks to `Animal` where it finds the `speak` method. Within the speak method, we call `puts` on the return of the `sound` method. `sound` is found in the `Cow` class. First we see the `super` keyword and so Ruby looks in the method lookup path to find another method with the same name and invokes the method when it finds it. Ruby finds another `sound` method in the `Animal` class, returning the interpolated string `"#{@name} says "`, using the instance variable for `@name` instantiated when the new `Cow` object was created, and so therefore returning `"Daisy says "`. This string is added to `"moooooooooooo!"` based on the remaining code within the `sound` method in the `Cow` class. This method returns the interpolated string `"Daisy says moooooooooooo!"`.

### Answer re-do

On `line 22` the `speak` instance method is invoked on the object of the `Cow` class. This outputs `"Daisy says moooooooooooo!"`. Ruby looks in the method lookup path of the `Cow` class and finds `speak` in the `Animal` class. Within the method definition of `speak` we have the expression `puts sound`. Now Ruby looks for the `sound` instance method within the method lookup path of the `Cow` class and finds it. Within the method definition of sound we have the `super` keyword in `line 17`. `super` is a keyword used by Ruby to invoke a method with the same name within the method lookup path. When we invoke a method which has a `super` keyword, Ruby looks in the method lookup path to find another method with the same name. Ruby invokes the method when it finds it. Hence the expression `super + "moooooooooooo!"` resolves as `"#{@name} says " + "moooooooooooo!"` after the `super` finds sound in `lines 10 - 13` from the `Animal` class.

## Example 42
Do molly and max have the same states and behaviors in the code below? Explain why or why not, and what this demonstrates about objects in Ruby.
```
class Cat
  def initialize(name, coloring)
    @name = name
    @coloring = coloring
  end

  def purr; end

  def jump; end

  def sleep; end

  def eat; end
end

max = Cat.new("Max", "tabby")
molly = Cat.new("Molly", "gray")
```
`max` and `molly` are both local variables which are assigned to 2 different objects which were created by calling the `::new` class method on the `Cat` class. 'max' as 2 sates `@name = Max` and `@coloring = tabby`. `molly` also has two states `@name = Molly` and `@coloring = gray`. As part of the `Cat` class, they bot have access to the behaviors defined by the methods `purr` `jump` `sleep` and `eat`.

Answer re-do
`max` has the state `@name="Max"`, `@coloring="tabby"` and `molly` has the state `@name="Molly"`, `@coloring="gray"`. Therefore we can see that both `molly` and `max` which are instances of the same object have different states. This is because in Ruby the objects, which are created from the class, encapsulate the state and the behaviors are defined by the classes. The objects are unique and their states are specific to them. However both the objects have the same behaviour as they are defined in the class they are created from.

## Example 43
```
class Student
  attr_accessor :name, :grade

  def initialize(name)
    @name = name
    @grade = nil
  end

  def change_grade(new_grade)
    grade = new_grade
  end
end

priya = Student.new("Priya")
priya.change_grade('A')
priya.grade
```

In the above code snippet, we want to return ”A”. What is actually returned and why? How could we adjust the code to produce the desired result?

In the code above, on `line 2063`, `priya.grade` returns `nil`. This is because in the `change_grade` method on `lines 2056-2058`, we did not distinguish `grade` on `line 2057` from local variable initialization, and so when we call `change_grade` a local variable `grade` is intialized, rather than reassigning the instance variable `@grade` with the setter method `grade=` as desired. By adding the `self` keyword, we are able to modify the desired value of the instance variable:
```
  def change_grade(new_grade)
    self.grade = new_grade
  end
```
### Answer re-do

On `line 16` when the instance method `grade` is invoked on the object referenced by `priya` it returns `nil`. This is because the argument `A` passed in to the setter method `change_grade` invocation in `line 15` does not reassign the value referenced by the `@grade` instance variable in `line 10`. Instead in `line 10` Ruby is initializing a local variable `grade` to the string `A`. Hence `@grade` is never reassigned and is always `nil`. In order to fix this we have to call the grade getter method on the `self` keyword in `line 10` as follows
```
def change_grade(new_grade)
  self.grade = new_grade
end
```
Now when `priya.grade` executes in `line 16` string `"A"` is returned.

## Example 44
What does each `self` refer to in the below code snippet?
```
class MeMyselfAndI
  self

  def self.me
    self
  end

  def myself
    self
  end
end

i = MeMyselfAndI.new
```
`self` on `line 2088` references the class that's in the process of being defined, so, in this case, `self` references `MeMyselfAndI`. On `line 2090` `self` references a class method, and so `self` again references the class `MeMyselfAndI`. On line `2091`, we call `self` within a class method, and so the calling object is the class itself, therefore `self` will reference the class that calls the method, `MeMyselfAndI`, rather than an instance of that class. However, on `line 2095` `self` we call self within an instance method and in this case `self` points to the object that calls the method, the new `MeMyselfAndI` object which is instantiated on `line 2099` and referenced by local variable `i`

### Answer re-do
The `self` keyword is an explicit caller. The `self` keyword represents the class or the object of a class depending upon the scope where it is used.

In `line 2` `self` represents the class `MeMyselfAndI` as it is defined in the scope of the class. In `line 4` `self` is used while defining a class method `me`. Here `self` represents the class `MeMyselfAndI`. There for `line 4 - 5` can also be written as
```
def MeMyselfAndI.me
  self
end
```
within the scope of the class methods `self` always represents the class.

In `line 8 - 10` `self` is used within the method definition if the instance method `myself`. Hence within the instance method `self` always represents the calling object `i` of the class `MeMyselfAndI`.

## Example 45
Running the following code will not produce the output shown on the last line. Why not? What would we need to change, and what does this demonstrate about instance variables?
```
class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @name = name
  end
end

ade = Student.new('Adewale')
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">
```

Running this code will produce `#<Student:0x00007fae54965af0 @name="Adewale">`. This is because the instance varibale `@grade` is never initialized within the method body of `initialize` and so the instance variable is not instantiated as part of the new object referenced by `ade` when we call `::new` on the class `Student`. In order to achieve the desired output, we need to change the method `initialize` to include `@grade`, as below:
```
  def initialize(name, grade=nil)
    @grade = grade
    @name = name
  end
```

### Answer re-do
This is because within the constructor method `initialize` we have not defined the instance variable `@grade`. Therefore it is not included in the state during instantiation of the instance `ade`. In order to fix the code we will have to initialize the instance variable `@grade` as follows:
```
class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @grade = grade
    @name = name
  end
end

ade = Student.new('Adewale')
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">
```
Now `line 11` will return the desired output. This demonstrates that the instance variables tracks the state of the object.

## Example 46
What is output and returned, and why? What would we need to change so that the last line outputs ”Sir Gallant is speaking.”?

```
class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} is speaking."
  end
end

class Knight < Character
  def name
    "Sir " + super
  end
end

sir_gallant = Knight.new("Gallant")
p sir_gallant.name
p sir_gallant.speak
```
On `line 2179` this code outputs and returns `"Sir Gallant"` and on `line 2180` it outputs and returns `"Gallant is speaking."`. This is because the `speak` method on `lines 2167-2169` reference the instance variable `@name` which in the `Character` class is assinged to `"Gallant"`. If we change the code in the speak method as below:
```
def speak
   "#{name} is speaking."
end
```
We are now accessing `@name` through the getter method, and so it refelcts the changes made in the `Kinght` class, which inherits from `Character`.

## Example 47
What is output and why?
```
class FarmAnimal
  def speak
    "#{self} says "
  end
end

class Sheep < FarmAnimal
  def speak
    super + "baa!"
  end
end

class Lamb < Sheep
  def speak
    super + "baaaaaaa!"
  end
end

class Cow < FarmAnimal
  def speak
    super + "mooooooo!"
  end
end

p Sheep.new.speak
p Lamb.new.speak
p Cow.new.speak
```

This code outputs the following: `"#<Sheep:0x00007fb6bd829288> says baa!" "#<Lamb:0x00007fb6bd828db0> says baa!baaaaaaa!" "#<Cow:0x00007fb6bd828108> says mooooooo!"`

This is because in the `FarmAnimal` class in the `speak` method which each of the subclasses use, we use the keyword `self` as the animal name from inside of an instance method. Inside of an instance method, `self` points to the object that calls the method, which is why the object is returned. In order to fix this, we can create a new name instance, or, if we want the name of the class to be output rather than the object, we can simply change `line 2195` to read `"#{self.class} says "`.

## Example 48
```
class Person
  def initialize(name)
    @name = name
  end
end

class Cat
  def initialize(name, owner)
    @name = name
    @owner = owner
  end
end

sara = Person.new("Sara")
fluffy = Cat.new("Fluffy", sara)
```
What are the collaborator objects in the above code snippet, and what makes them collaborator objects?

Collaborator objects are usually custom objects that are assigned to the state of another object. These help to form associations between the two objects and makes the methods of the collaborator object available to the other object.

In this snippit, the `Person` object referenced by the local variable `sara` is a collaborator object, as it is passed in during the instantiation of the new `Cat` object on `line 2242` and assigned to the instance variable `@owner` on `line 2237`.

### Answer re-do
Collaborator objects are custom objects that are assigned to the state of another object. This way we can form associations between the two objects. Thereby making the methods of the collaborator object available to the other object

In the above code the object referenced by the local variable `sara` created from the `Person` class is stored as a state of the object `fluffy`. In `fluffy` the object `sara` is assigned to the instance variable `@owner` when the object referenced by the local variable `fluffy` is instantiated from the `Cat` class.

Here the object referenced by `sara` is the collaborator object which makes it's behaviours availabe to the object `fluffy`.

## Example 49
What methods does this case statement use to determine which when clause is executed?
```
number = 42

case number
when 1          then 'first'
when 10, 20, 30 then 'second'
when 40..49     then 'third'
end
```

This case statement uses the `==` method for equality to determine when the clause is executed. It could be rewritten:
```
number = 42

if number == 1
  'first'
elsif number == 10
  'second'
elsif number == 20
  'second'
elsif number == 30
  'second'
elseif (40..49).include?(number)
  'third'
end
```
### Answer re-do
The case statement uses the === method explicitly. The calling object is treat as a group and checks if the argument is part of the group.

## Example 50
What are the scopes of each of the different variables in the above code?
```
class Person
  TITLES = ['Mr', 'Mrs', 'Ms', 'Dr']

  @@total_people = 0

  def initialize(name)
    @name = name
    @@total_people += 1
  end

  def age
    @age
  end
end
```

`TITLES` is a constant, and has lexical scope.  `@@total_people` is a class variable and has class scope. `@name` and `@age` are instance variables and have object scope.

### Answer re-do
The constant `TITLES` initialized in the `line 2` is available throught the class and its subclasses. The class variable acts as one copy through out the class and its subclasses. The instance variable `@name` is available only within a instance of a class. Once the instance is destroyed then the instance variable perishes along with it. Instance variables are scoped within the instance of the class. The instance variable `@age` is not initialized and hence it is not available anywhere as always evaluates to `nil`.

## Example 51 - Spike
The following is a short description of an application that lets a customer place an order for a meal:

A meal always has three meal items: a burger, a side, and drink.
For each meal item, the customer must choose an option.
The application must compute the total cost of the order.
Identify the nouns and verbs we need in order to model our classes and methods.
Create an outline in code (a spike) of the structure of this application.
Place methods in the appropriate classes to correspond with various verbs.

Nouns: meal = burger, side, drink; customer, option, application, cost
Verbs: choose, compute
```
class Meal
  attr_accessor :burger, :side, :drink, :cost

  def initialize(burger, side, drink)
    @burger = burger
    @side = side
    @drink = drink
    @cost = Application.new.calculate_cost(burger, side, drink)
  end

  def to_s
    "#{burger}, #{side}, and a #{drink}. Please pay $#{cost} at the window."
  end
end

class Customer
  attr_reader :name
  attr_accessor :meal

  def initialize(name)
    @name = name
    @meal = meal
  end

  def choose_meal(burger, side, drink)
    self.meal = Meal.new(burger, side, drink)
  end

  def to_s
    "#{name} ordered a #{meal.to_s} "
  end
end

class Application
  def calculate_cost(burger, side, drink)
    cost = 0
    if burger == 'hamburger'
      cost += 4.00
    elsif burger == 'cheeseburger'
      cost += 5.00
    else 
      puts "Your choice in burger is not on the menu. Please choose again."
    end
    if side == 'fries'
      cost += 2.50
    elsif side == 'onion rings'
      cost += 3.00 
    end
    if drink == 'soft drink'
      cost += 1.00
    elsif drink == 'milkshake'
      cost += 3.00
    end
    cost
  end
end

bob = Customer.new("Bob")
meal = bob.choose_meal('cheeseburger', 'fries', 'milkshake')
p bob
puts bob
p meal
```
### Answer re-do
```
class Order
  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end

  def to_s
    puts "The total cost is £#{customer.order.sum} for the following items:"
    puts customer.items
    ""
  end

end

class Meal
  attr_reader :burger, :side, :drink

  def initialize
    @burger = 4.50
    @side = 1.50
    @drink = 3
  end
end

class Customer
  attr_reader :meal, :order, :items

  def initialize
    @order = []
    @items = []
    @meal = Meal.new
  end

  def items_ordered(item, select)
    if item
      order << select
      items << item
    end
  end

  def choose(burger=nil, side=nil, drink=nil)
    items_ordered(burger, meal.burger)
    items_ordered(side, meal.side)
    items_ordered(drink, meal.drink)
  end
end

bob = Customer.new
bob.choose("burger", "side", "drink")
total = Order.new(bob)
puts total

# The total cost is £9.0 for the following items:
# burger
# side
# drink
Another take on the code spike this time with a more detailed implementation

# The following is a short description of an application that lets a customer place an order for a meal:

# - A meal always has three meal items: a burger, a side, and drink.
# - For each meal item, the customer must choose an option.
# - The application must compute the total cost of the order.

# 1. Identify the nouns and verbs we need in order to model our classes and methods.
# 2. Create an outline in code (a spike) of the structure of this application.
# 3. Place methods in the appropriate classes to correspond with various verbs.

=begin
  customer has orders
  orders have meal
  meals have cost
=end

module Display
  def display_error
    puts "Invalid selection! Please choose numbers 1, 2 or 3. Try again!"  
  end

  def list(food)
    food.each do |num, item|
      puts "#{num}. #{item.first}: £#{item.last}."
    end
  end
end

class Restaurant
  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end

  def total
    customer.print_selection.map { |food| food.last }.sum
  end

  def final
    puts "#{customer.name} has ordered a meal combo consisting of:"
    customer.print_selection.each { |food| puts "#{food.first} for £#{food.last}." }
    puts "The total amount due is £#{total}."
  end
end

class Customer
  include Display

  attr_accessor :name, :order

  def initialize(name)
    @name = name
    @order = Orders.new
  end

  def prompt(food)
    choice = 0
    loop do
      puts "Please choose one of the option (1, 2, 3)"
      list(food)
      choice = gets.chomp.to_i
      break if [1, 2, 3].include? choice
      display_error
    end

    choice
  end

  def food_selected(food)
    item = food
    choice = prompt(food)
    order.selection << item[choice]
    puts
  end

  def order_food
    food_selected(order.meal.burger)
    food_selected(order.meal.sides)
    food_selected(order.meal.drinks)
  end

  def print_selection
    order.selection
  end
end

class Orders
  attr_reader :meal, :selection

  def initialize
    @meal = Meal.new
    @selection = []
  end
end

class Meal
  attr_reader :burger, :sides, :drinks

  def initialize
    @burger = { 1 => ["Cheese Burger", 6], 2 => ["Chicken Burger", 4], 3 => ["Veggie Burger", 3] }
    @sides = { 1 => ["Onion Rings", 2], 2 => ["Chicken Wings", 3], 3 => ["Potato Wedges", 1] }
    @drinks = { 1 => ["Spring Water", 1], 2 => ["Coca Cola", 1], 3 => ["Fanta", 1] }
  end
end

# bob = Customer.new("Bob")
# grillz = Restaurant.new(bob)
# bob.order_food
# grillz.final

# Please choose one of the option (1, 2, 3)
# 1. Cheese Burger: £6.
# 2. Chicken Burger: £4.
# 3. Veggie Burger: £3.
# 2

# Please choose one of the option (1, 2, 3)
# 1. Onion Rings: £2.
# 2. Chicken Wings: £3.
# 3. Potato Wedges: £1.
# 1

# Please choose one of the option (1, 2, 3)
# 1. Spring Water: £1.
# 2. Coca Cola: £1.
# 3. Fanta: £1.
# 3

# Bob has ordered a meal combo consisting of:
# Chicken Burger for £4.
# Onion Rings for £2.
# Fanta for £1.
# The total amount due is £7.
Take 3

# The following is a short description of an application that lets a customer place an order for a meal:

# - A meal always has three meal items: a burger, a side, and drink.
# - For each meal item, the customer must choose an option.
# - The application must compute the total cost of the order.

# 1. Identify the nouns and verbs we need in order to model our classes and methods.
# 2. Create an outline in code (a spike) of the structure of this application.
# 3. Place methods in the appropriate classes to correspond with various verbs.

# Nouns - meals, burger, side, drink, customer, application, order, cost
# verbs - compute, chooses

module Display
  def prompt_select
    puts "Please select from one of the following using 1, 2, 3."
  end

  def raise_warning
    puts "Invalid selection!. Please try again (1, 2, or 3)."
  end
end

class Order
  attr_reader :customer_order, :cost

  def initialize
    @customer_order = {}
    @cost = []
  end

  def customer_selection(food)
    customer_order[food[0]] = food[1]
  end

  def total
    customer_order.each do |_, price|
      cost << price.chars.map(&:to_i).sum
    end
    cost.sum
  end

  def amount_due
    puts
    puts "The following was ordered:"
    customer_order.each do |item, cost|
      puts "====> #{item}: #{cost}"
    end
    puts "The amount due now is £#{total}"
  end
end

class Meal
  attr_reader :burger, :side, :drink

  def initialize
    @burger = [["Cheese Burger", "£7"], ["Chicken Burger", "£6"], ["Veggie Burger", "£4"]]
    @side = [["Onion Rings", "£1"], ["Chicken Wings", "£2"], ["Potato Wedges", "£2"]]
    @drink = [["Spring Water", "£1"], ["Fanta", "£1"], ["Sprite", "£1"]]
  end

  def list(food)
    food.each_with_index do |(item, cost), idx|
      puts "#{idx + 1}). #{item}: #{cost}"
    end
    puts
  end

  def display_menu
    puts "Please have a look at out Meal menu."
    list(burger)
    list(side)
    list(drink)
  end
end

class Customer
  include Display

  attr_reader :meal, :order

  def initialize
    @meal = Meal.new
    @order = Order.new
  end

  def choose(food)
    choice = 0
    loop do
      prompt_select
      meal.list(food)
      choice = gets.chomp.to_i
      break if [1, 2, 3].include? choice
      raise_warning
    end

    choice - 1
  end

  def selects_food
    meal.display_menu
    [choose(meal.burger), choose(meal.side), choose(meal.drink)]
  end

  def order_food
    food = [meal.burger, meal.side, meal.drink]
    counter = 0
    selects_food.each_with_index do |num, idx|
      order.customer_selection((food[counter])[num[idx]])
      counter += 1
    end
    order.amount_due
  end
end

=begin
order process
  - customer orders food
    - options provided
    - customer has to choose a type from each meal item
    - customer chooses a burger, side and a drink
  - Order is captured
    - the total cost is computed and the displayed
=end
bob = Customer.new
bob.order_food

# ============ exapected output ============
#Please have a look at out Meal menu.
# 1). Cheese Burger: £7
# 2). Chicken Burger: £6
# 3). Veggie Burger: £4

# 1). Onion Rings: £1
# 2). Chicken Wings: £2
# 3). Potato Wedges: £2

# 1). Spring Water: £1
# 2). Fanta: £1
# 3). Sprite: £1

# Please select from one of the following using 1, 2, 3.
# 1). Cheese Burger: £7
# 2). Chicken Burger: £6
# 3). Veggie Burger: £4

# 2
# Please select from one of the following using 1, 2, 3.
# 1). Onion Rings: £1
# 2). Chicken Wings: £2
# 3). Potato Wedges: £2

# 1
# Please select from one of the following using 1, 2, 3.
# 1). Spring Water: £1
# 2). Fanta: £1
# 3). Sprite: £1

# 2

# The following was ordered:
# ====> Chicken Burger: £6
# ====> Onion Rings: £1
# ====> Spring Water: £1
# The amount due now is £8
```

## Example 52
In the `make_one_year_older` method we have used `self`. What is another way we could write this method so we don't have to use the `self` prefix? Which use case would be preferred according to best practices in Ruby, and why?
```
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end
```

Another way to write the method would be to change `line 2763` to read `@age += 1`. However, using the `self` keyword is preferable, as we are using the settter method rather than accessing the instance variable directly. Getter/setter methods are much easier to reference if we ever need to retrieve or modify the state of the object as we can make changes in just one place.

## Example 53
What is output and why? What does this demonstrate about how methods need to be defined in modules, and why?
```
module Drivable
  def self.drive
  end
end

class Car
  include Drivable
end

bobs_car = Car.new
bobs_car.drive
```
This code raises a `NoMethodError` on  `line 2783` for undefined method `drive` for the `Car` object. This is because `drive` is defined as a module method, and we are attempting to call it on an object. Class/Module methods are scoped at the class level, and are not available to any instances of the class. This demosntrates that methods should be defined in modules just as they would be in the class body, so that they can be used when they are mixed into the class. This method definition should read as `def drive` on  `line 2774`. 

## Example 54
```
class House
  attr_reader :price

  def initialize(price)
    @price = price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2 # => Home 1 is cheaper
puts "Home 2 is more expensive" if home2 > home1 # => Home 2 is more expensive
```
What module/method could we add to the above code snippet to output the desired output on the last 2 lines, and why?

In order to output the desired output, we must define `<` and `>` methods. By default, the comparison methods do not know how or what values to compare. We define them to tell them which values we want to compare, relying on the specific implementations for comparison methods within Ruby's built in classes. The code below will allow the desired output:

```
class House
  attr_reader :price

  def initialize(price)
    @price = price
  end

  def <(other_house)
    price < other_house.price
  end

  def >(other_house)
    price > other_house.price
  end
end
```

### Answer re-do
`home1` and `home2` are two local variable referencinng the objects created from the `House` class on `line 9 and 10`. In line 11 the expression home1 < home2 raises an error. The above expression can also be written as `home1.<(home2)` this indicates that we are calling the `<` method which is looking to compare two `Integer` objects. Since we are dealing with two customs object Ruby raises an error. This is th same case in `line 12` for the expression `home1 > home2` where we use the `>` method instead. Inorder for this issue to be resolved we will have to override these methods by having a custom implementation within our class House. This is done as follows
```
class House
  attr_reader :price

  def initialize(price)
    @price = price
  end

  def >(other)
    price > other.price
  end

   def <(other)
    price < other.price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2 # => Home 1 is cheaper
puts "Home 2 is more expensive" if home2 > home1 # => Home 2 is more expensive
```
In `line 8 - 10` and in `line 12 - 15` we have defined the methods `<` and `>` which override the original methods and hence we get the desired output.
