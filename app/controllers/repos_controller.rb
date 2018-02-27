class ReposController < ApplicationController
  before_action :set_repo, only: [:show, :edit, :update, :destroy]

  # GET /repos
  # GET /repos.json
  def index
    @repos = Repo.all
  end

  # GET /repos/1
  # GET /repos/1.json
  def show
    @repo_projects = []
    logger.debug ("user: #{current_user.inspect}")
    @repo_cred = @repo.repo_creds.where(:created_by_id => current_user.id).first
    logger.debug ("@repo_cred: #{@repo_cred.inspect}")
    if @repo_cred
      logger.debug "Repo type: #{@repo.repo_type}"
      begin
        if @repo.repo_type == 'GitLab'
          logger.debug "Repo type: #{@repo.repo_type}"
          Gitlab.endpoint = @repo.api_url
          Gitlab.private_token = @repo_cred.token
          hsh = Gitlab.projects
          logger.debug "Gitlab hsh: #{hsh}"
          if hsh.present?
            hsh.each do |gitlab_proj|
              begin
                repo = gitlab_proj.to_hash
                inspec = Gitlab.file_contents(repo["name_with_namespace"], 'inspec.yml')
                logger.debug "inspec.yml: #{inspec}"
                repo_proj = {}
                repo_proj[:name] = repo["name_with_namespace"]
                repo_proj[:description] = repo["description"]
                repo_proj[:html_url] = repo["http_url_to_repo"]
                @repo_projects << repo_proj
              rescue
                logger.debug "#{repo["name_with_namespace"]} is missing inspec.yml file"
              end
            end
          end
        elsif @repo.repo_type == 'GitHub'
          logger.debug "Repo type: #{@repo.repo_type}"
          client = Octokit::Client.new(:access_token => @repo_cred.token)
          logger.debug "Octokit::Client: #{client}"
          repos = client.repos.select{|repo| repo.name.include?('-baseline')}
          logger.debug "GitHub repos: #{repos.size}"
          repos.each do |repo|
            begin
              inspec = client.contents(repo["full_name"], path: 'inspec.yml')
              logger.debug "inspec.yml: #{inspec}"
              repo_proj = {}
              repo_proj[:name] = repo["full_name"]
              repo_proj[:description] = repo["description"]
              logger.debug "Repo html_url: #{repo["html_url"]}"
              repo_proj[:html_url] = repo["html_url"]
              @repo_projects << repo_proj
            rescue
              logger.debug "#{repo["full_name"]} is missing inspec.yml file"
            end
          end
        end
        logger.debug "@repo_projects: #{@repo_projects}"
      rescue
        logger.debug "Rescued"
        @repo_projects = []
      end
    else
      @repo_cred = @repo.repo_creds.new()
    end
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
      if good_type &&  @repo.update(repo_params)
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
    # Use callbacks to share common setup or constraints between actions.
    def set_repo
      @repo = Repo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repo_params
      params.require(:repo).permit(:repo_type, :name, :api_url)
    end
end
