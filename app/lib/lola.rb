# frozen_string_literal: true

class Lola
  include Facebook::Messenger

  attr_accessor :sender, :payload, :source

  def initialize(sender, payload)
    @sender = sender
    @payload = payload
    file = File.read(Rails.root.join('app', 'bot', 'bot.json'))
    @source = JSON.parse(file)
  end

  def buy
    Bot.deliver({
                  recipient: sender,
                  message: {
                    attachment: {
                      type: 'template',
                      payload: {
                        template_type: 'receipt',
                        recipient_name: 'John Doe',
                        order_number: SecureRandom.random_number(100_000).to_s,
                        currency: 'GBP',
                        payment_method: 'Visa 2345',
                        order_url: 'https://asos.com/',
                        timestamp: Time.now.to_i,
                        elements: [
                          {
                            title: payload['product_name'],
                            subtitle: payload['product_name'],
                            quantity: 2,
                            price: 50,
                            currency: 'GBP',
                            image_url: payload['product_image']
                          }
                        ],
                        address: {
                          street_1: '1 Hacker Way',
                          street_2: 'Coding program',
                          city: 'Menlo Park',
                          postal_code: '94025',
                          state: 'CA',
                          country: 'GB'
                        },
                        summary: {
                          subtotal: 75.00,
                          shipping_cost: 4.95,
                          total_tax: 6.19,
                          total_cost: 56.14
                        }
                      }
                    }
                  }
                }, access_token: Rails.application.credentials.access_token)
  end

  def end_chat
    Bot.deliver({
                  recipient: sender,
                  message: {
                    text: 'Bye! see you another time'
                  }
                }, access_token: Rails.application.credentials.access_token)
  end

  def get_started
    Bot.deliver({
                  recipient: sender,
                  message: {
                    text: 'Greetins man'
                  }
                }, access_token: Rails.application.credentials.access_token)
  end

  def ask
    buttons = %w[aaa bbb ccc].map do |category|
      {
        type: 'postback',
        title: category.capitalize,
        payload: {
          id: 'suggest',
          category: category
        }.to_json
      }
    end

    Bot.deliver(
      {
        recipient: sender,
        message: {
          attachment: {
            type: 'template',
            payload: {
              template_type: 'button',
              text: 'What are you looking for?',
              buttons: buttons
            }
          }
        }
      }, access_token: Rails.application.credentials.access_token
    )
  end

  def suggest
    products = ["Product of #{payload['category']}"]

    Bot.deliver({
                  recipient: sender,
                  message: {
                    text: "Here are some new arrivals in: #{payload['category']}"
                  }
                }, access_token: Rails.application.credentials.access_token)

    elements = products.map do |product|
      {
        title: product,
        subtitle: product,
        # image_url: product.image,
        buttons: [
          {
            type: 'postback',
            title: 'Buy',
            payload: {
              id: 'buy',
              product_id: product,
              product_name: product,
              # product_image: product.image
            }.to_json
          },
          {
            type: 'postback',
            title: 'Not interested!',
            payload: 'end_chat'
          }
        ]
      }
    end

    Bot.deliver({
                  recipient: sender,
                  message: {
                    attachment: {
                      type: 'template',
                      payload: {
                        template_type: 'generic',
                        elements: elements.to_json
                      }
                    }
                  }
                }, access_token: Rails.application.credentials.access_token)
  end
end
