import jQuery from 'jquery'

window.$ = jQuery;

$('[data-ga-social]').on('click', function() {
  const [social, action] = $(this).data('ga-social').split('/');
  ga('send', 'social', social, action, $('h1').text());
});

$('.inline-subscribe').on('submit', function() {
  let request = $.post($(this).attr('action'), $(this).serializeArray());

  request.then(function(data, textStatus, jqXHR) {
    $('.inline-subscribe__box').html('<h2 style="text-align: center; color: #ff6e40; margin: 0; font-size: 1.5em; margin: .5em 0;">Great! You\'re in!</h2>')
    ga('send', 'event', 'newsletter', 'subscribe', 'inline');
  }, function(jqXHR, textStatus, errorThrown) {
    $('.inline-subscribe__error').text('The email you provided is invalid, please try again.')
  });

  return false;
});
