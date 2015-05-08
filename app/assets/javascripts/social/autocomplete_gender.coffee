@autocompleteGenderReady = () ->

  @genders = new Bloodhound (
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
    queryTokenizer: Bloodhound.tokenizers.whitespace
    local: $.map($("#user_gender").data("local"), (gender) -> { value: gender })
  )

  @genders.initialize()

  $('[data-object~="typeahead"]').each( () ->
    $this = $(this)
    if $this.attr("id") == "user_gender"
      $this.typeahead( null,
        name: 'genders'
        displayKey: 'value'
        source: genders.ttAdapter()
      )
  )
