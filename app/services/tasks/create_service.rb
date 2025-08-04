module Tasks
  class CreateService
    def initialize(user, taskable, params)
      @user = user
      @taskable = taskable
      @params = params
    end

    def call
      task = @taskable.tasks.new(@params)
      task.user = @user

      if task.save
        track_activity(task) if @taskable.is_a?(Company)
      end

      task
    end

    private

    def track_activity(task)
      task.create_activity(
        key: 'task.created',
        owner: @user,
        recipient: @taskable,
        parameters: {
          title: task.title,
          due_date: task.due_date,
          status: task.status
        }
      )
    end
  end
end
