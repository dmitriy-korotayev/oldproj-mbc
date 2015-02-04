module.exports = (grunt) ->

  require("jit-grunt") grunt

  # Configuration
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    compass:
      options:
        config: '/dev/null'
        sassDir: 'grunt/stylesheets'
        cssDir: 'middleman/stylesheets'
        imagesDir: 'middleman/images'
        fontsDir: 'middleman/fonts'
        importPath: 'bower_components'
        relativeAssets: true
        trace: true
      dev:
        options:
          watch: true
          sourcemap: true
      dist:
        options:
          environment: 'production'
          #outputStyle: 'compressed'
    middleman:
      options:
        useBundle: true
      server:
        options:
          command: "server"
      build:
        options:
          command: "build"
  

  # Default task on running `grunt`
  grunt.registerTask "default", ["dev"]
  # Tasks
  grunt.registerTask "dev", [
    "middleman:server"
  ]
  #grunt.registerTask "s",       ["middleman:server"]
  #grunt.registerTask "server",  ["middleman:server"]
  grunt.registerTask "b",       ["middleman:build"]
  grunt.registerTask "build",   ["middleman:build"]

# Samples
#module.exports = (grunt) ->
  
  ## Require it at the top and pass in the grunt instance
  #require("jit-grunt") grunt,
    #scsslint: "grunt-scss-lint"

  #require("time-grunt") grunt
  #grunt.option "port", 9002 if !grunt.option("port")
  #grunt.option "livereload-port", grunt.option("port") + 1 if !grunt.option("livereload-port")
  
  ## All configuration goes here 
  #grunt.initConfig
    #pkg: grunt.file.readJSON("package.json")
    
    ## Accessibility Configuration
    #accessibility:
      #options:
        #accessibilityLevel: "WCAG2A"
        #verbose: true

      #all:
        #files: [
          #cwd: "build/"
          #dest: "reports/"
          #expand: true
          #ext: "-report.txt"
          #src: ["*.html"]
        #]

    
    ## Configuration for assemble
    #assemble:
      #options:
        #data: "source/assemble/data/**/*.{json,yml}"
        #helpers: [
          #"handlebars-helper-partial"
          #"source/assemble/helpers/**/*.js"
        #]
        #layoutdir: "source/assemble/layouts/"
        #partials: [
          #"source/assemble/partials/**/*.hbs"
          #"tmp/icon-sprite.svg"
        #]

      #dev:
        #options:
          #production: false

        #files: [
          #cwd: "source/assemble/pages/"
          #dest: "build/"
          #expand: true
          #flatten: true
          #src: ["**/*.hbs"]
        #]

      #dist:
        #options:
          #data: "tmp/gitinfos.json"
          #production: true

        #files: [
          #cwd: "source/assemble/pages/"
          #dest: "dist/"
          #expand: true
          #flatten: true
          #src: ["**/*.hbs"]
        #]

    
    ## Configuration for autoprefixer
    #autoprefixer:
      #options:
        #browsers: [
          #"last 2 versions"
          #"ie 9"
        #]

      #dev:
        #options:
          #map: true

        #src: "build/css/*.css"

      #dist:
        #src: "dist/css/*.css"

    
    ## Configuration for deleting files
    #clean:
      #dev:
        #files: [src: ["build"]]

      #dist:
        #files: [src: ["dist"]]

      #docs:
        #dist: ["jsdocs/**/*"]

      #tmp:
        #files: [src: ["tmp"]]

    
    ## Configuration for concatenating js files
    #concat:
      #options:
        #separator: ";"

      #dev:
        #dest: "build/js/main.js"
        #src: [
          #"bower_components/requirejs/require.js"
          #"source/js/_requireconfig.js"
        #]

      #dist:
        #dest: "dist/js/main.js"
        #src: [
          #"bower_components/requirejs/require.js"
          #"source/js/_requireconfig.js"
          #"tmp/main.js"
        #]

    
    ## Configuration for run tasks concurrently
    #concurrent:
      #dev1: [
        #"grunticon:dev"
        #"imagemin:dev"
      #]
      #dev2: [
        #"sass:dev"
        #"assemble:dev"
        #"modernizr"
      #]
      #dist: [
        #"grunticon:dist"
        #"imagemin:dist"
      #]

    
    ## Configuration for livereload
    #connect:
      #livereload:
        #options:
          #base: "build"
          #hostname: "0.0.0.0"
          #port: grunt.option("port")
          #middleware: (connect, options) ->
            #grunt.log.writeln ""
            #grunt.log.writeln "Launching webserver now:"
            #grunt.log.writeln " - index at http://0.0.0.0:" + grunt.option("port") + "/"
            #grunt.log.writeln ""
            #[
              #require("connect-livereload")(port: grunt.option("livereload-port"))
              #connect.static(options.base)
              #connect.directory(options.base)
            #]

        #files:
          #src: ["*/*.html"]

    
    ## Configuration for copying files
    #copy:
      #ajax:
        #cwd: "source/ajax-content/"
        #dest: "dist/ajax-content/"
        #expand: true
        #src: ["**/*"]

      #bower_components:
        #cwd: "bower_components/"
        #dest: "dist/bower_components/"
        #expand: true
        #src: ["**/*"]

      #favicon:
        #cwd: "source/img/appicons/"
        #dest: "dist/img/appicons/"
        #expand: true
        #src: ["**/*.ico"]

      #fonts:
        #cwd: "source/fonts/"
        #dest: "dist/fonts/"
        #expand: true
        #src: ["**/*"]

      #js:
        #cwd: "source/js/"
        #dest: "dist/js/"
        #expand: true
        #src: ["**/*"]

      #modernizr:
        #cwd: "tmp/"
        #dest: "dist/js/"
        #expand: true
        #src: ["modernizr.js"]

      #styleguide:
        #cwd: "build/css/"
        #dest: "styleguide/css/"
        #expand: true
        #filter: "isFile"
        #flatten: true
        #src: ["**/*.css"]

    
    ## Configuration for minifying css-files
    #cssmin:
      #dist:
        #cwd: "dist/css/"
        #dest: "dist/css/"
        #expand: true
        #src: ["*.css"]

    
    ## Configuration for splitting css-files (e.g. IE9)
    #csssplit:
      #options:
        #maxRules: 500
        #suffix: "-part"

      #dev:
        #dest: "build/css"
        #src: "build/css/styles.css"

      #dist:
        #dest: "dist/css"
        #src: "dist/css/styles.css"

    
    ## Configuration for writing index files of directory contents (sass-globbing alernative for libsass)
    #fileindex:
      #globbing:
        #options:
          #format: (list, options, dest) ->
            #i = 0
            #imports = []
            #i
            #while i < list.length
              #listEl = list[i]
              #listElName = listEl.replace(/_([^_]*)$/, "" + "$1").replace(/\.scss|\.sass/g, "")
              #imports += "@import \"" + listElName + "\";\n"
              #i++
            #"//\n// List of all SASS imports\n// (automatically created by fileindex)\n// \n// No need to add your sass partials manually! ;)\n// \n\n" + imports

        #files: [
          #cwd: "source/sass/"
          #dest: "source/sass/styles.scss"
          #src: [
            
            ## Webfonts
            #"_webfonts.scss"
            
            ## Browser-Reset
            #"_reset.scss"
            
            ## SASS Variables
            #"variables/**/*.scss"
            
            ## nikita.css Mixins
            #"../../bower_components/nikita.css/mixins/_centering.scss"
            #"../../bower_components/nikita.css/mixins/_fixed-ratiobox.scss"
            #"../../bower_components/nikita.css/mixins/_font-smoothing.scss"
            #"../../bower_components/nikita.css/mixins/_layering.scss"
            #"../../bower_components/nikita.css/mixins/_px-to-rem.scss"
            #"../../bower_components/nikita.css/mixins/_respond-to.scss"
            #"../../bower_components/nikita.css/mixins/_triangle.scss"
            
            ## SASS Mixins
            #"mixins/**/*.scss"
            
            ## nikita.css Extends
            #"../../bower_components/nikita.css/extends/_a11y.scss"
            #"../../bower_components/nikita.css/extends/_cf.scss"
            #"../../bower_components/nikita.css/extends/_ellipsis.scss"
            #"../../bower_components/nikita.css/extends/_hide-text.scss"
            #"../../bower_components/nikita.css/extends/_ib.scss"
            
            ## SASS Extends
            #"extends/**/*.scss"
            
            ## SVG Background Extends
            #"svg-bg-extends/**/*.scss"
            
            ## Basic Formatting
            #"_basics.scss"
            
            ## Blocks
            #"blocks/**/*.scss"
          #]
        #]

    
    ## Configuration for gitinfo (will be populated with values from Git)
    #gitinfo: {}
    
    ## Configuration for grouping media queries
    #group_css_media_queries:
      #dist:
        #files:
          #"dist/css/styles.css": ["dist/css/styles.css"]

    
    ## Configuration for managing SVG-icons
    #grunticon:
      #options:
        #cssprefix: "%icon-"
        #datapngcss: "_icons-data-png.scss"
        #datasvgcss: "_icons-data-svg.scss"
        #urlpngcss: "_icons-fallback.scss"
        #tmpDir: "tmp/grunticon-tmp"

      #dev:
        #options:
          #pngfolder: "../../../build/img/bgs/png-fallback"
          #loadersnippet: "../../../tmp/grunticon/grunticon-loader.js" # we don't need this!
          #previewhtml: "../../../tmp/grunticon/preview.html" # we don't need this!

        #files: [
          #cwd: "tmp/svgmin/bgs"
          #dest: "source/sass/grunticon"
          #expand: true
          #src: ["*.svg"]
        #]

      #dist:
        #options:
          #pngfolder: "../../../dist/img/bgs/png-fallback"
          #loadersnippet: "../../../tmp/grunticon/grunticon-loader.js" # we don't need this!
          #previewhtml: "../../../tmp/grunticon/preview.html" # we don't need this!

        #files: [
          #cwd: "tmp/svgmin/bgs"
          #dest: "source/sass/grunticon"
          #expand: true
          #src: ["*.svg"]
        #]

    
    ## Configuration for validating html-files
    #htmlhint:
      #options:
        #force: true
        #"attr-lowercase": false # set to false because of svg-attribute 'viewBox'
        #"attr-value-double-quotes": true
        #"attr-value-not-empty": true
        #"doctype-first": true
        #"doctype-html5": true
        #"id-class-value": true
        #"id-unique": true
        #"img-alt-require": true
        #"spec-char-escape": true
        #"src-not-empty": true
        #"style-disabled": true
        #"tag-pair": true
        #"tag-self-close": true
        #"tagname-lowercase": true

      #all:
        #src: [
          #"*/*.html"
          #"!jsdocs/**/*.html"
          #"!styleguide/**/*.html"
        #]

    
    ## Configuration for optimizing image-files
    #imagemin:
      #options:
        #optimizationLevel: 7

      #dev:
        #files: [
          #cwd: "source/img/"
          #dest: "build/img/"
          #expand: true
          #src: ["**/*.{jpg,png,gif}"]
        #]

      #dist:
        #files: [
          #cwd: "source/img/"
          #dest: "dist/img/"
          #expand: true
          #src: ["**/*.{jpg,png,gif}"]
        #]

    
    ## Configuration for documenting js-files
    #jsdoc:
      #all:
        #options:
          #destination: "jsdocs"

        #src: [
          #"source/js/modules/**/*.js"
          #"source/js/README.md"
        #]

    
    ## Configuration for validating js-files
    #jshint:
      #options:
        #force: true
        #asi: false
        #bitwise: false
        #boss: true
        #browser: true
        #curly: false
        #eqeqeq: false
        #eqnull: true
        #evil: false
        #forin: true
        #immed: false
        #indent: 4
        #jquery: true
        #laxbreak: true
        #maxerr: 50
        #newcap: false
        #noarg: true
        #noempty: false
        #nonew: false
        #nomen: false
        #onevar: false
        #plusplus: false
        #regexp: false
        #undef: false
        #sub: true
        #strict: false
        #white: false

      #all:
        #options:
          #"-W015": true
          #"-W089": true

        #src: ["source/js/**/*.js"]

    
    ## Modernizr configuration
    #modernizr:
      #all:
        #customTests: ["source/js/modernizr/*.js"]
        #devFile: "remote"
        #files:
          #src: [
            #"source/**/*.js"
            #"source/**/*.scss"
          #]

        #outputFile: "tmp/modernizr.js"
        #uglify: false

    
    ## Configuration for pagespeed
    #pagespeed:
      #options:
        #nokey: true
        #url: "http://yoursite.com"

      #prod:
        #options:
          #locale: "de_DE"
          #strategy: "desktop"
          #threshold: 80
          #url: "http://yoursite.com"

      #paths:
        #options:
          #locale: "de_DE"
          #paths: [
            #"/yourpage1.html"
            #"/yourpage2.html"
          #]
          #strategy: "desktop"
          #threshold: 80

    
    ## Configuration for measuring frontend performance
    #phantomas:
      #all:
        #options:
          #indexPath: "reports/performance/"
          #numberOfRuns: 10
          #url: "http://0.0.0.0:" + grunt.option("port") + "/"

    
    ## Configuration for photobox
    #photobox:
      #all:
        #options:
          #indexPath: "reports/screenshots/"
          #screenSizes: [
            #"320"
            #"568"
            #"768"
            #"1024"
            #"1280"
          #]
          #urls: ["http://0.0.0.0:" + grunt.option("port") + "/index.html"]

    
    ## Configuration for prettifying the html-code generated by assemble
    #prettify:
      #options:
        #condense: false
        #indent: 1
        #indent_char: "\t"
        #indent_inner_html: false
        #max_preserve_newlines: 1
        #preserve_newlines: true
        #unformatted: [
          #"a"
          #"b"
          #"code"
          #"em"
          #"i"
          #"mark"
          #"strong"
          #"pre"
        #]

      #dev:
        #options:
          #brace_style: "expand"

        #files: [
          #cwd: "build/"
          #dest: "build/"
          #expand: true
          #ext: ".html"
          #src: ["*.html"]
        #]

      #dist:
        #options:
          #brace_style: "collapse"

        #files: [
          #cwd: "dist/"
          #dest: "dist/"
          #expand: true
          #ext: ".html"
          #src: ["*.html"]
        #]

    
    ## Configuration for requirejs
    #requirejs:
      #compile:
        #options:
          #baseUrl: "source/js/"
          #mainConfigFile: "source/js/_requireconfig.js"
          #out: "tmp/main.js"

    
    ## Configuration for SASS
    #sass:
      #dev:
        #options:
          #outputStyle: "nested"
          #sourceMap: true

        #files:
          #"build/css/styles.css": "source/sass/styles.scss"
          #"build/css/universal.css": "source/sass/universal.scss"

      #dist:
        #options:
          #outputStyle: "nested" # minifying by cssmin-task
          #sourceMap: false

        #files:
          #"dist/css/styles.css": "source/sass/styles.scss"
          #"dist/css/universal.css": "source/sass/universal.scss"

    
    ## Configuration for SCSS linting
    #scsslint:
      #allFiles: ["source/sass/{blocks,extends,mixins,variables,styles.scss,_*.scss}"]
      #options:
        #colorizeOutput: true
        #compact: true
        #config: ".scss-lint.yml"
        #force: true

    
    ## Configuration for string-replacing the grunticon output
    #"string-replace":
      #"grunticon-datasvg":
        #files:
          #"source/sass/svg-bg-extends/_bg-data-svg.scss": "source/sass/grunticon/_icons-data-svg.scss"

        #options:
          #replacements: [
            #pattern: /%icon-/g
            #replacement: "%bg-data-svg-"
          #]

      #"grunticon-datapng":
        #files:
          #"source/sass/svg-bg-extends/_bg-data-png.scss": "source/sass/grunticon/_icons-data-png.scss"

        #options:
          #replacements: [
            #pattern: /%icon-/g
            #replacement: "%bg-data-png-"
          #]

      #"grunticon-fallback":
        #files:
          #"source/sass/svg-bg-extends/_bg-fallback.scss": "source/sass/grunticon/_icons-fallback.scss"

        #options:
          #replacements: [
            #pattern: /%icon-/g
            #replacement: "%bg-fallback-"
          #]

    
    ## Configuration for the styleguide output
    #styleguide:
      #options:
        #framework:
          #name: "kss"

        #name: "Style Guide"
        #tmplate:
          #src: "source/styleguide-template/"

      #all:
        #files: [styleguide: "source/sass/blocks/**/*.scss"]

    
    ## Configuration for optimizing SVG-files
    #svgmin:
      #options:
        #plugins: [
          #{
            #cleanupAttrs: true
          #}
          #{
            #cleanupEnableBackground: true
          #}
          #{
            #cleanupIDs: true
          #}
          #{
            #cleanupNumericValues: true
          #}
          #{
            #collapseGroups: true
          #}
          #{
            #convertColors: true
          #}
          #{
            #convertPathData: true
          #}
          #{
            #convertShapeToPath: true
          #}
          #{
            #convertStyleToAttrs: true
          #}
          #{
            #convertTransform: true
          #}
          #{
            #mergePaths: true
          #}
          #{
            #moveElemsAttrsToGroup: true
          #}
          #{
            #moveGroupAttrsToElems: true
          #}
          #{
            #removeComments: true
          #}
          #{
            #removeDoctype: true
          #}
          #{
            #removeEditorsNSData: true
          #}
          #{
            #removeEmptyAttrs: true
          #}
          #{
            #removeEmptyContainers: true
          #}
          #{
            #removeEmptyText: true
          #}
          #{
            #removeHiddenElems: true
          #}
          #{
            #removeMetadata: true
          #}
          #{
            #removeNonInheritableGroupAttrs: true
          #}
          #{
            #removeRasterImages: true
          #}
          #{
            #removeTitle: true
          #}
          #{
            #removeUnknownsAndDefaults: true
          #}
          #{
            #removeUnusedNS: true
          #}
          #{
            #removeUselessStrokeAndFill: false # Enabling this may cause small details to be removed
          #}
          #{
            #removeViewBox: false # Keep the viewBox because that's where illustrator hides the SVG dimensions
          #}
          #{
            #removeXMLProcInst: false # Enabling this breaks grunticon because it removes the XML header
          #}
          #{
            #sortAttrs: true
          #}
          #{
            #transformsWithOnePath: false # Enabling this breaks Illustrator SVGs with complex text
          #}
        #]

      #dev_bg:
        #files: [
          #cwd: "source/img/bgs"
          #dest: "tmp/svgmin/bgs"
          #expand: true
          #ext: ".svg"
          #src: ["*.svg"]
        #]

      #dev_ico:
        #files: [
          #cwd: "source/img/icons"
          #dest: "tmp/svgmin/icons"
          #expand: true
          #ext: ".svg"
          #src: ["*.svg"]
        #]

      #dist_bg:
        #files: [
          #cwd: "source/img/bgs"
          #dest: "tmp/svgmin/bgs"
          #expand: true
          #ext: ".svg"
          #src: ["*.svg"]
        #]

      #dist_ico:
        #files: [
          #cwd: "source/img/icons"
          #dest: "tmp/svgmin/icons"
          #expand: true
          #ext: ".svg"
          #src: ["*.svg"]
        #]

    
    ## Configuration for building the SVG-sprite
    #svgstore:
      #options:
        #prefix: "icon-"
        #formatting:
          #indent_char: "\t"
          #indent_size: 1

        #svg:
          #style: "display: none;"

      #dev:
        #files:
          #"tmp/icon-sprite.svg": ["tmp/svgmin/icons/*.svg"]

      #dist:
        #files:
          #"tmp/icon-sprite.svg": ["tmp/svgmin/icons/*.svg"]

    
    ## Configuration for syncing files
    ## Task does not remove any files and directories in 'dest' that are no longer in 'cwd'. :'(
    #sync:
      #ajax:
        #files: [
          #cwd: "source/ajax-content/"
          #dest: "build/ajax-content/"
          #src: "**/*"
        #]

      #favicon:
        #files: [
          #cwd: "source/img/"
          #dest: "build/img/"
          #src: "**/*.ico"
        #]

      #fonts:
        #files: [
          #cwd: "source/fonts/"
          #dest: "build/fonts/"
          #src: "**/*"
        #]

      #js:
        #files: [
          #cwd: "source/js/"
          #dest: "build/js/"
          #src: [
            #"**/*"
            #"!_requireconfig.js"
          #]
        #]

      #modernizr:
        #files: [
          #cwd: "tmp/"
          #dest: "build/js/"
          #src: "modernizr.js"
        #]

    
    ## Configuration for uglifying JS
    #uglify:
      #dist:
        #options:
          #compress:
            #drop_console: true

        #files: [
          #cwd: "dist/js"
          #dest: "dist/js"
          #expand: true
          #src: [
            #"**/*.js"
            #"!**/_*.js"
          #]
        #]

    
    ## Configuration for symlink files
    #symlink:
      #options:
        #overwrite: false

      #dev:
        #src: "bower_components/"
        #dest: "build/bower_components/"

    
    ## Configuration for watching changes
    #watch:
      #options:
        #livereload: grunt.option("livereload-port")
        #spawn: true

      #scss:
        #files: ["source/sass/**/*.scss"]
        #tasks: [
          #"sass:dev"
          #"autoprefixer:dev"
          #"csssplit:dev"
        #]
        #options:
          #debounceDelay: 0
          #livereload: false

      #images:
        #files: [
          #"source/img/*"
          #"source/img/**/*.{jpg,png,gif}"
          #"!source/img/dev/*"
        #]
        #tasks: ["newer:imagemin:dev"]

      #svg_bgs:
        #files: ["source/img/bgs/*.svg"]
        #tasks: [
          #"newer:svgmin:dev_bg"
          #"grunticon:dev"
          #"string-replace"
        #]

      #svg_icons:
        #files: ["source/img/icons/*.svg"]
        #tasks: [
          #"newer:svgmin:dev_ico"
          #"svgstore:dev"
          #"newer:assemble:dev"
        #]

      #sync_ajax:
        #files: ["source/ajax-content/**/*"]
        #tasks: ["sync:ajax"]

      #sync_fonts:
        #files: ["source/fonts/**/*"]
        #tasks: ["sync:fonts"]

      #sync_js:
        #files: [
          #"source/js/**/*"
          #"!source/js/_requireconfig.js"
        #]
        #tasks: [
          #"modernizr"
          #"sync:js"
        #]

      #sync_requirejs:
        #files: ["source/js/_requireconfig.js"]
        #tasks: [
          #"modernizr"
          #"requirejs"
          #"concat:dev"
        #]

      #templates:
        #files: ["source/assemble/**/*.{json,hbs}"]
        #tasks: [
          #"newer:assemble:dev"
          #"prettify:dev"
        #]

  
  ## Where we tell Grunt we plan to use this plug-in.
  ## done by jit-grunt plugin loader
  
  ## Where we tell Grunt what to do when we type "grunt" into the terminal.
  
  ## Default -> Standard Build task
  #grunt.registerTask "default", ["build"]
  
  ## Development task
  #grunt.registerTask "dev", [
    #"clean:dev"
    #"clean:tmp"
    #"svgmin:dev_bg"
    #"svgmin:dev_ico"
    #"svgstore:dev"
    #"concurrent:dev1"
    #"string-replace"
    #"fileindex"
    #"concurrent:dev2"
    #"autoprefixer:dev"
    #"csssplit:dev"
    #"symlink:dev"
    #"concat:dev"
    #"sync"
    #"prettify:dev"
  #]
  
  ## Build task
  #grunt.registerTask "build", [
    #"dev"
    #"connect:livereload"
    #"watch"
  #]
  
  ## Distributing task
  #grunt.registerTask "dist", [
    #"clean:dist"
    #"clean:tmp"
    #"clean:docs"
    #"svgmin:dist_bg"
    #"svgmin:dist_ico"
    #"svgstore:dist"
    #"concurrent:dist"
    #"string-replace"
    #"fileindex"
    #"sass:dist"
    #"gitinfo"
    #"write-gitinfos"
    #"assemble:dist"
    #"modernizr"
    #"autoprefixer:dist"
    #"csssplit:dist"
    #"group_css_media_queries"
    #"cssmin"
    #"requirejs"
    #"concat:dist"
    #"copy:ajax"
    #"copy:bower_components"
    #"copy:favicon"
    #"copy:fonts"
    #"copy:js"
    #"copy:modernizr"
    #"uglify"
    #"prettify:dist"
  #]
  
  ## Gitinfos task
  #grunt.registerTask "write-gitinfos", "Write gitinfos to a temp. file", ->
    #grunt.task.requires "gitinfo"
    #grunt.file.write "tmp/gitinfos.json", JSON.stringify(gitinfo: grunt.config("gitinfo"))
    #return

  
  ## HTMLHint task
  #grunt.registerTask "check-html", ["htmlhint"]
  
  ## SCSSLint task
  #grunt.registerTask "check-scss", ["scsslint"]
  
  ## JSHint task
  #grunt.registerTask "check-js", ["jshint"]
  
  ## Accessibility task
  #grunt.registerTask "check-wcag2", ["accessibility"]
  
  ## Pagespeed task
  #grunt.registerTask "measure-pagespeed", ["pagespeed"]
  
  ## Phantomas task
  #grunt.registerTask "measure-performance", [
    #"dev"
    #"connect:livereload"
    #"phantomas"
  #]
  
  ## Photobox task
  #grunt.registerTask "take-screenshots", [
    #"dev"
    #"connect:livereload"
    #"photobox"
  #]
  
  ## Styleguide task
  #grunt.registerTask "build-styleguide", [
    #"styleguide"
    #"copy:styleguide"
  #]
  
  ## JSDoc task
  #grunt.registerTask "build-jsdoc", ["jsdoc"]
  #return
