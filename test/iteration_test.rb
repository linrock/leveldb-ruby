require 'test/unit'
require File.expand_path("../../lib/leveldb", __FILE__)

class IterationTest < Test::Unit::TestCase
  DB = LevelDB::DB.new(File.expand_path("../iteration.db", __FILE__))
  DB.put "a/1", "1"
  DB.put "b/1", "1"
  DB.put "b/2", "1"
  DB.put "b/3", "1"
  DB.put "c/1", "1"

  def test_each
    expected = %w(a/1 b/1 b/2 b/3 c/1)
    keys = []
    DB.each do |key, value|
      keys << key
    end

    assert_equal expected, keys
  end

  def test_each_with_key_from
    expected = %w(b/1 b/2 b/3 c/1)
    keys = []
    DB.each('b') do |key, value|
      keys << key
    end

    assert_equal expected, keys
  end

  def test_each_with_key_from_to
    expected = %w(b/1 b/2 b/3)
    keys = []
    DB.each('b', 'b/4') do |key, value|
      keys << key
    end

    assert_equal expected, keys
  end

  def test_reverse_each
    expected = %w(c/1 b/3 b/2 b/1 a/1)
    keys = []
    DB.reverse_each do |key, value|
      keys << key
    end

    assert_equal expected, keys
  end

  def test_reverse_each_with_key_from
    expected = %w(b/1 a/1)
    keys = []
    DB.reverse_each('b') do |key, value|
      keys << key
    end

    assert_equal expected, keys
  end

  def test_reverse_each_with_key_from_to
    expected = %w(c/1 b/3 b/2 b/1)
    keys = []
    DB.reverse_each('c', 'b') do |key, value|
      keys << key
    end

    assert_equal expected, keys
  end

  def test_iterator_init_with_default_options
    iter = LevelDB::Iterator.new DB
    assert_equal DB, iter.db
    assert_nil iter.from
    assert_nil iter.to
    assert_equal false, iter.reversed?
  end

  def test_iterator_init_with_options
    iter = LevelDB::Iterator.new DB, :from => 'abc', :to => 'def', :reversed => true
    assert_equal DB,iter.db
    assert_equal 'abc', iter.from
    assert_equal 'def', iter.to
    assert_equal true, iter.reversed?
  end

  def test_iterator_init_with_no_args
    assert_raise ArgumentError do
      LevelDB::Iterator.new
    end
  end

  def test_iterator_requires_db
    assert_raise ArgumentError do
      LevelDB::Iterator.new 'db'
    end
  end
end

