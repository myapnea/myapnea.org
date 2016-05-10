# frozen_string_literal: true

class Lottery

  # Draw a winner by using Lottery.draw_winner, or u = Lottery.draw_winner, if
  # more information about the winning user is required.
  def self.draw_winner
    puts ""
    puts "Started Lottery..."
    puts "Generating Tickets..."
    tickets = generate_tickets
    winning_ticket = pick_random_ticket(tickets)
    winning_user = winning_ticket.user

    puts "\n\nMember ##{winning_user.id} #{winning_user.name} <#{winning_user.email}> won the drawing!"
    puts ""

    return winning_user
  end

  private

    # Generates a list of tickets for each user. Each user gets one ticket per
    # completed survey. A ticket tracks the user and the survey.
    def self.generate_tickets
      tickets = []
      count = 0
      user_count = 0

      User.current.each do |u|
        u.completed_answer_sessions.each_with_index do |answer_session, index|
          user_count += 1 if index == 0
          tickets << ::Ticket.new(u.id, answer_session.id)
          count += 1
        end
        print "\r#{count} Ticket#{'s' if count != 1} Generated for #{user_count} User#{'s' if user_count != 1}"
      end

      tickets
    end

    # Shuffles an array of tickets and
    def self.pick_random_ticket(tickets)
      random_tickets = tickets.shuffle
      winning_ticket = random_tickets.first
      winning_ticket
    end

end
