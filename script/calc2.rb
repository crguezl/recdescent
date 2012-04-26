require "rdparser"

parser = RDParser.new do
   token(/\s+/)
   token(/\d+/) {|m| m.to_i }
   token(/./)   {|m| m }

   start :expr do
     match(:expr, '+', :term) {|a, _, b| a + b }
     match(:expr, '-', :term) {|a, _, b| a - b }
     match(:term)
   end

   rule :term do
     match(:term, '*', :atom) {|a, _, b| a * b }
     match(:term, '/', :atom) {|a, _, b| a / b }
     match(:atom)
   end

   rule :atom do
     match(Integer)
     match('(', :expr, ')') {|_, a, _| a }
   end
end

expr = ARGV.shift || "2+3*(4+2)"
puts parser.parse(expr)


