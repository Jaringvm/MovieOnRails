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

        movie = Movie.find_or_create_by!(
          name: row["Movie"],
          description: row["Description"],
          year: row["Year"]&.to_i,
          director: row["Director"]
        )


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
        movie = Movie.find_or_create_by!(name: row["Movie"])
        user = User.find_or_create_by!(name: row["User"])
        review = Review.create(
          rating: row["Stars"],
          content: row["Review"],
          movie_id: movie.id
        )

        review.users << user unless review.users.include?(user)


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