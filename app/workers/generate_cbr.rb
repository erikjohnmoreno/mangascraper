require 'zip'
class GenerateCbr
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(url, user_id, manga_id)
    user = User.find(user_id)
    @doc = Nokogiri::HTML(open(url))
    @images = []
    @total_images = @doc.css('.l')[0].children.last.text.gsub(/[^\d]/, '')
    (1..Integer(@total_images)).each do |page_num|
      @current_url = Nokogiri::HTML(open(url.gsub(/[\d].html$/, '') + String(page_num) + ".html"))
      @images << @current_url.css('#image').attr('src').value
      puts @current_url.css('#image').attr('src').value
    end
    filename = "#{Rails.root}/app/assets/cbr/#{user.email}/" +@doc.css('.no').text + '.cbr'
    dir = File.dirname(filename)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
      @images.each_with_index do |image, index|
        image_file = IO.copy_stream(open(image), "app/assets/images/temp_dir/" + String(index + 1) + '-image.png')
        zipfile.add(image_file, 'app/assets/images/temp_dir/' + String(index + 1) + '-image.png')
        zipfile.rename(image_file, String(index + 1) + '-image.png')
        puts String(index + 1) + '-image.png'
      end
    end
    user.chapters.create(:filename => filename, :manga_id => manga_id)
  end
end
