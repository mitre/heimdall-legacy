class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      #t.integer  :sign_in_count, default: 0, null: false
      #t.datetime :current_sign_in_at
      #t.datetime :last_sign_in_at
      #t.inet     :current_sign_in_ip
      #t.inet     :last_sign_in_ip

      t.timestamps null:false
    end

    # add omniauth to users
    add_column :users, :provider, :string
    add_column :users, :uid, :string

    # add name to users
    add_column :users, :name, :string

    # add trackable
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string



    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end

  def self.up
    # add confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime

    add_index :users, :confirmation_token, unique: true
    # add unconfirmed email to user
    add_column :users, :unconfirmed_email, :string
    #User.update_all confirmed_at: DateTime.now
  end

  def self.down
    remove_index :users, :confirmation_token

    remove_column :users, :unconfirmed_email
    remove_column :users, :confirmation_sent_at
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_token

  end

end
