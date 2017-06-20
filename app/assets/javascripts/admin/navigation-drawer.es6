$(() => {
  $('[data-behavior~="open-navigation-drawer"]').on('click', () => {
    $('.navigation-drawer').addClass('navigation-drawer--open')
  });

  $('[data-behavior~="close-navigation-drawer"]').on('click', () => {
    $('.navigation-drawer').removeClass('navigation-drawer--open')
  })
})
