### Methods

def create_manager
  @manager ||= FactoryGirl.create(:manager, @visitor)
end

### Given

Given /^there (is|are) (\d+) other managers in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  expect {
    @managers = FactoryGirl.create_list(:manager, n)
  }.to change(User, :count).by(n)
  @manager = @managers.last
end

### When

### Then
