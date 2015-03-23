@surveyReportsReady = () ->
  if $("[data-object~='d3-report']").length > 0
    healthConditionsReady() if $("[data-question~='health-conditions']").length > 0
    maritalStatusReady() if $("[data-question~='marital-status']").length > 0
    dailyActivitiesReady() if $("[data-question~='daily-activities']").length > 0
    difficultyPayingBasicsReady() if $("[data-question~='difficulty-paying-basics']").length > 0
    healthRatingReady() if $("[data-question~='health-rating']").length > 0
    healthImprovementReady() if $("[data-question~='health-improvement']").length > 0
    qolRatingReady() if $("[data-question~='qol-rating']").length > 0
    ageOfDiagnosisReady() if $("[data-question~='age-of-diagnosis']").length > 0





@randomBlue = () ->
  rBase = 89
  gBase = 153
  bBase = 222
  rNew = rBase + Math.pow(-1, 100)*Math.floor(Math.random()*50)
  gNew = gBase + Math.pow(-1, 100)*Math.floor(Math.random()*50)
  bNew = bBase + Math.pow(-1, 100)*Math.floor(Math.random()*50)
  color = "rgb("+rNew+","+gNew+","+bNew+")"

@randomOrange = () ->
  rBase = 255
  gBase = 164
  bBase = 0
  rNew = rBase + Math.pow(-1, 100)*Math.floor(Math.random()*50)
  gNew = gBase + Math.pow(-1, 100)*Math.floor(Math.random()*50)
  bNew = bBase + Math.pow(-1, 100)*Math.floor(Math.random()*50)
  color = "rgb("+rNew+","+gNew+","+bNew+")"
