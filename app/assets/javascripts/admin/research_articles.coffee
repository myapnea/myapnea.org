$(document)
  .on('input', '[data-object~="research-article-content-input"]', () ->
    $.post(root_url + 'admin/research_articles/' + $(this).data('id') + '/preview', $("#admin_research_article_content").serialize() + "&research_article_id=" + $(this).data('id'), null, "script")
  )
  .on('input', '[data-object~="research-article-references-input"]', () ->
    $.post(root_url + 'admin/research_articles/' + $(this).data('id') + '/preview', $("#admin_research_article_references").serialize() + "&research_article_id=" + $(this).data('id'), null, "script")
  )
