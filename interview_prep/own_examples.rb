# For each: How? What? Why? Along with own code example
  # To focus on especially: Polymorphism, capsulation, collaborator objects

# Classes and Objects
  # Objects
  # Classes
  # Object Instantiation
  class Team
    def initialize(team_name)
      @team_name = team_name
    end
  end
  
  badgers = Team.new("Badgers")
  p badgers
  
  # Instance Variables
  # Instance Methods
  class Team
    attr_reader :team_name

    def initialize(team_name)
      @team_name = team_name
    end
  
    def introduce
      puts "GoOoOoOo #{team_name}"
    end
  end
    
  badgers = Team.new("Badgers")
  badgers.introduce

  # Class Variables
  # Class Methods

  class Team
    @@number_of_teams = 0
  
    def initialize(team_name)
      @@number_of_teams += 1
      @team_name = team_name
    end
  
    def self.print_number_of_teams
      puts @@number_of_teams
    end
  end
  
  badgers = Team.new("Badgers")
  Team.print_number_of_teams
  tarheels = Team.new("Tarheels")
  Team.print_number_of_teams
  
    # Instance Methods vs Class Methods
=begin 
  Instance methods are called on the instances of the class (individual object, must be instantiated). Instance methods are the 
  behaviors or functionality available to the objects. Define a single behavior. They are encapsulated in the Classes from which the 
  objects are derived from. Instance variables can be accessed by the instance methods
=end
  
  class Team
    def	instance_method
      "From the instance method"
    end
  end
  
  p Team.new.instance_method
  
=begin
  Class methods are methods which are called on the class itself. They scoped at the class level and are not available to any 
  instances of the class. They cannot access instance variables. Define a behavior of the class as a whole. While defining the class 
  methods we chain the method name to the self keyword as shown in the example below.
=end
  
  class Team
    def self.class_method
      "I am from within the class method"
    end
  end
  
Team.class_method

# Setter and Getter Methods
  # Getter Methods

  class Team
    def initialize(team_name)
      @team_name = team_name
    end

    def team_name
      @team_name
    end
  end

  badgers = Team.new("Badgers")
  puts badgers.team_name

  # Setter Methods

  class Team
    def initialize(team_name)
      @team_name = team_name
    end

    def team_name=(new_name)
      @team_name = new_name
    end
  end

  badgers = Team.new("Badgers")
  p badgers
  badgers.team_name = "GO Badgers"
  p badgers

  # Using attr_*
    # Getter method
    class Team
      attr_reader :team_name 

      def initialize(team_name)
        @team_name = team_name
      end
    end

    badgers = Team.new("Badgers")
    p badgers.team_name

    # Setter method
    class Team
      attr_writer :team_name

      def initialize(team_name)
        @team_name = team_name
      end
    end

    badgers = Team.new("Badgers")
    p badgers
    badgers.team_name = ("GO Badgers")
    p badgers

    # Getter and Setter
    class Team
      attr_accessor :team_name
      
      def initialize(team_name)
        @team_name = team_name
      end
    end

    badgers = Team.new("Badgers")
    puts badgers.team_name
    badgers.team_name = "GO Badgers"
    puts badgers.team_name


# Method Access Control
  # Public
  # Private

  class Team
    attr_accessor :team_name
    attr_reader :state
  
    def initialize(team_name, state)
      @team_name = team_name
      @state = state
    end
  
    def to_s
      "The #{state} #{team_name}!!!"
    end
  
    private
    attr_writer :state
  end
  
  badgers = Team.new("Badgers", "Wisconsin")
  puts badgers
  badgers.state = "Illinois"
  
  # Protected
  class Team
    def initialize(team_name, state)
      @team_name = team_name
      @state = state
    end
  
    def to_s
      "The #{state} #{team_name}!!!"
    end
  
    def ==(other_team)
      state == other_team.state
    end
  
    private
    attr_writer :state
    attr_accessor :team_name
  
    protected
    attr_reader :state
  end
  
  badgers = Team.new("Badgers", "Wisconsin")
  puts badgers
  bucks = Team.new("Bucks", "Wisconsin")
  puts bucks
  puts badgers == bucks
  badgers.state

# Inheritance
  # Class Inheritance

  class Team 
    attr_accessor :team_name, :state

    def initialize(team_name, state)
      @team_name = team_name
      @state = state
    end
  end

  class Basketball < Team
  end

  badgers = Basketball.new("Badgers", "Wisconsin")
  p badgers

  # Interface Inheritance
  
  module Travelable
    def can_travel
      true
    end
  end

  class Team
    attr_accessor :state

    def initialize(team_name, state)
      @team_name = team_name
      @state = state
    end
  end

  class Hockey < Team
    include Travelable
  end

  class Basketball < Team
  end

  hockey_team = Hockey.new("Blackhawks", "Illinois")
  p hockey_team
  p hockey_team.can_travel

  basketball_team = Basketball.new("Bulls", "Illinois")
  p basketball_team
  p basketball_team.can_travel

  # Method Lookup Path

  module Travelable
    def can_travel
      true
    end
  end

  class Team
    include Travelable
  end

  class Hockey < Team
  end

  hawks = Hockey.new
  p hawks.can_travel
  p Hockey.ancestors

  # Super

  class Team
    def initialize(team_name)
      @team_name = team_name
    end
  end
  
  class Professional < Team
    def initialize(team_name, city)
      super(team_name)
      @city = city
    end
  end

  class Collegiate < Team
    def initialize(team_name, state)
      super(team_name)
      @city = state
    end
  end
  
  hawks = Professional.new("Blackhawks", "Chicago")
  p hawks

