require 'date'

class SongConfirmer

	###
	#
	###
	def initialize()
	end
	
	
	###
	#
	###
	def init_process()
		# Retrieve diferent unconfirmed session dates.
		dates = retrieve_unconfirmed_session_dates()
		
		# print and choose a date.
		date_item = 0
		until (date_item.to_i() > 0 && date_item.to_i() <= dates.length) do
			(0...dates.length).each do |i|
				puts "#{i+1} .- #{dates[i]}"
			end
			print('Choose the session\'s date to confirm : ')
			date_item = gets().chomp()		
		end
		
		# do process for selected date.
		do_process(dates[date_item.to_i()-1])
		
		 
	end
	
	private
	
		###
		#
		###
		def retrieve_unconfirmed_session_dates()
			sql_string = 'select distinct date(session_datetime) as session_date from session_songs where revised = 0 order by session_date desc limit 10'
			unconfirmed_sessions = SessionSong.find_by_sql(sql_string)
			dates = Array.new()
			unconfirmed_sessions.each do |session|
			  dates << session.attributes['session_date']
			end
			
			return dates
		end
		
		###
		#
		###
		def do_process(date)
			
			if (!date)
				return
			end 
			
			start_datetime 	= DateTime.new(date[0,4].to_i(), date[5, 2].to_i(), date[8,2].to_i(), 0, 0, 0) 
			end_datetime  	= DateTime.new(date[0,4].to_i(), date[5, 2].to_i(), date[8,2].to_i(), 23, 59, 59)
			
			# Getting list in order to include songs into it.
			list = get_list(start_datetime)						 
									 			
			
			songs = SessionSong.find(:all, 
									 :conditions => ['session_datetime between ? and ? and revised = ?', start_datetime, end_datetime, false],
									 :order => 'session_datetime')
									 
			# Processing songs.
			songs.each do |song|
				if (process_song(song, list))
					mark_song_as_processed(song)
				end
			end
		
		end


		###
		#
		###
		def mark_song_as_processed(song)
		
			if (!song)
				return false
			end
			
			song.revised = true
			song.save() 
			return true
		
		end

		###
		#
		###
		def get_list(date)
		
			list = List.find_by_day(date)
			if (!list)
				puts "Creating list using date #{date}"
				list = List.create(:day => date)
			end
			
			return list
		
		end
		
		###
		#
		###
		def process_song(song, list_id)

		  puts
		  puts 'NEW SONG :'
		  puts "Processing song titled '#{song.title}' performed by #{song.performers} and composed by #{song.authors}"

		  print "Do you want to process this song? "
		  process = gets().chomp()
		  if (process !~ /[Yy]/)
		  	print "Do you want to mark this song as revised? "
		  	revise = gets().chomp()
		  	return (revise =~ /[Yy]/)  
		  end
		  
		  # Searching performer(s)
		  performer_id = get_band_id(song.performers)
		  		  
		  # Searching author(s)
		  if (song.performers == song.authors)
			author_id = performer_id
		  else
			author_id = get_band_id(song.authors)
		  end
		  
		  # Searching song into system.
		  song_id = get_song_id(song.title, performer_id, author_id)
		  if (!song_id.blank?)
		  	add_song_into_list(song_id, song.session_datetime, list_id)
		  	puts 'Song added to list.'
		  end
		  
		  return true
		  
		end

		###
		#
		###
		def get_song_id(name, performer_id, author_id)
		
		  print "The song name is #{name.strip()}, if you want to use a different name, write it, otherwise press Enter. "
		  db_name = gets()
		  if (!db_name.blank?)  
			name = db_name.chomp()
		  end
		
		
		  name_to_search = '%' + clean_song_name(name) + '%'
		  @songs = Song.find(:all, 
		  					 :conditions => ["ucase(name) like ucase(?) AND performers.band_id = ? AND authors.band_id = ?", name_to_search.gsub(/%+/, '%').gsub(/\?+/, '?'), performer_id, author_id],
		  					 :joins => [:performers, :authors])
		  
		  case @songs.length()
			when 0
			  print "Song '#{name}' not found, do you want to create this song in db? "
			  create_song = gets()
			  if (create_song =~ /[Yy]/)
			  	song = create_song(name, performer_id, author_id)
			  end
			when 1
			  puts "The song found is '#{@songs[0].name}'."
			  right_song = ''
			  while (right_song !~ /[SsYyNn]/) do 
				  print 'Is this the song you are searching? '
				  right_song = gets().chomp()
				  if (right_song =~ /[SsYy]/)
					song = @songs[0]
				  else
				  	print('Do you want to create it?')
				  	if (gets() =~ /[SsYy]/)
				  		song = create_song(name, performer_id, author_id)
				  	end
				  end
				end
			else
			  puts 'Songs found : '
			  i=1
			  @songs.each do |song| 
				puts i.to_s() + '.-'+ song.name
				i += 1
			  end
		  
			  print 'Which is the right song (write its number) ? '
			  right_song = gets()
			  song = @songs[right_song.chomp().to_i()-1]
		  end		
		  
		  return song.id  

		end
		
		###
		#
		###
		def create_song(name, performer_id, author_id)
			return Song.create(:name => name.strip(), :performers_list_ids => [performer_id], :authors_list_ids => [author_id])
		end

		###
		#
		###
		def get_band_id(name)
		
		  print "The band name is #{name.strip()}, if you want to use a different name, write it, otherwise press Enter "
		  db_name = gets()
		  if (!db_name || db_name.strip().length == 0)  
				db_name = name
		  end

		  name_to_search = '%' + clean_band_name(db_name) + '%'
		  @bands = Band.find(:all, :conditions => ["name like ?", name_to_search.gsub(/%+/, '%').gsub(/\?+/, '?')])
		  
		  case @bands.length()
			when 0
			  print 'Do you want to create this band in db? '
			  create_band = gets()
			  if (create_band =~ /[Yy]/)
			  	band = create_band(db_name)
			  end
			when 1
			  puts "The band found is '#{@bands[0].name}'."
			  right_band = ''
			  while (right_band !~ /[SsYyNn]/) do 
				  print 'Is this the band you are searching? '
				  right_band = gets()
				  if (right_band =~ /[SsYy]/)
					return @bands[0].id
				  else
				  	print('Do you want to create it?')
				  	if (gets() =~ /[SsYy]/)
				  		band = create_band(db_name).id
				  	end
				  end
				end
			else
			  puts 'Bands found : '
			  i=1
			  @bands.each do |band| 
				puts i.to_s() + '.-'+ band.name
				i += 1
			  end
		  
			  print 'Which is the right band (write its number) ? '
			  right_band = gets()
			  band = @bands[right_band.chomp().to_i()-1]
		  end		
		  
		  return band.id
		    
		end
		
		###
		#
		###
		def create_band(name)
			print "The new band name is #{name.strip()}, if you want to use a different name, write it, otherwise press Enter "
			db_name = gets()
			if (!db_name || db_name.strip().length == 0)  
				db_name = name
			end
			
			return Band.create(:name => db_name.strip())
		end	
		
		###
		#
		###
		def add_song_into_list(song_id, session_datetime, list)
			# Creating ListSong
			list_song = ListSong.create(:list_id => list.id, :song_id => song_id, 
										:session_datetime => session_datetime)
			#Adding it.
			list.list_songs << list_song 
		end	
		
		###
		#
		###
		def clean_band_name(name)
		  return clean_name(name)
		end

		###
		#
		###
		def clean_song_name(name)
		  return clean_name(name)
		end

		###
		#
		###
		def clean_name(name)
		  #puts "---->#{name}"
		  cleaned_name = String.new(name.chomp().strip())
		  cleaned_name = cleaned_name.gsub(/The /i, '%')
		  cleaned_name = cleaned_name.gsub(/Los /i, '%')
		  cleaned_name = cleaned_name.gsub(/La /i, '%')
      cleaned_name = cleaned_name.gsub(/ and /i, '%')
		  cleaned_name = cleaned_name.gsub(/ & /i, '?')
      cleaned_name = cleaned_name.gsub(/of /i, '%')
		  cleaned_name = cleaned_name.gsub(/^A /i, '? ')
		  cleaned_name = cleaned_name.gsub(/ A /i, ' ? ')
		  cleaned_name = cleaned_name.gsub(/ Y /i, ' ? ')
		  cleaned_name = cleaned_name.gsub(/^Y  /i, '? ')
		  #puts "---->#{cleaned_name}"
		  
		  return cleaned_name
		  
		end
		                        
end

c = SongConfirmer.new() 
c.init_process()
