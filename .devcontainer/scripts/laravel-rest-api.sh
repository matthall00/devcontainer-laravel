#!/bin/bash

echo "Stripping frontend files for REST API..."

# Remove frontend-related files
rm -rf resources/js resources/css resources/views

# Adjust Web routes
echo "<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json(['message' => 'API Home']);
});
" >routes/web.php

echo "Frontend code stripped. Ready for REST API development."
