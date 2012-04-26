class Lexer
   attr_accessor :lex_tokens, :tokens

   def initialize(&block)
     @lex_tokens = []
     @tokens = []
     instance_eval(&block)
   end

   def lex(string)
     until string.empty?
       there_is_a_match = @lex_tokens.any? do |tok|
         match = tok.pattern.match(string)
         if match
           @tokens << tok.block.call(match.to_s) if tok.block
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

   LexToken = Struct.new(:pattern, :block)

    def token(pattern, &block)
      @lex_tokens << LexToken.new(Regexp.new('\\A(?:' + pattern.source + ')', pattern.options), block)
    end

end

if __FILE__ == $0 then

  lexer = Lexer.new do
     token(/\s+/)
     token(/\d+/) {|m| m.to_i }
     token(/./)   {|m| m }
  end

  expr = ARGV.shift || "2+3*(4+2)"
  puts expr
  lexer.lex(expr)
  puts lexer.tokens.join(",")

end
