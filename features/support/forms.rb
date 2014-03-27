def form_field_error(field, error)
  input = find_field(field).path
  expect(find(:xpath, "#{input}/ancestor::div[1]")).to have_content error
end
