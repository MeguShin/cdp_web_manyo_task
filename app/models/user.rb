class User < ApplicationRecord
    # TaskモデルとUserモデルを関連付ける
    has_many :tasks, dependent: :destroy
    has_many :labels, dependent: :destroy
    validates :name, presence: true, length: { maximum: 30 }
    validates :email, presence: true, length: { maximum: 255 }, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    before_validation { email.downcase! }
    has_secure_password
    validates :password, length: { minimum: 6 }
    # admin フィールドに対するバリデーションを緩和する。つまり、adminのチェックボックスにチェックを入れなくてもエラーが表示されない。チェックを入れないとfalseになる。
    validates_inclusion_of :admin, in: [true, false]
end
