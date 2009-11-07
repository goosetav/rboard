def setup_user_base
  # The anonymous user
  User.make_with_group(:anonymous, "Anonymous")
  registered_user_group = Group.make(:registered_users)

  # Set up the permissions
  # Also sets up admin user
  Permission.make(:registered_users)
  Permission.make(:anonymous)

  # Create the user
  User.make_with_group(:registered_user, "Registered Users")
  administrator = User.make_with_group(:administrator, "Administrators")

  registered_user_group.owner = administrator
  registered_user_group.save

  Permission.make(:administrator)
end

def valid_topic_for(forum)
  topic = forum.topics.make_unsaved
  post = topic.posts.build(Post.plan)
  post.user = User.ensure(:administrator)

  topic.tap(&:save!)
end