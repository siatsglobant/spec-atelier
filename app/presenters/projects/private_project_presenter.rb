module Projects
  class PrivateProjectPresenter < Presenter
    will_print :id, :name, :project_type, :work_type, :country, :city, :delivery_date, :status, :created_at, :updated_at
  end
end
