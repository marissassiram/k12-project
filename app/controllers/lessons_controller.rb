class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit]#, :update, :destroy]
  # 預設 end_time 現在時間一小時後，period "Does not repeat"
  def new
    @lesson = Lesson.new(:end_time => 1.hour.from_now, :period => "Does not repeat")
    #render :json => {:form => render_to_string(:partial => 'form')}
  end
  
  # 此處 period 是 :commit 訊息，不是 lesson table 的欄位
  def create
    if params[:lesson][:period] == "Does not repeat"
      @lesson = Lesson.new(lesson_params)
    else
      # lesson = @subjects = Subject.new(:frequency => params[:lesson][:frequency], :period => params[:lesson][:repeats], :start_time => params[:lesson][:start_time], :end_time => params[:lesson][:end_time], :all_day => params[:lesson][:all_day])
      @lesson = Subject.new(lesson_params)
    end
    if @lesson.save
      # render :nothing => true
      flash[:notice] = "Lesson was successfully created"
      redirect_to lessons_path
    else
      #render :text => lesson.errors.full_messages.to_sentence, :status => 422
      flash.now[:alert] = "Lesson was failed to created"
      render :new
    end
  end
  
  def index
    @lessons = Lesson.all
  end

  def list
    @lessons = Lesson.all
  end

  # 搜尋 lessons
  def get_lessons
    @lessons = Lesson.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    lessons = [] 
    @lessons.each do |lesson|
      lessons << {:id => lesson.id,
                  :name => lesson.name,
                  :description => lesson.description,
                  :start => "#{lesson.start_time.iso8601}",
                  :end => "#{lesson.end_time.iso8601}",
                  :allDay => lesson.all_day}#, :recurring => (event.event_series_id)? true: false
    end
    render :text => lessons.to_json
  end
  
  
  
  # def move
  #   @lesson = Lesson.find_by_id params[:id]
  #   if @lesson
  #     @lesson.starttime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.starttime))
  #     @lesson.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
  #     @lesson.all_day = params[:all_day]
  #     @lesson.save
  #   end
  #   render :nothing => true
  # end
  
  
  # def resize
  #   @lesson = Lesson.find_by_id params[:id]
  #   if @lesson
  #     @lesson.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
  #     @lesson.save
  #   end    
  #   render :nothing => true
  # end
  
  def edit
    @lesson = Lesson.find_by_id(params[:id])
    render :json => { :form => render_to_string(:partial => 'edit_form') } 
  end
  
  # def update
  #   @lesson = Lesson.find_by_id(params[:lesson][:id])
  #   if params[:lesson][:commit_button] == "Update All Occurrence"
  #     @lessons = @event.event_series.events #.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
  #     @lesson.update_events(@events, event_params)
  #   elsif params[:event][:commit_button] == "Update All Following Occurrence"
  #     @lessons = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
  #     @lesson.update_events(@events, event_params)
  #   else
  #     @lesson.attributes = event_params
  #     @lesson.save
  #   end
  #   render :nothing => true    
  # end
  
  # def destroy
  #   @lesson = Lesson.find_by_id(params[:id])
  #   if params[:delete_all] == 'true'
  #     @lesson.event_series.destroy
  #   elsif params[:delete_all] == 'future'
  #     @lessons = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
  #     @lesson.event_series.events.delete(@events)
  #   else
  #     @lesson.destroy
  #   end
  #   render :nothing => true   
  # end

  private

    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    def lesson_params
      params.require(:lesson).permit('name', 'start_time(1i)', 'start_time(2i)', 'start_time(3i)', 'start_time(4i)', 'start_time(5i)', 'end_time(1i)', 'end_time(2i)', 'end_time(3i)', 'end_time(4i)', 'end_time(5i)', 'all_day', 'period', 'frequency', 'commit_button')
    end

end