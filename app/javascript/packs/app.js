import jQuery from 'jquery'

window.$ = jQuery;

$('[data-ga-social]').on('click', function() {
  const [social, action] = $(this).data('ga-social').split('/');
  ga('send', 'social', social, action, $('h1').text());
});
