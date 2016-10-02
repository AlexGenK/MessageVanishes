class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |c|
      c.text :body
      c.text :link
      c.text :method
      c.integer :count

      c.timestamps
    end
  end
end
