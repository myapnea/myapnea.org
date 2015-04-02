feet_updated = false
inches_updated = false
current_weight_updated = false
@bmiAHICalculatorReady = () ->
  $(document).on 'change', '#my-height-feet', () ->
    feet_updated = true
    calculate_bmi()
  $(document).on 'change', '#my-height-inches', () ->
    inches_updated = true
    calculate_bmi()
  $(document).on 'change', '#my-weight', () ->
    current_weight_updated = true
    calculate_bmi()
  $(document).on 'change', '#desired-weight', () ->
    # CALCULATE OUTPUT
    output_BMI_changes()

  $(document).on 'click', "[data-object~='calculate-minimum-weight']", () ->
    $("#desired-weight").val minimum_healthy_weight(calculate_height(), calculate_bmi())
    # CALCULATE OUTPUT
    output_BMI_changes()


output_BMI_changes = () ->
  old_BMI = get_bmi(calculate_height(), parseFloat($("#my-weight").val()))
  new_BMI = get_bmi(calculate_height(), parseFloat($("#desired-weight").val()))
  $("#predicted-bmi").html(new_BMI)
  $("#bmi-change-result-text").removeClass 'hidden'
  $("#bmi-change-result-custom-text").html(determine_result_description(calculate_BMI_category(old_BMI), calculate_BMI_category(new_BMI)))

calculate_height = () ->
  height_feet = parseFloat($("#my-height-feet").val())
  height_inches = parseFloat($("#my-height-inches").val())
  return height_feet * 12 + height_inches

calculate_bmi = () ->
  height = calculate_height()
  weight = parseFloat($("#my-weight").val())

  $("#bmi").html(get_bmi(height, weight))
  $("#weight").html(weight + " pounds")
  $("#bmi").data('bmi', get_bmi(height, weight))
  $("#current-weight").data("weight", weight)
  $("#current-weight").html(weight + " pounds")

  # If all data is entered, show the BMI graph, the AHI graph,
  # and autocomplete necessary weight for healthy BMI (if applicable)
  if feet_updated and inches_updated and current_weight_updated
    output_BMI()
  return get_bmi(height,weight)

output_BMI = () ->
  $('#bmi-graph svg.chart').html("")
  draw_bmi_graph()
  $("#bmi-ahi-results-container").removeClass "hidden"

get_bmi = (height, weight) ->
  Math.round((weight / (height ** 2)) * 703)

minimum_healthy_weight = (height, bmi) ->
  desired_bmi = calculate_desired_BMI(bmi)
  if desired_bmi==bmi
    return parseFloat($("#my-weight").val())
  else
    Math.round(desired_bmi * (height ** 2) / 703)


calculate_desired_BMI = (bmi) ->
  if bmi < 18.5
    return 19
  else if bmi < 25
    return bmi
  else if bmi < 30
    return 24.4
  else
    return 29.4

calculate_BMI_category = (bmi) ->
  if bmi < 18.5
    return "Underweight"
  else if bmi < 25
    return "Normal weight"
  else if bmi < 30
    return "Overweight"
  else
    return "Obese"

determine_result_description = (bmiC1, bmiC2) ->
  if bmiC1 == bmiC2
    return "Try entering a new weight to see how it will affect your BMI, and how it might affect the severity of your sleep apnea."
  # Obese patients
  if bmiC1 == "Obese"
    result = "People with sleep apnea and a BMI greater than 30 are much more likely to develop severe OSA. "
    if bmiC2 == "Overweight"
      result += "By decreasing your weight to this level, you would greatly reduce the risk of your OSA being or becoming severe."
    else if bmiC2 == "Normal weight"
      result += "By decreasing your weight this much, you would accomplish having a normal BMI, and extremely lower the likelihood of your OSA being severe."
    else if bmiC2 == "Underweight"
      result += "By decreasing your weight this much, you would be much less likely to develop severe OSA. "
      result += "However, keep in mind that losing a drastic amount of weight can have alternate negative side effects."
  # Overweight patients
  else if bmiC1 == "Overweight"
    result = "People with sleep apnea and a BMI between 25 and 30 are most likely to develop moderate sleep apnea, but also at significant risk for severe OSA. "
    if bmiC2 == "Obese"
      result += "Gaining weight will increase your chances of developing severe OSA."
    else if bmiC2 == "Normal weight"
      result += "By losing this much weight, you could decrease the severity of your OSA."
    else if bmiC2 == "Underweight"
      result += "By losing this much weight, you could decrease the severity of your OSA. "
      result += "However, keep in mind that losing a drastic amount of weight can have alternate negative side effects."
  # Normal weight patients
  else if bmiC1 == "Normal weight"
    result = "People in the normal weight range for their height are least likely to develop severe sleep apnea. "
    if bmiC2 == "Obese" or bmiC2 == "Overweight"
      result += "Gaining weight will increase your risk for severe sleep apnea. You would do best to maintain your current weight."
    else if bmiC2 == "Underweight"
      result += "However, keep in mind that losing a drastic amount of weight can have alternate negative side effects."
  # Underweight patients
  else if bmiC1 == "Underweight"
    result = "People with a BMI below 19 are considered underweight. Being drastically underweight can have negative side effects that are not necessarily associated with your sleep apnea. "
    if bmiC2 == "Obese" or bmiC2 == "Overweight"
      result += "Gaining too much weight will increase your risk for severe sleep apnea. A normal weight category (BMI between 19 and 25) is generally preferred for lowest risk of severe OSA and best general health."
    else if bmiC2 == "Normal weight"
      result += "A normal weight category (BMI between 19 and 25) is generally preferred for lowest risk of severe OSA and best general health."

draw_bmi_graph = () ->
  data = [
    { label: "Underweight", color: "underweight", from: 0, to: 18.5 },
    { label: "Normal", color: "normal", from: 18.5, to: 25 },
    { label: "Overweight", color: "overweight", from: 25, to: 30 },
    { label: "Obese", color: "obese", from: 30, to: 45 },
  ]

  bmi = parseFloat($("#bmi").data("bmi"))


  m = {top: 15, right: 5, bottom: 20, left: 5}
  w = 457 - m.left - m.right
  h = 90 - m.top - m.bottom
  x = d3.scale.linear().range([0, w])

  svg = d3.select("#bmi-graph svg.chart")
    .attr("class", "chart")
    .attr("height", h + m.top + m.bottom)
    .attr("width", w + m.right + m.left)
    .append("g")
    .attr("transform", "translate("+m.left+","+m.top+")")

  x.domain([0,45])

  xAxis = d3.svg.axis().scale(x).orient("bottom").tickValues([0, 18.5, 25, 30, 45, bmi])

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0,"+h+")")
    .call(xAxis)

  graph = svg.selectAll(".bar").data(data).enter()

  graph.append("rect")
    .attr("class", (d) -> d.color)
    .attr("x", (d) -> x(d.from))
    .attr("width", (d) -> x(d.to - d.from))
    .attr("height", h)
    .attr("y", 0)

  graph.append("text")
    .style("text-anchor", "middle")
    .style("font-size", '10px')
    .style("font-weight", 'bold')
    .text((d) -> d.label)
    .attr("x", (d) -> x(((d.to - d.from)/2)+ d.from) )
    .attr("y", -7)

  svg.append('svg:line')
    .attr('class', 'my_bmi')
    .attr("x1", x(bmi))
    .attr("x2", x(bmi))
    .attr("y1", -1)
    .attr("y2", h+1)
    .attr("stroke-width", 2)
    .attr("stroke", "black")
