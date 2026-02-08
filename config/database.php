<?php

return [
    'host'     => env('DB_HOST', 'db'),
    'port'     => env('DB_PORT', 3306), // Aggiunta per flessibilità (es. Docker mapping)
    'database' => env('DB_DATABASE', 'brickphp'),
    'username' => env('DB_USERNAME', 'brick'),
    'password' => env('DB_PASSWORD', 'brick'),
    'charset'  => 'utf8mb4',
];