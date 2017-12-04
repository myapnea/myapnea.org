class AddCodePrefixToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :code_prefix, :string
  end
end
