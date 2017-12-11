class TasksController < ApplicationController
  #login要求をいれる？ここじゃないのか？
  before_action :require_user_logged_in, only: [:index, :show]
  
#CRUD操作ができる人を限定するコードを挿入
  before_action :correct_user,   only: [  :update, :destroy
  ]

  before_action :set_task, only: [:show, :edit, :update, :destroy]



  def index
    #all を
    @tasks = current_user.tasks.page(params[:page]).per(3)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end

# 本当にその操作をする人が、作成者かというid照合をする



  
  private
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end

  def set_task
    @task = Task.find(params[:id])
  end


  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
end
