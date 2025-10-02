require_relative '../lib/author'
#Labelling the test cases with pos, neg, or edge for my benefit.
RSpec.describe Author do
  describe '#initialize' do
    it 'creates author with valid name and email' do     # pos test 
      author = Author.new('Alice', 'alice@example.com')
      expect(author.name).to eq('Alice')
      expect(author.email).to eq('alice@example.com')
    end

    it 'raises ArgumentError when name is empty' do     # neg test, lowkey this is an edge case. 
      expect { Author.new('', 'test@example.com') }.to raise_error(ArgumentError, /Name cannot be empty/)
    end

    it 'raises ArgumentError when email is empty' do     # neg test, technically an edge case
      expect { Author.new('Alice', '') }.to raise_error(ArgumentError, /Email cannot be empty/)
    end

    it 'raises ArgumentError when email does not have @' do    # neg test, This is technically an edge case too
      expect { Author.new('Alice', 'invalid.email.com') }.to raise_error(ArgumentError, /Invalid email format/)
    end

  end
end
