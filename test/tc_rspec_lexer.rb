require "rd/tokenizer"

describe RD::Lexer, "pipe lines" do

  before(:each) do
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
                 
  it "tokenizes 'a = 2+3*(4+2)'" do
    expected = "[['ID', a], ['=', =], ['NUM', 2], ['+', +], ['NUM', 3], ['*', *], ['(', (], ['NUM', 4], ['+', +], ['NUM', 2], [')', )]]"

    expr = "a = 2+3*(4+2)"
    @lexer.lex(expr)
    res = @lexer.tokens.to_s

    res.should == expected
  end

  it "tokenizes 'a = 2 <= 3'" do
    expected = "[['ID', a], ['=', =], ['NUM', 2], ['COMP', <=], ['NUM', 3]]"


    expr = "a = 2 <= 3"
    @lexer.lex(expr)
    res = @lexer.tokens.to_s

    res.should == expected
  end

  it "Produces exception for  '2 % 3'" do
    expected = "[['ID', a], ['=', =], ['NUM', 2], ['COMP', <=], ['NUM', 3]]"

    expr = "2 % 3"
    lambda { @lexer.lex(expr) }.should raise_error
  end

end
