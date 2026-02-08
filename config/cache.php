<?php

return [
    'default' => env('CACHE_DRIVER', 'file'),
    'stores'  => [
        'file'  => [ 'path' => __DIR__ . '/../storage/cache' ],
        'redis' => [
            'host' => env('REDIS_HOST', 'redis'),
            'port' => env('REDIS_PORT', 6379),
        ],
    ],
];