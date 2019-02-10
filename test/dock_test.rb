require './test/test_helper'

class DockTest < Minitest::Test

  def setup
    @dock = Dock.new("The Rowing Dock", 3)

    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @canoe = Boat.new(:canoe, 25)

    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  def test_it_exists

   assert_instance_of Dock, @dock
  end

  def test_it_has_attributes

   assert_equal "The Rowing Dock", @dock.name
   assert_equal 3, @dock.max_rental_time
  end

  def test_it_can_keep_a_log_of_renters
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    expected = ({ @kayak_1 => @patrick, @kayak_2 => @patrick, @sup_1 => @eugene})

    assert_equal expected, @dock.rental_log
  end

  def test_it_can_show_the_total_charge_for_a_renters_credit_card
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    @kayak_1.add_hour
    @kayak_1.add_hour

    kayak_1_expected = ({ :card_number => "4242424242424242", :amount => 40})

    assert_equal kayak_1_expected, @dock.charge(@kayak_1)
  end

  def test_hours_past_maximum_rental_time_are_not_added
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour

    sup_1_expected = ({:card_number => "1313131313131313", :amount => 45})

    assert_equal sup_1_expected, @dock.charge(@sup_1)
  end

  def test_all_boats_currently_rented_are_charged_an_additional_hour
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)

    @dock.log_hour

    @dock.rent(@canoe, @patrick)

    @dock.log_hour

    assert_equal 2, @kayak_1.hours_rented
    assert_equal 2, @kayak_2.hours_rented
    assert_equal 1, @canoe.hours_rented
  end

  def test_boats_can_be_returned_to_dock
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@canoe, @patrick)

    expected = ({@kayak_1 => @patrick, @kayak_2 => @patrick, @canoe => @patrick})
    assert_equal expected, @dock.rental_log

    @dock.return(@kayak_1)

    expected = ({@kayak_2 => @patrick, @canoe => @patrick})
    assert_equal expected, @dock.rental_log

    @dock.return(@kayak_2)

    expected = ({@canoe => @patrick})
    assert_equal expected, @dock.rental_log
  end


  def test_revenue_is_calculated_when_boats_are_returned
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour

    @dock.rent(@canoe, @patrick)
    @dock.log_hour

    assert_equal 0, @dock.revenue

    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)

    assert_equal 105, @dock.revenue

    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)

    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour

    @dock.return(@sup_1)
    @dock.return(@sup_2)

    assert_equal 195, @dock.revenue
  end

end
