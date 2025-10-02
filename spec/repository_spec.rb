require_relative '../lib/repository'
require_relative '../lib/commit'
require_relative '../lib/author'

RSpec.describe Repository do    # me no like creating new instance in every test case. rspec is very convenient .>.
  let(:author) { Author.new('Bob', 'bob@example.com') }
  let(:repo) { Repository.new }

  describe '#initialize' do    # pos test 
    it 'initializes with main branch and empty commits' do    # pos test 
      expect(repo.branches).to eq({ "main" => nil })
      expect(repo.current_branch).to eq('main')
    end
  end

  describe '#create_branch' do    
    it 'creates a new branch and copies the current branch head' do     # pos test 
      repo.create_branch('feature')
      expect(repo.branches.key?('feature')).to be true
      expect(repo.branches['feature']).to eq(repo.branches[repo.current_branch])
    end

    it 'raises some error for empty branch name' do    # neg test
      expect { repo.create_branch('') }.to raise_error(ArgumentError, /Branch name cannot be empty/)
    end
  end

  describe '#branch' do
    it 'returns head commit id for existing branch' do   # Edge case
      head_commit_id = repo.branches['main']
      expect(repo.branch('main')).to eq(head_commit_id)
    end

    it 'raises BranchNotFound for missing branch' do   # neg test 
      expect { repo.branch('missing') }.to raise_error(NameError) 
    end
  end

  describe '#switch' do
    it 'switches current branch to existing branch' do    # pos test 
      repo.create_branch('test')
      repo.switch('test')
      expect(repo.current_branch).to eq('test')
    end

    it 'raises BranchNotFound for missing branch' do    # neg test, but also an edge case 
      expect { repo.switch('fake') }.to raise_error(NameError) 
    end
  end

  describe '#commit!' do    
    it 'An initial commit should be successfully made on main branch when no commits exist' do     # pos test
      commit = repo.commit!(message: 'Initial commit', author: author)
      expect(commit).to be_a(Commit)
      expect(repo.branches['main']).to eq(commit.id)
      expect(repo.log('main')).to include(commit)
      expect(commit.parent).to be_nil
    end

    it 'a new commit should be linked to a parent commit' do   # pos test 
      first_commit = repo.commit!(message: 'root', author: author)
      repo.create_branch('feature')
      repo.switch('feature')
      commit2 = repo.commit!(message: 'feature work', author: author)
      expect(commit2.parent.id).to eq(first_commit.id)
      expect(repo.current_branch).to eq('feature')
    end
  end

  describe '#log' do
    it 'returns commits from newest at the top to oldest at the bottom' do # pos test 
      commit1 = repo.commit!(message: 'first', author: author)
      commit2 = repo.commit!(message: 'second', author: author)
      log_commits = repo.log
      expect(log_commits).to eq([commit2, commit1])
    end

    it 'returns empty array if branch has no commits' do     # edge case
      expect(repo.log('main')).to eq([])
    end
  end
end
