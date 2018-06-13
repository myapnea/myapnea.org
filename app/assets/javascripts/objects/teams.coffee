@teamMembersSort = ->
  $("[data-object~=team-members-sortable]").sortable(
    axis: "y"
    stop: ->
      params = {}
      params.team_member_ids = $(this).sortable("toArray", attribute: "data-team-member-id")
      $.post("#{root_url}admin/team-members/order", params, null, "script")
      true
  )
