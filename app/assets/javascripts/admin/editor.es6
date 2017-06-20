$(() => {
  $('#post_content_textarea').on('keyup', function() {
    let content = $(this).val();
    let html_content = markdown.toHTML(content);
    $('#preview').html(html_content);
  });
});
