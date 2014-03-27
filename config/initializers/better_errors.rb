if defined? BetterErrors
  BetterErrors.editor = proc { |full_path, line| "emacs://#{full_path}/#{line}" }
end
