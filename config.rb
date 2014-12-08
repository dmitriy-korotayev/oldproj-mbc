# Directories
#set :source, 'source'
set :data_dir, 'source/data'

set :partials_dir, 'partials'
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :fonts_dir, 'fonts'

# General config
set :relative_links, true
activate :relative_assets
activate :autoprefixer
# Fix slim error "Option :locals is not supported by Slim::Engine"
require 'slim'
Slim::Engine.disable_option_validator!
# Change Compass configuration
#compass_config do |config|
#  config.output_style = :compact
#end
# Automatic image dimensions on image_tag helper
#activate :automatic_image_sizes

if development? # v4 - server?
  #activate :directory_indexes
  set :debug_assets, true
  activate :livereload
end
if build?
  ignore 'images/sprites/*/*.png'
  ignore 'javascripts/vendor/*'
  ignore 'partials/*'
  
  #activate :minify_css
  #activate :minify_javascript

  # Enable cache buster
  #activate :asset_hash, ignore: ['projects', 'partners', 'custom.css']
end
helpers do
  # Asset existence
  #def partial
  #end
  def path
    current_page.path.sub(/#{current_page.ext}$/, '')
  end
  def asset_exists?(subdirectory, filename)
    File.exists?(File.join(root, 'source', subdirectory, filename))
  end
  def image_exists?(image)
    asset_exists?('images', image)
  end
  def javascript_exists?(script)
    extensions = %w(.coffee .erb .coffee.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || asset_exists?('javascripts', "#{script}.js#{extension}")
    end
  end
  def stylesheet_exists?(stylesheet)
    extensions = %w(.sass .erb .sass.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || asset_exists?('stylesheets', "#{stylesheet}.css#{extension}")
    end
  end
end
ready do # pages configuration
  page '/404.html', layout: false

  # With no layout
  #page "/path/to/file.html", :layout => false
  # With alternative layout
  #page "/path/to/file.html", :layout => :otherlayout
  # A path which all have the same layout
  #with_layout :admin do
  #  page "/admin/*"
  #end

  # Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
  #proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
  # :which_fake_page => "Rendering a fake page with a local variable" }
end
after_configuration do  
  bower_directory = 'bower_components'
  bower_directory = JSON.parse(IO.read("#{root}/.bowerrc"))["directory"] if File.exists? "#{root}/.bowerrc"
  bower_assets_path = File.join "#{root}", bower_directory
  sprockets.append_path bower_assets_path
end
