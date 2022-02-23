 #arg1,2メソッドの場合分けを正確に！
class VMParser
  attr_accessor :current_code, :next_code, :current_code_s, :pc

  def initialize(file_name)
    @artithmetic_types = ["add", "sub", "neg", "eq", "gt", "lt", "and", "or", "not"]
    @segment_types = ["argument", "local", "static", "constant", "this", "that", "pointer", "temp"]
    @file = File.open(file_name)
    @pc = 0
  end

  def hasMoreCommands
    code = read_next()
    if (code.nil?)
      return false
    end
    @next_code = (code).split(" ")
    @current_code_s = code
  end

  def advance
    @current_code = @next_code.dup
  end

  def commandType
    if @artithmetic_types.include?(@current_code[0])
      @command_type = "C_ARTITHMETIC"
      correct_code?()
      return "C_ARTITHMETIC"
    elsif @current_code[0] == "push"
      @command_type = "C_PUSH"
      correct_code?()
      return "C_PUSH"
    elsif @current_code[0] == "pop"
      @command_type = "C_POP"
      correct_code?()
      return "C_POP"
    elsif @current_code[0] == "label"
      @command_type = "C_LABEL"
      correct_code?()
      return "C_LABEL"
    elsif @current_code[0] == "goto"
      @command_type = "C_GOTO"
      correct_code?()
      return "C_GOTO"
    elsif @current_code[0] == "if-goto"
      @command_type = "C_IF"
      correct_code?()
      return "C_IF"
    elsif @current_code[0] == "return"
      @command_type = "C_RETURN"
      return "C_RETURN"
    elsif @current_code[0] == "call"
      @command_type = "C_CALL"
      correct_code?()
      return "C_CALL"
    elsif @current_code[0] == "function"
      @command_type = "C_FUNCTION"
      correct_code?()
      return "C_FUNCTION"
    else
      puts "ERROR: '#{@current_code[0]}' in command:#{@pc} is invalid!"
    end
    puts @command_type
  end

  def arg1
    if @command_type == "C_ARTITHMETIC"
      return @current_code[0]
    elsif @command_type == "C_RETURN"
      puts "ERROR: command:#{@pc} return command doesn'd has arg1"
    else
      return @current_code[1]
    end
  end

  def arg2
    case @commnand_type
    when "C_PUSH" || "C_POP" || "C_FUNCTION" || "C_CALL"
      return @current_code[2]
    else
      puts "ERROR: command:#{@pc} #{@command_type} doesn't has arg2"
    end
  end


  private

    def correct_code?
      num=/^[0-9]+$/
      s=/^[a-zA-Z_\.\$\:][0-9a-zA-Z_\.\$\:]*$/
      case @command_type
      when "C_ARTITHMETIC"
        if !(@current_code.length == 1)
          puts "ERROR: '#{@current_code[0]}' in command:#{@pc} is invalid! expected to be given artithmetic code"
          exit
        end
      when "C_PUSH"
        if !(@segment_types.include?(@current_code[1]) && @current_code[2] =~ num && @current_code.length == 3)
          puts "ERROR: '#{@current_code_s}' in command:#{@pc} is invalid! expected to be given push code"
          exit
        end
      when "C_POP"
        if !(@segment_types.include?(@current_code[1]) && @current_code[2] =~ num && @current_code.length == 3)
          puts "ERROR: '#{@current_code_s}' in command:#{@pc} is invalid!  expected to be given pop code"
          exit
        end
      when "C_LABEL"
        if !((@current_code[1] =~ num || @current_code[1] =~ s) && @current_code.length == 2)
          puts "ERROR: '#{@current_code_s}' in command:#{@pc} is invalid! expected to be given label code"
        end
      when "C_GOTO"
        if !((@current_code[1] =~ num || @current_code[1] =~ s) && @current_code.length == 2)
          puts "ERROR: '#{@current_code_s}' in command:#{@pc} is invalid! expected to be given goto code"
          exit
        end
      when "C_IF"
        if !((@current_code[1] =~ num || @current_code[1] =~ s) && @current_code.length == 2)
          puts "ERROR: '#{@current_code_s}' in command:#{@pc} is invalid! expected to be given if code"
          exit
        end
      when "C_FUNCTION"
        if !(@current_code[1] =~ s && @current_code[2] =~ num && @current_code.length == 3)
          puts "ERROR: '#{@current_code_s}' in command:#{@pc} is invalid! expected to be given function code"
          exit
        end
      when "C_CALL"
        if !(@current_code[1] =~ s && @current_code[2] =~ num && @current_code.length == 3)
          puts "ERROR: '#{@current_code_s}' in command:#{@pc} is invalid! expected to be given call code"
          exit
        end
      end
    end
    def read_next
      @pc += 1
      i_code =  @file.gets
      if !(i_code.nil?)
        i_code = i_code.chomp
        slash=(/\/\//).match(i_code)
        i_code = slash ? slash.pre_match : i_code
        if i_code == ""
          i_code = read_next()
        end
        return i_code
      end
    end
end

class CodeWriter

  def initialize()
    @pc=0
    @function_counter = 0
  end

  def setup
    s = ""
    s += "@256\n"
    s += "D=A\n"
    s += "@0\n"
    s += "M=D\n"
    s += "\n"
    s += "\n"
    s += self.writeCall("Sys.init",0)
    puts s
    return s
  end

  def setFileName(f_name)
    @current_file = f_name
  end

  def writeArithmetic(command)
    s = ""
    case command
    when "add"
      s += "@SP\n"
      s += "M=M-1\n"
      s += "A=M\n"
      s += "D=M\n"
      s += "A=A-1\n"
      s += "M=M+D\n"
    when "sub"
      s += "@SP\n"
      s += "M=M-1\n"
      s += "A=M\n"
      s += "D=M\n"
      s += "A=A-1\n"
      s += "M=M-D\n"
    when "neg"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=-M\n"
    when "eq"
      s += "@SP\n"
      s += "M=M-1\n"
      s += "A=M\n"
      s += "D=M\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "D=D-M\n"
      s += "@IFZ#{@pc}\n"
      s += "D;JEQ\n"
      s += "@ELS#{@pc}\n"
      s += "0;JMP\n"
      s += "(IFZ#{@pc})\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=-1\n"
      s += "@ENDO#{@pc}\n"
      s += "0;JMP\n"
      s += "(ELS#{@pc})\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=0\n"
      s += "@ENDO#{@pc}\n"
      s += "0;JMP\n"
      s += "(ENDO#{@pc})\n"
    when "gt"
      s += "@SP\n"
      s += "M=M-1\n"
      s += "A=M\n"
      s += "D=M\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "D=M-D\n"
      s += "@IFZ#{@pc}\n"
      s += "D;JGT\n"
      s += "@ELS#{@pc}\n"
      s += "0;JMP\n"
      s += "(IFZ#{@pc})\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=-1\n"
      s += "@ENDO#{@pc}\n"
      s += "0;JMP\n"
      s += "(ELS#{@pc})\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=0\n"
      s += "@ENDO#{@pc}\n"
      s += "0;JMP\n"
      s += "(ENDO#{@pc})\n"
    when "lt"
      s += "@SP\n"
      s += "M=M-1\n"
      s += "A=M\n"
      s += "D=M\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "D=D-M\n"
      s += "@IFZ#{@pc}\n"
      s += "D;JGT\n"
      s += "@ELS#{@pc}\n"
      s += "0;JMP\n"
      s += "(IFZ#{@pc})\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=-1\n"
      s += "@ENDO#{@pc}\n"
      s += "0;JMP\n"
      s += "(ELS#{@pc})\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=0\n"
      s += "@ENDO#{@pc}\n"
      s += "0;JMP\n"
      s += "(ENDO#{@pc})\n"
    when "and"
      s += "@SP\n"
      s += "M=M-1\n"
      s += "A=M\n"
      s += "D=M\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=M&D\n"
    when "or"
      s += "@SP\n"
      s += "M=M-1\n"
      s += "A=M\n"
      s += "D=M\n"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=M|D\n"
    when "not"
      s += "@SP\n"
      s += "A=M-1\n"
      s += "M=!M\n"
    end
    s+="A=A\n"
    s+="A=A\n"
    s+="A=A\n"
    #s+="//#{@pc}\n"
    @pc+=1
    puts s
    return s
  end


  def writePushPop(command, segment, index)
    @segments = {"local" => "LCL", "argument" => "ARG", "this" => "THIS", "that" => "THAT", "temp" => "5", "pointer" => "3", "static" => "16"}
    s = ""
    if command == "C_PUSH"
      if segment == "constant"
        s += "@#{index}\n"
        s += "D=A\n"
        s += "@SP\n"
        s += "A=M\n"
        s += "M=D\n"
        s += "@SP\n"
        s += "M=M+1\n"
      elsif segment == "static"
        s += "@#{@current_file}.#{index}\n"
        s += "D=M\n"
        s += "@SP\n"
        s += "A=M\n"
        s += "M=D\n"
        s += "@SP\n"
        s += "M=M+1\n"
      else
        if segment == "temp" || segment == "pointer"
          s += "@#{@segments[segment]}\n"
          s += "D=A\n"
        else
          s += "@#{@segments[segment]}\n"
          s += "D=M\n"
        end
        s += "@#{index}\n"
        s += "A=D+A\n"
        s += "D=M\n"
        s += "@SP\n"
        s += "A=M\n"
        s += "M=D\n"
        s += "@SP\n"
        s += "M=M+1\n"
      end
    elsif command == "C_POP"
      s += "@SP\n"
      s += "M=M-1\n"
      s += "A=M\n"
      s += "D=M\n"
      s += "@13\n"
      s += "M=D\n"
      if segment == "temp" || segment == "pointer"
        s += "@#{index}\n"
        s += "D=A\n"
        s +="@#{@segments[segment]}\n"
        s += "D=A+D\n"
      elsif segment == "static"
        s += "@#{@current_file}.#{index}\n"
        s += "D=A\n"
      else
        s += "@#{index}\n"
        s += "D=A\n"
        s +="@#{@segments[segment]}\n"
        s += "D=M+D\n"
      end
      s += "@14\n"
      s += "M=D\n"
      s += "@13\n"
      s += "D=M\n"
      s += "@14\n"
      s += "A=M\n"
      s += "M=D\n"
    end
    s+="A=A\n"
    s+="A=A\n"
    s+="A=A\n"
    #s+="//#{@pc}\n"
    @pc+=1
    puts s
    return s
  end

  def writeLabel(label)
    s = "(#{label})\n"
    s+="A=A\n"
    s+="A=A\n"
    s+="A=A\n"
    #s+="//#{@pc}\n"
    @pc+=1
    puts s
    return s
  end

  def writeGoto(label)
    s = ""
    s += "@#{label}\n"
    s += "0;JMP\n"
    s+="A=A\n"
    s+="A=A\n"
    s+="A=A\n"
    #s+="//#{@pc}\n"
    @pc+=1
    puts s
    return s
  end

  def writeIf(label)
    s = ""
    s += "@SP\n"
    s += "M=M-1\n"
    s += "A=M\n"
    s += "D=M\n"
    s += "@#{label}\n"
    s += "D;JNE\n"
    s+="A=A\n"
    s+="A=A\n"
    s+="A=A\n"
    #s+="//#{@pc}\n"
    @pc+=1
    puts s
    return s
  end

  def writeCall(functionName, numArgs)
    @function_counter += 1
    s = ""
    s += "@#{functionName}$#{@function_counter}\n"
    s += "D=A\n"
    s += "@0\n"
    s += "M=M+1\n"
    s += "A=M-1\n"
    s += "M=D\n"
    s += "@1\n"
    s += "D=M\n"
    s += "@SP\n"
    s += "M=M+1\n"
    s += "A=M-1\n"
    s += "M=D\n"
    s += "@2\n"
    s += "D=M\n"
    s += "@SP\n"
    s += "M=M+1\n"
    s += "A=M-1\n"
    s += "M=D\n"
    s += self.writePushPop("C_PUSH", "pointer", "0")
    s += self.writePushPop("C_PUSH", "pointer", "1")
    s += "@5\n"
    s += "D=A\n"
    s += "@#{numArgs}\n"
    s += "D=D+A\n"
    s += "@0\n"
    s += "D=M-D\n"
    s += "@2\n"
    s += "M=D\n"
    s += "@0\n"
    s += "D=M\n"
    s += "@1\n"
    s += "M=D\n"
    s += "@#{functionName}\n"
    s += "0;JMP\n"
    s += "(#{functionName}$#{@function_counter})\n"
    s +="A=A\n"
    s +="A=A\n"
    s +="A=A\n"
    #s+="//#{@pc}\n"
    @pc+=1
    puts s
    return s
  end

  def writeFunction(functionName, numLocals)
    s = ""
    s += "(#{functionName})\n"
    numLocals.to_i.times do
      s += self.writePushPop("C_PUSH", "constant", "0")
    end
    s+="A=A\n"
    s+="A=A\n"
    s+="A=A\n"
    #s+="//#{@pc}\n"
    @pc+=1
    puts s
    return s
  end

  def writeReturn
    s = ""
    s += "@1\n"
    s += "D=M\n"
    s += "@13\n"
    s += "M=D\n"
    s += "@5\n"
    s += "D=D-A\n"
    s += "@14\n"
    s += "M=D\n"
    s += "@0\n"
    s += "M=M-1\n"
    s += "A=M\n"
    s += "D=M\n"
    s += "@2\n"
    s += "A=M\n"
    s += "M=D\n"
    s += "@2\n"
    s += "D=M\n"
    s += "@0\n"
    s += "M=D+1\n"
    s += "@13\n"
    s += "D=M\n"
    s += "D=D-1\n"
    s += "A=D\n"
    s += "D=M\n"
    s += "@4\n"
    s += "M=D\n"
    s += "@2\n"
    s += "D=A\n"
    s += "@13\n"
    s += "D=M-D\n"
    s += "A=D\n"
    s += "D=M\n"
    s += "@3\n"
    s += "M=D\n"
    s += "D=A\n"
    s += "@13\n"
    s += "D=M-D\n"
    s += "A=D\n"
    s += "D=M\n"
    s += "@2\n"
    s += "M=D\n"
    s += "@4\n"
    s += "D=A\n"
    s += "@13\n"
    s += "D=M-D\n"
    s += "A=D\n"
    s += "D=M\n"
    s += "@1\n"
    s += "M=D\n"
    s += "@14\n"
    s += "A=M\n"
    s += "A=M\n"
    s += "0;JMP\n"
    s+="A=A\n"
    s+="A=A\n"
    s+="A=A\n"
    #s+="//#{@pc}\n"
    @pc+=1
    puts s
    return s
  end

end
/main/
require 'find'
current_function = ""
path = ARGV[0] ? ARGV[0] : '.'
wfile = File.open("#{ARGV[0]}.asm","w")
code_writer = CodeWriter.new
wfile.puts (code_writer.setup)
Find.find(path) do |item|
  base = File.basename(item)
  if base.split("")[-3..-1].join == ".vm"
    code_writer.setFileName(base)
    rfile = VMParser.new(item)
    while rfile.hasMoreCommands
      rfile.advance
      type = rfile.commandType
      case type
      when "C_ARTITHMETIC"
        wfile.puts code_writer.writeArithmetic(rfile.current_code[0])
      when "C_POP"
        wfile.puts code_writer.writePushPop("C_POP", rfile.current_code[1], rfile.current_code[2])
      when "C_PUSH"
        wfile.puts code_writer.writePushPop("C_PUSH", rfile.current_code[1], rfile.current_code[2])
      when "C_LABEL"
        wfile.puts code_writer.writeLabel("#{current_function}$#{rfile.current_code[1]}")
      when "C_GOTO"
        wfile.puts code_writer.writeGoto("#{current_function}$#{rfile.current_code[1]}")
      when "C_IF"
        wfile.puts code_writer.writeIf("#{current_function}$#{rfile.current_code[1]}")
      when "C_CALL"
        wfile.puts code_writer.writeCall(rfile.current_code[1], rfile.current_code[2])
      when "C_FUNCTION"
        wfile.puts code_writer.writeFunction(rfile.current_code[1], rfile.current_code[2])
        current_function = rfile.current_code[1]
      when "C_RETURN"
        wfile.puts code_writer.writeReturn
      end
    end
  end
end


puts "Translating is Done! We made '.asm' File on same Directory."
