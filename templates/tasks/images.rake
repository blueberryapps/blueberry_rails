namespace :images do
  task :optimize do
    puts "Start of images optimizing"

    files = Dir.glob("#{Rails.root}/app/assets/images/**/*")
    files.each do |file|
      ImageOptimizer.new(file).optimize
    end

    puts "Images optimizing done"
  end
end
