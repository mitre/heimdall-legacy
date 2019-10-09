# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Evaluation.all.each do |evaluation|
  evaluation.results.each do |result|
    control = evaluation.top_control(result.control.control_id)
    unless control.id == result.control.id
      result.control_id = control.id
      result.save
    end
  end
  counts, _, _ = evaluation.status_counts
  evaluation.write_attribute(:findings, counts)
  evaluation.save
end
