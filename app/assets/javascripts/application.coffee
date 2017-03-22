# This is a manifest file that'll be compiled into application.js, which will
# include all the files listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts,
# vendor/assets/javascripts, or any plugin's vendor/assets/javascripts directory
# can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at
# the bottom of the compiled file. JavaScript code in this file should be added
# after the last require_* statement.
#
# Read Sprockets README
# (https://github.com/rails/sprockets#sprockets-directives)
# for details about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require turbolinks
#= require jquery-ui/widgets/sortable

# Compatibility
#= require compatibility/array_prototype_index_of.js
#= require compatibility/array_prototype_map.js

# External
# `vendor/assets/javascripts`
#= require jquery.slimscroll
#= require jquery.PrintArea
#= require d3.min
#
#= require external/bootstrap-datepicker.js
#= require external/jquery-fieldselection.js
#= require external/highcharts-4.0.4.src.js
#= require external/highmaps-1.0.4-modules-map.src.js
#= require external/highmaps-1.0.4-modules-data.js
#= require external/us-all.js
#= require external/world.js
#= require external/jquery.color.min.js
#= require external/jquery.placeholder.js
#= require external/jquery.animate-shadow-min.js
#= require external/froogaloop2.min.js

# Extensions
#= require extensions/datepicker
#= require extensions/filedrag
#= require extensions/notouch
#= require extensions/recaptcha
#= require extensions/tooltips

# Other
#= require_tree .
