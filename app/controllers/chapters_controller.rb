class ChaptersController < ApplicationController
  def index
    @chapters = current_user.chapters.order('created_at').all.reverse_order.page(params[:page]).per(5)
    @mangas = current_user.mangas.order('created_at').all.reverse_order.page(params[:page]).per(5)
  end

  def show
    @chapter = Chapter.find(params[:id])
    send_file(@chapter.filename)
  end
end
