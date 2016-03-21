namespace :icons do
  task :compile do
    puts "Start of icons optimizing"

    files = Dir.glob("#{Rails.root}/app/assets/icons/*.svg")

    files.each do |file|
      SvgOptimizer.optimize_file(file)
    end

    puts "Svg optimizing done."
    puts "----------------------"
    puts 'Compiling icons...'
    puts `fontcustom compile`
    puts "----------------------"
    puts "Icons compilation done."

  end
end
