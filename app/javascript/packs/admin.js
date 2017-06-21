import SimpleMDE from 'simplemde';

$ = require('jquery');

$(() => {
  let articleEditor = $('#post_content_textarea')[0];

  if (articleEditor) {
    console.log("asd");
    let simplemde = new SimpleMDE({
      element: articleEditor,
      blockStyles: {
        code: '~~~',
        italic: '_'
      },
      indentWithTabs: false,
      placeholder: 'Start to write...',
      status: false
    });
  }
});
