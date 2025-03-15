$(function() {
  $('#index_table_rabbit_messages pre').hide();

  $('#index_table_rabbit_messages .col-data a, #index_table_rabbit_messages .col-error_backtrace a').click(function () {
    $(this).parent().find('pre').toggle();

    return false;
  })
})
