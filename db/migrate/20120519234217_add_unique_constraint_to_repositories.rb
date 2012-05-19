class AddUniqueConstraintToRepositories < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE repositories ADD CONSTRAINT repositories_must_be_uniqueue UNIQUE (name, owner_name)'
  end

  def down
    execute 'ALTER TABLE repositories DROP CONSTRAINT repositories_must_be_uniqueue'
  end
end
