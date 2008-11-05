require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))
require SPEC_ROOT + 'lib/resource_shared_spec'

# TODO: test loaded and unloaded behavior

describe DataMapper::Associations::ManyToOne::Proxy do

  # define the model prior to with_adapters
  before do
    Object.send(:remove_const, :User) if defined?(User)
    class User
      include DataMapper::Resource

      property :name, String, :key => true
      property :age,  Integer

      has n, :comments
    end

    Object.send(:remove_const, :Comment) if defined?(Comment)
    class Comment
      include DataMapper::Resource

      property :id,      Serial
      property :body, Text

      belongs_to :user
    end
  end

  supported_by :all do
    before do
      @comment     = Comment.create(:body => "Cool spec",
                                    :user => User.create(:name => 'dbussink', :age => 25))

      @user        = @comment.user
      @model       = User
      @child_model = Comment
    end

    after do
      @comment.destroy
      @user.destroy
    end

    it_should_behave_like 'A Resource'
  end
end
