<?php

namespace App\Controllers\Web;

use BrickPHP\Core\Http\Request;
use BrickPHP\Core\Http\Response;

class HomeController
{
    public function index(Request $request): Response
    {
        return view('welcome', [
            'version' => '1.0.0',
            'phpVersion' => PHP_VERSION,
            'env' => env('APP_ENV', 'production')
        ]);
    }
}