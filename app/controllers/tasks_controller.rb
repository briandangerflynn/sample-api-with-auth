class TasksController < ApplicationController
  before_action :set_task, only: [ :update, :destroy ]
  before_action :authorized, only: [ :index, :create, :update, :destroy ]

  def index
    @tasks = Task.where(user: current_user)

    render json: @tasks
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    @task.update(task_params)

    if @task.save
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    head :no_content
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :complete)
  end
end
