ActiveAdmin.register Question do
  config.sort_order = "id_asc"
  config.filters = false
  permit_params :title, :kind, :picture, :option_1, :option_2, :option_3, :option_4, :pictute_1, :pictute_2, :pictute_3, :pictute_4, :correct 

  index do

    selectable_column
    column :title
    column :kind
    actions
    

  end

  form partial: "form"

  # controller do
  #   include PermitConcern, NoShowConcern
  # end
end
