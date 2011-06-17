class Media < ActiveRecord::Base

  YOUTUBE_MAX_WIDTH = 480

  belongs_to :song
  belongs_to :media_type

  validates_presence_of :code
  validates_presence_of :media_type_id
  validates_presence_of :song_id

  def save()

    self.code = nil

    if (self.url && self.url =~ /http:\/\/www\.youtube\.com\/watch\?v\=(.+)/)
      video_id = $1
      self.code = '<object width="480" height="385"> ' +
                  ' <param name="movie" value="http://www.youtube.com/v/' + video_id + '&hl=en_US&fs=1&rel=0"></param><param name="allowFullScreen" value="true"></param> ' +
                  ' <param name="allowscriptaccess" value="always"></param> ' +
                  ' <embed src="http://www.youtube.com/v/' + video_id + '&hl=en_US&fs=1&rel=0" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="480" height="385"></embed> ' +
                  '</object>'
      if (self.code && self.code =~ /.+width=\"(\d{3})\".+/)
        width = $1.to_i()
        if (width > YOUTUBE_MAX_WIDTH)
          self.code = self.code.gsub(/width=\"\d{3}\"/, 'width="' + YOUTUBE_MAX_WIDTH.to_s() + '"')
        end
      end
    end

    super()
    
  end

end
