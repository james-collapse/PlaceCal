# frozen_string_literal: true

module Admin
  class NeighbourhoodsController < Admin::ApplicationController
    before_action :set_neighbourhood, only: %i[show edit update destroy]

    def index
      @neighbourhoods = policy_scope(Neighbourhood).order(:name)
      authorize @neighbourhoods
    end

    def new
      @neighbourhood = Neighbourhood.new
      authorize @neighbourhood
    end

    def edit
      authorize @neighbourhood
      @users = @neighbourhood.users
    end

    def create
      @neighbourhood = Neighbourhood.new(neighbourhood_params)
      authorize @neighbourhood
      respond_to do |format|
        if @neighbourhood.save
          format.html { redirect_to admin_neighbourhoods_path, notice: 'Neighbourhood was successfully created.' }
          format.json { render :show, status: :created, location: @neighbourhood }
        else
          format.html { render :new }
          format.json { render json: @neighbourhood.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize @neighbourhood
      if @neighbourhood.update(neighbourhood_params)
        redirect_to admin_neighbourhoods_path
      else
        render 'edit'
      end
    end

    def destroy
      authorize @neighbourhood
      @neighbourhood.destroy
      respond_to do |format|
        format.html { redirect_to admin_neighbourhoods_url, notice: 'Neighbourhood was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    def set_neighbourhood
      @neighbourhood = Neighbourhood.find(params[:id])
    end

    def neighbourhood_params
      params.require(:neighbourhood).permit(:name, user_ids: [])
    end
  end
end
