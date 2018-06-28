class DashboardController < ApplicationController
  def index
    session[:filter] = nil
    recents = {}
    recents = get_recents(recents, Evaluation)
    recents = get_recents(recents, Profile)
    recents = get_recents(recents, User)

    recents = Hash[recents.sort_by { |key, _| key }]
    @recents = {}
    recents.each do |tl, ary|
      @recents[tl] = ary.sort
      #ary.each do |obj|
      #  logger.debug "#{tl}: #{obj.class}"
      #end
    end
  end

  def get_recents(recents, clss)
    recent_evals = clss.recent(10)
    recent_evals.each do |obj|
      next if obj.created_at.nil?
      key = obj.created_at.strftime('%d %b.%Y')
      recents[key] = [] unless recents.key?(key)
      recents[key] << obj
    end
    recents
  end
end
