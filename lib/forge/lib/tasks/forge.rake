namespace :forge do
  %w{admin super_admin contributor}.each do |role|
    desc "Create #{role.humanize} user (#{role}@factore.ca/#{role}) (Or pass it PASSWORD=)"
    task("create_#{role}".to_sym => :environment) do
      password = ENV['PASSWORD'].blank? ? role : ENV['PASSWORD']
      user = User.new(:password => password, :password_confirmation => password, :email => "#{role}@factore.ca")
      user.approved = true
      user.roles << Role.find_or_create_by(title: role.humanize.titleize)
      if user.save
        puts "#{role.humanize.titleize} user created with username: #{user.email}, password: #{password}"
      else
        puts "#{role.humanize.titleize} user not saved because #{user.errors.full_messages.to_sentence}.  Make sure your database is set up correctly."
      end
    end
  end

  desc "Load help files"
  task(:load_help => :environment ) do
    Dir.chdir("db/help") do
      Dir.foreach(".") do |entry|
        status, ht_values = parse_help_file(entry)
        # if the status is anything other than "published", ignore it
        if status == "published"
          if ht_values[:slugs] =~ /,/
            slugs = ht_values[:slugs].split(', ')
          else
            slugs = [ht_values[:slugs]]
          end
          slugs.each do |slug|
            if ht = HelpTopic.where(:language => ht_values[:language], :slug => slug).first
              ht.title = ht_values[:title]
              ht.content = ht_values[:content]
            else
              ht = HelpTopic.new
              ht_values[:slug] = slug
              ht_values.reject {|k, v| k == :slugs}.each { |key, value| ht.send((key.to_s + '=').to_sym, value) }
            end
            if ht.save
              puts "Help Topic #{slug} was saved"
            else
              puts "ERROR: Help Topic with slug #{slug} could not be saved because #{ht.errors.full_messages.to_sentence}"
            end
          end
        else
          "Skipping #{entry} because it isn't published."
        end
      end
    end
  end

  desc "Destroy help files"
  task(:destroy_help => :environment) do
    HelpTopic.all.each do |topic|
      topic.destroy
    end
    puts "All Help Topics have been destroyed"
  end

  desc "Create Fake Dispatch"
  task(:create_fake_dispatch => :environment) do
    require 'ipaddr'
    date1, date2 = Time.now - 1.month, Time.now
    opened = lambda { Time.at((date2.to_f - date1.to_f)*rand + date1.to_f) }
    dispatch = Dispatch.create!(:subject => "Fake Dispatch for Testing", :content => "<a href='http://google.com'>It has links</a> and also some spots that aren't links.<a href='http://factore.ca'>factore.ca</a>", :sent_at => date1)
    3235.times { Subscriber.create(:name => Faker::Name.name, :email => Faker::Internet.free_email) }
    Subscriber.all.each { |s| QueuedDispatch.create(:dispatch_id => dispatch.id, :subscriber_id => s.id, :sent_at => date1)}

    # Opens, clicks, unsubscribes
    Subscriber.limit(2303).each { |s| DispatchOpen.create(:dispatch_id => dispatch.id, :email => s.email, :created_at => opened.call, :ip => IPAddr.new(rand(2**32),Socket::AF_INET).to_s) }
    948.times { DispatchLinkClick.create(:dispatch_link_id => DispatchLink.order("RAND()").first.id, :ip => IPAddr.new(rand(2**32),Socket::AF_INET).to_s, :created_at => opened.call) }
    126.times { DispatchUnsubscribe.create(:dispatch_id => dispatch.id, :email => Subscriber.order("RAND()").first.email, :created_at => opened.call) }
  end

  desc "Set up Development Database"
  task(:setup_database) do
    db_file = File.join(Rails.root, 'config', 'database.yml')
    raise 'database.yml exists!' if File.exist?(db_file)

    # Build and write database.yml
    config_string = File.read(File.join(Rails.root, 'config', 'database.yml.template'))
    app_name = Rails.root.to_s.split("/").last
    config_string.gsub!(/(_production|_development|_test)/) { |w| "#{app_name}#{w}" }
    config_string.gsub!('username: ', "username: #{ENV['USERNAME']}") unless ENV['USERNAME'].blank?
    config_string.gsub!('password: ', "password: #{ENV['PASSWORD']}") unless ENV['PASSWORD'].blank?
    config_string.gsub!("  socket: \n", (ENV['SOCKET'].blank? ? "" : "  socket: #{ENV['SOCKET']}\n"))
    f = File.open(File.join(db_file), 'w')
    f.puts config_string
    f.close

    # Create and migrate the databases
    unless ENV['USERNAME'].blank?
      # system("rake db:create; rake db:migrate; rake db:test:prepare; rake db:seed")
      # use forge:deploy rather than db:seed, since that seeds the database and adds some default settings
      system("rake db:create; rake db:migrate; rake db:test:prepare; rake forge:deploy")
      puts "Created database.yml, created databases, migrated, seeded."
    end
  end

  def parse_help_file(entry)
    status, title, content, language, slugs = "", "", "", "", ""
    if entry.split(".").last == "help" && File.file?(entry)
      File.open(entry) do |file|
        # first few lines are in yml format:
          # key: value
          # so, need to read line, split it on : and trim both sides
        # eventually, you come to a line with a number of asterixes
          #  when that happens, ignore that line, but load the rest of the file in as :content
        parse_as = :yaml
        file.each_line do |line|
          if line[0..4] == "*****"
            parse_as = :markdown
          else
            case parse_as
            when :yaml
              eval "#{line.split(":")[0].strip} = '#{line.split(":")[1].strip}'"
            when :markdown
              content += line
            end
          end
        end
      end
    end
    return status.downcase, {:title => title, :content => content, :slugs => slugs, :language => language}
  end

  desc "Deploy a new Forge-based site"
  task :deploy => :environment do
    # eCommerce

    # db defaults from _gunk/sitemap.yml
    Rake::Task["db:seed"].invoke
    # by default, use flat rate shipping
    MySettings.flat_rate_shipping = true
  end


  desc "Expire cache"
  task :expire_cache => :environment do
    ActionController::Base.new.trash_cache
    puts "Expired Page Cache"
  end

  desc "Get updates from Zencoder"
  task :encode_notify => :environment do
    system "zencoder_fetcher -u http://localhost:3000/forge/videos/encode_notify #{Forge.config.videos.zencoder_api_key}"
  end

  desc "Generate a static secret token"
  task :secret => :environment do
    require 'securerandom'

    token = SecureRandom.hex(256)

    Rails.root.join("config", "secret_token.txt").open("w") do |f|
      f.write(token)
    end
  end
end
