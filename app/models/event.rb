# frozen_string_literal: true

class Event < ApplicationRecord
  enum access_status: { draft: 0, private: 1, link_only: 2, public: 3 }, _suffix: '_status'
  enum moderation_status: { not_moderated: 0, hidden: 1, shown: 2, featured: 3 }, _suffix: '_status'

  store_accessor :location, :country, :city, :address, :coordinates

  has_one_attached :poster_image

  has_many :ticket_types, dependent: :destroy
  has_many :performances, dependent: :destroy
  accepts_nested_attributes_for :performances,
                                allow_destroy: true,
                                reject_if: :all_blank
  has_many :line_ups, dependent: :destroy
  accepts_nested_attributes_for :line_ups,
                                allow_destroy: true,
                                reject_if: :all_blank

  def map_link
    "https://yandex.ru/maps/213/moscow/?ll=#{CGI.escape(coordinates)}&z=19" if coordinates.present?
  end
end

# == Schema Information
#
# Table name: events
#
#  id                :bigint(8)        not null, primary key
#  access_status     :integer          default("draft"), not null
#  conditions        :text
#  coordinates       :string
#  description_html  :text
#  description_short :string
#  ends_at           :datetime
#  fb_link           :string
#  location          :jsonb            not null
#  moderation_status :integer          default("not_moderated"), not null
#  name              :string
#  questions         :jsonb            not null
#  starts_at         :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  timepad_id        :integer
#
