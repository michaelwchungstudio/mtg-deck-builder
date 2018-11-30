class UsersController < ApplicationController
  def index
    cards = MTG::Set.where(set: 'Jace, the Mind Sculptor').all

    cards.each do |c|
      p c.set
    end
  end

  def profile

  end
end
