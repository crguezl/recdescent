require "rd/tokenizer"
require "test/unit"

class TestPipelineElement < Test::Unit::TestCase

  def setup
    @lexer = RD::Lexer.new do
       white  /\s+/
       token /\d+/              => :NUM do
         |m| m.to_i 
       end
       token /[a-zA-Z_]\w*/     => :ID 
       token /<=|>=|==|!=|[<>]/ => :COMP 
       token %r{[-+*/=()]} 
    end
  end
               
  def test_exp
    expected = "[['ID', a], ['=', =], ['NUM', 2], ['+', +], ['NUM', 3], ['*', *], ['(', (], ['NUM', 4], ['+', +], ['NUM', 2], [')', )]]"
    expr = "a = 2+3*(4+2)"

    @lexer.lex(expr)
    res = @lexer.tokens.to_s

    assert_equal(expected, res)
  end


end

