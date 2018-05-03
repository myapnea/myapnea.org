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
#= require jquery3
#= require jquery_ujs
#= require turbolinks
#= require popper
#= require bootstrap
#= require jquery-ui/widgets/sortable

# Compatibility
#= require compatibility/array_prototype_index_of.js
#= require compatibility/array_prototype_map.js

# External
#= require external/bootstrap-datepicker.js
#= require external/froogaloop2.min.js
#= require external/jquery-fieldselection.js
#= require external/highcharts-6.0.3.src.js

# Extensions
#= require extensions/datepicker
#= require extensions/filedrag
#= require extensions/notouch
#= require extensions/recaptcha
#= require extensions/tooltips

# Other
#= require_tree .
