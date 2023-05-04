class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    if params.dig(:search).present?
      @tasks = Task.search_tasks(search_title_param, status_param).page(params[:page]).per(10)
      @search_params = { search_title: search_title_param, status: status_param }
    else
      case params[:sort]
      when 'deadline_on_asc'
        @tasks = Task.all.order(deadline_on: :asc, created_at: :desc).page(params[:page]).per(10)
      when 'priority_desc'
        @tasks = Task.all.order(priority: :desc, created_at: :desc).page(params[:page]).per(10)
      else
        @tasks = Task.all.order(created_at: :desc).page(params[:page]).per(10)
      end
      @search_params = nil
      @status_params = params.dig(:status)
      @tasks = @tasks.filter_by_status(@status_params) if @status_params.present?
    end
  end

  def new
      @task = Task.new
  end

  def create
      @task = Task.new(task_params)
      if @task.save
        flash[:notice] = t('common.created')
        redirect_to tasks_url
      else
        render :new
      end
  end

  def show
  end
  
  def edit
  end

  def update
      if @task.update(task_params)
        flash[:notice] = t('common.updated')
        redirect_to @task
      else
        render :edit
      end
  end
  
  def destroy
      @task.destroy
      flash[:notice] = t('common.destroyed')
      redirect_to tasks_url
  end

  def search
    @tasks = Task.search_tasks(search_title_param, status_param).page(params[:page]).per(10)
    @search_params = { search_title: search_title_param, status: status_param }
    render 'index'
  end

  private
      def set_task
          @task = Task.find(params[:id])
      end
      def task_params
          params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
      end
      def search_title_param
        params.dig(:search, :search_title)&.strip
      end
      
      def status_param
        params.dig(:search, :status)
      end
end
