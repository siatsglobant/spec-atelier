module Api
  class ProjectsController < ApplicationController
    before_action :valid_session
    before_action :project, only: %i[show edit delete]
    before_action :projects, only: %i[index search]

    def index
      render json: Projects::PrivateProjectPresenter.decorate_list(projects.order(created_at: :desc)), status: :ok
    end

    def show
      render json: Projects::PrivateProjectPresenter.decorate(project), status: :ok
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
      render json: Projects::PrivateProjectPresenter.decorate_list(projects_list), status: :created
    end

    def destroy
      project.update(soft_deleted: true)
      render json: '', status: :deleted
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
  end
end
