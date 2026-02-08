<?php

return [
    'default' => env('CACHE_DRIVER', 'file'),

    'stores'  => [
        'file'  => [
            // Usiamo la costante globale per definire il percorso assoluto
            'path' => (defined('BRICK_PATH') ? BRICK_PATH : dirname(__DIR__)) . '/storage/cache',
        ],

        'redis' => [
            'host' => env('REDIS_HOST', 'redis'),
            'port' => (int) env('REDIS_PORT', 6379),
            'password' => env('REDIS_PASSWORD', null),
        ],
    ],
];