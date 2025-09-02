<?php

namespace App\Http\Controllers\Api;
use Illuminate\Support\Facades\Log;
//import model Product
use App\Models\Product;

//import resource ProductResource
use App\Models\ProductSpecs;

//import Http request
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

//import facade Validator
use App\Http\Resources\ProductResource;
use Illuminate\Support\Facades\Validator;

use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    /**
     * index
     *
     * @return void
     */
    public function index()
    {
        //get all product
        $products = Product::with('specification')->latest()->paginate(5);

        //return collection of posts as a resource
        return new ProductResource(true, 'List Data Posts', $products);
    }

    /**
     * store
     *
     * @param  mixed $request
     * @return void
     */


    public function store(Request $request)
    {

        // dd($request);
        //define validation rules
        $validator = Validator::make($request->all(), [
            'name'    => 'required|string|max:255', 
            'image'   => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048', 
            'storage' => 'required|string',
            'price'   => 'required',
        ]);

        //check if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $find_product = Product::where('name', $request->name)->first();
        // return new ProductResource(true, 'Data Post Berhasil Ditambahkan!', $find_product[0]['id']);
        echo($find_product);
        if ($find_product) {

            //create Product
            $specification = ProductSpecs::create([
                'product_id' => $find_product->id,
                'storage' => $request->storage,
                'price' => $request->price
            ]);

            //return response
            return new ProductResource(true, 'Data Post Berhasil Ditambahkan!', $specification);
        }

        //upload image
        $image = $request->file('image');
        $image->storeAs('public/product_image', $image->hashName());

        //create Product
        $product = Product::create([
            'image'    => $image->hashName(),
            'name'     => $request->name,
        ]);

        $product->specification()->create([
            'storage' => $request->storage,
            'price' => $request->price
        ]);

        $product->load('specification');

        //return response
        return new ProductResource(true, 'Data Product Berhasil Ditambahkan!', $product);
    }


    public function show($id)
    {
        //find post by ID
        $product = Product::with('specification')->find($id);

        //return single post as a resource
        return new ProductResource(true, 'Detail Data Product!', $product);
    }


    public function update(Request $request, $id)
    {
        //define validation rules
        $validator = Validator::make($request->all(), [
            'storage' => 'required',
            'price' => 'required',
        ]);

        //check if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        //find post by ID
        $product_spec = ProductSpecs::find($id);

        //check if image is not empty
        if ($request->hasFile('image')) {

            //upload image
            $image = $request->file('image');
            $image->storeAs('public/product_image', $image->hashName());

            //delete old image
            Storage::delete('public/product_image/' . basename($product_spec->image));

            //update post with new image
            $product_spec->update([
                'image'     => $image->hashName(),
                'storage'   => $request->storage,
                'price'     => $request->price,
            ]);
        } else {

            //update post without image
            $product_spec->update([
                'storage' => $request->storage,
                'price'   => $request->price,
            ]);
        }

        $product_spec->load('product');

        //return response
        return new ProductResource(true, 'Data Spesifikasi Berhasil Diubah!', $product_spec);
    }


    public function destroy($id)
    {

        //find post by ID
        $product = Product::find($id);

        //delete image
        Storage::delete('public/product_image/'.basename($product->image));

        //delete post
        $product->delete();

        //return response
        return new ProductResource(true, 'Data Product Berhasil Dihapus!', null);
    }

    public function updateVariant(Request $request, Product $product, ProductSpecs $variant)
    {
        Log::info('--- REQUEST UPDATE VARIANT DITERIMA ---');
        Log::info('Product ID: ' . $product->id);
        Log::info('Variant ID: ' . $variant->id);
        Log::info('Data dari Request: ', $request->all());

        // 1. Keamanan: Pastikan varian ini milik produk yang benar
        if ($variant->product_id !== $product->id) {
            return response()->json(['message' => 'Varian tidak ditemukan pada produk ini.'], 404);
        }

        // 2. Validasi data yang masuk
        $validatedData = $request->validate([
            'name'    => 'sometimes|string|max:255', // Nama produk
            'storage' => 'sometimes|string|max:255', // Detail varian
            'price'   => 'sometimes|numeric|min:0',  // Detail varian
        ]);
        
        // 3. Update nama produk utama (JIKA ADA 'name' dalam request)
        if ($request->has('name')) {
            $product->update([
                'name' => $validatedData['name']
            ]);
        }

        // 4. Update detail varian menggunakan data yang sudah divalidasi
        $variant->update([
            'storage' => $validatedData['storage'],
            'price'   => $validatedData['price']
        ]);

        // 5. Kembalikan response sukses dengan data terbaru
        return response()->json([
            'message' => 'Produk & Varian berhasil diperbarui!',
            'product' => $product->fresh(), // .fresh() untuk mengambil data terbaru dari DB
            'variant' => $variant->fresh()
        ]);
    }

}