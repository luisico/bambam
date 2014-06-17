module GroupsHelper
  def member_check_box(group, user)
    html = ''
    if user == group.owner
      html << hidden_field_tag("group[member_ids][]", user.id)
      html << check_box_tag("group[member_ids][]", user.id, true, disabled: true, id: dom_id(user))
    else
      html << check_box_tag("group[member_ids][]", user.id, group.member_ids.include?(user.id), id: dom_id(user))
    end

    html << label_tag(dom_id(user)) do
      image_tag(avatar_url(user)) + ' ' + user.email + (user == group.owner ? ' (owner)' : '')
    end

    html.html_safe
  end
end
