class CreateZombies < ActiveRecord::Migration
  def change
    create_table :zombies do |t|
      t.string :name
      t.string :message
      t.boolean :show
      t.string :secret

      t.timestamps
    end
  end
end
