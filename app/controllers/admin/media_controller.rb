module Admin
  class MediaController < AdminController
    def index
      media = Medium.all

      render locals: {
        media: media
      }
    end

    def new
      medium = Medium.new

      render locals: {
        medium: medium
      }
    end

    def create
      medium = Medium.new(media_params)

      if medium.save
        redirect_to [:admin, :media]
      else
        render :new, locals: {
          medium: medium
        }
      end
    end

    def destroy
      medium = Medium.find(params[:id])
      medium.destroy

      redirect_to [:admin, :media]
    end

    private

    def media_params
      params.require(:medium).permit(:file, :default_alt)
    end
  end
end
