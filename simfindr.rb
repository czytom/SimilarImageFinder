require 'rubygems'
require 'fileutils'
require 'ftools'
require 'exifr'

require 'digest/sha1'

digests = Hash.new

if ARGV.size != 2 
  puts "You should set two parameters: cmd image_path_src image_dest"
  exit 1
end

to_sort_dir = ARGV[0]
work_dir = ARGV[1]

Dir.glob("#{to_sort_dir}/**/*") do |file|
  if file.match(/(JPEG|jpg|JPG|jpeg)/) then
    puts file
    time = EXIFR::JPEG.new(file).date_time_original
    puts time.strftime("%Y-%m-%d_%H:%M:%S") unless time.nil?
    digest = Digest::SHA1.file(file).hexdigest if File.file?(file)
    digests[digest] ||= Array.new
    digests[digest] << file
  end
end


digests.each_pair do |key,v|
  v.each_with_index do |old_name, index|
    time = nil 
    puts
    puts old_name
    begin
      time = EXIFR::JPEG.new(old_name).date_time_original
    rescue Exception => e
      p e
      p key
      p v
    end
      if time.nil? then
        time_str = '0000'
      else
        time_str = time.strftime("%Y-%m-%d_%H:%M:%S") 
      end
      p time_str
      p key
      p index
      new_name = work_dir + '/' + time_str + '_'  + key + '_' + index.to_s + '.jpg'
p new_name
p old_name
      if File.exists?(new_name)
        puts "BLAD"
      end
      FileUtils.cp(old_name, new_name)
  end
end

