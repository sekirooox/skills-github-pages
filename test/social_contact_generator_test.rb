# frozen_string_literal: true

require "minitest/autorun"

module Jekyll
  class Generator
    def self.safe(*) = nil
    def self.priority(*) = nil
  end
end

require_relative "../_plugins/social-contact-generator"

class SocialContactGeneratorTest < Minitest::Test
  Site = Struct.new(:config, :data)

  def test_resolves_https_link_from_allowed_social_host
    site = build_site(
      ["https://www.facebook.com/profile.php?id=123"],
      [{ "type" => "facebook", "social_host" => "facebook.com" }]
    )

    MaylBlog::SocialContactGenerator.new.generate(site)

    assert_equal "https://www.facebook.com/profile.php?id=123", site.data["contact"][0]["url"]
  end

  def test_rejects_http_credentials_and_lookalike_hosts
    links = [
      "http://x.com/plain-http",
      "https://user@example.com/private",
      "https://x.com.example.net/lookalike"
    ]
    site = build_site(links, [{ "type" => "x", "social_host" => "x.com" }])

    MaylBlog::SocialContactGenerator.new.generate(site)

    assert_nil site.data["contact"][0]["url"]
  end

  private

  def build_site(links, contacts)
    Site.new({ "social" => { "links" => links } }, { "contact" => contacts })
  end
end
