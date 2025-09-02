<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\HasMany;
use App\Models\ProductSpecs;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    //
    protected $fillable = [
        "name",
        "image"
    ];

    public function specification(): HasMany
    {
        return $this->hasMany(ProductSpecs::class, 'product_id');
    }

    // app/Models/Product.php
    protected $appends = ['image_url'];

    public function getImageUrlAttribute()
    {
        return $this->image
            ? url('storage/product_image/' . $this->image)
            : null;
    }
}
