# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
["Super Admin", "Admin", "Contributor", "Member"].each {|r| Role.find_or_create_by_title(r)}

%w{admin super_admin contributor member}.each do |role|
  password = ENV['PASSWORD'].blank? ? role : ENV['PASSWORD']
  user = User.new(:password => password, :password_confirmation => password, :email => "#{role}@factore.ca")
  user.approved = true
  user.roles << Role.find_by_title(role.humanize.titleize)
  if user.save
    puts "#{role.humanize.titleize} user created with username: #{user.email}, password: #{password}"
  else
    puts "#{role.humanize.titleize} user not saved because #{user.errors.full_messages.to_sentence}.  Make sure your database is set up correctly."
  end
end

# Get config/sitemap.yml
require 'yaml'
classes = YAML.load(File.new("#{Rails.root}/config/sitemap.yml"))

# Default Pages from config/sitemap.yml
puts "\n============\nBUILDING PAGES"
content = "<p>Edit this page in Forge</p>"
classes["Pages"].each do |page, subpages|
  p = Page.new(:title => page, :slug => page.parameterize, :key => page.parameterize, :content => content, :published => true)
  puts p.save ? "Created #{page}" : "Errors on #{page}: " + p.errors.map { |e| "#{e[0]} #{e[1]}"}.join(', ')
  # Build the Subpages
  if p.errors.blank?
    subpages.each do |subpage, subsubpages|
      subp = Page.new(:title => subpage, :slug => subpage.parameterize, :content => content, :parent => p, :published => true)
      subp.published = true
      puts subp.save ? "  - Created #{subpage}" : "Errors on #{subpage}: " + subp.errors.map { |e| "#{e[0]} #{e[1]}"}.join(', ')
    end unless subpages.blank?
  end
end

# Default Post Categories from config/sitemap.yml
puts "\n============\nPOST CATEGORIES"
classes["PostCategory"].each do |category|
  pc = PostCategory.new(:title => category)
  puts pc.save ? "Created #{category}" : "Errors on #{category}: " + pc.errors.map { |e| "#{e[0]} #{e[1]}"}.join(', ')
end

