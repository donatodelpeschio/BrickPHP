<?php


/** @var \BrickPHP\Core\Router\Router $router */

$router->get('/user/{id}', [\App\Controllers\Web\UserController::class, 'show']);