jQuery(document).ready(($) => {
  $(document)
    // manage row selection
    .on('click', ':checkbox[data-role="select-row"]', function(e) {
      const table = $(this).closest('table');
      const checkboxes = table.find(':checkbox[data-role="select-row"]');
      const checkboxes_checked = checkboxes.filter(':checked');
      table.find(':checkbox[data-role="select-all-rows"]').prop('checked', checkboxes.length === checkboxes_checked.length);
      $('[data-role="action-buttons"]').toggle(checkboxes_checked.length > 0);
    })

    // manage all rows selection
    .on('click', ':checkbox[data-role="select-all-rows"]', function(e) {
      const self = $(this);
      const table = self.closest('table');
      const checked = self.is(':checked');

      table.find(':checkbox[data-role="select-row"]').prop('checked', checked);
      $('[data-role="action-buttons"]').toggle(checked);
    });
});