# Build default countries
Country.create(:code => 'AF', :title => 'Afghanistan')
Country.create(:code => 'AL', :title => 'Albania')
Country.create(:code => 'DZ', :title => 'Algeria')
Country.create(:code => 'AS', :title => 'American Samoa')
Country.create(:code => 'AD', :title => 'Andorra')
Country.create(:code => 'AO', :title => 'Angola')
Country.create(:code => 'AI', :title => 'Anguilla')
Country.create(:code => 'AG', :title => 'Antigua and Barbuda')
Country.create(:code => 'AR', :title => 'Argentina')
Country.create(:code => 'AM', :title => 'Armenia')
Country.create(:code => 'AW', :title => 'Aruba')
Country.create(:code => 'AU', :title => 'Australia')
Country.create(:code => 'AT', :title => 'Austria')
Country.create(:code => 'AZ', :title => 'Azerbaijan')
Country.create(:code => 'BS', :title => 'Bahamas')
Country.create(:code => 'BH', :title => 'Bahrain')
Country.create(:code => 'BD', :title => 'Bangladesh')
Country.create(:code => 'BB', :title => 'Barbados')
Country.create(:code => 'BY', :title => 'Belarus')
Country.create(:code => 'BE', :title => 'Belgium')
Country.create(:code => 'BZ', :title => 'Belize')
Country.create(:code => 'BJ', :title => 'Benin')
Country.create(:code => 'BM', :title => 'Bermuda')
Country.create(:code => 'BT', :title => 'Bhutan')
Country.create(:code => 'BO', :title => 'Bolivia')
Country.create(:code => 'BA', :title => 'Bosnia and Herzegovina')
Country.create(:code => 'BW', :title => 'Botswana')
Country.create(:code => 'BR', :title => 'Brazil')
Country.create(:code => 'BN', :title => 'Brunei Darussalam')
Country.create(:code => 'BG', :title => 'Bulgaria')
Country.create(:code => 'BF', :title => 'Burkina Faso')
Country.create(:code => 'BI', :title => 'Burundi')
Country.create(:code => 'KH', :title => 'Cambodia')
Country.create(:code => 'CM', :title => 'Cameroon')
Country.create(:code => 'CA', :title => 'Canada', :active => true, :top_of_list => true)
Country.create(:code => 'CV', :title => 'Cape Verde')
Country.create(:code => 'KY', :title => 'Cayman Islands')
Country.create(:code => 'CF', :title => 'Central African Republic')
Country.create(:code => 'TD', :title => 'Chad')
Country.create(:code => 'CL', :title => 'Chile')
Country.create(:code => 'CN', :title => 'China')
Country.create(:code => 'CO', :title => 'Colombia')
Country.create(:code => 'KM', :title => 'Comoros')
Country.create(:code => 'CG', :title => 'Congo')
Country.create(:code => 'CD', :title => 'Congo, the Democratic Republic of the')
Country.create(:code => 'CK', :title => 'Cook Islands')
Country.create(:code => 'CR', :title => 'Costa Rica')
Country.create(:code => 'CI', :title => 'Cote D\'Ivoire')
Country.create(:code => 'HR', :title => 'Croatia')
Country.create(:code => 'CU', :title => 'Cuba')
Country.create(:code => 'CY', :title => 'Cyprus')
Country.create(:code => 'CZ', :title => 'Czech Republic')
Country.create(:code => 'DK', :title => 'Denmark')
Country.create(:code => 'DJ', :title => 'Djibouti')
Country.create(:code => 'DM', :title => 'Dominica')
Country.create(:code => 'DO', :title => 'Dominican Republic')
Country.create(:code => 'EC', :title => 'Ecuador')
Country.create(:code => 'EG', :title => 'Egypt')
Country.create(:code => 'SV', :title => 'El Salvador')
Country.create(:code => 'GQ', :title => 'Equatorial Guinea')
Country.create(:code => 'ER', :title => 'Eritrea')
Country.create(:code => 'EE', :title => 'Estonia')
Country.create(:code => 'ET', :title => 'Ethiopia')
Country.create(:code => 'FK', :title => 'Falkland Islands (Malvinas)')
Country.create(:code => 'FO', :title => 'Faroe Islands')
Country.create(:code => 'FJ', :title => 'Fiji')
Country.create(:code => 'FI', :title => 'Finland')
Country.create(:code => 'FR', :title => 'France')
Country.create(:code => 'GF', :title => 'French Guiana')
Country.create(:code => 'PF', :title => 'French Polynesia')
Country.create(:code => 'GA', :title => 'Gabon')
Country.create(:code => 'GM', :title => 'Gambia')
Country.create(:code => 'GE', :title => 'Georgia')
Country.create(:code => 'DE', :title => 'Germany')
Country.create(:code => 'GH', :title => 'Ghana')
Country.create(:code => 'GI', :title => 'Gibraltar')
Country.create(:code => 'GR', :title => 'Greece')
Country.create(:code => 'GL', :title => 'Greenland')
Country.create(:code => 'GD', :title => 'Grenada')
Country.create(:code => 'GP', :title => 'Guadeloupe')
Country.create(:code => 'GU', :title => 'Guam')
Country.create(:code => 'GT', :title => 'Guatemala')
Country.create(:code => 'GN', :title => 'Guinea')
Country.create(:code => 'GW', :title => 'Guinea-Bissau')
Country.create(:code => 'GY', :title => 'Guyana')
Country.create(:code => 'HT', :title => 'Haiti')
Country.create(:code => 'VA', :title => 'Holy See (Vatican City State)')
Country.create(:code => 'HN', :title => 'Honduras')
Country.create(:code => 'HK', :title => 'Hong Kong')
Country.create(:code => 'HU', :title => 'Hungary')
Country.create(:code => 'IS', :title => 'Iceland')
Country.create(:code => 'IN', :title => 'India')
Country.create(:code => 'ID', :title => 'Indonesia')
Country.create(:code => 'IR', :title => 'Iran, Islamic Republic of')
Country.create(:code => 'IQ', :title => 'Iraq')
Country.create(:code => 'IE', :title => 'Ireland')
Country.create(:code => 'IL', :title => 'Israel')
Country.create(:code => 'IT', :title => 'Italy')
Country.create(:code => 'JM', :title => 'Jamaica')
Country.create(:code => 'JP', :title => 'Japan')
Country.create(:code => 'JO', :title => 'Jordan')
Country.create(:code => 'KZ', :title => 'Kazakhstan')
Country.create(:code => 'KE', :title => 'Kenya')
Country.create(:code => 'KI', :title => 'Kiribati')
Country.create(:code => 'KP', :title => 'Korea, Democratic People\'s Republic of')
Country.create(:code => 'KR', :title => 'Korea, Republic of')
Country.create(:code => 'KW', :title => 'Kuwait')
Country.create(:code => 'KG', :title => 'Kyrgyzstan')
Country.create(:code => 'LA', :title => 'Lao People\'s Democratic Republic')
Country.create(:code => 'LV', :title => 'Latvia')
Country.create(:code => 'LB', :title => 'Lebanon')
Country.create(:code => 'LS', :title => 'Lesotho')
Country.create(:code => 'LR', :title => 'Liberia')
Country.create(:code => 'LY', :title => 'Libyan Arab Jamahiriya')
Country.create(:code => 'LI', :title => 'Liechtenstein')
Country.create(:code => 'LT', :title => 'Lithuania')
Country.create(:code => 'LU', :title => 'Luxembourg')
Country.create(:code => 'MO', :title => 'Macao')
Country.create(:code => 'MK', :title => 'Macedonia, the Former Yugoslav Republic of')
Country.create(:code => 'MG', :title => 'Madagascar')
Country.create(:code => 'MW', :title => 'Malawi')
Country.create(:code => 'MY', :title => 'Malaysia')
Country.create(:code => 'MV', :title => 'Maldives')
Country.create(:code => 'ML', :title => 'Mali')
Country.create(:code => 'MT', :title => 'Malta')
Country.create(:code => 'MH', :title => 'Marshall Islands')
Country.create(:code => 'MQ', :title => 'Martinique')
Country.create(:code => 'MR', :title => 'Mauritania')
Country.create(:code => 'MU', :title => 'Mauritius')
Country.create(:code => 'MX', :title => 'Mexico')
Country.create(:code => 'FM', :title => 'Micronesia, Federated States of')
Country.create(:code => 'MD', :title => 'Moldova, Republic of')
Country.create(:code => 'MC', :title => 'Monaco')
Country.create(:code => 'MN', :title => 'Mongolia')
Country.create(:code => 'MS', :title => 'Montserrat')
Country.create(:code => 'MA', :title => 'Morocco')
Country.create(:code => 'MZ', :title => 'Mozambique')
Country.create(:code => 'MM', :title => 'Myanmar')
Country.create(:code => 'NA', :title => 'Namibia')
Country.create(:code => 'NR', :title => 'Nauru')
Country.create(:code => 'NP', :title => 'Nepal')
Country.create(:code => 'NL', :title => 'Netherlands')
Country.create(:code => 'AN', :title => 'Netherlands Antilles')
Country.create(:code => 'NC', :title => 'New Caledonia')
Country.create(:code => 'NZ', :title => 'New Zealand')
Country.create(:code => 'NI', :title => 'Nicaragua')
Country.create(:code => 'NE', :title => 'Niger')
Country.create(:code => 'NG', :title => 'Nigeria')
Country.create(:code => 'NU', :title => 'Niue')
Country.create(:code => 'NF', :title => 'Norfolk Island')
Country.create(:code => 'MP', :title => 'Northern Mariana Islands')
Country.create(:code => 'NO', :title => 'Norway')
Country.create(:code => 'OM', :title => 'Oman')
Country.create(:code => 'PK', :title => 'Pakistan')
Country.create(:code => 'PW', :title => 'Palau')
Country.create(:code => 'PA', :title => 'Panama')
Country.create(:code => 'PG', :title => 'Papua New Guinea')
Country.create(:code => 'PY', :title => 'Paraguay')
Country.create(:code => 'PE', :title => 'Peru')
Country.create(:code => 'PH', :title => 'Philippines')
Country.create(:code => 'PN', :title => 'Pitcairn')
Country.create(:code => 'PL', :title => 'Poland')
Country.create(:code => 'PT', :title => 'Portugal')
Country.create(:code => 'PR', :title => 'Puerto Rico')
Country.create(:code => 'QA', :title => 'Qatar')
Country.create(:code => 'RE', :title => 'Reunion')
Country.create(:code => 'RO', :title => 'Romania')
Country.create(:code => 'RU', :title => 'Russian Federation')
Country.create(:code => 'RW', :title => 'Rwanda')
Country.create(:code => 'SH', :title => 'Saint Helena')
Country.create(:code => 'KN', :title => 'Saint Kitts and Nevis')
Country.create(:code => 'LC', :title => 'Saint Lucia')
Country.create(:code => 'PM', :title => 'Saint Pierre and Miquelon')
Country.create(:code => 'VC', :title => 'Saint Vincent and the Grenadines')
Country.create(:code => 'WS', :title => 'Samoa')
Country.create(:code => 'SM', :title => 'San Marino')
Country.create(:code => 'ST', :title => 'Sao Tome and Principe')
Country.create(:code => 'SA', :title => 'Saudi Arabia')
Country.create(:code => 'SN', :title => 'Senegal')
Country.create(:code => 'SC', :title => 'Seychelles')
Country.create(:code => 'SL', :title => 'Sierra Leone')
Country.create(:code => 'SG', :title => 'Singapore')
Country.create(:code => 'SK', :title => 'Slovakia')
Country.create(:code => 'SI', :title => 'Slovenia')
Country.create(:code => 'SB', :title => 'Solomon Islands')
Country.create(:code => 'SO', :title => 'Somalia')
Country.create(:code => 'ZA', :title => 'South Africa')
Country.create(:code => 'ES', :title => 'Spain')
Country.create(:code => 'LK', :title => 'Sri Lanka')
Country.create(:code => 'SD', :title => 'Sudan')
Country.create(:code => 'SR', :title => 'Suriname')
Country.create(:code => 'SJ', :title => 'Svalbard and Jan Mayen')
Country.create(:code => 'SZ', :title => 'Swaziland')
Country.create(:code => 'SE', :title => 'Sweden')
Country.create(:code => 'CH', :title => 'Switzerland')
Country.create(:code => 'SY', :title => 'Syrian Arab Republic')
Country.create(:code => 'TW', :title => 'Taiwan, Province of China')
Country.create(:code => 'TJ', :title => 'Tajikistan')
Country.create(:code => 'TZ', :title => 'Tanzania, United Republic of')
Country.create(:code => 'TH', :title => 'Thailand')
Country.create(:code => 'TG', :title => 'Togo')
Country.create(:code => 'TK', :title => 'Tokelau')
Country.create(:code => 'TO', :title => 'Tonga')
Country.create(:code => 'TT', :title => 'Trinidad and Tobago')
Country.create(:code => 'TN', :title => 'Tunisia')
Country.create(:code => 'TR', :title => 'Turkey')
Country.create(:code => 'TM', :title => 'Turkmenistan')
Country.create(:code => 'TC', :title => 'Turks and Caicos Islands')
Country.create(:code => 'TV', :title => 'Tuvalu')
Country.create(:code => 'UG', :title => 'Uganda')
Country.create(:code => 'UA', :title => 'Ukraine')
Country.create(:code => 'AE', :title => 'United Arab Emirates')
Country.create(:code => 'GB', :title => 'United Kingdom')
Country.create(:code => 'US', :title => 'United States', :active => true, :top_of_list => true)
Country.create(:code => 'UY', :title => 'Uruguay')
Country.create(:code => 'UZ', :title => 'Uzbekistan')
Country.create(:code => 'VU', :title => 'Vanuatu')
Country.create(:code => 'VE', :title => 'Venezuela')
Country.create(:code => 'VN', :title => 'Viet Nam')
Country.create(:code => 'VG', :title => 'Virgin Islands, British')
Country.create(:code => 'VI', :title => 'Virgin Islands, U.s.')
Country.create(:code => 'WF', :title => 'Wallis and Futuna')
Country.create(:code => 'EH', :title => 'Western Sahara')
Country.create(:code => 'YE', :title => 'Yemen')
Country.create(:code => 'ZM', :title => 'Zambia')
Country.create(:code => 'ZW', :title => 'Zimbabwe')

