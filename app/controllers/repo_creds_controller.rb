class RepoCredsController < ApplicationController
  before_action :set_repo_cred, only: [:update, :destroy]

  # POST /repo_creds
  # POST /repo_creds.json
  def create
    @repo = Repo.find(params[:repo_id])
    authorize! :create, @repo
    @repo_cred = @repo.repo_creds.new(repo_cred_params)

    respond_to do |format|
      if @repo.save
        format.html { redirect_to @repo, notice: 'Repo credential was successfully created.' }
        format.json { render :show, status: :created, location: @repo_cred }
      else
        format.html { redirect_to @repo, error: 'Repo credential was not successfully created.' }
        format.json { render json: @repo_cred.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repo_creds/1
  # PATCH/PUT /repo_creds/1.json
  def update
    authorize! :update, @repo
    respond_to do |format|
      if @repo_cred.update(repo_cred_params)
        format.html { redirect_to @repo, notice: 'Repo cred was successfully updated.' }
        format.json { render :show, status: :ok, location: @repo_cred }
      else
        format.html { redirect_to @repo, error: 'Repo credential was not successfully updated.' }
        format.json { render json: @repo_cred.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repo_creds/1
  # DELETE /repo_creds/1.json
  def destroy
    authorize! :destroy, @repo
    @repo_cred.destroy
    respond_to do |format|
      format.html { redirect_to @repo, notice: 'Repo cred was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_repo_cred
    @repo = Repo.find(params[:repo_id])
    @repo_cred = @repo.repo_creds.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def repo_cred_params
    params.require(:repo_cred).permit(:username, :token)
  end
end
