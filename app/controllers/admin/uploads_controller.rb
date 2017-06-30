module Admin
  class UploadsController < AdminController
    def index
      uploads = Upload.all

      render locals: {
        uploads: uploads
      }
    end

    def new
      upload = Upload.new

      render locals: {
        upload: upload
      }
    end

    def create
      upload = Upload.new(uploads_params)

      if upload.save
        redirect_to %i[admin uploads]
      else
        render :new, locals: {
          upload: upload
        }
      end
    end

    def destroy
      upload = Upload.find(params[:id])
      upload.destroy

      redirect_to %i[admin uploads]
    end

    private

    def uploads_params
      params.require(:upload).permit(:file)
    end
  end
end
