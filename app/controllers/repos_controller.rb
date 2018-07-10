# require 'git'

class ReposController < ApplicationController
  load_and_authorize_resource

  # GET /repos
  # GET /repos.json
  def index
    @repos = Repo.all
  end

  # GET /repos/1
  # GET /repos/1.json
  def show
    @repo_cred = @repo.repo_creds.where(created_by_id: current_user.id).first || @repo.repo_creds.new
    @repo_projects = @repo.projects @repo_cred
    logger.debug "@repo_projects: #{@repo_projects}"
  end

  # GET /repos/new
  def new
    @repo = Repo.new
  end

  # GET /repos/1/edit
  def edit
  end

  # POST /repos
  # POST /repos.json
  def create
    @repo = Repo.new(repo_params)
    good_type = Repo.types.include?(repo_params[:repo_type])
    respond_to do |format|
      if good_type && @repo.save
        format.html { redirect_to @repo, notice: 'Repo was successfully created.' }
        format.json { render :show, status: :created, location: @repo }
      else
        format.html { render :new }
        format.json { render json: @repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repos/1
  # PATCH/PUT /repos/1.json
  def update
    good_type = Repo.types.include?(repo_params[:repo_type])
    respond_to do |format|
      if good_type && @repo.update(repo_params)
        format.html { redirect_to @repo, notice: 'Repo was successfully updated.' }
        format.json { render :show, status: :ok, location: @repo }
      else
        format.html { render :edit }
        format.json { render json: @repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repos/1
  # DELETE /repos/1.json
  def destroy
    @repo.destroy
    respond_to do |format|
      format.html { redirect_to repos_url, notice: 'Repo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def repo_params
    params.require(:repo).permit(:repo_type, :name, :api_url)
  end
end
