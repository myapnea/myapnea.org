@surveyReportsReady = () ->
  if $("[data-object~='d3-report']").length > 0
    healthConditionsReady() if $("[data-question~='health-conditions']").length > 0
    maritalStatusReady() if $("[data-question~='marital-status']").length > 0


