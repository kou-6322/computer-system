/parsermodule/
class Parser
  attr_accessor :current_code, :dest, :comp, :jump, :pc

  def initialize
    file_name = ARGV[0]
    @file=File.open(file_name)
    @pc = 1
  end

  def hasMoreCommands
    read_next()
    return !(@next_code.nil?)
  end

  def advance
    @current_code = @next_code
  end

  def commandType
    if @current_code[0] == "@"
      @command_type="A"
      correct_A_COMMAND?()
      return "A_COMMAND"
    elsif @current_code[0] == "("
      correct_L_COMMAND?()
      @command_type = "L"
      return "L_COMMAND"
    else
      @command_type="C"
      ceparate_C_COMMAND()
      return "C_COMMAND"
    end
  end

  def symbol
    if @command_type == "A"
      return @current_code[1..]
    elsif @command_type == "L"
      #puts "#{@current_code} #{@command_type}"
      return @current_code[1..-2]
    end
  end

  private

    def read_next
      @pc += 1
      @next_code = @file.gets
      if !(@next_code.nil?)
        @next_code = @next_code.chomp.gsub(" ", "")
        slash=(/\/\//).match(@next_code)
        @next_code = slash ? slash.pre_match : @next_code
        if @next_code == ""
          read_next()
        end
      end
    end

    def correct_A_COMMAND?
      num=/^[0-9]+$/
      s=/^[a-zA-Z_\.\$\:][0-9a-zA-Z_\.\$\:]*$/
      if !(num =~ @current_code[1..]) && !(s =~ @current_code[1..])
        puts "command:#{@pc}(A_COMMAND) '#{@current_code}' is invalid"
        exit
      end
    end

    def correct_L_COMMAND?
      num=/^[0-9]+$/
      s=/^[a-zA-Z_\.\$\:][0-9a-zA-Z_\.\$\:]*$/
      if !(num =~ @current_code[1..-2]) && !(s =~ @current_code[1..-2])
        puts "command:#{@pc}(L_COMMAND) '#{@current_code}' is invalid"
        exit
      end
    end


    def ceparate_C_COMMAND
      @dest = @comp = @jump = nil
      code =""
      @current_code.split("").each do |c|
        if c == "="
          @dest = code
          code = ""
        elsif c == ";"
          @comp = code
          code = ""
        else
          code += c
        end
      end
      @comp ? @jump = code : @comp = code
    end
end

/code/

module Code

  def self.dest(c)
    case c
    when nil
      return "000"
    when "M"
      return "001"
    when "D"
      return "010"
    when "MD"
      return "011"
    when "A"
      return "100"
    when "AM"
      return "101"
    when "AD"
      return "110"
    when "AMD"
      return "111"
    else
      puts "command:#{@pc}(C_COMMAND) dest of '#{@current_code}' is invalid"
      exit
    end
  end

  def self.comp(c)
    case c
    when "0"
      return "0101010"
    when "1"
      return "0111111"
    when "-1"
      return "0111010"
    when "D"
      return "0001100"
    when "A"
      return "0110000"
    when "!D"
      return "0001101"
    when "!A"
      return "0110001"
    when "-D"
      return "0001111"
    when "-A"
      return "0110011"
    when "D+1"
      return "0011111"
    when "A+1"
      return "0110111"
    when "D-1"
      return "0001110"
    when "A-1"
      return "0110010"
    when "D+A"
      return "0000010"
    when "D-A"
      return "0010011"
    when "A-D"
      return "0000111"
    when "D&A"
      return "0000000"
    when "D|A"
      return "0010101"
    when "M"
      return "1110000"
    when "!M"
      return "1110001"
    when "-M"
      return "1110011"
    when "M+1"
      return "1110111"
    when "M-1"
      return "1110010"
    when "D+M"
      return "1000010"
    when "D-M"
      return "1010011"
    when "M-D"
      return "1000111"
    when "D&M"
      return "1000000"
    when "D|M"
      return "1010101"
    else
      puts "command:#{@pc}(C_COMMAND) comp of '#{@current_code}' is invalid"
      exit
    end
  end

  def self.jump(c)
    case c
    when nil
      return "000"
    when "JGT"
      return "001"
    when "JEQ"
      return "010"
    when "JGE"
      return "011"
    when "JLT"
      return "100"
    when "JNE"
      return "101"
    when "JLE"
      return "110"
    when "JMP"
      return "111"
    else
      puts "command:#{@pc}(C_COMMAND) jump of '#{@current_code}' is invalid"
      exit
    end
  end

end

/SymbolTable/
class SymbolTable
  attr_accessor :symbol_table
  def initialize
    @symbol_table = {}
    @symbol_table["SP"] = 0
    @symbol_table["LCL"] = 1
    @symbol_table["ARG"] = 2
    @symbol_table["THIS"] = 3
    @symbol_table["THAT"] = 4
    @symbol_table["SCREEN"] =16384
    @symbol_table["KBD"] = 24576
    16.times do |c|
      @symbol_table["R#{c}"] = c
    end
  end

  def addEntry(symbol, address)
    @symbol_table[symbol] = address
  end

  def contains(symbol)
    return (@symbol_table[symbol])
  end

  def getAddress(symbol)
    return @symbol_table[symbol]
  end
end

/main/
#first parse
symbol_table = SymbolTable.new
file = Parser.new
cc = 0
while file.hasMoreCommands
  file.advance
  c_type = file.commandType
  if c_type == "L_COMMAND"
    #puts file.symbol
    symbol_table.addEntry(file.symbol,cc)
  else
    cc += 1
  end
end

#second parse
array=[]
file = Parser.new
cc = 16
while file.hasMoreCommands
  #puts "#{rfile.pc} #{has}"
  file.advance
  c_type = ""
  s=""
  c_type = file.commandType
  if c_type == "A_COMMAND"
    c_code = file.current_code[1..]
    if (/^[0-9]+$/ !~ c_code)
      if symbol_table.contains(c_code)
        c_code = symbol_table.getAddress(c_code)
      else
        symbol_table.symbol_table[c_code] = cc.to_s
        c_code = cc.to_s
        cc += 1
      end
    end
    num = c_code.to_i.to_s(2)
    c = "0"*(15-(num.length))
    c += num
    s += "0#{c}"
    array.push s
  elsif c_type == "C_COMMAND"
    s+="111#{Code.comp(file.comp)}#{Code.dest(file.dest)}#{Code.jump(file.jump)}"
    array.push s
  end
end
File.open("#{ARGV[1]}","w") do |text|
  array.each do |c|
    text.puts c
  end
end
puts "Done as Success"
