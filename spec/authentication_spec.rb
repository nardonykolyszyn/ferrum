# frozen_string_literal: true

require "spec_helper"

module Ferrum
  describe Browser do
    context "authentication support" do
      it "denies without credentials" do
        browser.goto("/ferrum/basic_auth")

        expect(browser.status).to eq(401)
        expect(browser.body).not_to include("Welcome, authenticated client")
      end

      it "allows with given credentials" do
        browser.authorize(user: "login", password: "pass")

        browser.goto("/ferrum/basic_auth")

        expect(browser.status).to eq(200)
        expect(browser.body).to include("Welcome, authenticated client")
      end

      it "allows even overwriting headers" do
        browser.authorize(user: "login", password: "pass")
        browser.headers.set("Cuprite" => "true")

        browser.goto("/ferrum/basic_auth")

        expect(browser.status).to eq(200)
        expect(browser.body).to include("Welcome, authenticated client")
      end

      it "denies with wrong credentials" do
        browser.authorize(user: "user", password: "pass!")

        browser.goto("/ferrum/basic_auth")

        expect(browser.status).to eq(401)
        expect(browser.body).not_to include("Welcome, authenticated client")
      end

      it "allows on POST request" do
        browser.authorize(user: "login", password: "pass")

        browser.goto("/ferrum/basic_auth")
        browser.at_css(%([type="submit"])).click

        expect(browser.status).to eq(200)
        expect(browser.body).to include("Authorized POST request")
      end
    end
  end
end
