class DecksController < ApplicationController
  def index
  end

  def new
    cards = MTG::Card.where(name: 'Jace, the Mind Sculptor').all

  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
