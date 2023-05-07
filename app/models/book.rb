class Book < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy


  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  validates :tag,presence:true
  
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(word, search)
    if search == "perfect"
      Book.where(title: word)
    elsif search == "forward"
      Book.where("title LIKE ?", word+'%')
    elsif search == "backward"
      Book.where("title LIKE ?", '%'+word)
    else
      Book.where("title LIKE ?",'%'+word+'%')
    end
  end
  
  def self.search(search_word)
    Book.where(['tag LIKE ?', "#{search_word}"])
  end
end