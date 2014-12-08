### Methods

### Given

Given /^there (is|are) (\d+|a) datapaths? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @datapaths = FactoryGirl.create_list(:test_datapath, n)
  }.to change(Datapath, :count).by(n)
  @datapath = @datapaths.last
end

### When

### Then
