document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('notify-me-form').addEventListener('submit', function(e) {
        e.preventDefault();
        
        var formData = new FormData(this); // Serialize form data
        var variantId = document.getElementById('stock_notify_variant_id').value;
        
        $.ajax({
            dataType: 'json',
            url: `/api/v2/storefront/products/${variantId}/stock_notify`,
            method: 'PUT',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
              console.log(response);
              var fetchDiv = document.getElementById('stock-notify-form')
              fetchDiv.innerHTML = '<div class="mb-2 mt-3 text-bold">Thank you for your interest! We will notify you as soon as the product becomes available.</div>';
            },
            error: function(xhr, status, error) {
              parsedError = JSON.parse(xhr.responseText);
              alert(parsedError.errors);
              document.getElementById('notify-me-button').removeAttribute('disabled')
            }
        });
    });
});