module Fancytree
  module TestHelpers
    def fancytree_node(title)
      # TODO make sure these take advantage of capybara inherent waiting
      page.find('span.fancytree-title', text: title, :match => :prefer_exact)
    end

    def fancytree_parent(node_title)
      fancytree_node(node_title).find(:xpath, '../../..')
    end

    def select_node(title)
      @title = title
      fancytree_parent(title).find('span.fancytree-checkbox').click
    end

    def expand_node(title)
      fancytree_parent(title).find('span.fancytree-expander').click
    end
  end
end
