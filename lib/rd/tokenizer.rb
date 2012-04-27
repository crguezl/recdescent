module RD
  class Lexer
     attr_accessor :patterns, :tokens

     def initialize(&block)
       @patterns = []
       @tokens = []
       instance_eval(&block)
     end

     def lex(string)
       @tokens = []
       until string.empty?
         there_is_a_match = @patterns.any? do |tok|
           match = tok.pattern.match(string)
           if match
             name = tok.name
             name = match[0] unless name
             name = name.to_s
             if tok.block
               @tokens << [ name, tok.block.call(match.to_s) ] 
             end
             string = match.post_match
             true
           else
             false
           end
         end
         raise "unable to lex '#{string}" unless  there_is_a_match
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
       @patterns << Pattern.new(name, 
                                   Regexp.new('\\A(?:' + pattern.source + ')', pattern.options), 
                                   block)
     end

     def white(pattern, block = nil)
       @patterns << Pattern.new(nil, 
                                   Regexp.new('\\A(?:' + pattern.source + ')', pattern.options), 
                                   block)
     end

  end
end

if __FILE__ == $0 then

  lexer = RD::Lexer.new do
     white  /\s+/
     token ({/\d+/              => :NUM}) {|m| m.to_i }
     token ({/[a-zA-Z_]\w*/     => :ID}) 
     token ({/<=|>=|==|!=|[<>]/ => :COMP}) 
     token /./ 
  end

  expr = ARGV.shift || "a = 2+3*(4+2)"
  puts expr
  lexer.lex(expr)
  puts lexer.tokens.inspect

  expr = "a = 2 <= 3"
  puts expr
  lexer.lex(expr)
  puts lexer.tokens.inspect
end
