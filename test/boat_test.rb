require './test/test_helper'

class Boat_Test < Minitest::Test

  def setup
    @kayak = kayak = Boat.new(:kayak, 20)
  end

  def test_it_exists

    assert_instance_of Boat, @kayak
  end

  def test_it_has_attributes

    assert_equal :kayak, @kayak.type
    assert_equal 20, @kayak.price_per_hour
  end

  def test_it_begins_with_zero_rental_hours

    assert_equal 0, @kayak.hours_rented
  end

  def test_it_can_add_hours_to_its_rental_hours_count
    @kayak.add_hour
    @kayak.add_hour
    @kayak.add_hour

    assert_equal 3, @kayak.hours_rented
  end

end
