# frozen_string_literal: true

module Db
  class ProgramsController < Db::ApplicationController
    before_action :authenticate_user!
    before_action :load_work, only: %i(index new create)
    before_action :load_program, only: %i(edit update hide destroy activities)

    def index
      @programs = @work.programs.eager_load(:channel, :episode, program_detail: :channel)
      @programs = @programs.where(channel_id: params[:channel_id]) if params[:channel_id]
      @programs = @programs.order(started_at: :desc).order(:channel_id)
    end

    def new
      @form = DB::ProgramRowsForm.new
      @form.work = @work
      @form.set_default_rows_by_program_detail!(params[:program_detail_id]) if params[:program_detail_id]
      authorize @form, :new?
    end

    def create
      @form = DB::ProgramRowsForm.new(program_rows_form)
      @form.user = current_user
      @form.work = @work
      authorize @form, :create?

      return render(:new) unless @form.valid?

      ActiveRecord::Base.transaction do
        @form.save!
        @form.reset_number!
      end

      redirect_to db_work_programs_path(@work), notice: t("resources.program.created")
    end

    def edit
      authorize @program, :edit?
      @work = @program.work
    end

    def update
      authorize @program, :update?
      @work = @program.work

      @program.attributes = program_params
      @program.user = current_user

      return render(:edit) unless @program.valid?
      @program.save_and_create_activity!

      redirect_to db_work_programs_path(@work), notice: t("resources.program.updated")
    end

    def hide
      authorize @program, :hide?

      @program.hide!

      flash[:notice] = t("resources.program.unpublished")
      redirect_back fallback_location: db_works_path
    end

    def destroy
      authorize @program, :destroy?

      @program.destroy

      flash[:notice] = t("resources.program.deleted")
      redirect_back fallback_location: db_works_path
    end

    def activities
      @activities = @program.db_activities.order(id: :desc)
      @comment = @program.db_comments.new
    end

    private

    def load_program
      @program = Program.find(params[:id])
    end

    def program_params
      params.require(:program).permit(
        :program_detail_id, :channel_id, :episode_id, :started_at, :number, :rebroadcast,
        :irregular, :time_zone
      )
    end

    def program_rows_form
      params.require(:db_program_rows_form).permit(:rows)
    end
  end
end
