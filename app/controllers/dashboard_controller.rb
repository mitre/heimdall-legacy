class DashboardController < ApplicationController
  def index
    session[:filter] = nil
    recents = get_recents([Evaluation, Profile, User])
    recents = Hash[recents.sort_by { |key, _| key }]
    @recents = {}
    recents.each do |tl, ary|
      @recents[tl] = ary.sort
    end
  end

  def get_recents(classes)
    recents = {}
    classes.each do |clss|
      recent_evals = clss.recent(10)
      recent_evals.each do |obj|
        next if obj.created_at.nil?
        key = obj.created_at.strftime('%d %b.%Y')
        recents[key] = [] unless recents.key?(key)
        recents[key] << obj
      end
    end
    recents
  end
end
