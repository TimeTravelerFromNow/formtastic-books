class Book < ApplicationRecord
  validates_presence_of :title, :synopsis, :isbn
  validate :validate_all_fields

  def validation_creates_base_error
    errors.add(:base, 'one :base err: Pretend error: The API is down :,(')
  end

  def validation_creates_many_base_errors
    errors.add(:base, 'Pretend error: The API is down :,(')
    errors.add(:base, 'Can only add books on business days')
  end

  def validate_all_fields
    validation_creates_base_error
    validate_title_cant_start_with_the
    validate_synopsis_cannot_contain_special_chars
    validate_published_before_now
  end

  def validate_title_cant_start_with_the
    return if title.nil?
    message = "If your book starts with 'The'," <<
              " please move the word 'The' after the title," <<
              " and parenthesize. Ex: 'The Boat' should be saved 'Boat (The)'"
    if title.downcase.starts_with?('the')
      errors.add(:title, message)
    end
  end

  def validate_synopsis_cannot_contain_special_chars
    return if synopsis.nil?
    if synopsis.include?('@' || '$' || '*' || '#' || '%')
      errors.add(:synopsis, "No special characters such as '@' allowed in synopsis")
    end
  end

  def validate_published_before_now
    return if published_at.nil?
    if published_at > Time.now
      errors.add(:publish_year, 'Published at must be in the past')
    end
  end

  def publish_year=(year)
    published_at = Time.new(year)
  end

  def publish_year
    if published_at.present?
      published_at.year
    else
      Time.now.year
    end
  end
end
