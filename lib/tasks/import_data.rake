require 'csv'

namespace :import do
  desc "Import data from CSV"

  task movies: :environment do
    puts "Enter CSV file path:"
    file_path = gets.chomp

    begin
      parsed_csv = CSV.parse(File.read(file_path), headers: true)

      parsed_csv.each do |row|
        actor = Actor.find_or_create_by!(name: row["Actor"])
        location = Location.find_or_create_by!(city: row["Filming location"], country: row["Country"])

        movie = Movie.where(name: row["Movie"]).first_or_initialize
        movie.assign_attributes(
          description: row["Description"],
          year: row["Year"]&.to_i,
          director: row["Director"]
        )
        movie.save!


        movie.actors << actor unless movie.actors.include?(actor)
        movie.locations << location unless movie.locations.include?(location)


        if movie.save
          puts "Successfully imported movie: #{movie.name}"
        else
          puts "Failed to import movie: #{movie.name} - #{movie.errors.full_messages.join(', ')}"
        end
      end

    rescue Errno::ENOENT
      puts "Error: File not found at #{file_path}"
    rescue CSV::MalformedCSVError
      puts "Error: Invalid CSV format"
    rescue ActiveRecord::RecordInvalid => e
      puts "Error creating record: #{e.message}"
    end
  end

  task reviews: :environment do
    puts "Enter CSV file path:"
    file_path = gets.chomp

    begin
      parsed_csv = CSV.parse(File.read(file_path), headers: true)

      parsed_csv.each do |row|
        movie = Movie.find_by(name: row["Movie"])
        if movie
          user = User.find_or_create_by!(name: row["User"])
          review = movie.reviews.create!(
            rating: row["Stars"],
            content: row["Review"],
            user: user
          )
          puts "Successfully imported review for movie: #{movie.name}"
        else
          puts "Skipping review: Movie '#{row["Movie"]}' not found in the database."
        end


        if review.save
          puts "Successfully imported review for movie: #{movie.name}"
        else
          puts "Failed to import review: #{review.errors.full_messages.join(', ')}"
        end
      end

    rescue Errno::ENOENT
      puts "Error: File not found at #{file_path}"
    rescue CSV::MalformedCSVError
      puts "Error: Invalid CSV format"
    rescue ActiveRecord::RecordInvalid => e
      puts "Error creating record: #{e.message}"
    end
  end
end