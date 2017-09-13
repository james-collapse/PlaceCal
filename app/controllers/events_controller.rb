class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :set_start_day, only: %i[index activities]

  # GET /events
  # GET /events.json
  def index
    @next_day = @current_day + 1.day
    @previous_day = @current_day - 1.day
    @events = Event.find_by_day(@current_day)
  end

  def activities
    # Get the start of the week
    @current_day = Date.commercial(@current_day.year, @current_day.cweek)
    @next_week = @current_day + 1.week
    @previous_week = @current_day - 1.week
    @events = Event.find_by_week(@current_day)
    # @events = @events.group_by{|e| [e.summary, e.place]}
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_start_day
      @today = Date.today
      if params[:year] && params[:month] && params[:day]
        @current_day = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      else
        @current_day = @today
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.fetch(:event, {})
    end
end
