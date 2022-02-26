class JackTokenizer
  attr_accessor :current_token

  def initialize(file_name)
    @rfile = File.open(file_name)
    @keywords = ["class", "constructor", "function", "method", "field", "static", "var", "int", "char", "boolean", "void", "true", "false", "null", "this", "let", "do", "if", "else", "while", "return"]
    @symbols = ["{", "}", "(", ")", "[", "]", ".", ",", ";", "+", "-", "*", "/", "&", "|", "<", ">", "=", "~"]
    @integer_constant = /[0-9]+/
    @string_constant = /^(?!.*\\n).*[^"]$/
    @identifier = /\w+/
    @current_command = []
    @tc = 0
  end

  def hasMoreTokens
    if @tc > 0
      @current_token = @current_command.shift
      @tc -= 1
      return true
    else
      read_next()
      if @next_code
        separate()
        @current_token = @current_command.shift
        return true
      else
        return false
      end
    end
  end

  def tokenType
    if @keywords.include?(@current_token)
      return "KEYWORD"
    elsif @symbols.include?(@current_token)
      return "SYMBOL"
    elsif @current_token =~ @integer_constant
      return "INT_CONST"
    elsif @current_token =~ @string_constant
      return "STRING_CONSTANT"
    elsif @current_token =~ @identifier
      return "IDENTIFIER"
    end
  end

  private

    def read_next
      @next_code = @rfile.gets
      if !(@next_code.nil?)
        @next_code = @next_code.strip
        slash=(/[(\/\/)|(\/\*)|(\/\*\*)]/).match(@next_code)
        @next_code = slash ? slash.pre_match : @next_code
        if @next_code == ""
          read_next()
        end
      end
    end

    def separate
      puts @next_code
      s = @next_code
      @current_command =[""]
      i = 0
      while i < s.length
        if s[i] == '"'
          @current_command.push "" if @current_command[-1] != ""
          @current_command[-1] += s[i]
          i+=1
          while s[i] != '"'
            @current_command[-1] += s[i]
            i += 1
          end
          @current_command[-1] += s[i]
          @current_command.push ""
        elsif @symbols.include?(s[i])
          @current_command.push "" if @current_command[-1] != ""
          @current_command[-1] = s[i]
          @current_command.push ""
        elsif s[i] == " "
          @current_command.push "" if @current_command[-1] != ""
        else
          @current_command[-1] += s[i]
        end
        i+=1
      end
      @tc = @current_command.length
      @next_code = nil
      @current_command.delete_at(-1) if @current_command[-1] == ""
      puts "#{@current_command}"
    end
end

tokens = JackTokenizer.new(ARGV[0])
while tokens.hasMoreTokens
  #puts "#{tokens.current_token} #{tokens.tokenType}"
end
