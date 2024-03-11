$(document).ready(function() {
  $('#notify-me-form').submit(function(e) {
    e.preventDefault(); // Prevent default form submission
    
    var formData = $(this).serialize(); // Serialize form data
    var variantId = $('#notify-me-form input[name="variant_id"]').val(); // Get variant ID
    
    $.ajax({
      dataType: 'json',
      url: '/api/v2/storefront/products/' + variantId + '/stock_notify',
      method: 'PUT',
      data: formData,
      success: function(response) {
        // Handle success response
        console.log(response);
        $('#notify-me-form').replaceWith("<%= j render partial: 'spree/shared/notification' %>"); // Replace form with alert partial
      },
      error: function(xhr, status, error) {
        // Handle error response
        console.error(xhr.responseText);
        alert('Failed to create stock notification');
      }
    });
  });
});