class DashboardController < ApplicationController
  def index
    session[:filter] = nil
    @recents = {}
    if current_user.present?
      @eval_count = current_user.readable_evaluations.length
      @profile_count = current_user.readable_profiles.length
      recents = get_recents([Evaluation, Profile, User])
      recents = Hash[recents.sort_by { |key, _| key }]
      recents.each do |tl, ary|
        @recents[tl] = ary.sort
      end
    else
      @circle = Circle.where(name: 'Public').try(:first)
      if @circle
        @recents = @circle.recents
        @eval_count = @circle.evaluations.length
        @profile_count = @circle.readable_profiles.length
      else
        @eval_count = 0
        @profile_count = 0
      end
    end
  end

  def get_recents(classes)
    recents = {}
    classes.each do |clss|
      recent_objs = clss.recent(10)
      recent_objs.each do |obj|
        next if obj.created_at.nil?
        next unless clss == User || can?(:read, obj)
        # key = obj.created_at.strftime('%d %b.%Y')
        key = obj.created_at.beginning_of_day
        recents[key] = [] unless recents.key?(key)
        recents[key] << obj
      end
    end
    recents
  end
end
