Deface::Override.new(
                virtual_path: "spree/products/show",
                name: "add_notify_me_button",
                insert_after: "[data-hook='cart_form']",
                partial: 'spree/shared/notify_me_button'
                )
