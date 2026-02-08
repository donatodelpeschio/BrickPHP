<?php


/** @var \BrickPHP\Core\Router\Router $router */

// Rotta di Benvenuto
$router->get('/', [\App\Controllers\Web\HomeController::class, 'index']);

$router->get('/user/{id}', [\App\Controllers\Web\UserController::class, 'show']);