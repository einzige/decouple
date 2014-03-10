module Decouple
  class Decoupler < Hash

    # @param klass [Class] A class to decouple
    # @yield Decoupling block
    def initialize(klass, &block)
      @klass = klass
      instance_eval(&block) if block
    end

    # @param action [Symbol] Name of the method being decoupled
    # @yield Method body extension
    def on(action, &block)
      if has_key?(action)
        raise ArgumentError, "#{action} action is already callbacked"
      end

      unless @klass.instance_methods.include?(action)
        raise ArgumentError, "No such action #{action}"
      end

      self[action] = block
    end

    # Runs callbacks (decouplings) attached to decoupling methods
    # @param klass_instance [Object] An object where the decoupling will be called
    # @param arguments [Array]
    def run(klass_instance, *arguments)
      unless klass_instance.is_a?(@klass)
        raise ArgumentError, "Running #{klass_instance.class.name} on #{@klass.name} Decoupler"
      end

      action = nil
      depth = 0 # Can be optimized by seeting to 3

      while action.nil?
        location = caller_locations(depth+=1, 1)[0] or raise "No action to proceed (invalid context) [#{depth}]"
        location = location.label.to_sym
        action = location if self.has_key?(location)
      end

      run_on(klass_instance, action, *arguments)
    end

    # Runs callback attached to method
    # @param klass_instance [Object] An object where the decoupling will be called
    # @param action [Symbol, String] Name of decoupled method
    def run_on(klass_instance, action, *arguments)
      block = self[action.to_sym] or raise ArgumentError, "No callback for #{action}"
      klass_instance.instance_exec(*arguments, &block)
    end
  end
end