# provinces and states
country = Country.find_by_code("US")
Province.create :title => 'Alabama', :code => 'AL', :country_id => country.id
Province.create :title => 'Alaska', :code => 'AK', :country_id => country.id
Province.create :title => 'Arizona', :code => 'AZ', :country_id => country.id
Province.create :title => 'Arkansas', :code => 'AR', :country_id => country.id
Province.create :title => 'California', :code => 'CA', :country_id => country.id
Province.create :title => 'Colorado', :code => 'CO', :country_id => country.id
Province.create :title => 'Connecticut', :code => 'CT', :country_id => country.id
Province.create :title => 'Delaware', :code => 'DE', :country_id => country.id
Province.create :title => 'District of Columbia', :code => 'DC', :country_id => country.id
Province.create :title => 'Florida', :code => 'FL', :country_id => country.id
Province.create :title => 'Georgia', :code => 'GA', :country_id => country.id
Province.create :title => 'Hawaii', :code => 'HI', :country_id => country.id
Province.create :title => 'Idaho', :code => 'ID', :country_id => country.id
Province.create :title => 'Illinois', :code => 'IL', :country_id => country.id
Province.create :title => 'Indiana', :code => 'IN', :country_id => country.id
Province.create :title => 'Iowa', :code => 'IA', :country_id => country.id
Province.create :title => 'Kansas', :code => 'KS', :country_id => country.id
Province.create :title => 'Kentucky', :code => 'KY', :country_id => country.id
Province.create :title => 'Louisiana', :code => 'LA', :country_id => country.id
Province.create :title => 'Maine', :code => 'ME', :country_id => country.id
Province.create :title => 'Maryland', :code => 'MD', :country_id => country.id
Province.create :title => 'Massachutsetts', :code => 'MA', :country_id => country.id
Province.create :title => 'Michigan', :code => 'MI', :country_id => country.id
Province.create :title => 'Minnesota', :code => 'MN', :country_id => country.id
Province.create :title => 'Mississippi', :code => 'MS', :country_id => country.id
Province.create :title => 'Missouri', :code => 'MO', :country_id => country.id
Province.create :title => 'Montana', :code => 'MT', :country_id => country.id
Province.create :title => 'Nebraska', :code => 'NE', :country_id => country.id
Province.create :title => 'Nevada', :code => 'NV', :country_id => country.id
Province.create :title => 'New Hampshire', :code => 'NH', :country_id => country.id
Province.create :title => 'New Jersey', :code => 'NJ', :country_id => country.id
Province.create :title => 'New Mexico', :code => 'NM', :country_id => country.id
Province.create :title => 'New York', :code => 'NY', :country_id => country.id
Province.create :title => 'North Carolina', :code => 'NC', :country_id => country.id
Province.create :title => 'North Dakota', :code => 'ND', :country_id => country.id
Province.create :title => 'Ohio', :code => 'OH', :country_id => country.id
Province.create :title => 'Oklahoma', :code => 'OK', :country_id => country.id
Province.create :title => 'Oregon', :code => 'OR', :country_id => country.id
Province.create :title => 'Pennsylvania', :code => 'PA', :country_id => country.id
Province.create :title => 'Rhode Island', :code => 'RI', :country_id => country.id
Province.create :title => 'South Carolina', :code => 'SC', :country_id => country.id
Province.create :title => 'South Dakota', :code => 'SD', :country_id => country.id
Province.create :title => 'Tennessee', :code => 'TN', :country_id => country.id
Province.create :title => 'Texas', :code => 'TX', :country_id => country.id
Province.create :title => 'Utah', :code => 'UT', :country_id => country.id
Province.create :title => 'Vermont', :code => 'VT', :country_id => country.id
Province.create :title => 'Virginia', :code => 'VA', :country_id => country.id
Province.create :title => 'Washington', :code => 'WA', :country_id => country.id
Province.create :title => 'West Virginia', :code => 'WV', :country_id => country.id
Province.create :title => 'Wisconsin', :code => 'WI', :country_id => country.id
Province.create :title => 'Wyoming', :code => 'WY', :country_id => country.id

country = Country.find_by_code("CA")
Province.create :title => "Alberta", :code => "AB", :country_id => country.id
Province.create :title => "British Columbia", :code => "BC", :country_id => country.id
Province.create :title => "Manitoba", :code => "MB", :country_id => country.id
Province.create :title => "New Brunswick", :code => "NB", :country_id => country.id
Province.create :title => "Newfoundland and Labrador", :code => "NL", :country_id => country.id
Province.create :title => "Nova Scotia", :code => "NS", :country_id => country.id
Province.create :title => "Ontario", :code => "ON", :country_id => country.id
Province.create :title => "Prince Edward Island", :code => "PE", :country_id => country.id
Province.create :title => "Quebec", :code => "QC", :country_id => country.id
Province.create :title => "Saskatchewan", :code => "SK", :country_id => country.id
Province.create :title => "Northwest Territories", :code => "NT", :country_id => country.id
Province.create :title => "Nunavut", :code => "NU", :country_id => country.id
Province.create :title => "Yukon", :code => "YT", :country_id => country.id
