class Api::TeamsController < ApplicationController
  def process_team
    team_requirements = params["_json"]
    selected_players = []
  
    team_requirements.each do |requirement|
      position = requirement["position"]
      main_skill = requirement["mainSkill"]
      number_of_players = requirement["numberOfPlayers"].to_i
  
      players = Player.by_position(position)

      if players.size < number_of_players
        render json: { message: "Insufficient number of players for position: #{position}" },
               status: :unprocessable_entity
        next
      end
  
      players_with_skill = players.with_skill(main_skill)
      sorted_players = players_with_skill.sorted_by_skill_value(main_skill)
  
      if sorted_players.size < number_of_players
        no_to_fill = number_of_players - players_with_skill.size
        sorted_players += Player.get_high_skilled(players - sorted_players, no_to_fill)
      end

      selected_players.concat(sorted_players.take(number_of_players))
    end
  
    render_json(selected_players.flatten, :ok, true)
  end
end
