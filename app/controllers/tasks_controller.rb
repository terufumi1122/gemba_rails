class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)

    respond_to do |format| # アクセスされたformatごとに処理を変更
      format.html # HTMLフォーマットとしてのアクセスだった場合は何もしない
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" } # CSVフォーマットとしてアクセスされたらcsvを作成する。 send_dataメソッドでレスポンスを送り出す。ブラウザからファイルとしてDLできるようにする。ファイル名はDLするたびに変わるように、現在時刻を使って生成する。
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def create
    @task = current_user.tasks.new(task_params)

    if params[:back].present? #確認画面の「戻る」に対応する
      render :new
      return # 「戻る」ボタンであれば、これ以降の処理は行わない
    end

    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      # TaskMailer.creation_email(@task).deliver_later(wait: 5.minutes) タスク作成から５分後にメール送信をする
      logger.debug "task: #{@task.attributes.inspect}"
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{task.name}」を更新しました。"
  end

  def destroy
    @task.destroy!
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end

  def task_logger
    @task_logger ||= Logger.new('log/task.log', 'daily')
  end

  def import
    current_user.tasks.import(params[:file]) # 関連越しにモデルに実装したimportメソッドを呼び出している -> アップロードされたファイルの内容を、ログインしているユーザーのタスク群として登録することができる
    redirect_to tasks_url, notice: "タスクを追加しました"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

end
