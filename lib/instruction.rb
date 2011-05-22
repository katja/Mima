require 'core_ext'

class Instruction

  attr_writer :value

  def initialize(command, argument = nil, label = nil)
    @command = command.to_sym
    @argument = argument
    @label = label
  end

  def value(machine)
    if @value
      @value
    else
      shift = machine.opcode_for(@command) > 15 ? 16 : 20
      (machine.opcode_for(@command) << shift) +
        resolved_argument(machine)
    end
  end

  def resolved_argument(machine)
    if @argument.nil?
      0
    elsif @argument.numeric?
      Integer(@argument) # it can even handle hex :)
    else
      machine.resolve_label(@argument)
    end
  end

  def command(machine = nil)
    if @value and machine
      shift = (@value >> 20) > 15 ? 16 : 20
      @argument = (@value - ((@value >> shift) << shift)).to_s
      @command = machine.command_with(@value >> shift)
    else
      @command
    end
  end

  def to_s
    "#{@command.upcase}".to_s.ljust(5) + "#{(@value || @argument)}".to_s.ljust(15) + @label.to_s
  end
end