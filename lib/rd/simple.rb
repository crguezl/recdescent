require "rdparser"

parser = RDParser.new do
   token(/\s+/)
   token(/./)   {|m| m }

   start :a do
     match(:a, 'b') {|a, b| puts "a -> a b"; true }
     match('b')     {|b|    puts "a -> b";   true }
   end
end

expr = ARGV.shift || "b b"
puts parser.parse(expr)


