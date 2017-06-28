import SimpleMDE from 'simplemde';

$ = require('jquery');

function countWords(text) {
  return text.split(/[\u200B\s]/).filter((s) => s.trim() != '').length;
}

function refreshArticleStats() {
  let text = $('.CodeMirror-code pre').map((_, line) => $(line).text()).toArray().join("\n");
  let plain = text.replace(/!\[[^\]]*\]\([^\)]*\)/g, '')
                  .replace(/\[([^\]]*)\]\([^\)]*\)/g, '$1')
                  .replace(/[\*_~#]/g, '')

  $('.article__stats').text("Words: " + countWords(plain));
}

$(() => {
  let articleEditor = $('#post_content_textarea')[0];

  if (articleEditor) {
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

    refreshArticleStats();

    simplemde.codemirror.on("change", () => {
      setTimeout(() => {
        refreshArticleStats();
      }, 0);
    });
  }
});
