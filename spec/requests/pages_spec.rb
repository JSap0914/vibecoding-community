require "rails_helper"

RSpec.describe "Pages" do
  after do
    # Make sure we reset this to avoid polluting any subsequent tests
    RequestStore.store[:subforem_id] = nil
  end

  describe "GET /:slug" do
    it "has proper headline for non-top-level" do
      page = create(:page, title: "Edna O'Brien96")
      get "/page/#{page.slug}"
      expect(response.body).to include(CGI.escapeHTML(page.title))
      expect(response.body).to include("/page/#{page.slug}")
    end

    it "has proper headline and classes for top-level" do
      page = create(:page, title: "Edna O'Brien96", is_top_level_path: true)
      get "/#{page.slug}"
      expect(response.body).to include(CGI.escapeHTML(page.title))
      expect(response.body).not_to include("/page/#{page.slug}")
      expect(response.body).to include("stories-show")
      expect(response.body).to include(" pageslug-#{page.slug}")
    end

    context "when redirect_if_different_subforem is triggered" do
      let(:subforem) { create(:subforem) }
      let!(:page) { create(:page, slug: "some-page", subforem_id: subforem.id) }

      context "when RequestStore.store[:subforem_id] is set and differs" do

        it "redirects to the subforem-based URL" do
          get "/page/#{page.slug}", headers: { "Host" => create(:subforem, domain: "other.com").domain }

          expect(response).to have_http_status(:redirect)
        end
      end

      context "when RequestStore.store[:subforem_id] matches the page" do
        before do
          RequestStore.store[:subforem_id] = 42
        end

        it "does not redirect" do
          get "/page/#{page.slug}"
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(CGI.escapeHTML(page.title))
        end
      end

      context "when RequestStore.store[:subforem_id] or page.subforem_id is nil" do
        it "does not redirect if page.subforem_id is nil" do
          page.update!(subforem_id: nil)
          get "/page/#{page.slug}"
          expect(response).to have_http_status(:ok)
        end

        it "does not redirect if RequestStore.store[:subforem_id] is nil" do
          RequestStore.store[:subforem_id] = nil
          get "/page/#{page.slug}"
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "when json template" do
      let(:json_text) { "{\"foo\": \"bar\"}" }
      let(:page) do
        create(:page, title: "sample_data", template: "json", body_json: json_text, body_html: nil, body_markdown: nil)
      end

      before do
        page.save! # Trigger processing of page.body_html
      end

      it "returns json data" do
        get "/page/#{page.slug}"

        expect(response.media_type).to eq("application/json")
        expect(response.body).to include(json_text)
      end

      it "returns json data for top level template" do
        page.is_top_level_path = true
        page.save!
        get "/#{page.slug}"

        expect(response.media_type).to eq("application/json")
        expect(response.body).to include(json_text)
      end
    end
  end

  describe "GET /:slug.txt" do
    it "renders proper text file when template is txt" do
      page = create(:page, title: "Text page", body_html: "This is a test", template: "txt")
      get "/#{page.slug}.txt"
      expect(response.body).to include(page.processed_html)
      expect(response.media_type).to eq("text/plain")
    end

    it "renders not found when .txt request does not have txt template" do
      page = create(:page, title: "Text page", body_html: "This is a test", template: "contained")
      expect { get "/#{page.slug}.txt" }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET /slug/slug/slug/etc." do
    it "renders proper page when slug has one subdirectory" do
      page = create(:page, slug: "first-slug/second-slug", is_top_level_path: true)
      get "/#{page.slug}"
      expect(response.body).to include(CGI.escapeHTML(page.title))
    end

    it "renders proper page when slug has two subdirectories" do
      page = create(:page, slug: "first-slug/second-slug/third-slug", is_top_level_path: true)
      get "/#{page.slug}"
      expect(response.body).to include(CGI.escapeHTML(page.title))
    end

    it "renders proper page when slug has three subdirectories" do
      page = create(:page, slug: "first-slug/second-slug/third-slug/fourth-slug", is_top_level_path: true)
      get "/#{page.slug}"
      expect(response.body).to include(CGI.escapeHTML(page.title))
    end

    it "renders proper page when slug has four subdirectories" do
      page = create(:page, slug: "first-slug/second-slug/third-slug/fourth-slug/fifth-slug", is_top_level_path: true)
      get "/#{page.slug}"
      expect(response.body).to include(CGI.escapeHTML(page.title))
    end

    it "renders proper page when slug has five subdirectories" do
      page = create(:page, slug: "first-slug/second-slug/third-slug/fourth-slug/fifth-slug/sixth-slug",
                           is_top_level_path: true)
      get "/#{page.slug}"
      expect(response.body).to include(CGI.escapeHTML(page.title))
    end

    it "returns not found when five directories, but no page" do
      # 6+ directories will be a non-valid page, so just further testing routing error
      expect { get "/heyhey/hey/hey/hey/hey" }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "returns routing error when 7+ directories" do
      # 6+ directories will be a non-valid page, so just further testing routing error
      expect { get "/heyhey/hey/hey/hey/hey/hey/hey" }.to raise_error(ActionController::RoutingError)
    end
  end

  # VIBECODING CUSTOMIZATION - Epic 1, Story 1.6
  describe "GET /about" do
    it "returns success status" do
      get "/about"
      expect(response).to have_http_status(:ok)
    end

    it "includes about page title" do
      get "/about"
      expect(response.body).to include("About Vibecoding Community")
    end

    it "includes mission statement" do
      get "/about"
      expect(response.body).to include("Our Mission")
      expect(response.body).to include("Building the vibecoding movement")
    end

    it "includes what makes community special section" do
      get "/about"
      expect(response.body).to include("What Makes This Community Special")
      expect(response.body).to include("Natural Language Development")
    end

    it "includes ANYON connection section" do
      get "/about"
      expect(response.body).to include("The ANYON Connection")
      expect(response.body).to include("ANYON")
    end

    it "includes contact information" do
      get "/about"
      expect(response.body).to include("Contact Us")
      expect(response.body).to include("hello@vibecoding.community")
    end

    it "includes get involved section" do
      get "/about"
      expect(response.body).to include("Get Involved")
    end
  end

  # VIBECODING CUSTOMIZATION - Epic 1, Story 1.6
  describe "GET /community-guidelines" do
    it "returns success status" do
      get "/community-guidelines"
      expect(response).to have_http_status(:ok)
    end

    it "includes community guidelines title" do
      get "/community-guidelines"
      expect(response.body).to include("Community Guidelines")
    end

    it "includes expected behavior section" do
      get "/community-guidelines"
      expect(response.body).to include("Expected Behavior")
      expect(response.body).to include("Be Respectful")
      expect(response.body).to include("Be Constructive")
      expect(response.body).to include("Be Authentic")
    end

    it "includes content quality standards" do
      get "/community-guidelines"
      expect(response.body).to include("Content Quality Standards")
    end

    it "includes self-promotion policy" do
      get "/community-guidelines"
      expect(response.body).to include("Self-Promotion Policy")
      expect(response.body).to include("ANYON project showcases")
    end

    it "includes moderation policy" do
      get "/community-guidelines"
      expect(response.body).to include("Moderation Policy")
    end

    it "includes how to report issues section" do
      get "/community-guidelines"
      expect(response.body).to include("How to Report Issues")
    end
  end

  describe "GET /community-moderation" do
    it "has proper headline" do
      get "/community-moderation"
      expect(response.body).to include("Community Moderation Guide")
    end
  end

  describe "GET /tag-moderation" do
    it "has proper headline" do
      get "/tag-moderation"
      expect(response.body).to include("Tag Moderation Guide")
    end
  end

  describe "GET /page/post-a-job" do
    it "has proper headline" do
      get "/page/post-a-job"
      expect(response.body).to include("Posting a Job on #{Settings::Community.community_name} Listings")
    end
  end

  describe "GET /api" do
    it "redirects to the API docs" do
      get "/api"
      expect(response.body).to redirect_to("https://developers.forem.com/api")
    end
  end

  describe "GET /privacy" do
    it "has proper headline" do
      get "/privacy"
      expect(response.body).to include("Privacy Policy")
    end
  end

  describe "GET /terms" do
    it "has proper headline" do
      get "/terms"
      expect(response.body).to include("Web Site Terms and Conditions of Use")
    end
  end

  describe "GET /security" do
    it "has proper headline" do
      get "/security"
      expect(response.body).to include("Reporting Vulnerabilities")
    end
  end

  describe "GET /code-of-conduct" do
    it "has proper headline" do
      get "/code-of-conduct"
      expect(response.body).to include("Code of Conduct")
    end
  end

  describe "GET /contact" do
    it "has proper headline" do
      get "/contact"
      expect(response.body).to include("Contact")
      expect(response.body).to include("@#{Settings::General.social_media_handles['twitter']}")
    end
  end

  describe "GET /welcome" do
    let(:user) { create(:user, id: 1) }

    it "redirects to the latest welcome thread" do
      earlier_welcome_thread = create(:article, user: user, tags: "welcome")
      earlier_welcome_thread.update(published_at: 1.week.ago)
      latest_welcome_thread = create(:article, user: user, tags: "welcome")
      get "/welcome"

      expect(response.body).to redirect_to(latest_welcome_thread.path)
    end

    context "when no welcome thread exists" do
      it "redirects to the notifications page" do
        get "/welcome"

        expect(response.body).to redirect_to(notifications_path)
      end
    end

    context "when the welcome thread has an absolute URL stored as its path" do
      it "redirects to a page on the same domain as the app" do
        vulnerable_welcome_thread = create(:article, user: user, tags: "welcome")
        vulnerable_welcome_thread.update_column(:path, "https://attacker.com/hijacked/welcome")

        get "/welcome"

        expect(response.body).to redirect_to("/hijacked/welcome")
      end
    end
  end

  describe "GET /challenge" do
    let(:user) { create(:user, id: 1) }

    it "redirects to the latest challenge thread" do
      earlier_challenge_thread = create(:article, user: user, tags: "challenge")
      earlier_challenge_thread.update(published_at: 1.week.ago)
      latest_challenge_thread = create(:article, user: user, tags: "challenge")
      get "/challenge"

      expect(response.body).to redirect_to(latest_challenge_thread.path)
    end

    context "when no challenge thread exists" do
      it "redirects to the notifications page" do
        get "/challenge"

        expect(response.body).to redirect_to(notifications_path)
      end
    end

    context "when the challenge thread has an absolute URL stored as its path" do
      it "redirects to a page on the same domain as the app" do
        vulnerable_challenge_thread = create(:article, user: user, tags: "challenge")
        vulnerable_challenge_thread.update_column(:path, "https://attacker.com/hijacked/challenge")

        get "/challenge"

        expect(response.body).to redirect_to("/hijacked/challenge")
      end
    end
  end

  describe "GET /checkin" do
    let(:user) { create(:user, username: "codenewbiestaff") }

    it "redirects to the latest CodeNewbie staff thread" do
      earlier_staff_thread = create(:article, user: user, tags: "staff")
      earlier_staff_thread.update(published_at: 1.week.ago)
      latest_staff_thread = create(:article, user: user, tags: "staff")
      get "/checkin"

      expect(response.body).to redirect_to(latest_staff_thread.path)
    end

    context "when there is no staff user post" do
      it "redirects to the notifications page" do
        get "/checkin"

        expect(response.body).to redirect_to(notifications_path)
      end
    end

    context "when the staff thread has an absolute URL stored as its path" do
      it "redirects to a page on the same domain as the app" do
        vulnerable_staff_thread = create(:article, user: user, tags: "staff")
        vulnerable_staff_thread.update_column(:path, "https://attacker.com/hijacked/staff")

        get "/checkin"

        expect(response.body).to redirect_to("/hijacked/staff")
      end
    end
  end

  describe "GET /robots.txt" do
    it "has proper text" do
      get "/robots.txt"

      text = "Sitemap: #{URL.url('sitemap-index.xml')}"
      expect(response.body).to include(text)
    end
  end

  describe "GET /report-abuse" do
    context "when provided the referer" do
      it "prefills with the provided url" do
        url = Faker::Internet.url
        get "/report-abuse", headers: { referer: url }
        expect(response.body).to include(url)
      end
    end
  end

  # VIBECODING CUSTOMIZATION - Epic 1, Story 1.5
  # Landing page tests
  describe "GET / (landing page)" do
    context "when landing page is the root route" do
      it "renders successfully" do
        get "/"
        expect(response).to have_http_status(:ok)
      end

      it "displays the hero section with title and tagline" do
        get "/"
        expect(response.body).to include("Welcome to Vibecoding Community")
        expect(response.body).to include("Where AI meets natural language development")
      end

      it "displays the value proposition section" do
        get "/"
        expect(response.body).to include("Why Vibecoding?")
        expect(response.body).to include("AI-Powered Development")
        expect(response.body).to include("Community-Driven")
        expect(response.body).to include("Learn & Grow")
      end

      it "displays community stats section" do
        create_list(:user, 5, registered: true)
        create_list(:article, 3, published: true, published_at: 1.day.ago)

        get "/"

        expect(response.body).to include("Join Our Growing Community")
        expect(response.body).to include("Community Members")
        expect(response.body).to include("Posts Shared")
        expect(response.body).to include("Projects Showcased")
      end

      it "displays CTA buttons" do
        get "/"
        expect(response.body).to include("Join the Community")
        expect(response.body).to include("Explore Posts")
      end

      it "includes SEO meta tags" do
        get "/"
        expect(response.body).to include("Vibecoding Community - Where AI Meets Natural Language Development")
        expect(response.body).to include('name="description"')
        expect(response.body).to include("vibecoding")
        expect(response.body).to include('property="og:title"')
        expect(response.body).to include('property="twitter:card"')
      end

      context "when featured articles exist" do
        let!(:user) { create(:user) }
        let!(:articles) { create_list(:article, 6, user: user, published: true, published_at: 1.day.ago) }

        it "displays featured articles section" do
          get "/"
          expect(response.body).to include("Recent Posts from the Community")
        end

        it "displays article titles and links" do
          get "/"
          articles.each do |article|
            expect(response.body).to include(CGI.escapeHTML(article.title))
          end
        end

        it "displays Read More links" do
          get "/"
          expect(response.body).to include("Read More")
        end
      end

      context "when no featured articles exist" do
        before do
          Article.destroy_all
        end

        it "displays placeholder message" do
          get "/"
          expect(response.body).to include("No posts yet, but great things are coming!")
        end

        it "displays appropriate CTA for signed out users" do
          get "/"
          expect(response.body).to include("Join to Start Posting")
        end
      end

      it "includes ANYON reference" do
        get "/"
        expect(response.body).to include("ANYON")
      end

      it "is cacheable" do
        get "/"
        expect(response.headers["Cache-Control"]).to be_present
      end
    end
  end
end
