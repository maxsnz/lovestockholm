ActiveAdmin.register Question do
  config.sort_order = "id_asc"
  config.filters = false
  permit_params :title, :kind, :picture, :option1, :option2, :option3, :option4, :picture1, :picture2, :picture3, :picture4, :correct, :remove_picture

  index do

    selectable_column
    column :title
    {picture: false}.each do |name, sortable|
      column(name, sortable: sortable) do |model|
        QuestionDecorator.new(model).send(name)
      end
    end

    column :kind
    actions
    

  end

  form partial: "form"

  # controller do
  #   include PermitConcern, NoShowConcern
  # end


  show do
    render partial: 'show'
  end
end
