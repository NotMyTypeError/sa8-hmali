require_relative '../lib/commit'
require_relative '../lib/author'

RSpec.describe Commit do
  let(:author) { Author.new('Alice', 'alice@example.com') }

  describe '#initialize' do
    it 'creates commit with valid parameters' do     # pos test 
      commit = Commit.new(message: 'Initial commit', author: author, parent: nil)
      expect(commit.message).to eq('Initial commit')
      expect(commit.author).to eq(author)
      expect(commit.parent).to be_nil
      expect(commit.id).to be_a(String)
      expect(commit.id.size).to eq(12)
    end

    it 'raises ArgumentError for empty message' do    # neg test
      expect { Commit.new(message: '', author: author, parent: nil) }.to raise_error(ArgumentError, /Message cannot be empty/)
    end

    it 'raises ArgumentError for nil author' do    # neg test 
      expect { Commit.new(message: 'Commit message', author: nil, parent: nil) }.to raise_error(ArgumentError, /Author required/)
    end

    it 'auto assigns timestamp if not provided' do    # EDGE CAAAAAAASE
      commit = Commit.new(message: 'Another commit', author: author, parent: nil)
      expect(commit.timestamp).to be_within(1).of(Time.now)
    end

    it 'generates unique id for different commits' do    # pos test 
      commit1 = Commit.new(message: 'msg1', author: author, parent: nil, timestamp: Time.now - 60)
      commit2 = Commit.new(message: 'msg2', author: author, parent: nil, timestamp: Time.now)
      expect(commit1.id).not_to eq(commit2.id)
    end
  end
end
