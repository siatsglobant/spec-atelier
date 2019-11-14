module Api
  class ProjectsController < ApplicationController
    before_action :valid_session
    before_action :project, only: %i[show edit delete]
    before_action :projects, only: %i[index search]

    def index
      render json: { projects: private_project_presenter.decorate_list(projects.order(created_at: :desc)) }, status: :ok
    end

    def show
      render json: { project: private_project_presenter.decorate(project) }, status: :ok
    end

    def create
      Project.create(project_params.merge(user: current_user))
      render json: '', status: :created
    end

    def update
      project.update(project_params)
      render json: '', status: :ok
    end

    def search
      projects_list = projects.search(params[:search_keywords])
      render json: { projects: private_project_presenter.decorate_list(projects_list) }, status: :created
    end

    def destroy
      project.update(soft_deleted: true)
      render json: '', status: :deleted
    end

    def ordered
      projects_list = case params[:ordered_by]
        when 'created_at_asc' then projects.order(created_at: :asc)
        when 'created_at_desc' then projects.order(created_at: :desc)
        when 'updated_at_asc' then projects.order(updated_at: :asc)
        when 'updated_at_desc' then projects.order(updated_at: :desc)
        when 'name_asc' then projects.order(name: :asc)
      end
      render json: { projects: private_project_presenter.decorate_list(projects_list) }, status: :created
    end

    private

    def project
      @project ||= Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :project_type, :work_type, :country, :city, :delivery_date, :visibility)
    end

    def projects
      @projects ||= current_user.projects
    end

    def private_project_presenter
      Projects::PrivateProjectPresenter
    end
  end
end
