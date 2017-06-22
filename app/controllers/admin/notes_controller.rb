module Admin
  class NotesController < AdminController
    def index
      render locals: {
        notes: Note.all
      }
    end

    def new
      note = Note.new
      note.build_main_medium

      render locals: {
        note: note
      }
    end

    def create
      n_params = note_params
      n_params.delete(:main_medium_attributes) if n_params[:main_medium_attributes][:file].nil?
      n_params.delete(:main_medium_attributes) if n_params[:main_medium_id]

      note = Note.new(n_params)
      note.draft = false

      if note.save
        redirect_to admin_note_path(note)
      else
        render :new, locals: {
          note: note
        }
      end
    end

    def show
      note = Note.note.find(params[:id])

      render locals: {
        note: note
      }
    end

    def edit
      note = Note.note.find(params[:id])

      render locals: {
        note: note
      }
    end

    def update
      n_params = note_params
      if n_params[:main_medium_id] ||
         (n_params[:main_medium_attributes] && n_params[:main_medium_attributes][:file].nil?)
          art_params.delete('main_medium_attributes')
      end

      note = Note.note.find(params[:id])

      if note.update(art_params)
        redirect_to admin_note_path(note)
      else
        render :edit, locals: {
          note: note
        }
      end
    end

    def destroy
      note = Note.note.find(params[:id])
      note.deleted = true
      note.save

      redirect_to admin_notes_path
    end

    def undestroy
      note = Note.note.find(params[:id])
      note.deleted = false
      note.save

      redirect_to admin_note_path(note)
    end

    private

    def note_params
      params.require(:note).permit(:body, :main_medium_id, main_medium_attributes: [:file])
    end
  end
end
