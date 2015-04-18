class NoCalendarException < Exception; end

module RequireCalendar
  extend ActiveSupport::Concern

  def self.included(base)
    base.send :include, BaseConcernController
    base.send :include, ActiveSupport::Callbacks
    base.rescue_from NoCalendarException, with: :calendar_required_exception
  end

  attr_accessor :current_calendar

  def set_calendar
    self.current_calendar = current_account.calendars.find(params[:calendar_id]) if params[:calendar_id]
  end

  def require_calendar
    raise NoCalendarException if current_calendar.blank?
  end

  def calendar_required_exception
    render :json => {:error => 'Agenda não informada (calendar_id).'}, :status => 401
  end

end