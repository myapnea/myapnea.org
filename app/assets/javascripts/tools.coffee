@toolsReady = () ->
  $("[data-object~='submit-risk-assessment']").click (e) ->
    submitRiskAssessment()

@submitRiskAssessment = () ->
  #### Check answers using the following syntax ####
  # console.log document.getElementById('gender_male').checked
  # console.log document.getElementById('gender_female').checked
  # console.log document.getElementById('age').value
  # console.log document.getElementById('feet').value
  # console.log document.getElementById('inches').value
  # console.log document.getElementById('weight').value
  # console.log document.getElementById('systolic').value
  # console.log document.getElementById('diastolic').value
  # console.log document.getElementById('snoring_yes').checked
  # console.log document.getElementById('snoring_no').checked
  # console.log document.getElementById('tiredness_yes').checked
  # console.log document.getElementById('tiredness_no').checked
  # console.log document.getElementById('observation_yes').checked
  # console.log document.getElementById('observation_no').checked
  # console.log document.getElementById('neck_yes').checked
  # console.log document.getElementById('neck_no').checked

  highbloodpressure = (document.getElementById('systolic').value > 140) and (document.getElementById('diastolic').value > 90)
  height = (document.getElementById('feet').value * 12) + parseInt(document.getElementById('inches').value)
  weight = document.getElementById('weight').value
  bmi = ( weight / Math.pow(height,2) ) * 703

  stop = { "s": 0, "t": 0, "o" : 0, "p" : 0 }
  stop["s"] = 1 if document.getElementById('snoring_yes').checked
  stop["t"] = 1 if document.getElementById('tiredness_yes').checked
  stop["o"] = 1 if document.getElementById('observation_yes').checked
  stop["p"] = 1 if highbloodpressure

  stop_score = 0
  for k of stop
    stop_score += stop[k]

  stopbang = stop
  stopbang["b"] = if bmi > 35 then 1 else 0
  stopbang["a"] = if document.getElementById('age').value > 50 then 1 else 0
  stopbang["n"] = if document.getElementById('neck_yes').checked then 1 else 0
  stopbang["g"] = if document.getElementById('gender_male').checked then 1 else 0

  stopbang_score = 0
  for k of stopbang
    stopbang_score += stopbang[k]

