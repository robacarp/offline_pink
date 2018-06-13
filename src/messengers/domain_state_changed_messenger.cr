class DomainStateChangedMessenger
  def self.message_for(domain : Domain, was old_status : Domain::Status)
    new(domain, was: old_status).render
  end

  def ppp(s : Domain::Status)
    puts "#{s} #{s.to_i}"
  end


  def initialize(@domain : Domain, was @old_status : Domain::Status)
    select_intro
    select_message
    select_title
  end

  def select_intro
    @message_intro = case @old_status
      when Domain::Status::UnChecked
        "Offline.pink has finished initial checks of #{@domain.name} and"
      when Domain::Status::Up
        "Offline.pink ran checks on #{@domain.name} and"
      when Domain::Status::Down, Domain::Status::PartiallyDown
        "Offline.pink is monitoring a downtime event on #{@domain.name} and now"
      else
        raise "invalid domain state for intro: #{@old_status}"
      end
  end

    UnChecked = -1
    Up = 0
    PartiallyDown = 1
    Down = 2

  def select_message
    @message = case @domain.status
      when Domain::Status::UnChecked
        raise "invalid domain state"
      when Domain::Status::Up
        "everything appears okay."
      when Domain::Status::Down
        "it appears completely offline."
      when Domain::Status::PartiallyDown
        "some monitors or hosts are failing."
      else
        raise "invalid domain state for message: #{@domain.status}"
      end
  end

  def select_title
    @title = "Status update for #{@domain.name}"
  end

  def render
    { "#{@title}", "#{@message_intro} #{@message}" }
  end
end