# Polymorphism & Encapsulation
  # Polymorphism
    # Polymorphism Through Inheritance
    # When we cannot find a method within the class that is is called on, but we find it in its superclass

    class Team
      attr_reader :team_name, :home
    
      def initialize(team_name, home)
        @team_name = team_name
        @home = home
      end
    
      def to_s
        "We are the #{home} #{team_name}!"
      end
    end
    
    class Professional < Team
    end
    
    class Collegiate < Team
    end
    
    badgers = Collegiate.new("Badgers", "Wisconsin")
    puts badgers
    
    # Polymorphism Through Duck Typing

    class HockeyTeam
      def play
        puts "We skate and hit!"
      end
    end

    class Dog
      def play
        puts "Woof woof! I can run all day"
      end
    end

    class Child
      def play
        puts "I want to go to the park!"
      end
    end

    arr = [HockeyTeam.new, Dog.new, Child.new]
    arr.each {|obj| obj.play}

  # Encapsulation

  class Team
    attr_reader :team_name
  
    def initialize(team_name, location)
      @team_name = team_name
      @location = location
    end

    def introduce
      puts "We are the #{location} #{team_name}"
    end
  
    private
    attr_accessor :location
    
  end
  
  badgers = Team.new("Badgers", "Wisconsin")
  badgers.team_name = "Blackhawks"
  p badgers

  badgers = Team.new("Badgers", "Wisconsin")
  badgers.introduce
  p badgers.team_name
  p badgers.location

# Modules
  # Mixin Modules
  module Payable
    def can_be_paid?
      true
    end
  end
  
  module NotPayable
    def can_be_paid?
      false
    end
  end
  
  class Team
  end
  
  class Professional < Team
    include Payable
  end
  
  class Collegiate < Team
    include NotPayable
  end
  
  badgers = Collegiate.new
  puts badgers.can_be_paid?
  blackhawks = Professional.new
  puts blackhawks.can_be_paid?

  # Namespacing
    # Using a module to group related classes
    module Team
      module Professional
        class Football
          def can_be_paid?
            true
          end
        end
      end
    
      module Collegiate
        class Football
          def can_be_paid?
            false
          end
        end
      end
    end
    
    p Team::Professional::Football.new.can_be_paid?
    p Team::Collegiate::Football.new.can_be_paid?

  # Module Methods
    # Useful when you have methods that seem out of place or don't really fit nicely anywhere in your code.

    module Team
      def self.out_of_place(num)
        2 * num
      end
    
      class Professional
        def can_be_paid?
          true
        end
      end
    
      class Collegiate
        def can_be_paid?
          false
        end
      end
    end
    
    p Team::Professional.new.can_be_paid?
    p Team::Collegiate.new.can_be_paid?
    p Team.out_of_place(5)

# Self
  # Inside Instance Methods
    # Refers to the object
    class Team
      def initialize(name, location)
        @name = name
        @location = location
      end
    end
    
    class Professional < Team
      def instance_method
        p self
      end
    end
    
    prof_team = Professional.new("Cubs", "Chicago")
    prof_team.instance_method
  # Inside Class Methods
    # Refers to the class
    class Team
      def initialize(name, location)
        @name = name
        @location = location
      end
    
      def self.class_method
        p self
      end
    end

    class Professional < Team
      def instance_method
        p self
      end
    end

    prof_team = Professional.new("Cubs", "Chicago")
    prof_team.instance_method
    Professional.class_method

  # Inside Class Definitions
    # References the class being defined
    class Team
      def initialize(name, location)
        @name = name
        @location = location
      end
    
      def self.class_method # References the Team class
        p self
      end
    end

    class Professional < Team
      def instance_method
        p self
      end
    end

    prof_team = Professional.new("Cubs", "Chicago")
    prof_team.instance_method
    Professional.class_method

  # Inside Mixin Modules
    # References the instance that calls the method
    module Payable
      def can_be_paid?
        p self
      end
    end
    
    class Team
      include Payable
    
      def initialize(name, location)
        @name = name
        @location = location
      end
    
      def self.class_method
        p self
      end
    end
    
    class Professional < Team
      def instance_method
        p self
      end
    end
    
    prof_team = Professional.new("Cubs", "Chicago")
    prof_team.instance_method
    Professional.class_method
    prof_team.can_be_paid?
    
  # Outside Any Class
# Fake Operators and Equality
  # Equivalence
    # ==
    # equal? and object_id
    # ===
    # eql?
  # Fake Operators
    # Comparison Methods
    # Right and Left Shift
    # Plus
    # Element Setters and Getters
# Collaborator Objects
  # When an object is stored as a state in another object

