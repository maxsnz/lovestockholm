ActiveAdmin.register Question do
  config.sort_order = "id_asc"
  config.filters = false

  index do
    {question: false, options: false, brand: false}.each do |name, sortable|
      column(name, sortable: sortable) do |model|
        QuestionDecorator.new(model).send(name)
      end
    end
  end

  form partial: "form"

  controller do
    include PermitConcern, NoShowConcern
  end
end
