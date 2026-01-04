jQuery(document).ready(($) => {
  $('#js-copy-address').on('click', (e) => {
    e.preventDefault();
    const shippingAddress = $('[data-address="shipping"]');
    shippingAddress.val($('[data-address="invoice"]').val());
    autosize.update(shippingAddress);
  });
});
