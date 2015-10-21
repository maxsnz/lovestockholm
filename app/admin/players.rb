ActiveAdmin.register Player do
  config.sort_order = "name_asc"
  config.filters = true
  actions :all, except: [ :new, :create, :edit ]
  menu label: "Участники"




  controller do
    include PermitConcern, NoShowConcern
  end
end
