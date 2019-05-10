class FiltersController < ApplicationController
  load_and_authorize_resource
  protect_from_forgery

  # GET /filters
  # GET /filters.json
  def index
    @filters = Filter.all
  end

  # GET /filters/1
  # GET /filters/1.json
  def show
  end

  # GET /filters/new
  def new
    @filter = Filter.new
    @nist_hash = Constants::NIST_800_53
  end

  # GET /filters/1/edit
  def edit
    @nist_hash = Constants::NIST_800_53
  end

  # POST /filters
  # POST /filters.json
  def create
    @filter = Filter.valid_filter filter_params
    @filter.save
    respond_to do |format|
      format.html { redirect_to Filter.find(@filter.id), notice: 'Filter was successfully created.' }
      format.json { render :show, status: :created, location: @filter }
    end
  end

  # PATCH/PUT /filters/1
  # PATCH/PUT /filters/1.json
  def update
    respond_to do |format|
      @filter.update(filter_params)
      format.html { redirect_to @filter, notice: 'Filter was successfully updated.' }
      format.json { render :show, status: :ok, location: @filter }
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.json
  def destroy
    if params.key?(:filter_group_id)
      @filter_group = FilterGroup.find(params[:filter_group_id])
      @filter_group.filters.delete(Filter.find(params[:id]))
      respond_to do |format|
        format.html { redirect_to @filter_group, notice: 'Filter was successfully removed.' }
        format.json { head :no_content }
      end
    else
      @filter.destroy
      respond_to do |format|
        format.html { redirect_to filters_url, notice: 'Filter was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def filter_params
    params.require(:filter).permit(family: [], number: [], sub_fam: [], sub_num: [], enhancement: [], enh_sub_fam: [], enh_sub_num: [])
  end
end
