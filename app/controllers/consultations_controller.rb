class ConsultationsController < InheritedResources::Base

  private

    def consultation_params
      params.require(:consultation).permit(:title, :description, :start_time, :end_time)
    end

end
