class Deal < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller&.current_user }

  # 🔁 Real-time broadcast when stage changes (optional)
  after_update_commit -> { broadcast_replace_to "deals" }, if: -> { saved_change_to_stage_id? }

  belongs_to :user     # Sales Manager
  belongs_to :company
  belongs_to :contact
  belongs_to :stage

  has_many :tasks, as: :taskable, dependent: :destroy

  validates :title, :value, :stage, :close_date, presence: true

  # ✅ Automatically track time when stage is changed
  before_update :update_entered_stage_at, if: :will_save_change_to_stage_id?
  before_create :set_initial_entered_stage_at

  private

  def update_entered_stage_at
    self.entered_stage_at = Time.current
  end

  def set_initial_entered_stage_at
    self.entered_stage_at ||= Time.current
  end
end
