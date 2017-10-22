include Rails.application.routes.url_helpers
describe User do
  let(:user) do
    User.new name: 'abc', fullname: 'abc xyz', email: 'abcxyz@gmail.com', password: '12345678', password_confirmation: '12345678',
             email_on_submission: 1, email_on_review: 1, email_on_review_of_review: 0, copy_of_emails: 1, handle: 'handle'
  end
  let(:user1) { User.new name: 'abc', fullname: 'abc bbc', email: 'abcbbc@gmail.com', password: '123456789', password_confirmation: '123456789' }
  let(:user2) { User.new name: 'abc', fullname: 'abc bbc', email: 'abcbbe@gmail.com', password: '123456789', password_confirmation: '123456789' }

  describe '#name' do
    it 'returns the name of the user' do
      expect(user.name).to eq('abc')
    end
    it 'Validate presence of name which cannot be blank' do
      expect(user).to be_valid
      user.name = '  '
      expect(user).not_to be_valid
    end
    it 'Validate that name is always unique' do
      expect(user1).to validate_uniqueness_of(:name)
    end
  end

  describe '#fullname' do
    it 'returns the full name of the user' do
      expect(user.fullname).to eq('abc xyz')
    end
  end

  describe '#email' do
    it 'returns the email of the user' do
      expect(user.email).to eq('abcxyz@gmail.com')
    end

    it 'Validate presence of email which cannot be blank' do
      user.email = '  '
      expect(user).not_to be_valid
    end

    it 'Validate the email format' do
      user.email = 'a@x'
      expect(user).not_to be_valid
    end

    it 'Validate the email format' do
      user.email = 'ax.com'
      expect(user).not_to be_valid
    end

    it 'Validate the email format' do
      user.email = 'axc'
      expect(user).not_to be_valid
    end

    it 'Validate the email format' do
      user.email = '123'
      expect(user).not_to be_valid
    end

    it 'Validate the email format correctness' do
      user.email = 'a@x.com'
      expect(user).to be_valid
    end
  end

  describe '#salt_first?' do
    it 'will always return true'
  end

  # xzhang72
  describe '#get_available_users' do
    before(:each) do
      role = Role.new
    end
    it 'returns the first 10 visible users' do
      lesser_roles = double
      allow(@role).to receive(:get_parents).and_return(['Teaching Assistant','Instructor','Administrator'])
      allow(User).to receive(:all).and_return([
          {:name => 'abca'},{:name => 'abcb'},{:name => 'abcc'},{:name => 'abcd'},{:name => 'abce'},
          {:name => 'abcf'},{:name => 'abcg'},{:name => 'abch'},{:name => 'abci'},{:name => 'abcj'},
          {:name => 'abck'},{:name => 'abcl'},{:name => 'abcm'},{:name => 'abcn'},{:name => 'abco'},
          {:name => 'abcp'},{:name => 'abcq'},{:name => 'abcr'},{:name => 'abcs'},{:name => 'abct'}
        ])
      allow(user).to receive(:role)
      allow(lesser_roles).to receive(:include?)
      expect(user.get_available_users("abc")).to eq ([
        {:name => 'abca'},{:name => 'abcb'},{:name => 'abcc'},{:name => 'abcd'},{:name => 'abce'},
        {:name => 'abcf'},{:name => 'abcg'},{:name => 'abch'},{:name => 'abci'},{:name => 'abcj'}
        ])
    end
  end

  describe '#can_impersonate?' do
    it 'can impersonate target user if current user is super admin'

    it 'can impersonate target user if current user is the TA of target user'

    it 'can impersonate target user if current user is the recursively parent of target user'

    it 'cannot impersonate target user if current user does not satisfy all requirements'
  end

  # xzhang72
  describe '#is_recursively_parent_of' do
    context 'when the parent of target user (user) is nil' do
      it 'returns false' do
        allow(user).to receive(:parent).and_return(nil)
        expect(user1.is_recursively_parent_of(user)).to eq false
      end
    end

    context 'when the parent of target user (user) is current user (user1)' do
      it 'returns true' do
        allow(user).to receive(:parent).and_return(user1)
        expect(user1.is_recursively_parent_of(user)).to eq true
      end
    end

    context 'when the parent of target user (user) is not current user (user1), but super admin (user2)' do
      it 'returns false' do
        allow(user).to receive(:parent).and_return(user2)
        allow(user2).to receive_message_chain("role.super_admin?") { true }
        expect(user1.is_recursively_parent_of(user)).to eq false
      end
    end
  end

  describe '#get_user_list' do
    context 'when current user is super admin' do
      it 'fetches all users' do
        allow(user).to receive_message_chain("role.super_admin?") { true }
        allow(user).to receive_message_chain("role.instructor?") { false }
        allow(user).to receive_message_chain("role.ta?") { false }
        allow(user).to receive_message_chain("role.super_admin?") { false }
        allow(User).to receive_message_chain("all.find_each").and_return(user1)
        user_list = double
        allow(user_list).to receive(uniq).and_return(user1)
        expect(user.get_user_list()).to eq ([user1])
      end
    end

    context 'when current user is an instructor' do
      it 'fetches all users in his/her course/assignment'
    end

    context 'when current user is a TA' do
      it 'fetches all users in his/her courses'
    end
  end

  describe '#super_admin?' do
    it 'returns ture if role name is Super-Administrator'

    it 'returns false if role name is not Super-Administrator'
  end

  describe '#is_creator_of?' do
    it 'returns true of current user (user) is the creator of target user (user1)'

    it 'returns false of current user (user) is not the creator of target user (user1)'
  end
  # xzhang72
  describe '.import' do
    it 'raises error if import column does not equal to 3' do
      #row = double
      #allow(row).to receive(length).and_return(5)
      #expect { User.import(row, _row_header,session,_id) }.to raise_error
    end
    it 'updates an existing user with info from impor file'
  end
  # xzhang72
  describe '.yesorno' do
    it 'returns yes when input is true' do
      expect(User.yesorno(true)).to eq "yes"
    end
    it 'returns no when input is false' do
      expect(User.yesorno(false)).to eq "no"
    end
    it 'returns empty string when input is other content' do
      content = "TEXT"
      expect(User.yesorno(content)).to eq ""
    end
  end
  # xzhang72
  describe '.find_by_login' do
    context 'when user\'s email is stored in DB' do
      it 'finds user by email' do
        email = 'abcxyz@gmail.com'
        allow(User).to receive(:find_by_email).with(email).and_return(user)
        expect(User.find_by_login(email)).to eq user
      end
    end

    context 'when user\'s email is not stored in DB' do
      it 'finds user by email if the local part of email is the same as username' do
        allow(User).to receive(:find_by_email).and_return(nil)
        allow(User).to receive(:where).and_return([{name: 'abc', fullname: 'abc bbc'}])
        expect(User.find_by_login('abcxyz@gmail.com')).to eq ({:name=>"abc", :fullname=>"abc bbc"})
      end
    end
  end
  # xzhang72
  describe '#get_instructor' do
    it 'gets the instructor id'
  end

  describe '#instructor_id' do
    it 'returns id when role of current user is a super admin'

    it 'returns id when role of current user is an Administrator'

    it 'returns id when role of current user is an Instructor'

    it 'returns instructor_id when role of current user is a TA'

    it 'raise an error when role of current user is other type'
  end

  describe '.export' do
    it 'exports all information setting in options'

    it 'exports only personal_details'

    it 'exports only current role and parent'

    it 'exports only email_options'

    it 'exports only handle'
  end

  describe '.export_fields' do
    it 'exports all information setting in options'

    it 'exports only personal_details'

    it 'exports only current role and parent'

    it 'exports only email_options'

    it 'exports only handle'
  end
  # xzhang72
  describe '.from_params' do
    it 'returns user by user_id fetching from params' do
      params = {
        :user_id => 1,
      }
      allow(User).to receive(:find).and_return(user)
      expect(User.from_params(params)).to eq user
    end
    it 'returns user by user name fetching from params' do
      params = {
        :user => {
          :name => 'abc'
        }
      }
      allow(User).to receive(:find_by_name).and_return(user)
      expect(User.from_params(params)).to eq user
    end
    it 'raises an error when Expertiza cannot find user' do
      params = {
        :user => {
          :name => 'ncsu'
        }
      }
      #allow(User).to receive(:find_by_name).and_return(nil)
      allow(user).to receive(:nil?).and_return(true)
      expect {User.from_params(params)}.to raise_error("Please <a href='http://localhost:3000/users/new'>create an account</a> for this user to continue.")
    end
  end

  describe '#is_teaching_assistant_for?' do
    it 'returns false if current user is not a TA'

    it 'returns false if current user is a TA, but target user is not a student'

    it 'returns true if current user is a TA of target user'
  end

  describe '#is_teaching_assistant?' do
    it 'returns true if current user is a TA'

    it 'returns false if current user is not a TA'
  end
end
