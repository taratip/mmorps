class Game
  def self.win?(player,computer)
    score = ""
    if player == "Rock" && computer == "Scissors" ||
      player == "Scissors" && computer == "Paper" ||
      player == "Paper" && computer == "Rock"
      score = "win"
    elsif player == "Rock" && computer == "Paper" ||
      player == "Scissors" && computer == "Rock" ||
      player == "Paper" && computer == "Scissors"
      score = "lose"
    elsif player == "Rock" && computer == "Rock" ||
      player == "Scissors" && computer == "Scissors" ||
      player == "Paper" && computer == "Paper"
      score = "tie"
    end
    score
  end
end
