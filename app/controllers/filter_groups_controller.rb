class FilterGroupsController < ApplicationController
  load_and_authorize_resource
  protect_from_forgery
  # authorize_resource only: [:show, :destroy, :filter, :clear_filter]
  # before_action :set_filter_group, only: [:show, :edit, :update, :destroy, :remove_filter]

  # GET /filter_groups
  # GET /filter_groups.json
  def index
    @filter_groups = FilterGroup.all
  end

  # GET /filter_groups/1
  # GET /filter_groups/1.json
  def show
  end

  # GET /filter_groups/new
  def new
    @filter_group = FilterGroup.new
  end

  # GET /filter_groups/1/edit
  def edit
  end

  # POST /filter_groups
  # POST /filter_groups.json
  def create
    @filter_group = FilterGroup.new(filter_group_params)

    respond_to do |format|
      if @filter_group.save
        format.html { redirect_to @filter_group, notice: 'Filter group was successfully created.' }
        format.json { render :show, status: :created, location: @filter_group }
      else
        format.html { render :new }
        format.json { render json: @filter_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filter_groups/1
  # PATCH/PUT /filter_groups/1.json
  def update
    logger.debug "filter_group_params: #{filter_group_params.inspect}"
    if (filter_ids = filter_group_params[:filter_ids])
      if (filter = Filter.find(filter_ids[:id]))
        @filter_group.filters << filter
        redirect_to @filter_group, notice: 'Filter was added.'
      end
    else
      respond_to do |format|
        if @filter_group.update(filter_group_params)
          format.html { redirect_to @filter_group, notice: 'Filter group was successfully updated.' }
          format.json { render :show, status: :ok, location: @filter_group }
        else
          format.html { render :edit }
          format.json { render json: @filter_group.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /filter_groups/1
  # DELETE /filter_groups/1.json
  def destroy
    @filter_group.destroy
    respond_to do |format|
      format.html { redirect_to filter_groups_url, notice: 'Filter group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def filter_group_params
    params.require(:filter_group).permit(:name, { filter_ids: [:id] })
  end
end
