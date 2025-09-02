*HOW TO USE THIS PROJECT*

1. Run menggunakan (' flutter run -d chrome --web-browser-flag "--disable-web-security" '),
2. Wajib run server API Laravel pada folder "ecommerce_laravel_api" menggunakan command (' php artisan server --host=0.0.0.0 '),
3. Matikal Firewall (OPSIONAL),
4. Wajib ganti IP baseurl untuk menggunakan API Laravel, ganti dengan IPv4 pada PC masing-masing (cek di CMD menggunakan 'ipconfig'),
5. ganti IP untuk keperluan API pada file dart dilist berikut ini:
    - ecommerce_flutter_laravel/lib/API/ProductService.dart
    - ecommerce_flutter_laravel/lib/services/product_services.dart
    - ecommerce_flutter_laravel/lib/CheckoutScreen.dart
    - ecommerce_flutter_laravel/lib/detail_product_pageBACKUP.dart
    - ecommerce_flutter_laravel/lib/edit_main_page.dart
    - ecommerce_flutter_laravel/lib/home_pageBACKUP.dart
    - ecommerce_flutter_laravel/lib/list_product_type.dart

6. apabila API_KEY rajaongkir Limit dapat menggunakan opsi dibawah ini:
    - API_KEY 1 = 'jR0EDLedf85ef6ceae18abefzFhKOG9a'
    - API_KEY 2 = 'k1qAB24o9f8b0931088eb61aTFsrR8Nm'
    - API_KEY 3 = 'IJcY46Jxe026418d994b461axMkPEh7U'



