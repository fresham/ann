module ANN
  def random_weight
    rand(101)/100.0
  end
  
  
  
  class Input
    attr_reader :weight
    
    def initialize(weight=random_weight)
      @weight=weight
    end
  end
  
  
  
  class Neuron
    attr_reader :inputs, :threshold
    
    def initialize(number_of_inputs)
      @inputs = Array.new(number_of_inputs) {Input.new}
      @threshold = random_weight
    end
    
    def input(inputs)
      sum = inputs.inject(0) do |sum, x|
        sum + inputs[x]*@inputs[x].weight
      end
      puts "INPUTS: #{inputs}"
      puts "WEIGHTS: #{@inputs.map(&:weight)}"
      puts "THRESHOLD: #{@threshold}"
      sum > threshold ? 1 : 0
    end
  end
  
  
  
  class Layer
    attr_reader :neurons
    
    def initialize(number_of_neurons, number_of_inputs)
      @neurons = Array.new(number_of_neurons) {Neuron.new(number_of_inputs)}
    end
    
    def input(inputs)
      @neurons.collect {|n| n.input inputs}
    end
  end
  
  
  
  class Network
    attr_reader :number_of_inputs, :number_of_outputs,
      :number_of_hidden_layers, :neurons_per_hidden_layer,
      :layers
    
    def initialize(number_of_inputs, number_of_outputs, number_of_hidden_layers,
        neurons_per_hidden_layer)
      @number_of_inputs = number_of_inputs
      @number_of_outputs = number_of_outputs
      @number_of_hidden_layers = number_of_hidden_layers
      @neurons_per_hidden_layer = neurons_per_hidden_layer
      @layers = []
      create_hidden_layers
      create_output_layer
    end
    
    def create_hidden_layers
      @layers << Layer.new(@neurons_per_hidden_layer, @number_of_inputs)
      (@number_of_hidden_layers-1).times do
        @layers << Layer.new(@neurons_per_hidden_layer, @neurons_per_hidden_layer)
      end
    end
    
    def create_output_layer
      @layers << Layer.new(@number_of_outputs, @neurons_per_hidden_layer)
    end
    
    def output_layer
      @layers.last
    end
    
    def hidden_layers
      @layers[0..-2]
    end
    
    def input(inputs)
      count = 0
      @layers.inject(inputs) do |inputs, layer|
        count += 1
        puts "LAYER: #{count}"
        inputs = layer.input inputs if inputs
        puts "\n"
      end
    end
  end
  
  
  
end
