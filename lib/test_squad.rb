require 'test_squad/engine'
require 'ostruct'

module TestSquad
  def self.configuration
    @configuration ||= OpenStruct.new
  end

  def self.configure(&block)
    configuration.tap(&block)
  end

  def self.app_class_name
    Rails.application.class.name.split('::').first
  end

  def self.test_directory
    @test_directory ||= begin
      if Rails.root.join('spec').exist?
        'spec/javascript'
      else
        'test/javascript'
      end
    end
  end
end
