class UsersController < ApplicationController
  def index
    cards = MTG::Card.where(name: 'Jace, the Mind Sculptor').all

    cards.each do |c|
      p c.set
    end
  end

  def profile

  end
end
