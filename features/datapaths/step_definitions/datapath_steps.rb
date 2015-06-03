### Methods

### Given

Given /^there (is|are) (\d+|a) datapaths? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @datapaths = FactoryGirl.create_list(:datapath, n)
  }.to change(Datapath, :count).by(n)
  @datapath = @datapaths.last
end

Given /^that datapath has (\d+|a) managers?$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  @datapath_managers = FactoryGirl.create_list(:manager, n, datapaths: [@datapath])
end

### When

### Then
