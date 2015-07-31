class LogUnitsController < ApplicationController
  before_action :set_log_unit, only: [:show, :edit, :update, :destroy]

  # GET /log_units
  # GET /log_units.json
  def index
    @log_units = LogUnit.all
  end

  # GET /log_units/1
  # GET /log_units/1.json
  def show
  end

  # GET /log_units/new
  def new
    @log_unit = LogUnit.new
  end

  # GET /log_units/1/edit
  def edit
  end

  # POST /log_units
  # POST /log_units.json
  def create
    @log_unit = LogUnit.new(log_unit_params)

    respond_to do |format|
      if @log_unit.save
        format.html { redirect_to @log_unit, notice: 'Log unit was successfully created.' }
        format.json { render :show, status: :created, location: @log_unit }
      else
        format.html { render :new }
        format.json { render json: @log_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /log_units/1
  # PATCH/PUT /log_units/1.json
  def update
    respond_to do |format|
      if @log_unit.update(log_unit_params)
        format.html { redirect_to @log_unit, notice: 'Log unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @log_unit }
      else
        format.html { render :edit }
        format.json { render json: @log_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /log_units/1
  # DELETE /log_units/1.json
  def destroy
    @log_unit.destroy
    respond_to do |format|
      format.html { redirect_to log_units_url, notice: 'Log unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log_unit
      @log_unit = LogUnit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_unit_params
      params.require(:log_unit).permit(:log_unit_uuid, :mac_addr, :os, :occurred_at)
    end
end
