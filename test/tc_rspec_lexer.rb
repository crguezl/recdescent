require "rd/tokenizer"

describe RD::Lexer, "pipe lines" do

  before(:each) do
  end
                 
  it "blabla" do
      expected = [ 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, ]

      10.times do |i|
         4.should == 4
      end
  end

  it "'pairs | mult3| mult5' produce multiples of 30" do
    expected = [ 0, 30, 60, 90, 120, 150, 180, 210, 240, 270, ]
       5.should == 5
  end

end
