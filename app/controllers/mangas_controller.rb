class MangasController < ApplicationController
  def index
    @mangas = current_user.mangas.all.reverse_order.page(params[:page]).per(5)
  end

  def new
    @manga = Manga.new
  end

  def edit
    @manga = Manga.find(params[:id])
  end

  def show
    @manga = Manga.find(params[:id])
    @doc = Nokogiri::HTML(open(@manga.url))

    @elements = []

    @doc.css('#chapters').children.each do |element|

      if element.css('.volume')
        @elements << element.css('.volume').text
      end

      if element.css('.tips')
        element.css('.tips').each do |tip|
          @elements << [tip.text, tip['href']]
        end
      end
    end
  end

  def scrape_images
    # @doc = Nokogiri::HTML(open(params[:url]))
    # @images = []
    # @total_images = @doc.css('.l')[0].children.last.text.gsub(/[^\d]/, '')
    # (1..Integer(@total_images)).each do |page_num|
    #   @current_url = Nokogiri::HTML(open(params[:url].gsub(/[\d].html$/, '') + String(page_num) + ".html"))
    #   @images << @current_url.css('#image').attr('src').value
    #   puts @current_url.css('#image').attr('src').value
    # end
    # filename = @doc.css('.no').text + '.cbr'
    # Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
    #   @images.each_with_index do |image, index|
    #     image_file = IO.copy_stream(open(image), "app/assets/images/temp_dir/" + String(index + 1) + '-image.png')
    #     zipfile.add(image_file, 'app/assets/images/temp_dir/' + String(index + 1) + '-image.png')
    #     zipfile.rename(image_file, String(index + 1) + '-image.png')
    #     puts String(index + 1) + '-image.png'
    #   end
    # end
    # current_user.chapters.create(:filename => filename)

    GenerateCbr.perform_async(params[:url], current_user.id, params[:manga_id])
    redirect_to chapters_path
  end

  def create
    @manga = current_user.mangas.new(manga_params)
    if @manga.save
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    @manga = Manga.find(params[:id])
    if @manga.update(manga_params)
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def destroy
    @manga = Manga.find(params[:id])
    @manga.destroy
    redirect_to root_url
  end

  private
    def manga_params
      params.require(:manga).permit(:title, :url)
    end
end
