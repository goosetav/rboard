class Forum < ActiveRecord::Base
  acts_as_list :scope => :parent_id
  acts_as_tree
  has_many :topics, :order => "created_at DESC", :dependent => :destroy
  has_many :posts, :through => :topics, :source => :posts
  validates_presence_of :title, :description
  belongs_to :visible_to, :class_name => "UserLevel", :foreign_key => "is_visible_to"
  belongs_to :creator_of_topics, :class_name => "UserLevel", :foreign_key => "topics_created_by"
  belongs_to :last_post, :class_name => "Post", :foreign_key => "last_post_id"
  belongs_to :last_post_forum, :class_name => "Forum", :foreign_key => "last_post_forum_id"
    
  def to_s
    title
  end
  
  #we do this because we want to order the topics by the last posts created_at date.
  #There's no easy way to do it
  alias_method :old_topics, :topics
  def topics
    old_topics.sort_by { |t| t.posts.last.created_at }.reverse
  end
  
  def descendants
    children.map { |f| !f.children.empty? ? f.children + [f]: f }.flatten
  end
  
  def self.find_all_without_parent
    find_all_by_parent_id(nil)
  end
  
  def root
    parent_id.nil? ? self : self.parent
  end
  
  def ancestors(list=[])
    if parent.nil?
      list << parent
    else
      list << parent
      parent.ancestors(list)
    end
    list.compact
  end
  
  def sub?
    !parent_id.nil?
  end
  
end
