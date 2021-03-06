class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :password, length: {minimum: 6, allow_nil: true}
  attr_reader :password

  validates :email, presence: true, length: {maximum: 255}

  has_many :permissions, dependent: :destroy
  has_many :blogs, through: :permissions
  has_many :posts, foreign_key: :author_id
  has_many :comments, foreign_key: :author_id
  has_many :follows
  has_many :followed_blogs, through: :follows, source: :blog
  has_many :authorizations, dependent: :destroy

  def first_name
    self.name.split.first || self.email.split("@").first
  end

  def email_md5
    return @email_md5 if @email_md5

    email_md5_obj = Digest::MD5.new
    email_md5_obj.update self.email
    @email_md5 = email_md5_obj.hexdigest
    @email_md5
  end

  def is_following?(blog)
    self.followed_blogs.include?(blog)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return nil unless user && user.valid_password?(password)
    user
  end
end
