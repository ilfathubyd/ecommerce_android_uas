<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ProductController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Group untuk endpoint Varian Produk
Route::prefix('products/{product}')->group(function () {
    // GET /api/products/{product}/variants/{variant} -> Mengambil 1 varian spesifik
    Route::get('/variants/{variant}', [ProductController::class, 'getVariant']);
    
    // PUT/PATCH /api/products/{product}/variants/{variant} -> Mengupdate 1 varian spesifik
    Route::put('/variants/{variant}', [ProductController::class, 'updateVariant']);

    // DELETE /api/products/{product}/variants/{variant} -> Menghapus 1 varian spesifik
    Route::delete('/variants/{variant}', [ProductController::class, 'deleteVariant']);
});

Route::apiResource('/products', App\Http\Controllers\Api\ProductController::class);

Route::post('/products', [ProductController::class, 'store']);

// routes/api.php



Route::apiResource('products', ProductController::class);   // POST /api/products
