@toolsReady = () ->
  riskAssessmentReady() if document.getElementById('risk-assessment-container')
  bmiAHICalculatorReady() if document.getElementById('bmi-ahi-calculator')

feet_updated = false
inches_updated = false
weight_updated = false
@riskAssessmentReady = () ->

  ### Radio input clicks ###
  $('#risk-assessment-container .radio-container').click (event) ->
    $(this).find("input:radio").prop "checked", !$(this).find('input:radio').prop("checked")

  $(document)
    .on('click', '#risk-assessment-container', () ->
      $("[data-object~='submit-risk-assessment']").removeClass 'disabled' if checkRiskAssessmentCompletion()
    )
    .on('keydown', '#risk-assessment-container', () ->
      $("[data-object~='submit-risk-assessment']").removeClass 'disabled' if checkRiskAssessmentCompletion()
    )

  ### Submit ###
  $("[data-object~='submit-risk-assessment']").click (e) ->
    params = submitRiskAssessment()
    if params == false || checkRiskAssessmentCompletion() == false
      e.preventDefault()

  ### Track changes of BMI categories ###
  $("[data-object~='feet-input']").change (e) ->
    feet_updated = true
    outputBMI()
  $("[data-object~='inches-input']").change (e) ->
    inches_updated = true
    outputBMI()
  $("[data-object~='weight-input']").change (e) ->
    weight_updated = true
    outputBMI()

@updateSystolicRange = (val) ->
  document.getElementById('systolic').value = val

@updateSystolicLabel = (val) ->
  document.getElementById('systolic_label').value = val

@updateDiastolicRange = (val) ->
  document.getElementById('diastolic').value = val

@updateDiastolicLabel = (val) ->
  document.getElementById('diastolic_label').value = val


@submitRiskAssessment = () ->

  stop = { "s": 0, "t": 0, "o" : 0, "p" : 0 }
  stop["s"] = 1 if document.getElementById('snoring_yes').checked
  stop["t"] = 1 if document.getElementById('tiredness_yes').checked
  stop["o"] = 1 if document.getElementById('observation_yes').checked
  stop["p"] = 1 if document.getElementById('hbp_yes').checked

  stop_score = 0
  for k of stop
    stop_score += stop[k]

  bmi = calculateBMI()
  male = document.getElementById('gender_male').checked
  largeNeck = document.getElementById('neck_yes').checked

  stopbang = stop
  stopbang["b"] = if bmi > 35 then 1 else 0
  stopbang["a"] = if document.getElementById('age').value > 50 then 1 else 0
  stopbang["n"] = if largeNeck then 1 else 0
  stopbang["g"] = if male then 1 else 0

  stopbang_score = 0
  for k of stopbang
    stopbang_score += stopbang[k]

  return [stop_score, stopbang_score, male, bmi, largeNeck]

@calculateBMI = () ->
  height = (document.getElementById('feet').value * 12) + parseInt(document.getElementById('inches').value)
  weight = document.getElementById('weight').value
  return ( weight / Math.pow(height,2) ) * 703

@outputBMI = () ->
  if feet_updated and inches_updated and weight_updated
    document.getElementById('stopbang-bmi-output').innerHTML = Math.round(calculateBMI() * 100)/100

@checkRiskAssessmentCompletion = () ->
  return (document.getElementById('gender_male').checked || document.getElementById('gender_female').checked) &&
  document.getElementById('age').value.length!=0 &&
  document.getElementById('feet').value.length!=0 &&
  document.getElementById('inches').value.length!=0 &&
  document.getElementById('weight').value.length!=0 &&
  (document.getElementById('hbp_yes').checked || document.getElementById('hbp_no').checked) &&
  (document.getElementById('observation_yes').checked || document.getElementById('observation_no').checked) &&
  (document.getElementById('tiredness_yes').checked || document.getElementById('tiredness_no').checked) &&
  (document.getElementById('snoring_yes').checked || document.getElementById('snoring_no').checked) &&
  (document.getElementById('neck_yes').checked || document.getElementById('neck_no').checked)