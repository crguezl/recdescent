module RD
  class Token
    attr_accessor :token, :value

    def initialize(token, value=token)
      @token, @value = token, value
    end

    def to_s
      "(#@token, #@value)"
    end
  end

  class Lexer
     attr_accessor :patterns, :tokens

     def initialize(&block)
       @patterns = []
       @tokens = []
       instance_eval(&block)
     end

     def lex(string)
       @tokens = []
       pos = 0
       len = string.length - 1
       until pos > len
         there_is_a_match = @patterns.any? do |tok|
           match = tok.pattern.match(string, pos)
           if match
             name = tok.name
             name = match[0] unless name
             name = name.to_s
             if tok.block
               @tokens << Token.new(name, tok.block.call(match.to_s)) 
             end
             pos += match[0].length
             true
           else
             false
           end
         end
         raise SyntaxError, "unable to parse '#{string[pos,10]}''" unless  there_is_a_match
       end
     end

     private

     Pattern = Struct.new(:name, :pattern, :block)

     def token(pattern, &block)
       if pattern.is_a? Hash
         pattern, name = pattern.each.next
       else
         name = nil # no name
       end
       block = Proc.new { |m| m } if block.nil?
       @patterns << Pattern.new(name, Regexp.new('\\G(?:' + pattern.source + ')', pattern.options),
                                block)
     end

     def white(pattern, &block)
       @patterns << Pattern.new('white', Regexp.new('\\G(?:' + pattern.source + ')', pattern.options),
                                block)
     end

  end
end

if __FILE__ == $0 then

  lexer = RD::Lexer.new do
     white  /\s+/
     token /\d+/              => :NUM do
       |m| m.to_i 
     end
     token /[a-zA-Z_]\w*/     => :ID 
     token /<=|>=|==|!=|[<>]/ => :COMP 
     token %r{[-+*/=()]} 
  end

  expr = ARGV.shift || "a = 2+3*(4+2)"
  puts expr
  lexer.lex(expr)
  puts lexer.tokens.inspect

  expr = "a = 2 <= 3"
  puts expr
  lexer.lex(expr)
  puts lexer.tokens.inspect

  expr = "2 % 3"
  puts expr
  lexer.lex(expr)
  puts lexer.tokens.inspect
end
