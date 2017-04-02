def fileWatcher(base_directory,files_list,mode='moderate')
  files_to_remove=Array.new
  if File.directory?(base_directory)
    files_in_directory=Dir.entries(base_directory).select { |f| !File.directory? f }
    files_to_remove = files_in_directory-files_list if mode == 'strict'
    while !files_to_remove.empty?
      file_path=base_directory+'/'+files_to_remove.pop
      File.delete(file_path)
    end
  end
end
