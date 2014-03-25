class SelfReportsController < ApplicationController
  def create
    @self_report = SelfReport.new(self_report_params)
    @self_report.student = current_student
    @self_report.save
    redirect_to :back, notice: "Your report has been entered"
  end

  private
  def self_report_params
    params.require(:self_report).permit(:attended, :hours_coding, :hours_learning, :hours_slept, :date)
  end
end
