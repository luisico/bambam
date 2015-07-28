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
      if fancytree_parent(title)[:class].include? 'fancytree-selected'
        raise "Error. You have attempt to select a node that is already selected"
      else
        toggle_selected(title)
      end
    end

    def deselect_node(title)
      if fancytree_parent(title)[:class].include? 'fancytree-selected'
        toggle_selected(title)
      else
        raise "Error. You have attempt to deselect a node that is not selected"
      end
    end

    def toggle_selected(title)
      fancytree_parent(title).find('span.fancytree-checkbox').click
      loop until page.evaluate_script('jQuery.active').zero?
    end

    def expand_node(title)
      if fancytree_parent(title)[:class].include? 'fancytree-expanded'
        raise "Error. You have attempt to expand a node that is already expanded"
      else
        toggle_expanded(title)
      end
    end

    def contract_node(title)
      if fancytree_parent(title)[:class].include? 'fancytree-expanded'
        toggle_expanded(title)
      else
        raise "Error. You have attempt to contract a node that is not expanded"
      end
    end

    def toggle_expanded(title)
      fancytree_parent(title).find('span.fancytree-expander').click
      loop until page.evaluate_script('jQuery.active').zero?
    end
  end
end
