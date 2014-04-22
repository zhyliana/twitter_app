class CreateTwitterSessions < ActiveRecord::Migration
  def change
    create_table :twitter_sessions do |t|

      t.timestamps
    end
  end
end
