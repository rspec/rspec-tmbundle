# This spec file is for manually checking the syntax highlighting. It is not meant to be executed.
describe SyntaxHighlighting do
  
  it 'works for a simple example (single quoted)' do
    # ...
  end
  
  it "works for a simple example (double quoted)" do
    # ...
  end
  
  context 'in a context (single quoted)' do
    context "that is nested (double quoted)" do
      it "still works correctly" do
        # ...
      end
    end
  end
  
  # See https://github.com/rspec/rspec-tmbundle/issues/45
  context 'with multiline
           descriptions (single quoted)' do
           
    context "or double 
             quoted" do
             
      it 'still works for 
          single quoted strings' do
        # ...
      end
  
      it "still works for 
          double quoted strings" do
        # ...
      end
    end
  end

  context "for pending examples" do
    # Make sure `keyword.other.rspec.pending` is really present – it may be visually indistinct from `keyword.other.rspec.example`.
    it "gives `it` the scope `keyword.other.rspec.pending` (double quotes)"
    it 'gives `it` the scope `keyword.other.rspec.pending` (single quotes)'
  end
  
  if foo 
    puts "Some Ruby code here, #{should} be highlightes correctly", :foo
  end
end