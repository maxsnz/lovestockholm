ActiveAdmin.register Result do
  config.sort_order = "seconds_asc"
  config.filters = false
  actions :all, except: [ :new, :create, :edit ]
  menu label: "Результаты"


  controller do

    def scoped_collection
      # Result.all.where(state: 'correct')
      # Result.winners
      Result.with_state(Result::PUBLISHED).includes :player
      # Result.all
    end
  end


  index do
    # column :n, sortable: true

    {player: 'players.name', email:false, seconds: :seconds, created_at: :created_at}.each do |name, sortable|
      column(name, sortable: sortable) do |model|
        ResultDecorator.new(model).send(name)
      end
    end
  end

  form partial: "form"

  controller do
    include PermitConcern, NoShowConcern
  end
end
