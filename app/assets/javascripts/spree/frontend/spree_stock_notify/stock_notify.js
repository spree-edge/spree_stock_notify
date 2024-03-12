Spree.ready(function() {
  var ADD_TO_CART_FORM_SELECTOR = '.add-to-cart-form'
  var VARIANT_ID_SELECTOR = '[name="variant_id"]'
  var OPTION_VALUE_SELECTOR = '.product-variants-variant-values-radio'

  const radioButtonInputs = $(OPTION_VALUE_SELECTOR)
  const notifyMeForm = document.getElementById('notify-me-form');

  window.$cartFormProduct = $(ADD_TO_CART_FORM_SELECTOR)

  if (notifyMeForm) {
    notifyMeForm.addEventListener('submit', function(e) {
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
  }

  document.querySelectorAll('.product-variants-variant-values-radio').forEach(button => {
    button.addEventListener('click', handleClickForVariant);
  });

  var checkedInput = radioButtonInputs.filter(':checked');

  if (checkedInput.length > 0) {
    handleVariantSelection(checkedInput[0])
  }

  function handleClickForVariant() {
    handleVariantSelection(this)
  }

  function handleVariantSelection(radioButton) {
    var variantId = radioButton.dataset.variantId
    this.variants = JSON.parse($cartFormProduct.attr('data-variants'))
    const variant = this.variants.find(item => item.id == variantId);

    var hiddenField= document.getElementById('stock_notify_variant_id')
    hiddenField.value = variantId

    if (variant.in_stock || (variant.stock_notify.length > 0 && variant.stock_notify[0]?.notified == false)) {
      document.getElementById('stock-notify-form').classList.add('d-none');
      if (variant.in_stock) {
        document.getElementById('already-subscribed').classList.add('d-none');
      }
    } 
    else {
      document.getElementById('stock-notify-form').classList.remove('d-none')
      document.getElementById('already-subscribed').classList.add('d-none');
    }

    if (variant.stock_notify.length > 0 && variant.in_stock == false) {
      document.getElementById('already-subscribed').classList.remove('d-none');
    }
  }
});
