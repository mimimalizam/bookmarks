class InitialSchema < ActiveRecord::Migration[5.1]
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :full_name
      t.string :email
      t.string :password

      t.timestamps
    end

    create_table :bookmarks do |t|
      t.string :user_id
      t.string :uri
      t.string :uri_hash

      t.string :short_description
      t.text :long_description
      t.boolean :public

      t.timestamps
    end

    # This join table reflects the fact that bookmarks are subordinate
    # resources to users
    create_table :user_bookmarks do |t|
      t.integer :user_id
      t.integer :bookmark_id

      t.timestamps
    end

    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    # Define the relationship between tags and the things tagged
    # In this case -> bookmarks
    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :taggable_id
      t.string :taggable_type

      t.timestamps
    end

    # Four indexes that capture the ways we plan to search
    # the database
    add_index :users, :name
    add_index :bookmarks, :uri_hash
    add_index :tags, :name
    add_index :taggings, [:tag_id, :taggable_id, :taggable_type]

    def self.down
      [:users, :bookmarks, :tags, :user_bookmarks, :taggings].each do |t|
        drop_table t
      end
    end
  end
end
