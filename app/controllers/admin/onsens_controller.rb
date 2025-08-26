class Admin::OnsensController < ApplicationController
  before_action :set_onsen, only: %i[ show edit update destroy ]

  # GET /onsens or /onsens.json
  def index
    @onsens = Onsen.all
  end

  # GET /onsens/1 or /onsens/1.json
  def show
  end

  # GET /onsens/new
  def new
    @onsen = Onsen.new
  end

  # GET /onsens/1/edit
  def edit
  end

  # POST /onsens or /onsens.json
  def create
    @onsen = Onsen.new(onsen_params)

    respond_to do |format|
      if @onsen.save
        format.html { redirect_to admin_onsen_path(@onsen), notice: "Onsen was successfully created." }
        format.json { render :show, status: :created, location: @onsen }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @onsen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /onsens/1 or /onsens/1.json
  def update
    respond_to do |format|
      if @onsen.update(onsen_params)
        format.html { redirect_to admin_onsen_path(@onsen), notice: "Onsen was successfully updated." }
        format.json { render :show, status: :ok, location: @onsen }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @onsen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /onsens/1 or /onsens/1.json
  def destroy
    @onsen.destroy!

    respond_to do |format|
      format.html { redirect_to admin_onsens_path, status: :see_other, notice: "Onsen was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_onsen
      @onsen = Onsen.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def onsen_params
      params.expect(onsen: [ :name, :geo_lat, :geo_lng, :description, :tags, :pet, images: [] ])
    end
end
