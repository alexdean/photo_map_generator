require 'erb'
require 'json'
require 'time'
require 'where_was_i'
require 'httparty-cookies'

class Gallery
  include HTTParty::Cookies
  follow_redirects false
end

gpx_file = './trip.GPX'
time_offset = (3600*5) # exif data has tz wrong. fix this.
hostname = 'https://www.deanspot.org'

locator = WhereWasI::Gpx.new(gpx_file: gpx_file, intersegment_behavior: :nearest)

# day1 is used in captions for dividing photos into trip days
start_time = locator.tracks[0].start_time
day1 = start_time - (start_time.hour*60*60) - (start_time.min*60) - start_time.sec

##
## Add some code here to fetch photo data into `album`.
##
## Mine pulls photos from my personal photo album.
##
## Check out https://github.com/remvee/exifr/ for extracting time information
##   from photos.
##

@photos = []

album['items'].each do |item|
  time = Time.parse(item['exif_data']['date_time_original']) + time_offset
  data = locator.at(time)
  if ! data
    $stderr.puts item['main']
    $stderr.puts time.iso8601
    next
  end

  day = ((time - day1) / 86400).ceil

  @photos << {
    lat: data[:lat],
    lng: data[:lon],
    url: "#{hostname}#{item['main']}",
    iconUrl: "#{hostname}#{item['thumbnail']}",
    caption: "Day #{day}, #{time.strftime('%l:%M %p')}. elevation: #{data[:elevation].round(1)}m"
  }
end

# 'helper' used by template
$next_idx = -1
def next_line_color
  colors = [
    '#7EB26D',
    '#1F78C1',
    '#CCA31D',
    '#3F6833', # dark green
    '#6D1F62' # purple
  ]
  $next_idx+=1
  if $next_idx == colors.size
    $next_idx = 0
  end
  colors[$next_idx]
end

@tracks = []
locator.tracks.each do |track|
  track_points = []
  track.points.each do |point|
    track_points << [point[:lat], point[:lon]]
  end
  @tracks << track_points
end

tpl = ERB.new(File.read('map.js.erb'), 0, '>')
puts tpl.result(binding)
